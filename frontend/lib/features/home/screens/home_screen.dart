import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app.dart';
import '../../../shared/models/master.dart';
import '../../../shared/widgets/master_card.dart';
import '../../../shared/widgets/category_chip.dart';
import '../../../data/mock/mock_masters.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedCategory;

  List<Master> get _filteredMasters {
    if (_selectedCategory == null) return mockMasters;
    return mockMasters
        .where((m) => m.category == _selectedCategory)
        .toList();
  }

  List<String> get _categories {
    return mockMasters.map((m) => m.category).toSet().toList()..sort();
  }

  Map<String, String> get _categoryIcons {
    return {
      'Парикмахер': '💇',
      'Косметолог': '💆',
      'Мастер маникюра': '💅',
      'Массажист': '💆',
      'Визажист': '💄',
      'Бровист': '👁️',
      'Тренер': '💪',
      'Репетитор': '📚',
      'Фотограф': '📷',
      'Стилист': '👔',
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Platform'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Уведомления')),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final messenger = ScaffoldMessenger.of(context);
          await Future.delayed(const Duration(seconds: 1));
          if (!mounted) return;
          messenger.showSnackBar(
            const SnackBar(content: Text('Обновлено')),
          );
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Найди своего мастера',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Поиск мастера или услуги...',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onTap: () => context.go('/search'),
                      readOnly: true,
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    CategoryChip(
                      icon: '🌟',
                      label: 'Все',
                      selected: _selectedCategory == null,
                      onTap: () {
                        setState(() {
                          _selectedCategory = null;
                        });
                      },
                    ),
                    ..._categories.map((category) {
                      return CategoryChip(
                        icon: _categoryIcons[category] ?? '⭐',
                        label: category,
                        selected: _selectedCategory == category,
                        onTap: () {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final master = _filteredMasters[index];
                    final favoritesNotifier = FavoritesNotifier.of(context);
                    return MasterCard(
                      master: master,
                      isFavorite: favoritesNotifier?.favoriteIds.contains(master.id) ?? false,
                      onTap: () => context.go('/master/${master.id}'),
                      onFavorite: () => favoritesNotifier?.toggleFavorite(master.id),
                    );
                  },
                  childCount: _filteredMasters.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
