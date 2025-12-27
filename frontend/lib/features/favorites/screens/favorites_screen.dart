import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app.dart';
import '../../../shared/models/master.dart';
import '../../../shared/widgets/master_card.dart';
import '../../../data/mock/mock_masters.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final favoritesNotifier = FavoritesNotifier.of(context);
    final favoriteIds = favoritesNotifier?.favoriteIds ?? {};

    final favoriteMasters = mockMasters
        .where((m) => favoriteIds.contains(m.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранное'),
      ),
      body: favoriteMasters.isEmpty
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
              itemCount: favoriteMasters.length,
              itemBuilder: (context, index) {
                final master = favoriteMasters[index];
                return MasterCard(
                  master: master,
                  isFavorite: true,
                  onTap: () => context.go('/master/${master.id}'),
                  onFavorite: () {
                    favoritesNotifier?.toggleFavorite(master.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${master.name} удален из избранного'),
                        action: SnackBarAction(
                          label: 'Отменить',
                          onPressed: () => favoritesNotifier?.toggleFavorite(master.id),
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
