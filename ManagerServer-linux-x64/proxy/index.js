const express = require('express');
const fetch = require('node-fetch'); // v2 for CommonJS (kept for optional fallbacks)
const { createProxyMiddleware } = require('http-proxy-middleware');
const jwt = require('jsonwebtoken');
const jwksClient = require('jwks-rsa');

const SUPABASE_URL = process.env.SUPABASE_URL;
const SUPABASE_JWKS_URL = process.env.SUPABASE_JWKS_URL; // optional override for JWKS
const SUPABASE_JWT_SECRET = process.env.SUPABASE_JWT_SECRET; // optional HS256 secret fallback

const MANAGER_PORT = process.env.MANAGER_PORT || 8080;
const MANAGER_TARGET = `http://127.0.0.1:${MANAGER_PORT}`;
const PORT = process.env.PORT || 3000;

if (!SUPABASE_URL && !SUPABASE_JWKS_URL && !SUPABASE_JWT_SECRET) {
  console.error('One of SUPABASE_URL, SUPABASE_JWKS_URL or SUPABASE_JWT_SECRET must be set.');
  process.exit(1);
}

// Build a JWKS client if JWKS is available
let jwks;
const jwksUri = SUPABASE_JWKS_URL || (SUPABASE_URL ? `${SUPABASE_URL}/auth/v1/.well-known/jwks.json` : null);
if (jwksUri) {
  jwks = jwksClient({
    jwksUri,
    cache: true,
    cacheMaxEntries: 5,
    cacheMaxAge: 10 * 60 * 1000, // 10 minutes
    jwksRequestsPerMinute: 30,
  });
}

const app = express();

// Simple health endpoint
app.get('/health', (req, res) => res.json({ status: 'ok' }));

// Verify token using either HS256 secret or JWKS-based RS256 verification.
async function verifyToken(authHeader) {
  if (!authHeader || !authHeader.startsWith('Bearer ')) throw { code: 401, message: 'missing or invalid authorization header' };
  const token = authHeader.slice('Bearer '.length);

  // If SUPABASE_JWT_SECRET is provided, verify with HS256 (shared secret)
  if (SUPABASE_JWT_SECRET) {
    try {
      const payload = jwt.verify(token, SUPABASE_JWT_SECRET);
      return payload;
    } catch (err) {
      throw { code: 401, message: 'invalid token (HS256 verify failed)' };
    }
  }

  // Otherwise try JWKS (RS256 / public key verification)
  if (!jwks) {
    // As a final fallback (legacy), call Supabase auth endpoint to validate (slower)
    if (SUPABASE_URL) {
      const resp = await fetch(`${SUPABASE_URL}/auth/v1/user`, { headers: { Authorization: authHeader } });
      if (!resp.ok) throw { code: 401, message: 'invalid or expired token' };
      try {
        return await resp.json();
      } catch (e) {
        return { validated: true };
      }
    }
    throw { code: 500, message: 'no verification method available' };
  }

  // decode header to get kid
  const decodedHeader = jwt.decode(token, { complete: true });
  if (!decodedHeader || !decodedHeader.header) throw { code: 401, message: 'invalid token' };
  const kid = decodedHeader.header.kid;

  return new Promise((resolve, reject) => {
    jwks.getSigningKey(kid, (err, key) => {
      if (err) return reject({ code: 401, message: 'unable to get signing key' });
      const signingKey = key.getPublicKey();
      try {
        const payload = jwt.verify(token, signingKey);
        resolve(payload);
      } catch (e) {
        reject({ code: 401, message: 'invalid token (JWKS verify failed)' });
      }
    });
  });
}

// Authentication middleware: validate the bearer token and attach user info
app.use(async (req, res, next) => {
  if (req.path === '/health') return next();

  const auth = req.headers['authorization'];
  try {
    const user = await verifyToken(auth);
    // Attach user payload (may be the raw GoTrue user object if fallback was used)
    req.supabaseUser = user;
    next();
  } catch (err) {
    const status = err && err.code ? err.code : 401;
    const message = err && err.message ? err.message : 'authentication failed';
    return res.status(status).json({ error: message });
  }
});

// Proxy everything else to ManagerServer
app.use(
  '/',
  createProxyMiddleware({
    target: MANAGER_TARGET,
    changeOrigin: true,
    proxyTimeout: 30000,
    onProxyReq: (proxyReq, req, res) => {
      // Forward the original Authorization header to the backend if it needs user context
      const auth = req.headers['authorization'];
      if (auth) proxyReq.setHeader('authorization', auth);
      // Optionally forward a compact user header (JSON-stringified) - enable if ManagerServer expects it
      // if (req.supabaseUser) proxyReq.setHeader('x-supabase-user', Buffer.from(JSON.stringify(req.supabaseUser)).toString('base64'));
    },
  }),
);

app.listen(PORT, () => {
  console.log(`Auth proxy listening on port ${PORT}, forwarding to ${MANAGER_TARGET}`);
});
