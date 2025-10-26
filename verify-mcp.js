// Quick MCP verification script
// Run with: node verify-mcp.js

const fs = require('fs');
const path = require('path');

console.log('🔍 MCP Configuration Verification\n');

// Check if MCP config exists
const mcpConfigPath = path.join('.kiro', 'settings', 'mcp.json');
if (!fs.existsSync(mcpConfigPath)) {
  console.log('❌ MCP config not found at:', mcpConfigPath);
  process.exit(1);
}

// Read and parse MCP config
let config;
try {
  const configContent = fs.readFileSync(mcpConfigPath, 'utf8');
  config = JSON.parse(configContent);
  console.log('✅ MCP config file found and parsed successfully');
} catch (error) {
  console.log('❌ Error reading MCP config:', error.message);
  process.exit(1);
}

// Check server configurations
const servers = config.mcpServers || {};
console.log(`\n📊 Found ${Object.keys(servers).length} MCP server(s):\n`);

Object.entries(servers).forEach(([name, serverConfig]) => {
  console.log(`🔧 ${name.toUpperCase()} Server:`);
  console.log(`   Command: ${serverConfig.command} ${serverConfig.args?.join(' ') || ''}`);
  console.log(`   Disabled: ${serverConfig.disabled ? '❌' : '✅'}`);
  
  // Check environment variables
  const env = serverConfig.env || {};
  const envKeys = Object.keys(env);
  console.log(`   Environment variables (${envKeys.length}):`);
  
  envKeys.forEach(key => {
    const value = env[key];
    const hasValue = value && value.trim() !== '';
    const displayValue = hasValue ? 
      (key.includes('TOKEN') || key.includes('KEY') ? '***hidden***' : value) : 
      '⚠️  NOT SET';
    console.log(`     ${key}: ${displayValue}`);
  });
  
  // Check auto-approved tools
  const autoApprove = serverConfig.autoApprove || [];
  console.log(`   Auto-approved tools (${autoApprove.length}): ${autoApprove.join(', ')}`);
  console.log('');
});

// Provide next steps
console.log('📋 Next Steps:');
console.log('1. Update the empty environment variables in .kiro/settings/mcp.json');
console.log('2. Restart Kiro or reconnect MCP servers');
console.log('3. Test by asking: "List my DigitalOcean droplets" or "Show my Supabase tables"');
console.log('\n📖 See MCP_SETUP.md for detailed configuration instructions');