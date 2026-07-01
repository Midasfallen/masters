import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/api/user_model.dart';
import '../../../core/providers/api/subscriptions_provider.dart';

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

  String _displayName(UserModel user) =>
      (user.fullName?.trim().isNotEmpty == true)
          ? user.fullName!
          : '${user.firstName} ${user.lastName}'.trim();

  List<UserModel> _filter(List<UserModel> users) {
    if (_searchQuery.isEmpty) {
      return users;
    }
    final query = _searchQuery.toLowerCase();
    return users
        .where((user) => _displayName(user).toLowerCase().contains(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final followingAsync = ref.watch(mySubscriptionsListProvider());
    final followersAsync = ref.watch(mySubscribersListProvider());

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
                  _buildTab('Подписки', followingAsync.valueOrNull?.length),
                  _buildTab('Подписчики', followersAsync.valueOrNull?.length),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFollowingTab(followingAsync),
          _buildFollowersTab(followersAsync),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int? count) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          if (count != null) ...[
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFollowingTab(AsyncValue<List<UserModel>> async) {
    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => _buildError(
        () => ref.invalidate(mySubscriptionsListProvider),
      ),
      data: (users) {
        final following = _filter(users);
        if (following.isEmpty) {
          return _buildEmpty(
            icon: Icons.person_add_outlined,
            title: _searchQuery.isEmpty ? 'Нет подписок' : 'Ничего не найдено',
            subtitle: _searchQuery.isEmpty
                ? 'Подпишитесь на мастеров, чтобы видеть их посты в ленте'
                : null,
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
                  backgroundColor:
                      Theme.of(context).colorScheme.surfaceContainerHighest,
                  foregroundColor: Theme.of(context).colorScheme.onSurface,
                ),
                child: const Text('Отписаться'),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFollowersTab(AsyncValue<List<UserModel>> async) {
    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => _buildError(
        () => ref.invalidate(mySubscribersListProvider),
      ),
      data: (users) {
        final followers = _filter(users);
        if (followers.isEmpty) {
          return _buildEmpty(
            icon: Icons.people_outline,
            title: _searchQuery.isEmpty ? 'Нет подписчиков' : 'Ничего не найдено',
          );
        }
        return ListView.builder(
          itemCount: followers.length,
          itemBuilder: (context, index) {
            final user = followers[index];
            return _buildUserCard(
              user,
              trailing: OutlinedButton(
                onPressed: () => _follow(user),
                child: const Text('Подписаться'),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmpty({
    required IconData icon,
    required String title,
    String? subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildError(VoidCallback onRetry) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Не удалось загрузить данные',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          TextButton(onPressed: onRetry, child: const Text('Повторить')),
        ],
      ),
    );
  }

  Widget _buildUserCard(UserModel user, {required Widget trailing}) {
    final name = _displayName(user);
    final hasRating = user.rating > 0;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundImage: (user.avatarUrl != null && user.avatarUrl!.isNotEmpty)
                ? CachedNetworkImageProvider(user.avatarUrl!)
                : null,
            child: (user.avatarUrl == null || user.avatarUrl!.isEmpty)
                ? Text(name.isNotEmpty ? name[0].toUpperCase() : '?')
                : null,
          ),
          if (user.isMaster)
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
      title: Text(
        name,
        style: const TextStyle(fontWeight: FontWeight.bold),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Row(
        children: [
          if (hasRating) ...[
            Icon(Icons.star, size: 14, color: Colors.amber[700]),
            const SizedBox(width: 2),
            Text(
              user.rating.toStringAsFixed(1),
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
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
      trailing: trailing,
      onTap: () => context.push('/user/${user.id}'),
    );
  }

  Future<void> _follow(UserModel user) async {
    try {
      await ref.read(subscriptionNotifierProvider.notifier).subscribe(user.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Вы подписались на ${_displayName(user)}')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось подписаться')),
      );
    }
  }

  Future<void> _unfollow(UserModel user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Отписаться?'),
        content: Text(
          'Вы уверены, что хотите отписаться от ${_displayName(user)}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Отписаться'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ref.read(subscriptionNotifierProvider.notifier).unsubscribe(user.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Вы отписались от ${_displayName(user)}')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось отписаться')),
      );
    }
  }
}
