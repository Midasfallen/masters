import {
  WebSocketGateway,
  WebSocketServer,
  SubscribeMessage,
  OnGatewayConnection,
  OnGatewayDisconnect,
  ConnectedSocket,
  MessageBody,
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { Logger } from '@nestjs/common';
import { WebSocketService } from './websocket.service';

@WebSocketGateway({
  cors: {
    origin: '*', // В продакшене указать конкретные домены
  },
  namespace: '/ws',
})
export class WebSocketGateway implements OnGatewayConnection, OnGatewayDisconnect {
  @WebSocketServer()
  server: Server;

  private logger = new Logger('WebSocketGateway');

  constructor(private readonly websocketService: WebSocketService) {}

  async handleConnection(client: Socket) {
    try {
      // Получаем userId из токена или query параметров
      const userId = client.handshake.auth?.userId || client.handshake.query?.userId;

      if (!userId) {
        this.logger.warn(`Client ${client.id} connected without userId`);
        client.disconnect();
        return;
      }

      this.logger.log(`Client connected: ${client.id}, userId: ${userId}`);

      // Сохраняем подключение
      await this.websocketService.addConnection(userId as string, client.id);

      // Присоединяем к комнате пользователя
      client.join(`user:${userId}`);

      // Уведомляем о статусе online
      this.server.emit('user:status', {
        userId,
        status: 'online',
        timestamp: new Date(),
      });
    } catch (error) {
      this.logger.error(`Error handling connection: ${error.message}`);
      client.disconnect();
    }
  }

  async handleDisconnect(client: Socket) {
    try {
      const userId = client.handshake.auth?.userId || client.handshake.query?.userId;

      if (userId) {
        this.logger.log(`Client disconnected: ${client.id}, userId: ${userId}`);

        // Удаляем подключение
        await this.websocketService.removeConnection(userId as string, client.id);

        // Проверяем, есть ли еще активные подключения пользователя
        const hasActiveConnections = await this.websocketService.hasActiveConnections(userId as string);

        if (!hasActiveConnections) {
          // Уведомляем о статусе offline
          this.server.emit('user:status', {
            userId,
            status: 'offline',
            timestamp: new Date(),
          });
        }
      }
    } catch (error) {
      this.logger.error(`Error handling disconnect: ${error.message}`);
    }
  }

  // Новое сообщение в чате
  @SubscribeMessage('message:send')
  async handleMessage(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { chatId: string; message: any },
  ) {
    const userId = client.handshake.auth?.userId || client.handshake.query?.userId;
    this.logger.log(`Message from ${userId} to chat ${data.chatId}`);

    // Отправляем сообщение всем участникам чата
    this.server.to(`chat:${data.chatId}`).emit('message:new', data.message);
  }

  // Прочитано сообщение
  @SubscribeMessage('message:read')
  async handleMessageRead(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { chatId: string; messageId: string },
  ) {
    const userId = client.handshake.auth?.userId || client.handshake.query?.userId;

    // Уведомляем участников чата
    this.server.to(`chat:${data.chatId}`).emit('message:read', {
      userId,
      messageId: data.messageId,
      timestamp: new Date(),
    });
  }

  // Пользователь печатает
  @SubscribeMessage('user:typing')
  async handleTyping(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { chatId: string; isTyping: boolean },
  ) {
    const userId = client.handshake.auth?.userId || client.handshake.query?.userId;

    // Уведомляем других участников чата
    client.to(`chat:${data.chatId}`).emit('user:typing', {
      userId,
      chatId: data.chatId,
      isTyping: data.isTyping,
      timestamp: new Date(),
    });
  }

  // Присоединиться к комнате чата
  @SubscribeMessage('chat:join')
  async handleJoinChat(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { chatId: string },
  ) {
    const userId = client.handshake.auth?.userId || client.handshake.query?.userId;
    this.logger.log(`User ${userId} joined chat ${data.chatId}`);

    client.join(`chat:${data.chatId}`);

    return { success: true, chatId: data.chatId };
  }

  // Покинуть комнату чата
  @SubscribeMessage('chat:leave')
  async handleLeaveChat(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { chatId: string },
  ) {
    const userId = client.handshake.auth?.userId || client.handshake.query?.userId;
    this.logger.log(`User ${userId} left chat ${data.chatId}`);

    client.leave(`chat:${data.chatId}`);

    return { success: true, chatId: data.chatId };
  }

  // Публичные методы для отправки событий из других модулей

  sendMessageToUser(userId: string, event: string, data: any) {
    this.server.to(`user:${userId}`).emit(event, data);
  }

  sendMessageToChat(chatId: string, event: string, data: any) {
    this.server.to(`chat:${chatId}`).emit(event, data);
  }

  broadcastMessage(event: string, data: any) {
    this.server.emit(event, data);
  }
}
