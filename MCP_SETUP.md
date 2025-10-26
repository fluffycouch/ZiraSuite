# MCP Server Setup Guide

This guide helps you connect your project to DigitalOcean and Supabase MCP servers for seamless cloud resource management.

## Prerequisites

Make sure you have `uv` and `uvx` installed:

```powershell
# Install uv (Python package manager)
# Option 1: Using pip
pip install uv

# Option 2: Using PowerShell (recommended)
powershell -c "irm https://astral.sh/uv/install.ps1 | iex"

# Option 3: Using Chocolatey
choco install uv
```

## Configuration Steps

### 1. DigitalOcean MCP Server

**Get your DigitalOcean API Token:**
1. Go to [DigitalOcean Control Panel](https://cloud.digitalocean.com/account/api/tokens)
2. Click "Generate New Token"
3. Name it "MCP Server" and select appropriate scopes (read/write)
4. Copy the generated token

**Update the MCP configuration:**
Edit `.kiro/settings/mcp.json` and replace the empty `DIGITALOCEAN_API_TOKEN` with your actual token.

### 2. Supabase MCP Server

**Get your Supabase credentials:**
1. Go to your [Supabase Dashboard](https://supabase.com/dashboard)
2. Select your project
3. Go to Settings → API
4. Copy:
   - Project URL (e.g., `https://your-project.supabase.co`)
   - Service Role Key (secret key with full access)

**Update the MCP configuration:**
Edit `.kiro/settings/mcp.json` and replace:
- `SUPABASE_URL` with your project URL
- `SUPABASE_SERVICE_ROLE_KEY` with your service role key

## Available MCP Tools

### DigitalOcean Tools
- `list_droplets` - List all your droplets
- `get_droplet` - Get detailed droplet information
- `list_databases` - List managed databases
- `list_apps` - List App Platform applications
- `list_volumes` - List block storage volumes
- `list_load_balancers` - List load balancers

### Supabase Tools
- `list_tables` - List all database tables
- `describe_table` - Get table schema and details
- `query_database` - Execute SQL queries
- `list_storage_buckets` - List storage buckets
- `list_auth_users` - List authenticated users

## Security Notes

- **Service Role Key**: Keep this secret! It has full access to your Supabase project
- **API Token**: Store securely, consider using environment variables in production
- The MCP config includes auto-approval for read-only operations for convenience

## Testing the Connection

After updating the credentials, you can test the MCP servers:

1. Restart Kiro or reconnect MCP servers from the MCP Server view
2. Try asking: "List my DigitalOcean droplets" or "Show my Supabase tables"
3. The MCP tools will be available for managing your cloud resources

## Integration with Your ManagerServer Project

With these MCP servers connected, you can:

1. **Deploy to DigitalOcean**: Use MCP tools to create droplets, configure App Platform, or manage databases
2. **Manage Supabase**: Query your auth users, manage database schema, or check storage buckets
3. **Monitor Resources**: Check the status of your deployed ManagerServer containers
4. **Automate Deployments**: Use MCP tools in combination with your Docker setup

## Example Usage

Once configured, you can ask Kiro:
- "Create a new DigitalOcean droplet for my ManagerServer"
- "Show me the users in my Supabase auth table"
- "List my DigitalOcean apps and their status"
- "Query my Supabase database for recent activity"