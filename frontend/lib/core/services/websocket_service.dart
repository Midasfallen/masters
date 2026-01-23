import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

/// WebSocket Service для real-time коммуникации
/// Использует Socket.IO для подключения к backend WebSocket Gateway
class WebSocketService {
  final FlutterSecureStorage _storage;
  io.Socket? _socket;
  final _connectionStateController = StreamController<ConnectionState>.broadcast();
  final _messageController = StreamController<WebSocketMessage>.broadcast();

  // Отслеживание online пользователей
  final Set<String> _onlineUsers = {};

  Stream<ConnectionState> get connectionState => _connectionStateController.stream;
  Stream<WebSocketMessage> get messages => _messageController.stream;
  Set<String> get onlineUsers => Set.unmodifiable(_onlineUsers);

  bool get isConnected => _socket?.connected ?? false;

  WebSocketService(this._storage);

  /// Подключение к WebSocket серверу
  Future<void> connect(String baseUrl) async {
    if (_socket?.connected == true) {
      return;
    }

    try {
      // Получаем токен из secure storage
      final token = await _storage.read(key: 'auth_token');
      if (token == null) {
        throw Exception('No auth token found');
      }

      // Создаем Socket.IO клиент
      _socket = io.io(
        '$baseUrl/ws', // namespace /ws
        io.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .enableReconnection()
            .setReconnectionDelay(1000)
            .setReconnectionDelayMax(5000)
            .setReconnectionAttempts(5)
            .setAuth({'token': token})
            .build(),
      );

      _setupListeners();
      _socket!.connect();

      _connectionStateController.add(ConnectionState.connecting);
    } catch (e) {
      _connectionStateController.add(ConnectionState.error);
      rethrow;
    }
  }

  /// Настройка слушателей событий
  void _setupListeners() {
    if (_socket == null) return;

    // Успешное подключение
    _socket!.on('connected', (data) {
      _connectionStateController.add(ConnectionState.connected);
      _messageController.add(WebSocketMessage(
        event: 'connected',
        data: data,
        timestamp: DateTime.now(),
      ));
    });

    // Требуется синхронизация
    _socket!.on('sync:required', (data) {
      _messageController.add(WebSocketMessage(
        event: 'sync:required',
        data: data,
        timestamp: DateTime.now(),
      ));
    });

    // Новое сообщение в чате
    _socket!.on('chat:message:new', (data) {
      _messageController.add(WebSocketMessage(
        event: 'chat:message:new',
        data: data,
        timestamp: DateTime.now(),
      ));
    });

    // Сообщение доставлено
    _socket!.on('chat:message:delivered', (data) {
      _messageController.add(WebSocketMessage(
        event: 'chat:message:delivered',
        data: data,
        timestamp: DateTime.now(),
      ));
    });

    // Сообщение прочитано
    _socket!.on('chat:message:read', (data) {
      _messageController.add(WebSocketMessage(
        event: 'chat:message:read',
        data: data,
        timestamp: DateTime.now(),
      ));
    });

    // Пользователь печатает
    _socket!.on('chat:typing', (data) {
      _messageController.add(WebSocketMessage(
        event: 'chat:typing',
        data: data,
        timestamp: DateTime.now(),
      ));
    });

    // Пользователь присоединился к чату
    _socket!.on('chat:user:joined', (data) {
      _messageController.add(WebSocketMessage(
        event: 'chat:user:joined',
        data: data,
        timestamp: DateTime.now(),
      ));
    });

    // Пользователь вышел из чата
    _socket!.on('chat:user:left', (data) {
      _messageController.add(WebSocketMessage(
        event: 'chat:user:left',
        data: data,
        timestamp: DateTime.now(),
      ));
    });

    // Статус пользователя: онлайн
    _socket!.on('user:online', (data) {
      if (data is Map && data['user_id'] != null) {
        _onlineUsers.add(data['user_id'] as String);
      }
      _messageController.add(WebSocketMessage(
        event: 'user:online',
        data: data,
        timestamp: DateTime.now(),
      ));
    });

    // Статус пользователя: оффлайн
    _socket!.on('user:offline', (data) {
      if (data is Map && data['user_id'] != null) {
        _onlineUsers.remove(data['user_id'] as String);
      }
      _messageController.add(WebSocketMessage(
        event: 'user:offline',
        data: data,
        timestamp: DateTime.now(),
      ));
    });

    // Новое уведомление
    _socket!.on('notification:new', (data) {
      _messageController.add(WebSocketMessage(
        event: 'notification:new',
        data: data,
        timestamp: DateTime.now(),
      ));
    });

    // Ошибка
    _socket!.on('error', (data) {
      _connectionStateController.add(ConnectionState.error);
      _messageController.add(WebSocketMessage(
        event: 'error',
        data: data,
        timestamp: DateTime.now(),
      ));
    });

    // Отключение
    _socket!.on('disconnect', (_) {
      _connectionStateController.add(ConnectionState.disconnected);
    });

    // Переподключение
    _socket!.on('reconnect', (_) {
      _connectionStateController.add(ConnectionState.connected);
    });

    // Попытка переподключения
    _socket!.on('reconnect_attempt', (_) {
      _connectionStateController.add(ConnectionState.connecting);
    });
  }

  /// Отправка сообщения в чат
  Future<void> sendMessage({
    required String chatId,
    required String type,
    required String content,
    Map<String, dynamic>? metadata,
    String? replyToId,
  }) async {
    if (_socket?.connected != true) {
      throw Exception('WebSocket not connected');
    }

    _socket!.emitWithAck('chat:message:send', {
      'chat_id': chatId,
      'type': type,
      'content': content,
      if (metadata != null) 'metadata': metadata,
      if (replyToId != null) 'reply_to_id': replyToId,
    }, ack: (response) {
      // Callback с подтверждением от сервера
      _messageController.add(WebSocketMessage(
        event: 'chat:message:send:ack',
        data: response,
        timestamp: DateTime.now(),
      ));
    });
  }

  /// Отметить сообщение как доставленное
  void markAsDelivered({required String messageId, required String chatId}) {
    if (_socket?.connected != true) return;

    _socket!.emit('chat:message:delivered', {
      'message_id': messageId,
      'chat_id': chatId,
    });
  }

  /// Отметить сообщение как прочитанное
  void markAsRead({required String messageId, required String chatId}) {
    if (_socket?.connected != true) return;

    _socket!.emit('chat:message:read', {
      'message_id': messageId,
      'chat_id': chatId,
    });
  }

  /// Отправка события "печатаю"
  void sendTypingIndicator({required String chatId, required bool isTyping}) {
    if (_socket?.connected != true) return;

    _socket!.emit('chat:typing', {
      'chat_id': chatId,
      'is_typing': isTyping,
    });
  }

  /// Присоединиться к комнате чата
  Future<void> joinChat(String chatId) async {
    if (_socket?.connected != true) {
      throw Exception('WebSocket not connected');
    }

    _socket!.emitWithAck('chat:join', {
      'chat_id': chatId,
    }, ack: (response) {
      _messageController.add(WebSocketMessage(
        event: 'chat:join:ack',
        data: response,
        timestamp: DateTime.now(),
      ));
    });
  }

  /// Выйти из комнаты чата
  Future<void> leaveChat(String chatId) async {
    if (_socket?.connected != true) {
      throw Exception('WebSocket not connected');
    }

    _socket!.emitWithAck('chat:leave', {
      'chat_id': chatId,
    }, ack: (response) {
      _messageController.add(WebSocketMessage(
        event: 'chat:leave:ack',
        data: response,
        timestamp: DateTime.now(),
      ));
    });
  }

  /// Отметить уведомление как прочитанное
  void markNotificationAsRead(String notificationId) {
    if (_socket?.connected != true) return;

    _socket!.emit('notification:read', {
      'notification_id': notificationId,
    });
  }

  /// Отключение от WebSocket сервера
  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _connectionStateController.add(ConnectionState.disconnected);
  }

  /// Очистка ресурсов
  void dispose() {
    disconnect();
    _connectionStateController.close();
    _messageController.close();
  }
}

/// Состояние подключения WebSocket
enum ConnectionState {
  disconnected,
  connecting,
  connected,
  error,
}

/// Модель WebSocket сообщения
class WebSocketMessage {
  final String event;
  final dynamic data;
  final DateTime timestamp;

  WebSocketMessage({
    required this.event,
    required this.data,
    required this.timestamp,
  });

  @override
  String toString() {
    return 'WebSocketMessage(event: $event, data: $data, timestamp: $timestamp)';
  }
}

/// Provider для WebSocket service
final webSocketServiceProvider = Provider<WebSocketService>((ref) {
  const storage = FlutterSecureStorage();
  final service = WebSocketService(storage);

  // Автоматическая очистка при dispose
  ref.onDispose(() {
    service.dispose();
  });

  return service;
});

/// Provider для состояния подключения
final webSocketConnectionStateProvider = StreamProvider<ConnectionState>((ref) {
  final service = ref.watch(webSocketServiceProvider);
  return service.connectionState;
});

/// Provider для WebSocket сообщений
final webSocketMessagesProvider = StreamProvider<WebSocketMessage>((ref) {
  final service = ref.watch(webSocketServiceProvider);
  return service.messages;
});
