import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:service_platform/core/models/favorite.dart';
import 'package:service_platform/core/providers/favorites_provider.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  FavoriteEntityType? _currentFilter;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      setState(() {
        switch (_tabController.index) {
          case 0:
            _currentFilter = null; // All
            break;
          case 1:
            _currentFilter = FavoriteEntityType.master;
            break;
          case 2:
            _currentFilter = FavoriteEntityType.post;
            break;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoritesAsync = ref.watch(
      favoritesListProvider(entityType: _currentFilter),
    );
    final favoritesCountAsync = ref.watch(
      favoritesCountProvider(entityType: _currentFilter),
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text(
              'Избранное',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            // Count badge
            favoritesCountAsync.when(
              data: (count) => count > 0
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        count.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).primaryColor,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey[600],
          tabs: const [
            Tab(text: 'Все'),
            Tab(text: 'Мастера'),
            Tab(text: 'Посты'),
          ],
        ),
      ),
      body: favoritesAsync.when(
        data: (favorites) {
          if (favorites.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(favoritesListProvider(entityType: _currentFilter));
            },
            child: ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final favorite = favorites[index];
                return _FavoriteTile(
                  favorite: favorite,
                  onTap: () => _handleFavoriteTap(favorite),
                  onRemove: () => _handleRemoveFavorite(favorite),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Ошибка: ${error.toString()}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(favoritesListProvider(entityType: _currentFilter));
                },
                child: const Text('Повторить'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    String message = 'Нет избранного';
    IconData icon = Icons.favorite_border;

    switch (_currentFilter) {
      case FavoriteEntityType.master:
        message = 'Нет избранных мастеров';
        icon = Icons.person_outline;
        break;
      case FavoriteEntityType.post:
        message = 'Нет избранных постов';
        icon = Icons.image_outlined;
        break;
      default:
        message = 'Нет избранного';
        icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Добавляйте мастеров и посты в избранное',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _handleFavoriteTap(Favorite favorite) {
    switch (favorite.entityType) {
      case FavoriteEntityType.master:
        context.push('/master/${favorite.entityId}');
        break;
      case FavoriteEntityType.post:
        context.push('/post/${favorite.entityId}');
        break;
    }
  }

  Future<void> _handleRemoveFavorite(Favorite favorite) async {
    try {
      await ref.read(favoritesNotifierProvider.notifier).removeFromFavorites(
            favorite.entityType,
            favorite.entityId,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Удалено из избранного')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: ${e.toString()}')),
        );
      }
    }
  }
}

class _FavoriteTile extends StatelessWidget {
  final Favorite favorite;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _FavoriteTile({
    required this.favorite,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(favorite.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {
        onRemove();
      },
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: _getBackgroundColor(context),
          child: Icon(
            _getIcon(),
            color: Colors.white,
          ),
        ),
        title: Text(
          _getTitle(),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          _getSubtitle(),
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.favorite,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: onRemove,
        ),
      ),
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    switch (favorite.entityType) {
      case FavoriteEntityType.master:
        return Theme.of(context).primaryColor;
      case FavoriteEntityType.post:
        return Theme.of(context).colorScheme.secondary;
    }
  }

  IconData _getIcon() {
    switch (favorite.entityType) {
      case FavoriteEntityType.master:
        return Icons.person;
      case FavoriteEntityType.post:
        return Icons.image;
    }
  }

  String _getTitle() {
    if (favorite.entity != null) {
      switch (favorite.entityType) {
        case FavoriteEntityType.master:
          return favorite.entity['full_name'] ?? 'Мастер';
        case FavoriteEntityType.post:
          return favorite.entity['title'] ?? 'Пост';
      }
    }
    return favorite.entityType == FavoriteEntityType.master ? 'Мастер' : 'Пост';
  }

  String _getSubtitle() {
    if (favorite.entity != null) {
      switch (favorite.entityType) {
        case FavoriteEntityType.master:
          final rating = favorite.entity['rating'];
          return rating != null ? 'Рейтинг: ${rating.toStringAsFixed(1)}' : '';
        case FavoriteEntityType.post:
          return 'Пост в ленте';
      }
    }
    return '';
  }
}
