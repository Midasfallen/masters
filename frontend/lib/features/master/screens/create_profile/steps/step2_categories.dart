import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/models/api/category_tree_model.dart';
import '../../../../../core/providers/api/categories_tree_provider.dart';

class Step2Categories extends ConsumerStatefulWidget {
  final Map<String, dynamic> initialData;
  final Function(Map<String, dynamic>) onNext;
  final VoidCallback onBack;

  const Step2Categories({
    super.key,
    required this.initialData,
    required this.onNext,
    required this.onBack,
  });

  @override
  ConsumerState<Step2Categories> createState() => _Step2CategoriesState();
}

class _Step2CategoriesState extends ConsumerState<Step2Categories> {
  /// Выбранные ID категорий level 1 (для API и шаблонов)
  Set<String> _selectedCategoryIds = {};

  @override
  void initState() {
    super.initState();
    final saved = widget.initialData['category_ids'];
    if (saved is List) {
      _selectedCategoryIds = Set<String>.from(
        saved.map((e) => e.toString()),
      );
    }
  }

  void _continue() {
    if (_selectedCategoryIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Выберите хотя бы одну категорию')),
      );
      return;
    }

    if (_selectedCategoryIds.length > 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Максимум 5 категорий')),
      );
      return;
    }

    widget.onNext({'category_ids': _selectedCategoryIds.toList()});
  }

  /// Собираем все категории level 1 из дерева (дети корневых)
  static List<CategoryTreeModel> _level1Categories(List<CategoryTreeModel> roots) {
    final list = <CategoryTreeModel>[];
    for (final root in roots) {
      for (final child in root.children) {
        list.add(child);
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesTreeProvider(language: 'ru'));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Выберите категории',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'От 1 до 5 категорий услуг (level 1). На следующем шаге вы сможете выбрать шаблоны услуг.',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          const SizedBox(height: 24),
          categoriesAsync.when(
            data: (roots) {
              final level1 = _level1Categories(roots);
              if (level1.isEmpty) {
                return const Text(
                  'Категории не загружены. Проверьте подключение.',
                  style: TextStyle(color: Colors.red),
                );
              }
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: level1.map((cat) {
                  final id = cat.id;
                  final name = cat.name;
                  final isSelected = _selectedCategoryIds.contains(id);
                  return FilterChip(
                    label: Text(name),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          if (_selectedCategoryIds.length < 5) {
                            _selectedCategoryIds.add(id);
                          }
                        } else {
                          _selectedCategoryIds.remove(id);
                        }
                      });
                    },
                  );
                }).toList(),
              );
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (err, _) => Text(
              'Ошибка загрузки категорий: $err',
              style: const TextStyle(color: Colors.red),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Выбрано: ${_selectedCategoryIds.length}/5',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onBack,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Назад'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: FilledButton(
                  onPressed: _continue,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Продолжить'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
