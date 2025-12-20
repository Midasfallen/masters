import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/models/master.dart';
import '../../../shared/widgets/master_card.dart';
import '../../../data/mock/mock_masters.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  // Mock favorites - first 3 masters
  final Set<String> _favoriteIds = {
    mockMasters[0].id,
    mockMasters[1].id,
    mockMasters[2].id,
  };

  List<Master> get _favoriteMasters {
    return mockMasters.where((m) => _favoriteIds.contains(m.id)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранное'),
      ),
      body: _favoriteMasters.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_outline,
                    size: 80,
                    color: theme.colorScheme.outline,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Нет избранных мастеров',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Добавьте мастеров в избранное,\nчтобы быстро находить их',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () => context.go('/search'),
                    child: const Text('Найти мастера'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _favoriteMasters.length,
              itemBuilder: (context, index) {
                final master = _favoriteMasters[index];
                return MasterCard(
                  master: master,
                  isFavorite: true,
                  onTap: () => context.go('/master/${master.id}'),
                  onFavorite: () {
                    setState(() {
                      _favoriteIds.remove(master.id);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${master.name} удален из избранного'),
                        action: SnackBarAction(
                          label: 'Отменить',
                          onPressed: () {
                            setState(() {
                              _favoriteIds.add(master.id);
                            });
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
