import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/models/api/post_model.dart';
import '../../../core/providers/api/feed_provider.dart';
import '../../../core/api/api_exceptions.dart';
import '../../../core/providers/favorites_provider.dart';
import '../../../core/models/favorite.dart';
import '../../../shared/widgets/app_avatar.dart';

class PostDetailScreen extends ConsumerStatefulWidget {
  final String postId;

  const PostDetailScreen({
    super.key,
    required this.postId,
  });

  @override
  ConsumerState<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends ConsumerState<PostDetailScreen> {
  final PageController _mediaController = PageController();
  int _currentMediaIndex = 0;
  bool _isLiking = false; // Флаг для защиты от race conditions
  bool _isTogglingFavorite =
      false; // Флаг для защиты от race conditions при переключении закладок
  PostModel? _optimisticPost; // Локальное оптимистичное состояние

  @override
  void dispose() {
    _mediaController.dispose();
    super.dispose();
  }

  Future<void> _handleLike(String postId, bool isLiked) async {
    // Защита от двойных кликов
    if (_isLiking) return;

    // Сохраняем текущее состояние для отката
    final currentPost = ref.read(postByIdProvider(postId)).value;
    if (currentPost == null) return;

    // Оптимистичное обновление - меняем UI СРАЗУ через локальное состояние
    final optimisticPost = currentPost.copyWith(
      isLiked: !isLiked,
      likesCount:
          isLiked ? currentPost.likesCount - 1 : currentPost.likesCount + 1,
    );

    setState(() {
      _optimisticPost = optimisticPost;
      _isLiking = true;
    });

    try {
      // Отправляем запрос в фоне
      if (isLiked) {
        await ref.read(postNotifierProvider.notifier).unlikePost(postId);
      } else {
        await ref.read(postNotifierProvider.notifier).likePost(postId);
      }

      // При успехе обновляем состояние реальными данными (на случай, если счетчик изменился)
      setState(() {
        _optimisticPost = null; // Сбрасываем оптимистичное состояние
      });
      ref.invalidate(postByIdProvider(postId));
    } catch (e) {
      // При ошибке ОТКАТЫВАЕМ изменения
      setState(() {
        _optimisticPost = null; // Сбрасываем оптимистичное состояние
      });

      if (mounted) {
        // Ошибка 409 (Conflict) означает, что лайк уже поставлен/удален - это нормально
        final errorMessage = e.toString();
        if (errorMessage.contains('409') || errorMessage.contains('Conflict')) {
          // Просто обновляем состояние без показа ошибки
          ref.invalidate(postByIdProvider(postId));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ошибка: ${e.toString()}'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    } finally {
      // Снимаем флаг блокировки
      if (mounted) {
        setState(() {
          _isLiking = false;
        });
      }
    }
  }

  Future<void> _toggleFavorite(PostModel post, bool currentIsFavorite) async {
    // DEBUG: Проверка, что метод вызывается
    debugPrint(
        'DEBUG: Toggle favorite started for post ${post.id}, currentIsFavorite: $currentIsFavorite');

    // Защита от двойных кликов
    if (_isTogglingFavorite) {
      debugPrint('DEBUG: Already toggling, ignoring');
      return;
    }

    // Сохраняем значение до клика для оптимизации (избегаем лишнего запроса)
    final wasFavorite = currentIsFavorite;

    setState(() {
      _isTogglingFavorite = true;
    });

    try {
      debugPrint('DEBUG: Calling toggleFavorite on notifier');

      // Сначала выполняем запрос к серверу (без оптимистичного обновления для диагностики)
      await ref.read(favoritesNotifierProvider.notifier).toggleFavorite(
            FavoriteEntityType.post,
            post.id,
          );

      debugPrint('DEBUG: Toggle favorite SUCCESS');

      // После успешного запроса инвалидируем провайдер для обновления UI
      ref.invalidate(isFavoriteProvider(FavoriteEntityType.post, post.id));

      // Показываем уведомление на основе значения ДО клика (инвертированное)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              !wasFavorite ? 'Сохранено в закладки' : 'Удалено из закладок',
            ),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e, stackTrace) {
      debugPrint('DEBUG: Toggle favorite ERROR: $e');
      debugPrint('DEBUG: Stack trace: $stackTrace');

      // Если это ApiException, логируем дополнительную информацию от сервера
      if (e is ApiException) {
        debugPrint(
            'DEBUG: Toggle favorite ApiException status=${e.statusCode}, data=${e.data}');

        // 409 для избранного считаем «нормальным» конфликтом (уже в нужном состоянии)
        if (e.statusCode == 409) {
          ref.invalidate(
              isFavoriteProvider(FavoriteEntityType.post, post.id));

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  !wasFavorite
                      ? 'Уже было в закладках'
                      : 'Уже было удалено из закладок',
                ),
                duration: const Duration(seconds: 1),
              ),
            );
          }

          return;
        }
      }

      // При ошибке инвалидируем провайдер для отката
      ref.invalidate(isFavoriteProvider(FavoriteEntityType.post, post.id));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isTogglingFavorite = false;
        });
      }
      debugPrint('DEBUG: Toggle favorite finished');
    }
  }

  @override
  Widget build(BuildContext context) {
    final postAsync = ref.watch(postByIdProvider(widget.postId));

    return Scaffold(
      backgroundColor: Colors.black,
      body: postAsync.when(
        data: (post) {
          // Используем оптимистичное состояние, если оно есть
          final displayPost = _optimisticPost ?? post;
          return _buildPostPage(displayPost);
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 64),
              const SizedBox(height: 16),
              Text(
                'Ошибка: ${error.toString()}',
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    ref.invalidate(postByIdProvider(widget.postId)),
                child: const Text('Повторить'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostPage(PostModel post) {
    // Проверка статуса избранного
    final isFavoriteAsync = ref.watch(
      isFavoriteProvider(
        FavoriteEntityType.post,
        post.id,
      ),
    );

    final isFavorite = isFavoriteAsync.when(
      data: (value) => value,
      loading: () => false, // Правильно для первого рендера
      error: (_, __) => false,
    );

    return Stack(
      children: [
        // Full-screen media
        Positioned.fill(
          child: post.media.isEmpty
              ? Container(
                  color: Colors.black,
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image_not_supported,
                            color: Colors.white54, size: 64),
                        SizedBox(height: 16),
                        Text(
                          'Нет медиа для отображения',
                          style: TextStyle(color: Colors.white54),
                        ),
                      ],
                    ),
                  ),
                )
              : post.media.length > 1
                  ? PageView.builder(
                      controller: _mediaController,
                      itemCount: post.media.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentMediaIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return _buildMediaItem(post.media[index]);
                      },
                    )
                  : _buildMediaItem(post.media.first),
        ),

        // Top gradient overlay
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.6),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Back button
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 8,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.pop(),
          ),
        ),

        // Media indicator (if multiple images)
        if (post.media.length > 1)
          Positioned(
            top: MediaQuery.of(context).padding.top + 20,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_currentMediaIndex + 1}/${post.media.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),

        // Bottom gradient overlay
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.9),
                  Colors.black.withValues(alpha: 0.7),
                  Colors.transparent,
                ],
              ),
            ),
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 80,
              bottom: MediaQuery.of(context).padding.bottom + 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Master info
                Row(
                  children: [
                    AppAvatar(
                      avatarUrl: post.author?.avatarUrl,
                      userId: post.authorId,
                      fallbackName: post.author?.fullName ??
                          (post.author != null
                              ? '${post.author!.firstName} ${post.author!.lastName}'
                              : null),
                      radius: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          // API теперь поддерживает поиск по userId через тот же эндпоинт
                          if (post.authorId.isNotEmpty) {
                            context.push('/master/${post.authorId}');
                          }
                        },
                        child: Text(
                          post.author?.fullName ??
                              (post.author != null
                                  ? '${post.author!.firstName} ${post.author!.lastName}'
                                  : 'Неизвестный мастер'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white70,
                          ),
                        ),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Подписались на ${post.author?.fullName ?? (post.author != null ? '${post.author!.firstName} ${post.author!.lastName}' : 'мастера')}',
                            ),
                            duration: const Duration(milliseconds: 800),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        minimumSize: Size.zero,
                      ),
                      child: const Text('Подписаться'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Description
                if (post.content != null)
                  Text(
                    post.content!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                if (post.tags.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    post.tags.map((tag) => '#$tag').join(' '),
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 16),

                // CTA buttons
                FilledButton.icon(
                  onPressed: () {
                    // API теперь поддерживает поиск по userId через тот же эндпоинт
                    context.push('/master/${post.authorId}');
                  },
                  icon: const Icon(Icons.calendar_today, size: 18),
                  label: const Text('Записаться'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    minimumSize: const Size(double.infinity, 0),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Right action buttons (vertical) — поверх нижнего оверлея и контента
        Positioned(
          right: 12,
          bottom: 160,
          child: Column(
            children: [
              _buildActionButton(
                icon: post.isLiked ? Icons.favorite : Icons.favorite_border,
                label: '${post.likesCount}',
                color: post.isLiked ? Colors.red : Colors.white,
                onTap:
                    _isLiking ? null : () => _handleLike(post.id, post.isLiked),
              ),
              const SizedBox(height: 24),
              _buildActionButton(
                icon: Icons.chat_bubble_outline,
                label: '${post.commentsCount}',
                onTap: _showComments,
              ),
              const SizedBox(height: 24),
              _buildActionButton(
                icon: Icons.share_outlined,
                label: '',
                onTap: () => _sharePost(post),
              ),
              const SizedBox(height: 24),
              _buildActionButton(
                icon: isFavorite ? Icons.bookmark : Icons.bookmark_border,
                color: isFavorite ? Colors.amber : Colors.white,
                label: '',
                onTap: _isTogglingFavorite
                    ? null
                    : () => _toggleFavorite(post, isFavorite),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMediaItem(PostMediaModel mediaItem) {
    return CachedNetworkImage(
      imageUrl: mediaItem.url,
      fit: BoxFit.contain,
      width: double.infinity,
      height: double.infinity,
      placeholder: (context, url) => const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
      errorWidget: (context, url, error) => const Center(
        child: Icon(Icons.error, color: Colors.white, size: 48),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    Color color = Colors.white,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: SizedBox(
        // Минимальная область клика 56x56 для удобства на мобильных устройствах
        // (Material Design guidelines рекомендуют минимум 48x48, но 56x56 более комфортно)
        width: 56,
        height: label.isNotEmpty ? null : 56,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: onTap != null
              ? () {
                  debugPrint('DEBUG: Action button tapped: $icon');
                  onTap();
                }
              : null,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IgnorePointer(
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 28,
                  ),
                ),
              ),
              if (label.isNotEmpty) ...[
                const SizedBox(height: 4),
                IgnorePointer(
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      shadows: [
                        Shadow(
                          blurRadius: 4,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showComments() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CommentsSheet(postId: widget.postId),
    );
  }

  Future<void> _sharePost(PostModel post) async {
    // Формируем URL поста (в будущем можно взять из AppConfig)
    final postUrl = 'https://service-platform.com/post/${post.id}';
    final text = post.content != null
        ? '${post.content}\n\n$postUrl'
        : 'Посмотри этот пост: $postUrl';

    try {
      // Попытка использовать нативный шаринг
      await Share.share(
        text,
        subject:
            'Пост от ${post.author?.fullName ?? (post.author != null ? '${post.author!.firstName} ${post.author!.lastName}' : 'мастера')}',
      );
    } catch (e) {
      // На веб Share.share может выбросить исключение, если не поддерживается
      // ⚠️ ОБЯЗАТЕЛЬНЫЙ FALLBACK для веба и десктопа
      await Clipboard.setData(ClipboardData(text: postUrl));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ссылка скопирована в буфер обмена'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }
}

/// Comments Sheet Widget with real API integration
class _CommentsSheet extends ConsumerStatefulWidget {
  final String postId;

  const _CommentsSheet({required this.postId});

  @override
  ConsumerState<_CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends ConsumerState<_CommentsSheet> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _handleSendComment() async {
    final commentText = _commentController.text.trim();
    if (commentText.isEmpty) return;

    // Сохраняем текст для возможного отката
    final savedText = commentText;

    // Очищаем поле сразу (оптимистично)
    _commentController.clear();

    try {
      // Отправляем комментарий
      // refresh уже вызывается внутри createComment в провайдере
      await ref.read(postNotifierProvider.notifier).createComment(
            widget.postId,
            CreateCommentRequest(content: savedText),
          );

      // UI автоматически обновится благодаря ref.watch(postCommentsProvider)

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Комментарий отправлен'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // При ошибке возвращаем текст обратно
      _commentController.text = savedText;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'только что';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} мин. назад';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ч. назад';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} д. назад';
    } else {
      return '${date.day}.${date.month}.${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final commentsAsync = ref.watch(postCommentsProvider(widget.postId));

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Text(
                      'Комментарии',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: commentsAsync.when(
                  data: (comments) {
                    if (comments.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.chat_bubble_outline,
                                size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              'Пока нет комментариев',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppAvatar(
                                avatarUrl: comment.author?.avatarUrl,
                                userId: comment.authorId,
                                fallbackName: comment.author?.fullName ??
                                    (comment.author != null
                                        ? '${comment.author!.firstName} ${comment.author!.lastName}'
                                        : null),
                                radius: 18,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      comment.author?.fullName ??
                                          (comment.author != null
                                              ? '${comment.author!.firstName} ${comment.author!.lastName}'
                                              : 'Аноним'),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(comment.content),
                                    const SizedBox(height: 4),
                                    Text(
                                      _formatDate(comment.createdAt),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (error, stack) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 64),
                        const SizedBox(height: 16),
                        Text('Ошибка: ${error.toString()}'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => ref
                              .invalidate(postCommentsProvider(widget.postId)),
                          child: const Text('Повторить'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 12,
                  bottom: 12 + MediaQuery.of(context).padding.bottom,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          hintText: 'Добавить комментарий...',
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
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        Icons.send,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: _handleSendComment,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
