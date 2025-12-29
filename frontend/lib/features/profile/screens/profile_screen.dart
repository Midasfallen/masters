import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/mock_data_provider.dart';
import '../../../shared/widgets/service_card.dart';
import '../../../shared/widgets/review_card.dart';
import '../../../data/mock/mock_services.dart';
import '../../feed/widgets/post_card.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isMaster = false; // Имитация: можно поменять на true для теста

  int get _tabCount => _isMaster ? 4 : 2;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabCount, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _becomeMaster() {
    setState(() {
      _isMaster = true;
      _tabController.dispose();
      _tabController = TabController(length: _tabCount, vsync: this);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Поздравляем! Теперь вы мастер 🎉'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    final allPosts = ref.watch(mockPostsProvider);

    // Filter user's posts
    final userPosts = allPosts
        .where((p) => p.masterId == currentUser.id)
        .toList();

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
      body: NestedScrollView(
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
                        backgroundImage: CachedNetworkImageProvider(
                          currentUser.avatar,
                        ),
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
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Изменить фото (в разработке)'),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Name
                  Text(
                    currentUser.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Bio
                  if (currentUser.bio != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        currentUser.bio!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const SizedBox(height: 16),

                  // Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStat('Посты', userPosts.length.toString()),
                      _buildStat(
                        'Подписчики',
                        currentUser.followersCount?.toString() ?? '0',
                      ),
                      _buildStat(
                        'Подписки',
                        currentUser.followingCount?.toString() ?? '0',
                      ),
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
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Редактировать профиль (в разработке)'),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 36),
                          ),
                          child: const Text('Редактировать профиль'),
                        ),
                        if (!_isMaster) ...[
                          const SizedBox(height: 12),
                          FilledButton.icon(
                            onPressed: _becomeMaster,
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
                    isScrollable: _isMaster,
                    tabs: _isMaster
                        ? const [
                            Tab(text: 'Посты'),
                            Tab(text: 'Портфолио'),
                            Tab(text: 'Услуги'),
                            Tab(text: 'Отзывы'),
                          ]
                        : const [
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
          children: _isMaster
              ? [
                  // Posts tab
                  _buildPostsTab(userPosts),
                  // Portfolio tab
                  _buildPortfolioTab(),
                  // Services tab
                  _buildServicesTab(),
                  // Reviews tab
                  _buildReviewsTab(),
                ]
              : [
                  // Posts tab
                  _buildPostsTab(userPosts),
                  // Saved tab
                  _buildSavedTab(),
                ],
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

  Widget _buildPostsTab(List posts) {
    if (posts.isEmpty) {
      return Center(
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
      );
    }

    return MasonryGridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      padding: const EdgeInsets.all(4),
      itemCount: posts.length,
      itemBuilder: (context, index) => PostCard(post: posts[index]),
    );
  }

  Widget _buildPortfolioTab() {
    // Mock portfolio images
    final portfolio = List.generate(
      6,
      (index) => 'https://picsum.photos/400/600?random=${index + 100}',
    );

    return GridView.builder(
      padding: const EdgeInsets.all(4),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemCount: portfolio.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Просмотр фото ${index + 1}')),
            );
          },
          child: Image.network(
            portfolio[index],
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }

  Widget _buildServicesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: mockServices.length,
      itemBuilder: (context, index) {
        final service = mockServices[index];
        return ServiceCard(
          service: service,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Редактировать: ${service.name}')),
            );
          },
        );
      },
    );
  }

  Widget _buildReviewsTab() {
    // Mock reviews
    final reviews = [
      {
        'name': 'Мария Иванова',
        'avatar': 'https://i.pravatar.cc/100?img=10',
        'rating': 5.0,
        'comment':
            'Отличный мастер! Очень профессионально выполнила работу. Обязательно вернусь снова!',
        'date': DateTime.now().subtract(const Duration(days: 5)),
      },
      {
        'name': 'Анна Петрова',
        'avatar': 'https://i.pravatar.cc/100?img=20',
        'rating': 4.5,
        'comment': 'Хорошее качество работы, приятная атмосфера. Рекомендую!',
        'date': DateTime.now().subtract(const Duration(days: 15)),
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
        return ReviewCard(
          userName: review['name'] as String,
          userAvatar: review['avatar'] as String,
          rating: review['rating'] as double,
          comment: review['comment'] as String,
          date: review['date'] as DateTime,
        );
      },
    );
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
              if (_isMaster)
                ListTile(
                  leading: const Icon(Icons.settings_applications_outlined),
                  title: const Text('Настроить профиль мастера'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Настройка профиля мастера (в разработке)'),
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
                  _tabController.animateTo(_isMaster ? 0 : 1);
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
              context.go('/login');
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
