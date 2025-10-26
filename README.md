# Zira Suite

A containerized ManagerServer application with Supabase authentication proxy, designed for cloud deployment.

## 🚀 Features

- **ManagerServer**: Core .NET application with Manager.io functionality
- **Authentication Proxy**: Node.js Express proxy with Supabase JWT verification
- **Docker Ready**: Fully containerized with health checks and auto-scaling
- **Cloud Deployable**: Optimized for Fly.io, Railway, Render, and DigitalOcean
- **Security First**: JWT verification with JWKS support and fallback options

## 📁 Project Structure

```
Zira Suite/
├── ManagerServer-linux-x64/          # Main application directory
│   ├── ManagerServer                  # .NET binary
│   ├── Assets/                        # Application assets
│   ├── proxy/                         # Node.js authentication proxy
│   │   └── index.js                   # Express server with JWT auth
│   ├── Dockerfile                     # Container configuration
│   ├── entrypoint.sh                  # Container startup script
│   ├── package.json                   # Node.js dependencies
│   ├── fly.toml                       # Fly.io configuration
│   └── docker-compose.yml             # Local development setup
├── .github/workflows/                 # CI/CD pipelines
│   └── deploy-flyio.yml               # Fly.io auto-deployment
├── deploy-to-*.md                     # Deployment guides
└── project.db                         # SQLite database for tracking
```

## 🛠️ Local Development

### Prerequisites
- Docker Desktop
- Node.js 18+
- Git

### Quick Start

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-username/zira-suite.git
   cd zira-suite
   ```

2. **Test locally with Docker**:
   ```bash
   cd ManagerServer-linux-x64
   docker build -t zira-suite .
   docker run -p 3000:3000 \
     -e SUPABASE_URL=your_supabase_url \
     -e SUPABASE_ANON_KEY=your_anon_key \
     zira-suite
   ```

3. **Verify it's working**:
   ```bash
   curl http://localhost:3000/health
   # Should return: {"status":"ok"}
   ```

## ☁️ Cloud Deployment

### Fly.io (Recommended)
```bash
cd ManagerServer-linux-x64
flyctl launch --no-deploy
flyctl secrets set SUPABASE_URL=your_supabase_url
flyctl secrets set SUPABASE_ANON_KEY=your_anon_key
flyctl deploy
```

### Railway
```bash
npm install -g @railway/cli
cd ManagerServer-linux-x64
railway login
railway init
railway up
```

### Render
1. Connect your GitHub repository
2. Create a new Web Service
3. Set root directory to `ManagerServer-linux-x64`
4. Add environment variables in dashboard

### DigitalOcean App Platform
1. Connect GitHub repository
2. Auto-detects Dockerfile
3. Set environment variables in dashboard
4. Deploy with built-in CI/CD

## 🔐 Authentication

The application uses Supabase for authentication with multiple verification methods:

1. **JWKS Verification** (Recommended): Fast, local JWT verification
2. **HS256 Secret**: Shared secret verification
3. **HTTP Fallback**: Direct Supabase API calls

### Environment Variables

| Variable | Description | Required |
|----------|-------------|----------|
| `SUPABASE_URL` | Your Supabase project URL | Yes |
| `SUPABASE_ANON_KEY` | Supabase anonymous key | Yes |
| `SUPABASE_JWKS_URL` | JWKS endpoint for JWT verification | Optional |
| `SUPABASE_JWT_SECRET` | JWT secret for HS256 verification | Optional |
| `PORT` | Proxy port (default: 3000) | No |
| `MANAGER_PORT` | ManagerServer port (default: 8080) | No |

## 🏗️ Architecture

```
Internet → [Proxy:3000] → [ManagerServer:8080]
              ↓
         JWT Verification
              ↓
         Supabase Auth
```

1. **Client** sends requests with `Authorization: Bearer <token>`
2. **Proxy** validates JWT token with Supabase
3. **ManagerServer** receives authenticated requests
4. **Health checks** ensure service availability

## 📊 Monitoring

- **Health Endpoint**: `/health` returns service status
- **Logs**: Container logs available via platform dashboards
- **Metrics**: Built-in platform monitoring (Fly.io, Railway, etc.)

## 🔧 Development Tools

- **MCP Integration**: SQLite server for project tracking
- **GitHub Actions**: Automated deployment pipelines
- **Docker Compose**: Local development environment
- **Health Checks**: Automated service monitoring

## 📈 Scaling

The application is designed to scale horizontally:
- **Stateless**: No local session storage
- **Health Checks**: Automatic failover
- **Auto-scaling**: Platform-native scaling support
- **Load Balancing**: Built-in with cloud platforms

## 🛡️ Security

- **JWT Verification**: Multiple verification methods
- **HTTPS Only**: Force HTTPS in production
- **Environment Secrets**: Secure credential management
- **CORS Protection**: Configurable CORS policies
- **Rate Limiting**: Ready for rate limiting middleware

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test locally with Docker
5. Submit a pull request

## 📞 Support

For issues and questions:
- Create an issue in this repository
- Check the deployment guides in `/deploy-to-*.md`
- Review container logs for troubleshooting

---

**Zira Suite** - Containerized ManagerServer with cloud-native authentication 🚀