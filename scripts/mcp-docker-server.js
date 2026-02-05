#!/usr/bin/env node
/**
 * Simple Docker MCP Server
 * Provides docker commands through MCP protocol
 */

const { Server } = require('@modelcontextprotocol/sdk/server/index.js');
const { StdioServerTransport } = require('@modelcontextprotocol/sdk/server/stdio.js');
const {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} = require('@modelcontextprotocol/sdk/types.js');
const { execSync } = require('child_process');

const server = new Server(
  {
    name: 'docker-mcp-server',
    version: '1.0.0',
  },
  {
    capabilities: {
      tools: {},
    },
  }
);

server.setRequestHandler(ListToolsRequestSchema, async () => ({
  tools: [
    {
      name: 'docker_ps',
      description: 'List running Docker containers',
      inputSchema: {
        type: 'object',
        properties: {
          all: {
            type: 'boolean',
            description: 'Show all containers (including stopped)',
            default: false,
          },
        },
      },
    },
    {
      name: 'docker_logs',
      description: 'Get logs from a Docker container',
      inputSchema: {
        type: 'object',
        properties: {
          container: {
            type: 'string',
            description: 'Container name or ID',
          },
          tail: {
            type: 'number',
            description: 'Number of lines to show',
            default: 50,
          },
        },
        required: ['container'],
      },
    },
    {
      name: 'docker_compose_ps',
      description: 'List Docker Compose services',
      inputSchema: {
        type: 'object',
        properties: {
          path: {
            type: 'string',
            description: 'Path to docker-compose.yml',
            default: './docker-compose.yml',
          },
        },
      },
    },
    {
      name: 'docker_compose_logs',
      description: 'Get logs from Docker Compose services',
      inputSchema: {
        type: 'object',
        properties: {
          service: {
            type: 'string',
            description: 'Service name',
          },
          tail: {
            type: 'number',
            description: 'Number of lines to show',
            default: 50,
          },
        },
        required: ['service'],
      },
    },
  ],
}));

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  try {
    let result;
    const dockerCmd = (cmd) => {
      return execSync(`docker ${cmd}`, {
        encoding: 'utf-8',
        stdio: ['pipe', 'pipe', 'pipe'],
      }).trim();
    };

    const composeCmd = (cmd, path = './docker-compose.yml') => {
      return execSync(`docker-compose -f ${path} ${cmd}`, {
        encoding: 'utf-8',
        stdio: ['pipe', 'pipe', 'pipe'],
      }).trim();
    };

    switch (name) {
      case 'docker_ps':
        const all = args?.all ? '-a' : '';
        result = dockerCmd(`ps ${all}`);
        return { content: [{ type: 'text', text: result }] };

      case 'docker_logs':
        const container = args?.container;
        const tail = args?.tail || 50;
        result = dockerCmd(`logs --tail ${tail} ${container}`);
        return { content: [{ type: 'text', text: result }] };

      case 'docker_compose_ps':
        const composePath = args?.path || './docker-compose.yml';
        result = composeCmd('ps', composePath);
        return { content: [{ type: 'text', text: result }] };

      case 'docker_compose_logs':
        const service = args?.service;
        const logTail = args?.tail || 50;
        result = composeCmd(`logs --tail ${logTail} ${service}`);
        return { content: [{ type: 'text', text: result }] };

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
  console.error('Docker MCP server running on stdio');
}

main().catch(console.error);
