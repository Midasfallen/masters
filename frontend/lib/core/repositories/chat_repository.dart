import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_platform/core/api/api_endpoints.dart';
import 'package:service_platform/core/api/api_exceptions.dart';
import 'package:service_platform/core/api/dio_client.dart';
import 'package:service_platform/core/models/api/chat_model.dart';

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

      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => ChatModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Get chat by ID
  Future<ChatModel> getChatById(String id) async {
    try {
      final response = await _client.get(
        ApiEndpoints.chatById(int.parse(id)),
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

  /// Get chat messages
  Future<List<MessageModel>> getMessages(
    String chatId, {
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final response = await _client.get(
        ApiEndpoints.chatMessages(int.parse(chatId)),
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => MessageModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Send message
  Future<MessageModel> sendMessage(
    String chatId,
    SendMessageRequest request,
  ) async {
    try {
      final response = await _client.post(
        ApiEndpoints.chatSendMessage(int.parse(chatId)),
        data: request.toJson(),
      );
      return MessageModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Mark chat as read
  Future<void> markAsRead(String chatId) async {
    try {
      await _client.post(ApiEndpoints.chatMarkRead(int.parse(chatId)));
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
