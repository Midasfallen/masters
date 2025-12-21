import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app.dart';
import '../../../shared/models/master.dart';
import '../../../shared/widgets/master_card.dart';
import '../../../shared/widgets/search_bar_widget.dart';
import '../../../data/mock/mock_masters.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedCategory;
  double _maxDistance = 50.0;
  double _minRating = 0.0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Master> get _filteredMasters {
    var results = mockMasters;

    if (_searchQuery.isNotEmpty) {
      results = results.where((m) {
        return m.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            m.category.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            (m.bio?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
      }).toList();
    }

    if (_selectedCategory != null) {
      results = results.where((m) => m.category == _selectedCategory).toList();
    }

    results = results.where((m) => m.distance <= _maxDistance).toList();
    results = results.where((m) => m.rating >= _minRating).toList();

    return results;
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Фильтры',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('Максимальное расстояние: ${_maxDistance.toInt()} км'),
                  Slider(
                    value: _maxDistance,
                    min: 1,
                    max: 50,
                    divisions: 49,
                    label: '${_maxDistance.toInt()} км',
                    onChanged: (value) {
                      setModalState(() {
                        _maxDistance = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Text('Минимальный рейтинг: ${_minRating.toStringAsFixed(1)}'),
                  Slider(
                    value: _minRating,
                    min: 0,
                    max: 5,
                    divisions: 50,
                    label: _minRating.toStringAsFixed(1),
                    onChanged: (value) {
                      setModalState(() {
                        _minRating = value;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () {
                      setState(() {});
                      Navigator.pop(context);
                    },
                    child: const Text('Применить'),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      setModalState(() {
                        _maxDistance = 50.0;
                        _minRating = 0.0;
                        _selectedCategory = null;
                      });
                      setState(() {});
                      Navigator.pop(context);
                    },
                    child: const Text('Сбросить'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final favoritesNotifier = FavoritesNotifier.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Поиск'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SearchBarWidget(
              controller: _searchController,
              hintText: 'Поиск мастера или услуги...',
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              onFilterTap: _showFilterDialog,
            ),
          ),
          if (_searchQuery.isEmpty && _filteredMasters.length == mockMasters.length)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search,
                      size: 80,
                      color: theme.colorScheme.outline,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Начните поиск',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Введите имя мастера или название услуги',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          else if (_filteredMasters.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 80,
                      color: theme.colorScheme.outline,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Ничего не найдено',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Попробуйте изменить параметры поиска',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filteredMasters.length,
                itemBuilder: (context, index) {
                  final master = _filteredMasters[index];
                  return MasterCard(
                    master: master,
                    isFavorite: favoritesNotifier?.favoriteIds.contains(master.id) ?? false,
                    onTap: () => context.go('/master/${master.id}'),
                    onFavorite: () => favoritesNotifier?.toggleFavorite(master.id),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
