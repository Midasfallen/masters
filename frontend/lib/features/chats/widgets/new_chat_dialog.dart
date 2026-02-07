import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/api/user_model.dart';
import '../../../core/providers/api/chats_provider.dart';

/// Диалог выбора пользователя для создания нового чата
class NewChatDialog extends ConsumerStatefulWidget {
  const NewChatDialog({super.key});

  @override
  ConsumerState<NewChatDialog> createState() => _NewChatDialogState();
}

class _NewChatDialogState extends ConsumerState<NewChatDialog> {
  String _debouncedQuery = '';
  bool _isCreating = false;
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() => _debouncedQuery = value.trim());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) => Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Новый чат',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Введите имя пользователя...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                  onChanged: _onSearchChanged,
                ),
              ],
            ),
          ),

          // User list
          Expanded(
            child: _buildContent(scrollController),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ScrollController scrollController) {
    if (_debouncedQuery.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person_search, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text(
              'Введите имя пользователя',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          ],
        ),
      );
    }

    final usersAsync = ref.watch(searchUsersForChatProvider(_debouncedQuery));

    return usersAsync.when(
      data: (users) {
        if (users.isEmpty) {
          return Center(
            child: Text(
              'Никого не найдено',
              style: TextStyle(color: Colors.grey[600]),
            ),
          );
        }

        return ListView.builder(
          controller: scrollController,
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return _UserTile(
              user: user,
              isCreating: _isCreating,
              onTap: () => _createChat(user),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Text('Ошибка: ${error.toString()}'),
      ),
    );
  }

  Future<void> _createChat(UserModel user) async {
    if (_isCreating) return;

    setState(() => _isCreating = true);

    try {
      final chat = await ref
          .read(chatNotifierProvider.notifier)
          .createChat(user.id);

      if (mounted) {
        final chatId = chat.id;
        // Закрываем диалог и навигируем в следующем фрейме,
        // чтобы избежать обновления defunct element
        Navigator.pop(context);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            context.push('/chat/$chatId');
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isCreating = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: ${e.toString()}')),
        );
      }
    }
  }
}

class _UserTile extends StatelessWidget {
  final UserModel user;
  final bool isCreating;
  final VoidCallback onTap;

  const _UserTile({
    required this.user,
    required this.isCreating,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: Colors.grey[300],
        backgroundImage: user.avatarUrl != null
            ? CachedNetworkImageProvider(user.avatarUrl!)
            : null,
        child: user.avatarUrl == null
            ? Text(
                user.firstName[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              )
            : null,
      ),
      title: Text(
        '${user.firstName} ${user.lastName}',
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: user.isMaster
          ? Row(
              children: [
                Icon(Icons.verified, size: 14, color: Colors.blue[600]),
                const SizedBox(width: 4),
                Text('Мастер', style: TextStyle(color: Colors.blue[600])),
              ],
            )
          : null,
      trailing: isCreating
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.chat_bubble_outline, size: 20),
      onTap: isCreating ? null : onTap,
    );
  }
}
