import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/models/api/category_tree_model.dart';
import '../../../../../core/providers/api/categories_tree_provider.dart';
import '../../../../../core/providers/api/service_templates_provider.dart';
import '../../../../../core/models/api/service_template_model.dart';

/// Шаг 2: Выбор категорий + Добавление услуг (объединённый шаг)
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

  /// Услуги мастера
  List<Map<String, dynamic>> _services = [];
  final Map<String, List<ServiceTemplateModel>> _templatesByCategory = {};
  final Map<String, bool> _loadingTemplates = {};

  @override
  void initState() {
    super.initState();
    final saved = widget.initialData['category_ids'];
    if (saved is List) {
      _selectedCategoryIds = Set<String>.from(
        saved.map((e) => e.toString()),
      );
    }
    _services = List<Map<String, dynamic>>.from(
      widget.initialData['services'] ?? [],
    );
    if (_selectedCategoryIds.isNotEmpty) {
      _loadTemplates();
    }
  }

  Future<void> _loadTemplates() async {
    for (final categoryId in _selectedCategoryIds) {
      if (_templatesByCategory.containsKey(categoryId)) continue;
      setState(() {
        _loadingTemplates[categoryId] = true;
      });
      try {
        final response = await ref.read(
          serviceTemplatesByCategoryIdProvider(categoryId, language: 'ru')
              .future,
        );
        if (mounted) {
          setState(() {
            _templatesByCategory[categoryId] = response.data;
            _loadingTemplates[categoryId] = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _templatesByCategory[categoryId] = [];
            _loadingTemplates[categoryId] = false;
          });
        }
      }
    }
  }

  Map<String, dynamic> _createEmptyService() {
    final firstCategoryId =
        _selectedCategoryIds.isNotEmpty ? _selectedCategoryIds.first : '';
    return {
      'category_id': firstCategoryId,
      'service_template_id': null,
      'name': '',
      'price': '',
      'duration': '60',
      'description': '',
    };
  }

  Map<String, dynamic> _createServiceFromTemplate(
      ServiceTemplateModel template) {
    return {
      'category_id': template.categoryId,
      'service_template_id': template.id,
      'name': template.name,
      'price': template.defaultPriceRangeMin?.toStringAsFixed(0) ?? '',
      'duration': template.defaultDurationMinutes?.toString() ?? '60',
      'description': template.description ?? '',
    };
  }

  void _addService() {
    setState(() {
      _services.add(_createEmptyService());
    });
  }

  void _addServiceFromTemplate(ServiceTemplateModel template) {
    setState(() {
      _services.add(_createServiceFromTemplate(template));
    });
    if (context.mounted) Navigator.of(context).pop();
  }

  void _removeService(int index) {
    setState(() {
      _services.removeAt(index);
    });
  }

  void _showTemplateSelector() {
    if (_selectedCategoryIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Сначала выберите категории')),
      );
      return;
    }

    final allTemplates = <ServiceTemplateModel>[];
    for (final categoryId in _selectedCategoryIds) {
      allTemplates.addAll(_templatesByCategory[categoryId] ?? []);
    }
    if (allTemplates.isEmpty) {
      final loading = _loadingTemplates.values.any((v) => v);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            loading
                ? 'Загрузка шаблонов…'
                : 'Нет шаблонов для выбранных категорий',
          ),
        ),
      );
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Выберите шаблон услуги',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: allTemplates.length,
                itemBuilder: (context, index) {
                  final t = allTemplates[index];
                  return ListTile(
                    title: Text(t.name),
                    subtitle: t.defaultDurationMinutes != null
                        ? Text('${t.defaultDurationMinutes} мин')
                        : null,
                    trailing: t.defaultPriceRangeMin != null
                        ? Text(
                            'от ${t.defaultPriceRangeMin!.toStringAsFixed(0)} ₽',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          )
                        : null,
                    onTap: () => _addServiceFromTemplate(t),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
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

    final firstCategoryId = _selectedCategoryIds.first;
    final validServices = <Map<String, dynamic>>[];
    for (final service in _services) {
      if (service['name'].toString().trim().isEmpty ||
          service['price'].toString().trim().isEmpty) {
        continue;
      }
      final map = Map<String, dynamic>.from(service);
      if (map['category_id'] == null ||
          map['category_id'].toString().isEmpty) {
        map['category_id'] = firstCategoryId;
      }
      validServices.add(map);
    }

    if (validServices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Добавьте хотя бы одну услугу')),
      );
      return;
    }

    widget.onNext({
      'category_ids': _selectedCategoryIds.toList(),
      'services': validServices,
    });
  }

  /// Собираем все категории level 1 из дерева (дети корневых)
  static List<CategoryTreeModel> _level1Categories(
      List<CategoryTreeModel> roots) {
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
    final categoriesAsync =
        ref.watch(categoriesTreeProvider(language: 'ru'));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // === СЕКЦИЯ КАТЕГОРИЙ ===
          Text(
            'Категории и услуги',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Выберите от 1 до 5 категорий и добавьте услуги',
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
                            _loadTemplates();
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
          const SizedBox(height: 8),
          Text(
            'Выбрано: ${_selectedCategoryIds.length}/5',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),

          // === СЕКЦИЯ УСЛУГ ===
          if (_selectedCategoryIds.isNotEmpty) ...[
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              'Услуги и цены',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Добавьте услуги, которые вы предоставляете',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: 16),

            // Кнопка выбора из шаблонов
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _showTemplateSelector,
                icon: const Icon(Icons.auto_awesome),
                label: const Text('Выбрать из шаблонов'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Список услуг
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _services.length,
              itemBuilder: (context, index) => _buildServiceCard(index),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _addService,
              icon: const Icon(Icons.add),
              label: const Text('Добавить кастомную услугу'),
            ),
          ],

          // === КНОПКИ НАВИГАЦИИ ===
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

  Widget _buildServiceCard(int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Услуга ${index + 1}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                if (_services.length > 1)
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _removeService(index),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: TextEditingController(
                  text: _services[index]['name']?.toString() ?? ''),
              decoration: const InputDecoration(
                labelText: 'Название',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _services[index]['name'] = value;
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: TextEditingController(
                      text: _services[index]['price']?.toString() ?? '',
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Цена (₽)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      _services[index]['price'] = value;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: TextEditingController(
                      text:
                          _services[index]['duration']?.toString() ?? '60',
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Время (мин)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      _services[index]['duration'] = value;
                    },
                  ),
                ),
              ],
            ),
            if (_services[index]['description'] != null &&
                _services[index]['description'].toString().isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                _services[index]['description'].toString(),
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
