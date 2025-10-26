# ManagerServer (Linux) — Docker + Supabase-auth proxy

This repository contains the Linux edition of ManagerServer and a small Express-based authentication proxy that validates incoming Bearer tokens with Supabase before forwarding requests to the ManagerServer.

What I added
- `Dockerfile` — builds an image with the ManagerServer binary and the Node auth proxy.
- `entrypoint.sh` — starts `ManagerServer` in background and then the auth proxy.
- `proxy/index.js` — Express app that calls `POST ${SUPABASE_URL}/auth/v1/user` (using the Authorization header) to validate tokens, then proxies to ManagerServer.
- `package.json` — Node dependencies for the proxy.
- `docker-compose.yml` — example runtime with a named volume for persistent data.
- `.env.example` — example env vars.

Required environment variables
- `SUPABASE_URL` — your Supabase project URL (e.g. `https://abcd1234.supabase.co`). Used as a fallback for legacy validation and to infer JWKS URL when appropriate.

Optional / recommended JWT setup
- `SUPABASE_JWKS_URL` — URL to the project's JWKS (JSON Web Key Set). If present the proxy will verify JWTs locally using the JWKS (recommended).
- `SUPABASE_JWT_SECRET` — If your Supabase project issues HS256 tokens and you have the project's JWT secret, set this to verify tokens locally. Keep this secret safe.

Behavior summary
- If `SUPABASE_JWKS_URL` is provided (or inferred from `SUPABASE_URL`), the proxy verifies JWTs using the JWKS (fast, no network call per request except JWKS refreshes).
- If `SUPABASE_JWT_SECRET` is provided, the proxy verifies tokens with that secret (HS256).
- If neither JWKS nor secret are configured, the proxy falls back to calling `${SUPABASE_URL}/auth/v1/user` which validates the token remotely (simpler but slower).

How it works (summary)
- Client asks Supabase Auth to sign in and receives an access token (Bearer token).
- Client sends requests to your ManagerServer endpoints with the Authorization header: `Authorization: Bearer <access_token>`.
- The Express proxy validates the token by calling `${SUPABASE_URL}/auth/v1/user` with that Authorization header. If valid, the proxy forwards the request to the ManagerServer binary (running locally inside the container).

Local development
- To debug locally without Docker, start the ManagerServer binary on your machine (set `MANAGER_PORT` if needed) and run the Node proxy directly:

```powershell
# from repo root
npm install
SUPABASE_URL=https://your-project.supabase.co MANAGER_PORT=8080 node proxy/index.js
```

For container-based deployments, follow the DigitalOcean App Platform or Droplet instructions in the "Deploy to DigitalOcean" section.

Run without docker (for debugging)
- Start the ManagerServer binary locally on port 8080 (or set `MANAGER_PORT`), then start the Node proxy:

```powershell
# from repo root
npm install
SUPABASE_URL=https://your-project.supabase.co MANAGER_PORT=8080 node proxy/index.js
```

Deploy to DigitalOcean
- You can deploy this as a container on DigitalOcean App Platform (recommended) or to a Droplet.

Option A — App Platform (recommended for managed deployments):
1. Point App Platform to this repository and configure the App to build the Dockerfile, or build an image locally and push it to DigitalOcean Container Registry.
2. In App Platform settings, set the environment variables: at minimum `SUPABASE_URL`. For local JWT verification set `SUPABASE_JWKS_URL` or `SUPABASE_JWT_SECRET` as a secret in App Platform.

Option B — Droplet / Docker on VPS:
1. Build the image on the server or push to a registry and pull it on your Droplet.
2. Create a volume or bind-mount a directory for persistent storage and use the same docker run options as `docker-compose.yml`.
3. If you use the HS256 secret (`SUPABASE_JWT_SECRET`) keep it in a secure place (environment file or secret store) and do not commit it.

DigitalOcean MCP / App Platform notes
- Use App Platform's Environment and Secrets UI to store `SUPABASE_JWT_SECRET` securely or set `SUPABASE_JWKS_URL` (public) so the proxy can verify tokens without storing secrets.
- If deploying to a DigitalOcean Container Registry, tag and push the image then reference it from App Platform.
- For persistent data on Droplets, create/attach a Docker volume or use a host directory bind mount.

DigitalOcean Registry (example using Docker CLI / PowerShell)

```powershell
# Tag the image for DigitalOcean registry (after creating a registry in your DO project)
docker build -t registry.digitalocean.com/<your-registry>/<image-name>:latest .
docker push registry.digitalocean.com/<your-registry>/<image-name>:latest
```

Notes & next steps
- If your ManagerServer expects a different port or additional environment variables, set them in `docker-compose.yml` or the App Platform config.
- The proxy now supports JWKS-based verification and HS256 secret verification (local), and will fall back to Supabase's HTTP validation if needed. For production, prefer JWKS or secure secret verification to avoid per-request network calls.
- Add HTTPS termination (TLS) at a load balancer or using a reverse proxy in front of this container for public deployments.

If you want, I can:
- Help configure `SUPABASE_JWKS_URL` or store `SUPABASE_JWT_SECRET` securely in DigitalOcean App Platform secrets.
- Add stricter claim checks (roles/allowed aud/or issuer) to the verification step so only users with required roles can reach certain endpoints.
- Build and push the container to a registry and deploy it to your DigitalOcean account (if you provide registry/project details or OAuth access).
