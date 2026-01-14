import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/mock_data_provider.dart';
import '../../../core/models/user.dart';

class SubscriptionsScreen extends ConsumerStatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  ConsumerState<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends ConsumerState<SubscriptionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<User> _getFollowing(List<User> users) {
    final following = users.where((user) => user.isFollowing == true).toList();

    if (_searchQuery.isEmpty) {
      return following;
    }

    return following.where((user) {
      return user.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (user.bio?.toLowerCase().contains(_searchQuery.toLowerCase()) == true);
    }).toList();
  }

  List<User> _getFollowers(List<User> users) {
    // В реальном приложении это будут отдельные данные
    // Для mock берем пользователей с рейтингом (мастера)
    final followers = users.where((user) => user.rating != null).toList();

    if (_searchQuery.isEmpty) {
      return followers;
    }

    return followers.where((user) {
      return user.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (user.bio?.toLowerCase().contains(_searchQuery.toLowerCase()) == true);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final users = ref.watch(mockUsersProvider);
    final following = _getFollowing(users);
    final followers = _getFollowers(users);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Подписки',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Поиск...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
              TabBar(
                controller: _tabController,
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Подписки'),
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${following.length}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Подписчики'),
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${followers.length}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFollowingList(following),
          _buildFollowersList(followers),
        ],
      ),
    );
  }

  Widget _buildFollowingList(List<User> following) {
    if (following.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_add_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isEmpty ? 'Нет подписок' : 'Ничего не найдено',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            if (_searchQuery.isEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Подпишитесь на мастеров, чтобы видеть их посты в ленте',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: following.length,
      itemBuilder: (context, index) {
        final user = following[index];
        return _buildUserCard(
          user,
          trailing: FilledButton(
            onPressed: () => _unfollow(user),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              foregroundColor: Theme.of(context).colorScheme.onSurface,
            ),
            child: const Text('Отписаться'),
          ),
        );
      },
    );
  }

  Widget _buildFollowersList(List<User> followers) {
    if (followers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isEmpty ? 'Нет подписчиков' : 'Ничего не найдено',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: followers.length,
      itemBuilder: (context, index) {
        final user = followers[index];
        final isFollowing = user.isFollowing == true;

        return _buildUserCard(
          user,
          trailing: OutlinedButton(
            onPressed: () {
              if (isFollowing) {
                _unfollow(user);
              } else {
                _follow(user);
              }
            },
            child: Text(isFollowing ? 'Отписаться' : 'Подписаться'),
          ),
        );
      },
    );
  }

  Widget _buildUserCard(User user, {required Widget trailing}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundImage: CachedNetworkImageProvider(user.avatar),
          ),
          if (user.rating != null)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.surface,
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.verified,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
        ],
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              user.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (user.bio != null)
            Text(
              user.bio!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          const SizedBox(height: 2),
          Row(
            children: [
              if (user.rating != null) ...[
                Icon(
                  Icons.star,
                  size: 14,
                  color: Colors.amber[700],
                ),
                const SizedBox(width: 2),
                Text(
                  user.rating!.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Text(
                '${user.followersCount} подписчиков',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
      trailing: trailing,
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Профиль ${user.name}')),
        );
      },
    );
  }

  void _follow(User user) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Вы подписались на ${user.name}'),
        action: SnackBarAction(
          label: 'Отменить',
          onPressed: () {},
        ),
      ),
    );
  }

  void _unfollow(User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Отписаться?'),
        content: Text('Вы уверены, что хотите отписаться от ${user.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Вы отписались от ${user.name}'),
                  action: SnackBarAction(
                    label: 'Отменить',
                    onPressed: () {},
                  ),
                ),
              );
            },
            child: const Text('Отписаться'),
          ),
        ],
      ),
    );
  }
}
