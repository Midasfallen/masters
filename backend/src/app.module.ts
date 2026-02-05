import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ScheduleModule } from '@nestjs/schedule';
import { APP_GUARD } from '@nestjs/core';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { typeOrmConfig } from './config/typeorm.config';
import smtpConfig from './config/smtp.config';
import minioConfig from './config/minio.config';
import { LoggerModule } from './common/logger/logger.module';
import { CommonModule } from './common/common.module';
import { AuthModule } from './modules/auth/auth.module';
import { UsersModule } from './modules/users/users.module';
import { MastersModule } from './modules/masters/masters.module';
import { ServicesModule } from './modules/services/services.module';
import { BookingsModule } from './modules/bookings/bookings.module';
import { CategoriesModule } from './modules/categories/categories.module';
import { ServiceTemplatesModule } from './modules/service-templates/service-templates.module';
import { ReviewsModule } from './modules/reviews/reviews.module';
import { NotificationsModule } from './modules/notifications/notifications.module';
import { SearchModule } from './modules/search/search.module';
import { PostsModule } from './modules/posts/posts.module';
import { SocialModule } from './modules/social/social.module';
import { FriendsModule } from './modules/friends/friends.module';
import { ChatsModule } from './modules/chats/chats.module';
import { WebSocketModule } from './modules/websocket/websocket.module';
import { AutoProposalsModule } from './modules/auto-proposals/auto-proposals.module';
import { AdminModule } from './modules/admin/admin.module';
import { SchedulerModule } from './modules/scheduler/scheduler.module';
import { FavoritesModule } from './modules/favorites/favorites.module';
import { JwtAuthGuard } from './modules/auth/guards/jwt-auth.guard';
import { UploadModule } from './modules/upload/upload.module';

@Module({
  imports: [
    // Configuration
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: '.env',
      load: [smtpConfig, minioConfig],
    }),

    // Scheduler (для cron jobs)
    ScheduleModule.forRoot(),

    // Logger
    LoggerModule,

    // Common (Health checks, cache, email)
    CommonModule,

    // Database
    TypeOrmModule.forRootAsync({
      useFactory: typeOrmConfig,
    }),

    // Feature modules
    AuthModule,
    UsersModule,
    MastersModule,
    ServicesModule,
    BookingsModule,
    CategoriesModule,
    ServiceTemplatesModule,
    ReviewsModule,
    NotificationsModule,
    SearchModule,

    // Social Platform modules (v2.0)
    PostsModule,
    SocialModule,
    FriendsModule,
    ChatsModule,
    WebSocketModule,
    FavoritesModule,

    // Auto Proposals (Premium feature)
    AutoProposalsModule,

    // Admin Panel
    AdminModule,

    // Scheduled Tasks
    SchedulerModule,

    UploadModule,
  ],
  controllers: [AppController],
  providers: [
    AppService,
    // Global JWT guard - все endpoints требуют аутентификации по умолчанию
    // Используйте @Public() декоратор для публичных endpoints
    {
      provide: APP_GUARD,
      useClass: JwtAuthGuard,
    },
  ],
})
export class AppModule {}
