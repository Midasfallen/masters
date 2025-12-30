import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Global prefix
  const apiPrefix = process.env.API_PREFIX || 'api/v2';
  app.setGlobalPrefix(apiPrefix);

  // CORS
  app.enableCors({
    origin: process.env.CORS_ORIGIN?.split(',') || '*',
    credentials: true,
  });

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

  // Swagger documentation
  const config = new DocumentBuilder()
    .setTitle('Service Platform API v2.0')
    .setDescription('API documentation for Service Platform - Social platform for service professionals')
    .setVersion('2.0.0')
    .addBearerAuth()
    .addTag('auth', 'Authentication endpoints')
    .addTag('users', 'User management')
    .addTag('masters', 'Master profiles')
    .addTag('services', 'Services management')
    .addTag('bookings', 'Booking system')
    .addTag('posts', 'Social posts')
    .addTag('friends', 'Friends & Subscriptions')
    .addTag('chats', 'Real-time messaging')
    .addTag('notifications', 'Notifications')
    .addTag('search', 'Search functionality')
    .build();

  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup(`${apiPrefix}/docs`, app, document, {
    swaggerOptions: {
      persistAuthorization: true,
    },
  });

  const port = process.env.PORT || 3000;
  await app.listen(port);

  console.log(`
    🚀 Service Platform Backend v2.0 started!

    📡 API running on: http://localhost:${port}/${apiPrefix}
    📚 Swagger docs: http://localhost:${port}/${apiPrefix}/docs
    🌍 Environment: ${process.env.NODE_ENV || 'development'}
  `);
}

bootstrap();
