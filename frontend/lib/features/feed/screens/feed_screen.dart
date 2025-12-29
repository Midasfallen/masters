import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/mock_data_provider.dart';
import '../../../shared/models/post.dart';
import '../widgets/post_card.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  // Filter state
  double _locationRadius = 20.0; // km
  bool _allCountry = false;
  String _selectedCategory = 'Все';
  bool _friendsOnly = false;
  bool _subscriptionsOnly = false;
  bool _favoritesOnly = false;

  final List<String> _categories = [
    'Все',
    'Красота',
    'Ремонт',
    'Обучение',
    'Здоровье',
    'Фото/Видео',
    'Авто',
    'Другое',
  ];

  List<Post> _getFilteredPosts(List<Post> posts) {
    // TODO: Implement actual filtering logic with real data
    // For now, just return all posts
    return posts;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allPosts = ref.watch(mockPostsProvider);
    final posts = _getFilteredPosts(allPosts);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: _showExtendedFilters,
          tooltip: 'Фильтры',
        ),
        title: const Text(
          'SERVICE',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Navigate to search
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Поиск (в разработке)')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              context.push('/notifications');
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_box_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Создание поста (в разработке)')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                // Refresh logic (для прототипа просто задержка)
                await Future.delayed(const Duration(seconds: 1));
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Обновлено!')),
                );
              },
              child: MasonryGridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                padding: const EdgeInsets.all(4),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  return PostCard(post: posts[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: 1,
          ),
        ),
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // Location filter chip
          FilterChip(
            avatar: const Icon(Icons.location_on, size: 18),
            label: Text(_allCountry
                ? 'Вся страна'
                : '${_locationRadius.toInt()} км'),
            selected: !_allCountry,
            onSelected: (_) => _showLocationFilter(),
          ),
          const SizedBox(width: 8),
          // Category filter chip
          FilterChip(
            avatar: const Icon(Icons.category, size: 18),
            label: Text(_selectedCategory),
            selected: _selectedCategory != 'Все',
            onSelected: (_) => _showCategoryFilter(),
          ),
          const SizedBox(width: 8),
          // Friends filter chip
          FilterChip(
            avatar: const Icon(Icons.group, size: 18),
            label: const Text('Друзья'),
            selected: _friendsOnly,
            onSelected: (selected) {
              setState(() {
                _friendsOnly = selected;
                if (selected) {
                  _subscriptionsOnly = false;
                  _favoritesOnly = false;
                }
              });
            },
          ),
          const SizedBox(width: 8),
          // Subscriptions filter chip
          FilterChip(
            avatar: const Icon(Icons.bookmark, size: 18),
            label: const Text('Подписки'),
            selected: _subscriptionsOnly,
            onSelected: (selected) {
              setState(() {
                _subscriptionsOnly = selected;
                if (selected) {
                  _friendsOnly = false;
                  _favoritesOnly = false;
                }
              });
            },
          ),
          const SizedBox(width: 8),
          // Favorites filter chip
          FilterChip(
            avatar: const Icon(Icons.star, size: 18),
            label: const Text('Избранные'),
            selected: _favoritesOnly,
            onSelected: (selected) {
              setState(() {
                _favoritesOnly = selected;
                if (selected) {
                  _friendsOnly = false;
                  _subscriptionsOnly = false;
                }
              });
            },
          ),
        ],
      ),
    );
  }

  void _showLocationFilter() {
    showModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Геолокация',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Вся страна'),
                value: _allCountry,
                onChanged: (value) {
                  setModalState(() {
                    _allCountry = value;
                  });
                },
              ),
              if (!_allCountry) ...[
                const SizedBox(height: 16),
                Text('Радиус: ${_locationRadius.toInt()} км'),
                Slider(
                  value: _locationRadius,
                  min: 1,
                  max: 50,
                  divisions: 49,
                  label: '${_locationRadius.toInt()} км',
                  onChanged: (value) {
                    setModalState(() {
                      _locationRadius = value;
                    });
                  },
                ),
              ],
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Отмена'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () {
                      setState(() {
                        // Values already updated via setModalState
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('Применить'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCategoryFilter() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Категория',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _categories.map((category) {
                return ChoiceChip(
                  label: Text(category),
                  selected: _selectedCategory == category,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = category;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _showExtendedFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            controller: scrollController,
            children: [
              Text(
                'Расширенные фильтры',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              Text(
                'Геолокация',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SwitchListTile(
                title: const Text('Вся страна'),
                value: _allCountry,
                onChanged: (value) {
                  setState(() {
                    _allCountry = value;
                  });
                },
              ),
              if (!_allCountry) ...[
                Text('Радиус: ${_locationRadius.toInt()} км'),
                Slider(
                  value: _locationRadius,
                  min: 1,
                  max: 50,
                  divisions: 49,
                  label: '${_locationRadius.toInt()} км',
                  onChanged: (value) {
                    setState(() {
                      _locationRadius = value;
                    });
                  },
                ),
              ],
              const Divider(height: 32),
              Text(
                'Категория',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _categories.map((category) {
                  return ChoiceChip(
                    label: Text(category),
                    selected: _selectedCategory == category,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                  );
                }).toList(),
              ),
              const Divider(height: 32),
              Text(
                'Фильтры контента',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SwitchListTile(
                title: const Text('👥 Только друзья'),
                value: _friendsOnly,
                onChanged: (value) {
                  setState(() {
                    _friendsOnly = value;
                    if (value) {
                      _subscriptionsOnly = false;
                      _favoritesOnly = false;
                    }
                  });
                },
              ),
              SwitchListTile(
                title: const Text('📌 Только подписки'),
                value: _subscriptionsOnly,
                onChanged: (value) {
                  setState(() {
                    _subscriptionsOnly = value;
                    if (value) {
                      _friendsOnly = false;
                      _favoritesOnly = false;
                    }
                  });
                },
              ),
              SwitchListTile(
                title: const Text('⭐ Только избранные'),
                value: _favoritesOnly,
                onChanged: (value) {
                  setState(() {
                    _favoritesOnly = value;
                    if (value) {
                      _friendsOnly = false;
                      _subscriptionsOnly = false;
                    }
                  });
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _locationRadius = 20.0;
                          _allCountry = false;
                          _selectedCategory = 'Все';
                          _friendsOnly = false;
                          _subscriptionsOnly = false;
                          _favoritesOnly = false;
                        });
                      },
                      child: const Text('Сбросить все'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Применить'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
