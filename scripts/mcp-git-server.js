#!/usr/bin/env node
/**
 * Simple Git MCP Server
 * Provides git commands through MCP protocol
 */

const { Server } = require('@modelcontextprotocol/sdk/server/index.js');
const { StdioServerTransport } = require('@modelcontextprotocol/sdk/server/stdio.js');
const {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} = require('@modelcontextprotocol/sdk/types.js');
const { execSync } = require('child_process');
const path = require('path');

const WORKSPACE = process.env.GIT_WORKSPACE || process.cwd();

const server = new Server(
  {
    name: 'git-mcp-server',
    version: '1.0.0',
  },
  {
    capabilities: {
      tools: {},
    },
  }
);

// Git status
server.setRequestHandler(ListToolsRequestSchema, async () => ({
  tools: [
    {
      name: 'git_status',
      description: 'Get git status of the repository',
      inputSchema: {
        type: 'object',
        properties: {},
      },
    },
    {
      name: 'git_log',
      description: 'Get git log (last N commits)',
      inputSchema: {
        type: 'object',
        properties: {
          limit: {
            type: 'number',
            description: 'Number of commits to show',
            default: 10,
          },
        },
      },
    },
    {
      name: 'git_diff',
      description: 'Get git diff',
      inputSchema: {
        type: 'object',
        properties: {
          staged: {
            type: 'boolean',
            description: 'Show staged changes',
            default: false,
          },
        },
      },
    },
    {
      name: 'git_branch',
      description: 'List git branches',
      inputSchema: {
        type: 'object',
        properties: {},
      },
    },
    {
      name: 'git_commit',
      description: 'Create a git commit',
      inputSchema: {
        type: 'object',
        properties: {
          message: {
            type: 'string',
            description: 'Commit message',
          },
          files: {
            type: 'array',
            items: { type: 'string' },
            description: 'Files to commit (empty = all staged)',
          },
        },
        required: ['message'],
      },
    },
  ],
}));

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  try {
    let result;
    const gitCmd = (cmd) => {
      return execSync(`git ${cmd}`, {
        cwd: WORKSPACE,
        encoding: 'utf-8',
        stdio: ['pipe', 'pipe', 'pipe'],
      }).trim();
    };

    switch (name) {
      case 'git_status':
        result = gitCmd('status --short');
        return { content: [{ type: 'text', text: result || 'No changes' }] };

      case 'git_log':
        const limit = args?.limit || 10;
        result = gitCmd(`log --oneline -n ${limit}`);
        return { content: [{ type: 'text', text: result }] };

      case 'git_diff':
        const staged = args?.staged ? '--staged' : '';
        result = gitCmd(`diff ${staged}`);
        return { content: [{ type: 'text', text: result || 'No changes' }] };

      case 'git_branch':
        result = gitCmd('branch -a');
        return { content: [{ type: 'text', text: result }] };

      case 'git_commit':
        const message = args?.message;
        const files = args?.files || [];
        if (files.length > 0) {
          gitCmd(`add ${files.join(' ')}`);
        }
        gitCmd(`commit -m "${message}"`);
        return { content: [{ type: 'text', text: `Committed: ${message}` }] };

      default:
        throw new Error(`Unknown tool: ${name}`);
    }
  } catch (error) {
    return {
      content: [{ type: 'text', text: `Error: ${error.message}` }],
      isError: true,
    };
  }
});

async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error('Git MCP server running on stdio');
}

main().catch(console.error);
