import { Injectable } from '@nestjs/common';

interface UserConnection {
  userId: string;
  socketIds: Set<string>;
  lastActivity: Date;
}

@Injectable()
export class WebSocketService {
  private connections: Map<string, UserConnection> = new Map();

  async addConnection(userId: string, socketId: string): Promise<void> {
    const connection = this.connections.get(userId);

    if (connection) {
      connection.socketIds.add(socketId);
      connection.lastActivity = new Date();
    } else {
      this.connections.set(userId, {
        userId,
        socketIds: new Set([socketId]),
        lastActivity: new Date(),
      });
    }
  }

  async removeConnection(userId: string, socketId: string): Promise<void> {
    const connection = this.connections.get(userId);

    if (connection) {
      connection.socketIds.delete(socketId);

      // Если у пользователя не осталось подключений, удаляем запись
      if (connection.socketIds.size === 0) {
        this.connections.delete(userId);
      } else {
        connection.lastActivity = new Date();
      }
    }
  }

  async hasActiveConnections(userId: string): Promise<boolean> {
    const connection = this.connections.get(userId);
    return connection ? connection.socketIds.size > 0 : false;
  }

  async getSocketIds(userId: string): Promise<string[]> {
    const connection = this.connections.get(userId);
    return connection ? Array.from(connection.socketIds) : [];
  }

  async getOnlineUsers(): Promise<string[]> {
    return Array.from(this.connections.keys());
  }

  async isUserOnline(userId: string): Promise<boolean> {
    return this.connections.has(userId);
  }

  async getUsersCount(): Promise<number> {
    return this.connections.size;
  }

  async getConnectionsCount(): Promise<number> {
    let count = 0;
    this.connections.forEach((connection) => {
      count += connection.socketIds.size;
    });
    return count;
  }

  async cleanupInactiveConnections(inactiveMinutes: number = 30): Promise<number> {
    const now = new Date();
    const threshold = new Date(now.getTime() - inactiveMinutes * 60 * 1000);
    let cleaned = 0;

    this.connections.forEach((connection, userId) => {
      if (connection.lastActivity < threshold) {
        this.connections.delete(userId);
        cleaned++;
      }
    });

    return cleaned;
  }
}
