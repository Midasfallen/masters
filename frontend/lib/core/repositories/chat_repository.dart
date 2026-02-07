import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_platform/core/api/api_endpoints.dart';
import 'package:service_platform/core/api/api_exceptions.dart';
import 'package:service_platform/core/api/dio_client.dart';
import 'package:service_platform/core/api/api_helpers.dart';
import 'package:service_platform/core/models/api/chat_model.dart';
import 'package:service_platform/core/models/api/user_model.dart';

part 'chat_repository.g.dart';

class ChatRepository {
  final DioClient _client;

  ChatRepository(this._client);

  /// Get all chats
  Future<List<ChatModel>> getChats({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _client.get(
        ApiEndpoints.chats,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      final data = ApiHelpers.parseListResponse(response.data);
      return data.map((json) => ChatModel.fromJson(json as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Get chat by ID
  Future<ChatModel> getChatById(String id) async {
    try {
      final response = await _client.get(
        ApiEndpoints.chatById(id),
      );
      return ChatModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Create or get existing chat with user
  Future<ChatModel> createChat(CreateChatRequest request) async {
    try {
      final response = await _client.post(
        ApiEndpoints.chatCreate,
        data: request.toJson(),
      );
      return ChatModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Get chat messages (GET /messages?chat_id=xxx)
  Future<List<MessageModel>> getMessages(
    String chatId, {
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final response = await _client.get(
        ApiEndpoints.messages,
        queryParameters: {
          'chat_id': chatId,
          'page': page,
          'limit': limit,
        },
      );

      final data = ApiHelpers.parseListResponse(response.data);
      return data.map((json) => MessageModel.fromJson(json as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Send message (POST /messages, chat_id in body)
  Future<MessageModel> sendMessage(SendMessageRequest request) async {
    try {
      final response = await _client.post(
        ApiEndpoints.messages,
        data: request.toJson(),
      );
      return MessageModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Mark chat as read (POST /chats/:id/read with { message_id })
  Future<void> markAsRead(String chatId, {required String messageId}) async {
    try {
      await _client.post(
        ApiEndpoints.chatMarkRead(chatId),
        data: {'message_id': messageId},
      );
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Search users for chat creation
  Future<List<UserModel>> searchUsers(String query, {int page = 1, int limit = 20}) async {
    try {
      final response = await _client.get(
        ApiEndpoints.searchUsers,
        queryParameters: {
          'query': query,
          'page': page,
          'limit': limit,
        },
      );
      final data = ApiHelpers.parseListResponse(response.data);
      return data.map((json) => UserModel.fromJson(json as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Delete / leave chat
  Future<void> deleteChat(String chatId) async {
    try {
      await _client.delete(ApiEndpoints.chatById(chatId));
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Pin chat
  Future<void> pinChat(String chatId) async {
    try {
      await _client.post(ApiEndpoints.chatPin(chatId));
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Unpin chat
  Future<void> unpinChat(String chatId) async {
    try {
      await _client.post(ApiEndpoints.chatUnpin(chatId));
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }
}

@riverpod
ChatRepository chatRepository(ChatRepositoryRef ref) {
  final client = ref.watch(dioClientProvider);
  return ChatRepository(client);
}
