import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../core/providers/mock_data_provider.dart';
import '../../../core/models/chat.dart';

class ChatsListScreen extends ConsumerStatefulWidget {
  const ChatsListScreen({super.key});

  @override
  ConsumerState<ChatsListScreen> createState() => _ChatsListScreenState();
}

class _ChatsListScreenState extends ConsumerState<ChatsListScreen> {
  List<Chat> _chats = [];

  @override
  void initState() {
    super.initState();
    // Initialize chats from provider
    Future.microtask(() {
      setState(() {
        _chats = ref.read(mockChatsProvider);
      });
    });
  }

  void _togglePin(Chat chat) {
    setState(() {
      _chats = _chats.map((c) {
        if (c.id == chat.id) {
          return c.copyWith(isPinned: !c.isPinned);
        }
        return c;
      }).toList();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          chat.isPinned ? 'Чат откреплён' : 'Чат закреплён',
        ),
        duration: const Duration(milliseconds: 800),
      ),
    );
  }

  List<Chat> get _sortedChats {
    // Sort chats: pinned first, then by update time
    final pinned = _chats.where((c) => c.isPinned).toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    final unpinned = _chats.where((c) => !c.isPinned).toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return [...pinned, ...unpinned];
  }

  @override
  Widget build(BuildContext context) {
    final sortedChats = _sortedChats;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Чаты',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_square),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Новый чат (в разработке)')),
              );
            },
          ),
        ],
      ),
      body: _chats.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Нет активных чатов',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: sortedChats.length + (_hasPinnedChats ? 1 : 0),
              itemBuilder: (context, index) {
                // Add separator between pinned and unpinned
                final pinnedCount = sortedChats.where((c) => c.isPinned).length;
                if (_hasPinnedChats && index == pinnedCount) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      border: Border(
                        top: BorderSide(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                        bottom: BorderSide(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Text(
                      'Все чаты',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                  );
                }

                // Adjust index if separator was added
                final chatIndex = _hasPinnedChats && index > pinnedCount
                    ? index - 1
                    : index;
                final chat = sortedChats[chatIndex];
                final lastMessage = chat.lastMessage;

                return InkWell(
                  onTap: () {
                    context.push('/chat/${chat.id}');
                  },
                  onLongPress: () {
                    _showChatActions(chat);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey[200]!,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        // Avatar with online indicator
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundImage: CachedNetworkImageProvider(
                                chat.participantAvatar,
                              ),
                            ),
                            if (chat.isOnline ?? false)
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
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

                        // Chat info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Name, pin icon, and time
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        if (chat.isPinned) ...[
                                          Icon(
                                            Icons.push_pin,
                                            size: 14,
                                            color: Theme.of(context).primaryColor,
                                          ),
                                          const SizedBox(width: 4),
                                        ],
                                        Expanded(
                                          child: Text(
                                            chat.participantName,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    timeago.format(
                                      chat.updatedAt,
                                      locale: 'ru',
                                    ),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),

                              // Last message and unread badge
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      lastMessage?.content ??
                                          'Нет сообщений',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: chat.unreadCount > 0
                                            ? Colors.black87
                                            : Colors.grey[600],
                                        fontWeight: chat.unreadCount > 0
                                            ? FontWeight.w500
                                            : FontWeight.normal,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (chat.unreadCount > 0) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        chat.unreadCount > 99
                                            ? '99+'
                                            : chat.unreadCount.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  bool get _hasPinnedChats => _chats.any((c) => c.isPinned);

  void _showChatActions(Chat chat) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                chat.isPinned ? Icons.push_pin_outlined : Icons.push_pin,
              ),
              title: Text(
                chat.isPinned ? 'Открепить чат' : 'Закрепить чат',
              ),
              onTap: () {
                Navigator.pop(context);
                _togglePin(chat);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('Удалить чат'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Удаление чата (в разработке)')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.volume_off_outlined),
              title: const Text('Отключить уведомления'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Уведомления (в разработке)')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
