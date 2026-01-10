import {
  WebSocketGateway,
  WebSocketServer,
  SubscribeMessage,
  OnGatewayConnection,
  OnGatewayDisconnect,
  ConnectedSocket,
  MessageBody,
  WsException,
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { Logger } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { WebSocketService } from './websocket.service';

@WebSocketGateway({
  cors: {
    origin: '*', // В продакшене указать конкретные домены
  },
  namespace: '/ws',
})
export class AppWebSocketGateway
  implements OnGatewayConnection, OnGatewayDisconnect
{
  @WebSocketServer()
  server: Server;

  private logger = new Logger('AppWebSocketGateway');

  constructor(
    private readonly websocketService: WebSocketService,
    private readonly jwtService: JwtService,
  ) {}

  async handleConnection(client: Socket) {
    try {
      // JWT аутентификация через handshake
      const token =
        client.handshake.auth?.token || client.handshake.headers?.authorization;

      if (!token) {
        this.logger.warn(`Client ${client.id} connected without token`);
        client.emit('error', {
          code: 'UNAUTHORIZED',
          message: 'No token provided',
          timestamp: new Date().toISOString(),
        });
        client.disconnect();
        return;
      }

      // Валидация JWT
      let payload: any;
      try {
        // Убираем "Bearer " если есть
        const cleanToken = token.replace('Bearer ', '');
        payload = this.jwtService.verify(cleanToken);
      } catch (error) {
        this.logger.warn(
          `Client ${client.id} provided invalid token: ${error.message}`,
        );
        client.emit('error', {
          code: 'UNAUTHORIZED',
          message: 'Invalid or expired token',
          timestamp: new Date().toISOString(),
        });
        client.disconnect();
        return;
      }

      const userId = payload.sub;

      if (!userId) {
        this.logger.warn(`Client ${client.id} - no userId in token payload`);
        client.disconnect();
        return;
      }

      // Сохраняем user в socket data для дальнейшего использования
      client.data.user = {
        id: userId,
        email: payload.email,
      };

      this.logger.log(`Client connected: ${client.id}, userId: ${userId}`);

      // Сохраняем подключение
      await this.websocketService.addConnection(userId, client.id);

      // Присоединяем к личной комнате пользователя
      client.join(`user:${userId}`);

      // Уведомляем об online статусе
      this.server.emit('user:online', {
        user_id: userId,
        online: true,
        last_seen: new Date().toISOString(),
      });

      // Отправляем подтверждение подключения
      client.emit('connected', {
        socket_id: client.id,
        user_id: userId,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      this.logger.error(`Error handling connection: ${error.message}`);
      client.emit('error', {
        code: 'CONNECTION_ERROR',
        message: 'Failed to establish connection',
        timestamp: new Date().toISOString(),
      });
      client.disconnect();
    }
  }

  async handleDisconnect(client: Socket) {
    try {
      const userId = client.data.user?.id;

      if (userId) {
        this.logger.log(`Client disconnected: ${client.id}, userId: ${userId}`);

        // Удаляем подключение
        await this.websocketService.removeConnection(userId, client.id);

        // Проверяем, есть ли еще активные подключения пользователя
        const hasActiveConnections =
          await this.websocketService.hasActiveConnections(userId);

        if (!hasActiveConnections) {
          // Уведомляем о статусе offline
          this.server.emit('user:offline', {
            user_id: userId,
            online: false,
            last_seen: new Date().toISOString(),
          });
        }
      }
    } catch (error) {
      this.logger.error(`Error handling disconnect: ${error.message}`);
    }
  }

  // ============ CHAT EVENTS ============

  // Отправка сообщения
  @SubscribeMessage('chat:message:send')
  async handleMessageSend(
    @ConnectedSocket() client: Socket,
    @MessageBody()
    data: {
      chat_id: string;
      type: string;
      content: string;
      metadata?: any;
      reply_to_id?: string;
    },
  ) {
    try {
      const userId = client.data.user?.id;

      if (!userId) {
        throw new WsException('Unauthorized');
      }

      this.logger.log(
        `Message from ${userId} to chat ${data.chat_id}, type: ${data.type}`,
      );

      // Здесь должна быть интеграция с MessagesService для сохранения в БД
      // Пока эмитим событие всем участникам чата

      // Отправляем сообщение всем участникам чата
      this.server.to(`chat:${data.chat_id}`).emit('chat:message:new', {
        id: `temp-${Date.now()}`, // Временный ID, в реальности вернется из БД
        chat_id: data.chat_id,
        sender_id: userId,
        type: data.type,
        content: data.content,
        metadata: data.metadata,
        reply_to_id: data.reply_to_id,
        created_at: new Date().toISOString(),
        status: 'sent',
      });

      // ACK отправителю
      return {
        status: 'sent',
        message_id: `temp-${Date.now()}`,
        created_at: new Date().toISOString(),
      };
    } catch (error) {
      this.logger.error(`Error sending message: ${error.message}`);
      throw new WsException('Failed to send message');
    }
  }

  // Сообщение доставлено
  @SubscribeMessage('chat:message:delivered')
  async handleMessageDelivered(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { message_id: string; chat_id: string },
  ) {
    const userId = client.data.user?.id;

    // Уведомляем отправителя о доставке
    this.server.to(`chat:${data.chat_id}`).emit('chat:message:delivered', {
      message_id: data.message_id,
      chat_id: data.chat_id,
      delivered_to: userId,
      delivered_at: new Date().toISOString(),
    });

    return { status: 'acknowledged' };
  }

  // Прочитано сообщение
  @SubscribeMessage('chat:message:read')
  async handleMessageRead(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { message_id: string; chat_id: string },
  ) {
    const userId = client.data.user?.id;

    if (!userId) {
      throw new WsException('Unauthorized');
    }

    // Уведомляем участников чата
    this.server.to(`chat:${data.chat_id}`).emit('chat:message:read', {
      message_id: data.message_id,
      chat_id: data.chat_id,
      read_by: userId,
      read_at: new Date().toISOString(),
    });

    return { status: 'read', timestamp: new Date().toISOString() };
  }

  // Пользователь печатает
  @SubscribeMessage('chat:typing')
  async handleTyping(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { chat_id: string; is_typing: boolean },
  ) {
    const userId = client.data.user?.id;

    if (!userId) {
      throw new WsException('Unauthorized');
    }

    // Уведомляем других участников чата (не самого отправителя)
    client.to(`chat:${data.chat_id}`).emit('chat:typing', {
      chat_id: data.chat_id,
      user_id: userId,
      is_typing: data.is_typing,
      timestamp: new Date().toISOString(),
    });

    return { status: 'broadcasted' };
  }

  // Присоединиться к комнате чата
  @SubscribeMessage('chat:join')
  async handleJoinChat(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { chat_id: string },
  ) {
    try {
      const userId = client.data.user?.id;

      if (!userId) {
        throw new WsException('Unauthorized');
      }

      this.logger.log(`User ${userId} joined chat ${data.chat_id}`);

      // Присоединяем к комнате чата
      client.join(`chat:${data.chat_id}`);

      // Уведомляем участников о присоединении
      client.to(`chat:${data.chat_id}`).emit('chat:user:joined', {
        chat_id: data.chat_id,
        user_id: userId,
        timestamp: new Date().toISOString(),
      });

      return { status: 'joined', chat_id: data.chat_id };
    } catch (error) {
      this.logger.error(`Error joining chat: ${error.message}`);
      throw new WsException('Failed to join chat');
    }
  }

  // Покинуть комнату чата
  @SubscribeMessage('chat:leave')
  async handleLeaveChat(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { chat_id: string },
  ) {
    const userId = client.data.user?.id;

    if (!userId) {
      throw new WsException('Unauthorized');
    }

    this.logger.log(`User ${userId} left chat ${data.chat_id}`);

    // Уведомляем участников о выходе
    client.to(`chat:${data.chat_id}`).emit('chat:user:left', {
      chat_id: data.chat_id,
      user_id: userId,
      timestamp: new Date().toISOString(),
    });

    // Покидаем комнату
    client.leave(`chat:${data.chat_id}`);

    return { status: 'left', chat_id: data.chat_id };
  }

  // ============ NOTIFICATION EVENTS ============

  // Прочтение уведомления (клиент отправляет)
  @SubscribeMessage('notification:read')
  async handleNotificationRead(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { notification_id: string },
  ) {
    const userId = client.data.user?.id;

    if (!userId) {
      throw new WsException('Unauthorized');
    }

    // Здесь должна быть интеграция с NotificationsService

    return {
      notification_id: data.notification_id,
      is_read: true,
      read_at: new Date().toISOString(),
    };
  }

  // ============ PUBLIC METHODS (вызываются из других модулей) ============

  // Отправить сообщение конкретному пользователю
  sendMessageToUser(userId: string, event: string, data: any) {
    this.server.to(`user:${userId}`).emit(event, data);
    this.logger.debug(`Sent ${event} to user ${userId}`);
  }

  // Отправить сообщение в чат
  sendMessageToChat(chatId: string, event: string, data: any) {
    this.server.to(`chat:${chatId}`).emit(event, data);
    this.logger.debug(`Sent ${event} to chat ${chatId}`);
  }

  // Broadcast всем подключенным клиентам
  broadcastMessage(event: string, data: any) {
    this.server.emit(event, data);
    this.logger.debug(`Broadcasted ${event} to all clients`);
  }

  // Отправить новое уведомление пользователю
  sendNotification(userId: string, notification: any) {
    this.sendMessageToUser(userId, 'notification:new', notification);
  }

  // Отправить событие online/offline статуса
  broadcastUserStatus(userId: string, online: boolean) {
    this.server.emit(online ? 'user:online' : 'user:offline', {
      user_id: userId,
      online,
      last_seen: new Date().toISOString(),
    });
  }

  // Отправить событие о лайке поста
  broadcastPostLiked(postId: string, data: any) {
    this.server.emit('post:liked', {
      post_id: postId,
      ...data,
    });
  }

  // Отправить событие о новом комментарии
  broadcastPostCommented(postId: string, data: any) {
    this.server.emit('post:commented', {
      post_id: postId,
      ...data,
    });
  }

  // ============ UTILITY METHODS ============

  // Получить количество подключенных клиентов
  async getConnectionsCount(): Promise<number> {
    return this.websocketService.getConnectionsCount();
  }

  // Получить список онлайн пользователей
  async getOnlineUsers(): Promise<string[]> {
    return this.websocketService.getOnlineUsers();
  }

  // Проверить онлайн ли пользователь
  async isUserOnline(userId: string): Promise<boolean> {
    return this.websocketService.isUserOnline(userId);
  }
}
