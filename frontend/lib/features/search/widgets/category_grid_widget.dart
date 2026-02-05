import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/api/categories_tree_provider.dart';
import '../../../core/models/api/category_tree_model.dart';

/// Виджет для отображения категорий в виде сетки
/// Используется на странице поиска для показа верхнего уровня каталога
class CategoryGridWidget extends ConsumerWidget {
  const CategoryGridWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesTreeProvider(language: 'ru'));

    return categoriesAsync.when(
      data: (categories) {
        // Фильтруем только категории верхнего уровня (level == 0)
        final topLevelCategories = categories.where((cat) => cat.level == 0).toList();

        if (topLevelCategories.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.category_outlined, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Категории не найдены',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          );
        }

        // Фильтруем категорию test-beauty
        final filteredCategories = topLevelCategories
            .where((cat) => cat.slug != 'test-beauty')
            .toList();

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filteredCategories.length,
          itemBuilder: (context, index) {
            final category = filteredCategories[index];
            return _CategoryListItem(
              category: category,
              onTap: () {
                // Переходим на экран категории с услугами
                context.push(
                  '/search/category/${category.id}',
                  extra: {
                    'categoryName': category.name,
                    'categoryId': category.id,
                  },
                );
              },
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Ошибка загрузки категорий: ${error.toString()}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.invalidate(categoriesTreeProvider),
              child: const Text('Повторить'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryListItem extends StatelessWidget {
  final CategoryTreeModel category;
  final VoidCallback onTap;

  const _CategoryListItem({
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasChildren = category.children.isNotEmpty;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: category.color != null
                ? Color(int.parse(category.color!.replaceFirst('#', '0xFF')))
                : Theme.of(context).primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: category.iconUrl != null && category.iconUrl!.startsWith('emoji:')
                ? Text(
                    category.iconUrl!.substring(6),
                    style: const TextStyle(fontSize: 24),
                  )
                : Icon(
                    Icons.category,
                    color: category.color != null
                        ? Colors.white
                        : Theme.of(context).primaryColor,
                  ),
          ),
        ),
        title: Text(
          category.name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: hasChildren
            ? Text('${category.children.length} подкатегорий')
            : category.mastersCount > 0
                ? Text('${category.mastersCount} мастеров')
                : null,
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
