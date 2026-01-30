import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/api/chat_model.dart';
import '../../../core/providers/api/auth_provider.dart';
import '../../../core/providers/api/chats_provider.dart';
import '../../../core/services/websocket_service.dart';
import '../widgets/message_bubble.dart';

/// Chat Screen с real API и WebSocket интеграцией
class ChatScreen extends ConsumerStatefulWidget {
  final String chatId;

  const ChatScreen({
    super.key,
    required this.chatId,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _messageFocusNode = FocusNode();

  Timer? _typingTimer;
  bool _isTyping = false;
  final List<MessageModel> _messages = [];
  bool _isLoadingMessages = false;
  final Set<String> _typingUsers = {};

  @override
  void initState() {
    super.initState();
    _initialize();
    _setupMessageListener();
    _setupTypingListener();

    // Отправка typing indicator при наборе текста
    _messageController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _messageController.removeListener(_onTextChanged);
    _messageController.dispose();
    _scrollController.dispose();
    _messageFocusNode.dispose();
    _typingTimer?.cancel();

    // Выходим из комнаты чата при уходе с экрана
    final wsService = ref.read(webSocketServiceProvider);
    wsService.leaveChat(widget.chatId);

    super.dispose();
  }

  /// Инициализация чата
  Future<void> _initialize() async {
    try {
      final wsService = ref.read(webSocketServiceProvider);

      // Присоединяемся к комнате чата
      await wsService.joinChat(widget.chatId);

      // Загружаем сообщения из API
      await _loadMessages();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка инициализации: ${e.toString()}')),
        );
      }
    }
  }

  /// Загрузка сообщений из API
  Future<void> _loadMessages() async {
    if (_isLoadingMessages) return;

    setState(() => _isLoadingMessages = true);

    try {
      final messages = await ref.read(chatMessagesProvider(widget.chatId).future);

      if (mounted) {
        setState(() {
          _messages.clear();
          _messages.addAll(messages);
        });

        // Прокручиваем к последнему сообщению
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });

        // Отмечаем сообщения как прочитанные
        _markMessagesAsRead();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка загрузки: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingMessages = false);
      }
    }
  }

  /// Настройка слушателя WebSocket сообщений
  void _setupMessageListener() {
    final wsService = ref.read(webSocketServiceProvider);

    wsService.messages.listen((wsMessage) {
      if (wsMessage.event == 'chat:message:new') {
        final data = wsMessage.data as Map<String, dynamic>;

        // Проверяем, что сообщение для этого чата
        if (data['chat_id'] == widget.chatId) {
          final newMessage = MessageModel.fromJson(data);

          if (mounted) {
            setState(() {
              _messages.add(newMessage);
            });

            _scrollToBottom();

            // Отмечаем как прочитанное если не мы отправили
            if (newMessage.senderId != ref.read(currentUserIdProvider)) {
              wsService.markAsRead(
                messageId: newMessage.id,
                chatId: widget.chatId,
              );
            }
          }
        }
      }
    });
  }

  /// Настройка слушателя typing indicator
  void _setupTypingListener() {
    final wsService = ref.read(webSocketServiceProvider);

    wsService.messages.listen((wsMessage) {
      if (wsMessage.event == 'chat:typing') {
        final data = wsMessage.data as Map<String, dynamic>;

        if (data['chat_id'] == widget.chatId) {
          final userId = data['user_id'] as String;
          final isTyping = data['is_typing'] as bool;

          if (mounted) {
            setState(() {
              if (isTyping) {
                _typingUsers.add(userId);
              } else {
                _typingUsers.remove(userId);
              }
            });
          }
        }
      }
    });
  }

  /// Обработчик изменения текста (для typing indicator)
  void _onTextChanged() {
    if (_messageController.text.trim().isEmpty) {
      if (_isTyping) {
        _sendTypingIndicator(false);
        _isTyping = false;
      }
      return;
    }

    if (!_isTyping) {
      _sendTypingIndicator(true);
      _isTyping = true;
    }

    // Сбрасываем таймер
    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(seconds: 2), () {
      if (_isTyping) {
        _sendTypingIndicator(false);
        _isTyping = false;
      }
    });
  }

  /// Отправка typing indicator
  void _sendTypingIndicator(bool isTyping) {
    final wsService = ref.read(webSocketServiceProvider);
    wsService.sendTypingIndicator(chatId: widget.chatId, isTyping: isTyping);
  }

  /// Отправка сообщения
  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final content = _messageController.text.trim();
    _messageController.clear();

    // Останавливаем typing indicator
    if (_isTyping) {
      _sendTypingIndicator(false);
      _isTyping = false;
    }

    try {
      final wsService = ref.read(webSocketServiceProvider);

      // Отправляем через WebSocket
      await wsService.sendMessage(
        chatId: widget.chatId,
        type: 'text',
        content: content,
      );

      // Сообщение будет добавлено в список когда придет событие chat:message:new
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка отправки: ${e.toString()}')),
        );
      }
    }
  }

  /// Прокрутка к последнему сообщению
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  /// Отметить сообщения как прочитанные
  void _markMessagesAsRead() {
    final wsService = ref.read(webSocketServiceProvider);
    final currentUserId = ref.read(currentUserIdProvider);

    for (final message in _messages) {
      if (message.senderId != currentUserId) {
        wsService.markAsRead(
          messageId: message.id,
          chatId: widget.chatId,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatAsync = ref.watch(chatByIdProvider(widget.chatId));

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: chatAsync.when(
          data: (chat) => _buildAppBarTitle(chat),
          loading: () => const Text('Загрузка...'),
          error: (_, __) => const Text('Ошибка'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Видеозвонок (в разработке)')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Звонок (в разработке)')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Меню (в разработке)')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Список сообщений
          Expanded(
            child: _isLoadingMessages
                ? const Center(child: CircularProgressIndicator())
                : _messages.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final message = _messages[index];
                          final currentUserId = ref.read(currentUserIdProvider);
                          final isMe = message.senderId == currentUserId;

                          return MessageBubble(
                            message: message,
                            isMe: isMe,
                          );
                        },
                      ),
          ),

          // Typing indicator
          if (_typingUsers.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              alignment: Alignment.centerLeft,
              child: Text(
                'Печатает...',
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[600],
                ),
              ),
            ),

          // Поле ввода сообщения
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            padding: EdgeInsets.only(
              left: 16,
              right: 8,
              top: 12,
              bottom: 12 + MediaQuery.of(context).padding.bottom,
            ),
            child: Row(
              children: [
                // Кнопка прикрепления
                IconButton(
                  icon: Icon(Icons.add_circle_outline,
                      color: Theme.of(context).primaryColor),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Прикрепление файлов (в разработке)')),
                    );
                  },
                ),
                const SizedBox(width: 8),

                // Поле ввода
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    focusNode: _messageFocusNode,
                    decoration: InputDecoration(
                      hintText: 'Сообщение...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),

                // Кнопка отправки
                IconButton(
                  icon: Icon(
                    Icons.send,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBarTitle(ChatModel chat) {
    final currentUserId = ref.watch(currentUserIdProvider);

    // Определяем собеседника из otherUser или name чата
    final otherUser = chat.otherUser;

    // Для group чатов показываем название
    if (chat.type == ChatType.group) {
      return Text(chat.name ?? 'Группа');
    }

    if (otherUser == null) {
      return Text(chat.name ?? 'Чат');
    }

    // Для direct чата получаем ID собеседника из myParticipant
    final otherUserId = chat.myParticipant?.userId != currentUserId
        ? chat.myParticipant?.userId
        : null;

    // Проверяем online статус через WebSocket
    final wsService = ref.watch(webSocketServiceProvider);
    final isOnline = wsService.onlineUsers.contains(otherUserId);

    return Row(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: otherUser.avatarUrl != null
                ? NetworkImage(otherUser.avatarUrl!)
                : null,
              child: otherUser.avatarUrl == null
                ? Text(
                    otherUser.firstName[0].toUpperCase(),
                    style: const TextStyle(fontSize: 14),
                  )
                : null,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: isOnline ? Colors.green : Colors.grey,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${otherUser.firstName} ${otherUser.lastName}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                isOnline ? 'В сети' : 'Не в сети',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Нет сообщений',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Начните общение с собеседником',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}

final currentUserIdProvider = Provider<String>((ref) {
  // Получаем из auth state
  final authState = ref.watch(authNotifierProvider);
  return authState.value?.user?.id ?? '';
});
