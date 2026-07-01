import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { WINSTON_MODULE_NEST_PROVIDER } from 'nest-winston';
import { AppModule } from './app.module';
import { SerializeInterceptor } from './common/interceptors/serialize.interceptor';
import { configureSecurity } from './config/security.config';
import * as crypto from 'crypto';

// Global crypto polyfill for @nestjs/schedule compatibility with Node.js 18+
if (typeof (global as any).crypto === 'undefined') {
  (global as any).crypto = crypto;
}

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Winston Logger
  app.useLogger(app.get(WINSTON_MODULE_NEST_PROVIDER));

  // Global prefix
  const apiPrefix = process.env.API_PREFIX || 'api/v2';
  app.setGlobalPrefix(apiPrefix);

  // Security: Helmet (OWASP headers) + CORS.
  // В dev разрешает все источники, в production — whitelist из CORS_ORIGIN.
  configureSecurity(app);

  // Global validation pipe
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
      transformOptions: {
        enableImplicitConversion: true,
      },
    }),
  );

  // Global serialization interceptor (converts snake_case → camelCase in responses)
  app.useGlobalInterceptors(new SerializeInterceptor());

  // Swagger documentation
  const config = new DocumentBuilder()
    .setTitle('Service Platform API v2.0')
    .setDescription(`
## Overview
Service Platform is a comprehensive social platform connecting service professionals with clients.
This API provides all the necessary endpoints to build mobile and web applications for both service providers (masters) and clients.

## Features
- 🔐 **Authentication**: JWT-based authentication with refresh tokens
- 👥 **User Management**: Complete user profile and settings management
- 🎨 **Master Profiles**: Professional profiles with portfolios and service listings
- 💼 **Services**: Create, manage, and discover professional services
- 📅 **Bookings**: Real-time booking system with status tracking
- ⭐ **Reviews**: Two-way review system for quality assurance
- 🔍 **Search**: Powerful search with Meilisearch (with PostgreSQL fallback)
- 🔔 **Notifications**: Real-time notifications via WebSocket and Push (FCM/APNs)
- 💬 **Chat**: Real-time messaging between users
- 📊 **Analytics**: Track views, favorites, and engagement

## Authentication
All endpoints (except those marked with 🌐 Public) require Bearer token authentication.

### Getting a token:
1. Register: \`POST /auth/register\`
2. Login: \`POST /auth/login\`
3. Use the returned \`access_token\` in the Authorization header: \`Bearer <token>\`

### Example:
\`\`\`
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
\`\`\`

## Rate Limiting
- Default: 100 requests per minute per IP
- Authenticated: 1000 requests per minute per user

## Error Responses
All errors follow a consistent format:
\`\`\`json
{
  "statusCode": 400,
  "message": "Validation failed",
  "error": "Bad Request"
}
\`\`\`

## Pagination
List endpoints support pagination with these query parameters:
- \`page\`: Page number (default: 1)
- \`limit\`: Items per page (default: 20, max: 100)

Response includes:
\`\`\`json
{
  "data": [...],
  "total": 150,
  "page": 1,
  "limit": 20
}
\`\`\`

## Date Format
All dates are in ISO 8601 format: \`2025-12-30T12:00:00Z\`
    `)
    .setVersion('2.0.0')
    .setContact(
      'Service Platform Team',
      'https://serviceplatform.com',
      'support@serviceplatform.com',
    )
    .setLicense('Proprietary', 'https://serviceplatform.com/license')
    .addServer('http://localhost:3000/api/v2', 'Development Server')
    .addServer('https://api-dev.serviceplatform.com/api/v2', 'Staging Server')
    .addServer('https://api.serviceplatform.com/api/v2', 'Production Server')
    .addBearerAuth(
      {
        type: 'http',
        scheme: 'bearer',
        bearerFormat: 'JWT',
        name: 'Authorization',
        description: 'Enter JWT token',
        in: 'header',
      },
      'JWT-auth',
    )
    .addTag('auth', '🔐 Authentication - User registration, login, and token management')
    .addTag('users', '👥 Users - User profile management and settings')
    .addTag('masters', '🎨 Masters - Professional master profiles and portfolios')
    .addTag('services', '💼 Services - Service listings and management')
    .addTag('bookings', '📅 Bookings - Appointment booking and scheduling')
    .addTag('reviews', '⭐ Reviews - Rating and review system')
    .addTag('categories', '📂 Categories - Service categories and subcategories')
    .addTag('posts', '📱 Posts - Social media posts and content')
    .addTag('friends', '👫 Friends - Friends, followers, and subscriptions')
    .addTag('chats', '💬 Chats - Real-time messaging')
    .addTag('notifications', '🔔 Notifications - Push and in-app notifications')
    .addTag('search', '🔍 Search - Full-text search for masters and services')
    .addTag('analytics', '📊 Analytics - Usage statistics and insights')
    .build();

  const document = SwaggerModule.createDocument(app, config, {
    operationIdFactory: (controllerKey: string, methodKey: string) => methodKey,
  });

  SwaggerModule.setup(`${apiPrefix}/docs`, app, document, {
    customSiteTitle: 'Service Platform API Documentation',
    customfavIcon: 'https://serviceplatform.com/favicon.ico',
    customJs: [
      'https://cdnjs.cloudflare.com/ajax/libs/swagger-ui/4.15.5/swagger-ui-bundle.min.js',
    ],
    customCssUrl: [
      'https://cdnjs.cloudflare.com/ajax/libs/swagger-ui/4.15.5/swagger-ui.min.css',
    ],
    swaggerOptions: {
      persistAuthorization: true,
      docExpansion: 'list',
      filter: true,
      showRequestDuration: true,
      syntaxHighlight: {
        activate: true,
        theme: 'monokai',
      },
      tryItOutEnabled: true,
      requestSnippetsEnabled: true,
      defaultModelsExpandDepth: 3,
      defaultModelExpandDepth: 3,
    },
  });

  const port = process.env.PORT || 3000;
  const host = process.env.HOST || '0.0.0.0';
  await app.listen(port, host);

  console.log(`
    🚀 Service Platform Backend v2.0 started!

    📡 API running on: http://${host}:${port}/${apiPrefix}
    📚 Swagger docs: http://${host}:${port}/${apiPrefix}/docs
    🌍 Environment: ${process.env.NODE_ENV || 'development'}
    🔌 Host: ${host} (accessible from network)
  `);
}

bootstrap();
