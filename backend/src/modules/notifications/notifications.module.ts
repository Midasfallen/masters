import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { NotificationsService } from './notifications.service';
import { NotificationsController } from './notifications.controller';
import { FCMService } from './fcm.service';
import { Notification } from './entities/notification.entity';
import { DeviceToken } from './entities/device-token.entity';
import { WebSocketModule } from '../websocket/websocket.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([Notification, DeviceToken]),
    WebSocketModule,
  ],
  controllers: [NotificationsController],
  providers: [NotificationsService, FCMService],
  exports: [NotificationsService, FCMService],
})
export class NotificationsModule {}
