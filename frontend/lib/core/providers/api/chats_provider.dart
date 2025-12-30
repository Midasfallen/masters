import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_platform/core/models/api/chat_model.dart';
import 'package:service_platform/core/repositories/chat_repository.dart';

part 'chats_provider.g.dart';

/// Chats List Provider
@riverpod
Future<List<ChatModel>> chatsList(
  ChatsListRef ref, {
  int page = 1,
  int limit = 20,
}) async {
  final repository = ref.watch(chatRepositoryProvider);
  return await repository.getChats(page: page, limit: limit);
}

/// Chat by ID Provider
@riverpod
Future<ChatModel> chatById(ChatByIdRef ref, String chatId) async {
  final repository = ref.watch(chatRepositoryProvider);
  return await repository.getChatById(chatId);
}

/// Chat Messages Provider
@riverpod
Future<List<MessageModel>> chatMessages(
  ChatMessagesRef ref,
  String chatId, {
  int page = 1,
  int limit = 50,
}) async {
  final repository = ref.watch(chatRepositoryProvider);
  return await repository.getMessages(
    chatId,
    page: page,
    limit: limit,
  );
}

/// Chat Notifier for mutations
@riverpod
class ChatNotifier extends _$ChatNotifier {
  @override
  FutureOr<ChatModel?> build() async {
    return null;
  }

  /// Create or get chat with user
  Future<ChatModel> createChat(String userId) async {
    state = const AsyncValue.loading();

    return await AsyncValue.guard(() async {
      final repository = ref.read(chatRepositoryProvider);
      final chat = await repository.createChat(
        CreateChatRequest(userId: userId),
      );

      // Invalidate chats list
      ref.invalidate(chatsListProvider);

      return chat;
    }).then((asyncValue) {
      state = asyncValue;
      return asyncValue.requireValue;
    });
  }

  /// Send message
  Future<MessageModel> sendMessage(
    String chatId,
    String content, {
    MessageType type = MessageType.text,
    String? mediaUrl,
    Map<String, dynamic>? metadata,
  }) async {
    final repository = ref.read(chatRepositoryProvider);
    final message = await repository.sendMessage(
      chatId,
      SendMessageRequest(
        content: content,
        type: type,
        mediaUrl: mediaUrl,
        metadata: metadata,
      ),
    );

    // Invalidate messages
    ref.invalidate(chatMessagesProvider(chatId));
    ref.invalidate(chatByIdProvider(chatId));
    ref.invalidate(chatsListProvider);

    return message;
  }

  /// Mark chat as read
  Future<void> markAsRead(String chatId) async {
    final repository = ref.read(chatRepositoryProvider);
    await repository.markAsRead(chatId);

    // Invalidate chat
    ref.invalidate(chatByIdProvider(chatId));
    ref.invalidate(chatsListProvider);
  }
}
