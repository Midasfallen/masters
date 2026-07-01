import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:service_platform/core/providers/api/feed_provider.dart';
import 'package:service_platform/core/providers/api/chats_provider.dart';
import 'package:service_platform/core/providers/api/subscriptions_provider.dart';
import 'package:service_platform/core/models/api/post_model.dart';
import 'package:service_platform/core/models/api/user_model.dart';
import 'package:service_platform/core/widgets/app_image_preview.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Step 1: Media selection
  final List<XFile> _selectedMedia = [];
  final ImagePicker _picker = ImagePicker();

  // Step 2: Content
  final TextEditingController _contentController = TextEditingController();

  // Отмеченные (tagged) пользователи
  final List<UserModel> _taggedUsers = [];

  bool _isLoading = false;

  /// Определить тип поста на основе медиафайлов
  PostType _determinePostType(List<XFile> media) {
    if (media.isEmpty) return PostType.text;

    // Проверяем, есть ли хотя бы одно видео
    final hasVideo = media.any((file) {
      final mimeType = lookupMimeType(file.path) ?? '';
      return mimeType.startsWith('video/');
    });

    return hasVideo ? PostType.video : PostType.photo;
  }

  /// Определить тип медиафайла
  MediaType _determineMediaType(XFile file) {
    final mimeType = lookupMimeType(file.path) ?? '';
    if (mimeType.startsWith('video/')) {
      return MediaType.video;
    }
    return MediaType.photo;
  }

  @override
  void dispose() {
    _pageController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    if (_selectedMedia.length >= 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Максимум 10 медиафайлов')),
      );
      return;
    }

    try {
      final images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        setState(() {
          final remaining = 10 - _selectedMedia.length;
          _selectedMedia.addAll(images.take(remaining));
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _pickCamera() async {
    if (_selectedMedia.length >= 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Максимум 10 медиафайлов')),
      );
      return;
    }

    try {
      final image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        setState(() {
          _selectedMedia.add(image);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: ${e.toString()}')),
        );
      }
    }
  }

  void _removeMedia(int index) {
    setState(() {
      _selectedMedia.removeAt(index);
    });
  }

  void _nextStep() {
    if (_currentStep == 0 && _selectedMedia.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Выберите хотя бы одно фото')),
      );
      return;
    }

    if (_currentStep == 1 && _contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Добавьте описание')),
      );
      return;
    }

    if (_currentStep < 2) {
      setState(() => _currentStep++);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _submitPost();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _submitPost() async {
    // Дополнительная проверка перед отправкой
    final content = _contentController.text.trim();
    if (content.isEmpty && _selectedMedia.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Добавьте описание или фото')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Определяем тип поста
      final postType = _determinePostType(_selectedMedia);

      // Upload media files to server and create media DTOs
      final mediaList = <CreatePostMediaDto>[];
      for (int i = 0; i < _selectedMedia.length; i++) {
        final file = _selectedMedia[i];
        final url = await ref
            .read(postNotifierProvider.notifier)
            .uploadPostMediaFromXFile(file);

        // Определяем тип медиа
        mediaList.add(CreatePostMediaDto(
          type: _determineMediaType(file),
          url: url,
          order: i,
        ));
      }

      // Формируем запрос согласно DTO бэкенда
      final request = CreatePostRequest(
        type: postType,
        content: content.isEmpty ? null : content,
        media: mediaList.isNotEmpty ? mediaList : null,
        taggedUserIds:
            _taggedUsers.isNotEmpty ? _taggedUsers.map((u) => u.id).toList() : null,
        // tags убраны - бэкенд их не принимает
      );

      await ref.read(postNotifierProvider.notifier).createPost(request);

      // Обновляем ленту после успешного создания поста
      // Инвалидируем провайдер, чтобы при следующем обращении загрузились свежие данные
      ref.invalidate(feedPostsProvider);

      // Также инвалидируем локальное состояние ленты, если экран еще открыт
      // Это заставит FeedScreen перезагрузить данные при возврате
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Пост создан успешно!')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Создать пост'),
        actions: [
          if (_currentStep > 0)
            TextButton(
              onPressed: _isLoading ? null : _previousStep,
              child: const Text('Назад'),
            ),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: List.generate(3, (index) {
                return Expanded(
                  child: Container(
                    height: 4,
                    margin: EdgeInsets.only(
                      right: index < 2 ? 8 : 0,
                    ),
                    decoration: BoxDecoration(
                      color: index <= _currentStep
                          ? Theme.of(context).primaryColor
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
          ),

          // Content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildMediaStep(),
                _buildContentStep(),
                _buildReviewStep(),
              ],
            ),
          ),

          // Bottom button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: _isLoading ? null : _nextStep,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        _currentStep == 2 ? 'Опубликовать' : 'Далее',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Выберите фото или видео',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'До 10 файлов',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _pickImages,
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Галерея'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _pickCamera,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Камера'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Selected media grid
          if (_selectedMedia.isNotEmpty) ...[
            Text(
              'Выбрано: ${_selectedMedia.length}/10',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _selectedMedia.length,
              itemBuilder: (context, index) {
                final file = _selectedMedia[index];
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: AppImagePreview(
                        file: file,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => _removeMedia(index),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContentStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Описание',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Расскажите о своей работе',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),

          // Content field
          TextField(
            controller: _contentController,
            maxLines: 6,
            maxLength: 2000,
            decoration: InputDecoration(
              hintText: 'Напишите описание...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Отметить людей
          const Text(
            'Отметить людей',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _openTagUsersSheet,
            icon: const Icon(Icons.person_add_alt),
            label: Text(
              _taggedUsers.isEmpty
                  ? 'Добавить пользователей'
                  : 'Отмечено: ${_taggedUsers.length}',
            ),
          ),
          const SizedBox(height: 12),
          if (_taggedUsers.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _taggedUsers.map((user) {
                return Chip(
                  avatar: CircleAvatar(
                    backgroundImage: (user.avatarUrl != null && user.avatarUrl!.isNotEmpty)
                        ? CachedNetworkImageProvider(user.avatarUrl!)
                        : null,
                    child: (user.avatarUrl == null || user.avatarUrl!.isEmpty)
                        ? Text(
                            user.firstName.isNotEmpty
                                ? user.firstName[0].toUpperCase()
                                : '?',
                            style: const TextStyle(fontSize: 12),
                          )
                        : null,
                  ),
                  label: Text('${user.firstName} ${user.lastName}'),
                  onDeleted: () =>
                      setState(() => _taggedUsers.removeWhere((u) => u.id == user.id)),
                  deleteIcon: const Icon(Icons.close, size: 16),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Future<void> _openTagUsersSheet() async {
    final result = await showModalBottomSheet<List<UserModel>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _TagUsersSheet(initialSelected: _taggedUsers),
    );
    if (result != null) {
      setState(() {
        _taggedUsers
          ..clear()
          ..addAll(result);
      });
    }
  }

  Widget _buildReviewStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Предпросмотр',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          // Media preview
          if (_selectedMedia.isNotEmpty) ...[
            AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AppImagePreview(
                  file: _selectedMedia.first,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            if (_selectedMedia.length > 1)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '+${_selectedMedia.length - 1} фото',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            const SizedBox(height: 16),
          ],

          // Content
          Text(
            _contentController.text.trim(),
            style: const TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 12),

          // Отмеченные пользователи
          if (_taggedUsers.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.person_pin, size: 18, color: Colors.grey[700]),
                const SizedBox(width: 4),
                Text(
                  'Отмечены:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _taggedUsers.map((user) {
                return Chip(
                  avatar: CircleAvatar(
                    backgroundImage:
                        (user.avatarUrl != null && user.avatarUrl!.isNotEmpty)
                            ? CachedNetworkImageProvider(user.avatarUrl!)
                            : null,
                    child: (user.avatarUrl == null || user.avatarUrl!.isEmpty)
                        ? Text(
                            user.firstName.isNotEmpty
                                ? user.firstName[0].toUpperCase()
                                : '?',
                            style: const TextStyle(fontSize: 12),
                          )
                        : null,
                  ),
                  label: Text('${user.firstName} ${user.lastName}'),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

/// Bottom-sheet мультивыбора пользователей для отметки в посте.
/// Переиспользует поиск пользователей (Meilisearch) из чатов.
class _TagUsersSheet extends ConsumerStatefulWidget {
  final List<UserModel> initialSelected;

  const _TagUsersSheet({required this.initialSelected});

  @override
  ConsumerState<_TagUsersSheet> createState() => _TagUsersSheetState();
}

class _TagUsersSheetState extends ConsumerState<_TagUsersSheet> {
  final Map<String, UserModel> _selected = {};
  String _debouncedQuery = '';
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    for (final u in widget.initialSelected) {
      _selected[u.id] = u;
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _debouncedQuery = value.trim());
    });
  }

  void _toggle(UserModel user) {
    setState(() {
      if (_selected.containsKey(user.id)) {
        _selected.remove(user.id);
      } else {
        _selected[user.id] = user;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Отметить людей',
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
          Expanded(child: _buildContent(scrollController)),
          // Закреплённая кнопка «Добавить»
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () =>
                      Navigator.pop(context, _selected.values.toList()),
                  child: Text(
                    _selected.isEmpty
                        ? 'Готово'
                        : 'Добавить (${_selected.length})',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ScrollController scrollController) {
    if (_debouncedQuery.isEmpty) {
      // Без поискового запроса — показываем подписки пользователя.
      // Уже выбранные (в т.ч. найденные ранее) выводим сверху.
      final subsAsync = ref.watch(mySubscriptionsListProvider());
      return subsAsync.when(
        data: (subs) {
          // Объединяем: сначала выбранные, затем подписки (без дублей)
          final Map<String, UserModel> combined = {
            for (final u in _selected.values) u.id: u,
          };
          for (final u in subs) {
            combined.putIfAbsent(u.id, () => u);
          }
          final list = combined.values.toList();

          if (list.isEmpty) {
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

          return ListView(
            controller: scrollController,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                child: Text(
                  'Мои подписки',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              ...list.map(
                (u) => _buildTile(u, selected: _selected.containsKey(u.id)),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        // Если подписки не загрузились — не блокируем поиск, показываем выбранных
        error: (_, __) => ListView(
          controller: scrollController,
          children: _selected.values
              .map((u) => _buildTile(u, selected: true))
              .toList(),
        ),
      );
    }

    final usersAsync = ref.watch(searchUsersForChatProvider(_debouncedQuery));
    return usersAsync.when(
      data: (users) {
        if (users.isEmpty) {
          return Center(
            child: Text('Никого не найдено',
                style: TextStyle(color: Colors.grey[600])),
          );
        }
        return ListView.builder(
          controller: scrollController,
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return _buildTile(user, selected: _selected.containsKey(user.id));
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) =>
          Center(child: Text('Ошибка: ${error.toString()}')),
    );
  }

  Widget _buildTile(UserModel user, {required bool selected}) {
    return ListTile(
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: Colors.grey[300],
        backgroundImage: (user.avatarUrl != null && user.avatarUrl!.isNotEmpty)
            ? CachedNetworkImageProvider(user.avatarUrl!)
            : null,
        child: (user.avatarUrl == null || user.avatarUrl!.isEmpty)
            ? Text(
                user.firstName.isNotEmpty ? user.firstName[0].toUpperCase() : '?',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )
            : null,
      ),
      title: Text('${user.firstName} ${user.lastName}',
          style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: user.isMaster
          ? Row(
              children: [
                Icon(Icons.verified, size: 14, color: Colors.blue[600]),
                const SizedBox(width: 4),
                Text('Мастер', style: TextStyle(color: Colors.blue[600])),
              ],
            )
          : null,
      trailing: Icon(
        selected ? Icons.check_circle : Icons.radio_button_unchecked,
        color: selected ? Theme.of(context).primaryColor : Colors.grey,
      ),
      onTap: () => _toggle(user),
    );
  }
}
