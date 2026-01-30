import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/models/api/post_model.dart';
import '../../../core/providers/api/auth_provider.dart';
import '../../../core/providers/api/feed_provider.dart';
import '../../../core/providers/api/user_provider.dart';
import '../../feed/widgets/post_card.dart';

/// Profile Posts Providers для infinite scroll с autoDispose
final profilePostsPageProvider =
    StateProvider.autoDispose<int>((ref) => 1);
final profilePostsListProvider =
    StateProvider.autoDispose<List<PostModel>>((ref) => []);
final profileHasMorePostsProvider =
    StateProvider.autoDispose<bool>((ref) => true);
final profilePostsLoadingProvider =
    StateProvider.autoDispose<bool>((ref) => false);
final profilePostsErrorProvider =
    StateProvider.autoDispose<String?>((ref) => null);
final profilePostsInitializedProvider =
    StateProvider.autoDispose<bool>((ref) => false);

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleAvatarChange() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    try {
      await ref
          .read(userNotifierProvider.notifier)
          .uploadAvatar(image.path);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Аватар успешно обновлен'),
            backgroundColor: Colors.green,
          ),
        );
        // Refresh auth state
        ref.invalidate(authNotifierProvider);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка загрузки аватара: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _handleLogout() async {
    try {
      await ref.read(authNotifierProvider.notifier).logout();
      if (mounted) {
        context.go('/login');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка выхода: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserAsync = ref.watch(authNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Профиль',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              _showSettingsSheet(context);
            },
          ),
        ],
      ),
      body: currentUserAsync.when(
        data: (authState) {
          final user = authState.user;
          if (user == null) {
            return const Center(child: Text('Пользователь не найден'));
          }

          // Инициализируем загрузку постов при первом показе или смене пользователя
          if (_currentUserId != user.id) {
            _currentUserId = user.id;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _initializeUserPosts(user.id);
            });
          }

          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // Avatar
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: user.avatarUrl != null
                                ? CachedNetworkImageProvider(user.avatarUrl!)
                                : null,
                            child: user.avatarUrl == null
                                ? Text(
                                    user.firstName.isNotEmpty
                                        ? user.firstName[0].toUpperCase()
                                        : user.email[0].toUpperCase(),
                                    style: const TextStyle(fontSize: 32),
                                  )
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: 32,
                                  minHeight: 32,
                                ),
                                onPressed: _handleAvatarChange,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Name
                      Text(
                        user.fullName ?? '${user.firstName} ${user.lastName}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Email
                      Text(
                        user.email,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Stats
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStat('Посты', user.postsCount.toString()),
                          _buildStat('Друзья', user.friendsCount.toString()),
                          _buildStat('Подписчики', user.followersCount.toString()),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Badges
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (user.isMaster)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.verified, color: Colors.white, size: 16),
                                  SizedBox(width: 4),
                                  Text(
                                    'Мастер',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (user.isPremium) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.amber[700]!, Colors.amber[400]!],
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.star, color: Colors.white, size: 16),
                                  SizedBox(width: 4),
                                  Text(
                                    'Premium',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Edit Profile Button or Become Master Button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                context.push('/edit-profile');
                              },
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 36),
                              ),
                              child: const Text('Редактировать профиль'),
                            ),
                            if (!user.isMaster) ...[
                              const SizedBox(height: 12),
                              FilledButton.icon(
                                onPressed: () {
                                  context.push('/create-master-profile');
                                },
                                icon: const Icon(Icons.work_outline),
                                label: const Text('Стать мастером'),
                                style: FilledButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 48),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Tabs
                      TabBar(
                        controller: _tabController,
                        tabs: const [
                          Tab(
                            icon: Icon(Icons.grid_on),
                            text: 'Посты',
                          ),
                          Tab(
                            icon: Icon(Icons.bookmark_border),
                            text: 'Сохраненное',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: [
                // Posts tab
                _buildPostsTab(user.id),
                // Saved tab
                _buildSavedTab(),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Ошибка: ${error.toString()}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(authNotifierProvider),
                child: const Text('Повторить'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  /// Инициализация загрузки постов (вызывается один раз при показе экрана)
  void _initializeUserPosts(String userId) {
    final isInitialized = ref.read(profilePostsInitializedProvider);
    if (!isInitialized) {
      ref.read(profilePostsInitializedProvider.notifier).state = true;
      _loadUserPosts(userId);
    }
  }

  Widget _buildPostsTab(String userId) {
    final posts = ref.watch(profilePostsListProvider);
    final hasMore = ref.watch(profileHasMorePostsProvider);
    final isLoading = ref.watch(profilePostsLoadingProvider);
    final error = ref.watch(profilePostsErrorProvider);
    final isInitialized = ref.watch(profilePostsInitializedProvider);

    // Состояние: ещё не инициализировано
    if (!isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    // Состояние: идёт первичная загрузка
    if (posts.isEmpty && isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Состояние: ошибка загрузки (посты пустые и есть ошибка)
    if (posts.isEmpty && error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Не удалось загрузить посты',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _loadUserPosts(userId),
              icon: const Icon(Icons.refresh),
              label: const Text('Повторить'),
            ),
          ],
        ),
      );
    }

    // Состояние: у пользователя нет постов
    if (posts.isEmpty && !isLoading) {
      return RefreshIndicator(
        onRefresh: () => _handleRefresh(userId),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.photo_library_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Нет постов',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Поделитесь своими работами',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // Состояние: есть посты — показываем сетку с RefreshIndicator
    return RefreshIndicator(
      onRefresh: () => _handleRefresh(userId),
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollEndNotification &&
              notification.metrics.pixels >=
                  notification.metrics.maxScrollExtent - 200) {
            if (!isLoading && hasMore) {
              _loadMoreUserPosts(userId);
            }
          }
          return false;
        },
        child: GridView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(4),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            childAspectRatio: 1.0,
          ),
          itemCount: posts.length + (hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == posts.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            }
            return PostCard(post: posts[index]);
          },
        ),
      ),
    );
  }

  /// Pull-to-refresh handler
  Future<void> _handleRefresh(String userId) async {
    await _loadUserPosts(userId);
  }

  Future<void> _loadUserPosts(String userId) async {
    // Сбрасываем ошибку перед загрузкой
    ref.read(profilePostsErrorProvider.notifier).state = null;
    ref.read(profilePostsLoadingProvider.notifier).state = true;
    ref.read(profilePostsPageProvider.notifier).state = 1;
    ref.read(profileHasMorePostsProvider.notifier).state = true;

    try {
      // Инвалидируем кэш провайдера для получения свежих данных
      ref.invalidate(userPostsProvider(userId));
      final posts = await ref.read(userPostsProvider(userId).future);
      if (mounted) {
        ref.read(profilePostsListProvider.notifier).state = posts;
        if (posts.isEmpty || posts.length < 20) {
          ref.read(profileHasMorePostsProvider.notifier).state = false;
        }
      }
    } catch (e) {
      if (mounted) {
        ref.read(profilePostsErrorProvider.notifier).state = e.toString();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка загрузки постов: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        ref.read(profilePostsLoadingProvider.notifier).state = false;
      }
    }
  }

  Future<void> _loadMoreUserPosts(String userId) async {
    if (ref.read(profilePostsLoadingProvider)) return;
    ref.read(profilePostsLoadingProvider.notifier).state = true;

    try {
      final currentPage = ref.read(profilePostsPageProvider);
      final nextPage = currentPage + 1;
      ref.read(profilePostsPageProvider.notifier).state = nextPage;

      final newPosts =
          await ref.read(userPostsProvider(userId, page: nextPage).future);
      if (mounted) {
        final currentPosts = ref.read(profilePostsListProvider);
        ref.read(profilePostsListProvider.notifier).state = [
          ...currentPosts,
          ...newPosts
        ];

        if (newPosts.isEmpty || newPosts.length < 20) {
          ref.read(profileHasMorePostsProvider.notifier).state = false;
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        ref.read(profilePostsLoadingProvider.notifier).state = false;
      }
    }
  }

  Widget _buildSavedTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bookmark_border,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Нет сохраненных постов',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  void _showSettingsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Редактировать профиль'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Редактирование профиля (в разработке)'),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications_outlined),
                title: const Text('Уведомления'),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/notifications');
                },
              ),
              ListTile(
                leading: const Icon(Icons.bookmark_outline),
                title: const Text('Сохраненное'),
                onTap: () {
                  Navigator.pop(context);
                  _tabController.animateTo(1);
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: const Text('Настройки'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Настройки (в разработке)'),
                    ),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text('Помощь'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Помощь (в разработке)'),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip_outlined),
                title: const Text('Политика конфиденциальности'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Политика конфиденциальности'),
                    ),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.red[700]),
                title: Text(
                  'Выйти',
                  style: TextStyle(color: Colors.red[700]),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showLogoutDialog(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выйти из аккаунта?'),
        content: const Text('Вы уверены, что хотите выйти?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _handleLogout();
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red[700],
            ),
            child: const Text('Выйти'),
          ),
        ],
      ),
    );
  }
}
