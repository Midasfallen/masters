#!/usr/bin/env node
/**
 * Simple Redis MCP Server
 * Provides Redis commands through MCP protocol
 */

const { Server } = require('@modelcontextprotocol/sdk/server/index.js');
const { StdioServerTransport } = require('@modelcontextprotocol/sdk/server/stdio.js');
const {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} = require('@modelcontextprotocol/sdk/types.js');
const Redis = require('ioredis');

const REDIS_HOST = process.env.REDIS_HOST || 'localhost';
const REDIS_PORT = parseInt(process.env.REDIS_PORT || '6379', 10);
const REDIS_PASSWORD = process.env.REDIS_PASSWORD || 'redis_password';

const redis = new Redis({
  host: REDIS_HOST,
  port: REDIS_PORT,
  password: REDIS_PASSWORD,
  retryStrategy: () => null, // Don't retry on connection failure
});

const server = new Server(
  {
    name: 'redis-mcp-server',
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
      name: 'redis_get',
      description: 'Get value from Redis by key',
      inputSchema: {
        type: 'object',
        properties: {
          key: {
            type: 'string',
            description: 'Redis key',
          },
        },
        required: ['key'],
      },
    },
    {
      name: 'redis_set',
      description: 'Set value in Redis',
      inputSchema: {
        type: 'object',
        properties: {
          key: {
            type: 'string',
            description: 'Redis key',
          },
          value: {
            type: 'string',
            description: 'Value to set',
          },
          ttl: {
            type: 'number',
            description: 'TTL in seconds (optional)',
          },
        },
        required: ['key', 'value'],
      },
    },
    {
      name: 'redis_keys',
      description: 'List Redis keys matching pattern',
      inputSchema: {
        type: 'object',
        properties: {
          pattern: {
            type: 'string',
            description: 'Key pattern (e.g., "user:*")',
            default: '*',
          },
        },
      },
    },
    {
      name: 'redis_del',
      description: 'Delete key from Redis',
      inputSchema: {
        type: 'object',
        properties: {
          key: {
            type: 'string',
            description: 'Redis key',
          },
        },
        required: ['key'],
      },
    },
    {
      name: 'redis_info',
      description: 'Get Redis server information',
      inputSchema: {
        type: 'object',
        properties: {},
      },
    },
  ],
}));

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  try {
    let result;

    switch (name) {
      case 'redis_get':
        result = await redis.get(args.key);
        return {
          content: [{ type: 'text', text: result || '(nil)' }],
        };

      case 'redis_set':
        const ttl = args?.ttl;
        if (ttl) {
          await redis.setex(args.key, ttl, args.value);
        } else {
          await redis.set(args.key, args.value);
        }
        return {
          content: [{ type: 'text', text: `OK: ${args.key} = ${args.value}` }],
        };

      case 'redis_keys':
        const pattern = args?.pattern || '*';
        const keys = await redis.keys(pattern);
        return {
          content: [{ type: 'text', text: keys.join('\n') || '(empty)' }],
        };

      case 'redis_del':
        const deleted = await redis.del(args.key);
        return {
          content: [
            {
              type: 'text',
              text: deleted > 0 ? `Deleted: ${args.key}` : `Key not found: ${args.key}`,
            },
          ],
        };

      case 'redis_info':
        result = await redis.info();
        return {
          content: [{ type: 'text', text: result }],
        };

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
  // Test connection
  try {
    await redis.ping();
    console.error('Redis MCP server connected to Redis');
  } catch (error) {
    console.error(`Redis connection error: ${error.message}`);
    console.error('Server will continue but Redis operations may fail');
  }

  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error('Redis MCP server running on stdio');
}

main().catch(console.error);
