import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/models/api/category_tree_model.dart';
import '../../../../../core/providers/api/categories_tree_provider.dart';
import '../../../../../core/providers/api/service_templates_provider.dart';
import '../../../../../core/models/api/service_template_model.dart';

/// Шаг 2: Иерархический выбор «категория (L0) → подкатегория (L1) → услуги».
///
/// Мастер добавляет один или несколько блоков. В каждом блоке выбирает главную
/// категорию (level 0), затем её подкатегорию (level 1), затем услуги этой
/// подкатегории (из шаблонов или кастомные).
///
/// На выходе onNext отдаёт:
///   category_ids    — уникальные ID (L0 ∪ L1); L1 обязателен в этом списке,
///                     т.к. услуга привязана к L1 и бэк требует category_id услуги
///                     ∈ profile.category_ids.
///   subcategory_ids — уникальные L1.
///   services        — [{category_id: L1, service_template_id?, name, price, duration, description}]
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

/// Один блок: главная категория → подкатегория → её услуги.
class _CategoryBlock {
  String? rootId; // L0
  String? subId; // L1
  final List<Map<String, dynamic>> services = [];

  _CategoryBlock();
}

class _Step2CategoriesState extends ConsumerState<Step2Categories> {
  final List<_CategoryBlock> _blocks = [];

  /// Кэш шаблонов услуг по L1-категории.
  final Map<String, List<ServiceTemplateModel>> _templatesByCategory = {};
  final Map<String, bool> _loadingTemplates = {};

  @override
  void initState() {
    super.initState();
    _restoreFromInitial();
    if (_blocks.isEmpty) {
      _blocks.add(_CategoryBlock());
    }
  }

  /// Восстановление ранее собранных данных (при возврате «Назад» из след. шага).
  void _restoreFromInitial() {
    final savedBlocks = widget.initialData['category_blocks'];
    if (savedBlocks is! List) return;
    for (final b in savedBlocks) {
      if (b is! Map) continue;
      final block = _CategoryBlock()
        ..rootId = b['root_id'] as String?
        ..subId = b['sub_id'] as String?;
      final svcs = b['services'];
      if (svcs is List) {
        block.services.addAll(
          svcs.map((e) => Map<String, dynamic>.from(e as Map)),
        );
      }
      _blocks.add(block);
      if (block.subId != null) _loadTemplates(block.subId!);
    }
  }

  Future<void> _loadTemplates(String subCategoryId) async {
    if (_templatesByCategory.containsKey(subCategoryId)) return;
    setState(() => _loadingTemplates[subCategoryId] = true);
    try {
      final response = await ref.read(
        serviceTemplatesByCategoryIdProvider(subCategoryId, language: 'ru')
            .future,
      );
      if (mounted) {
        setState(() {
          _templatesByCategory[subCategoryId] = response.data;
          _loadingTemplates[subCategoryId] = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _templatesByCategory[subCategoryId] = [];
          _loadingTemplates[subCategoryId] = false;
        });
      }
    }
  }

  // ==== Услуги внутри блока ====

  Map<String, dynamic> _emptyService(String subId) => {
        'category_id': subId,
        'service_template_id': null,
        'name': '',
        'price': '',
        'duration': '60',
        'description': '',
      };

  Map<String, dynamic> _serviceFromTemplate(
    String subId,
    ServiceTemplateModel t,
  ) =>
      {
        'category_id': subId,
        'service_template_id': t.id,
        'name': t.name,
        'price': t.defaultPriceRangeMin?.toStringAsFixed(0) ?? '',
        'duration': t.defaultDurationMinutes?.toString() ?? '60',
        'description': t.description ?? '',
      };

  void _showTemplateSelector(_CategoryBlock block) {
    final subId = block.subId;
    if (subId == null) return;
    final templates = _templatesByCategory[subId] ?? [];
    if (templates.isEmpty) {
      final loading = _loadingTemplates[subId] ?? false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            loading ? 'Загрузка шаблонов…' : 'Нет шаблонов для этой подкатегории',
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
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: templates.length,
                itemBuilder: (context, index) {
                  final t = templates[index];
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
                    onTap: () {
                      setState(() {
                        block.services.add(_serviceFromTemplate(subId, t));
                      });
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==== Сбор данных и переход дальше ====

  void _continue() {
    // Валидация: каждый блок — L0 + L1 + хотя бы 1 валидная услуга.
    final categoryIds = <String>{};
    final subcategoryIds = <String>{};
    final services = <Map<String, dynamic>>[];

    for (var i = 0; i < _blocks.length; i++) {
      final b = _blocks[i];
      if (b.rootId == null) {
        _snack('Блок ${i + 1}: выберите главную категорию');
        return;
      }
      if (b.subId == null) {
        _snack('Блок ${i + 1}: выберите подкатегорию');
        return;
      }
      final valid = b.services.where((s) =>
          s['name'].toString().trim().isNotEmpty &&
          s['price'].toString().trim().isNotEmpty);
      if (valid.isEmpty) {
        _snack('Блок ${i + 1}: добавьте хотя бы одну услугу с названием и ценой');
        return;
      }
      categoryIds.add(b.rootId!);
      categoryIds.add(b.subId!); // L1 нужен в category_ids для валидации услуг
      subcategoryIds.add(b.subId!);
      for (final s in valid) {
        final map = Map<String, dynamic>.from(s);
        map['category_id'] = b.subId; // услуга привязана к L1
        services.add(map);
      }
    }

    if (services.isEmpty) {
      _snack('Добавьте хотя бы одну услугу');
      return;
    }

    widget.onNext({
      'category_ids': categoryIds.toList(),
      'subcategory_ids': subcategoryIds.toList(),
      'services': services,
      // Сохраняем блочную структуру для восстановления при возврате «Назад».
      'category_blocks': _blocks
          .map((b) => {
                'root_id': b.rootId,
                'sub_id': b.subId,
                'services': b.services,
              })
          .toList(),
    });
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
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
            'Категории и услуги',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Выберите категорию, подкатегорию и услуги. Можно добавить несколько категорий.',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          const SizedBox(height: 24),
          categoriesAsync.when(
            data: (roots) {
              if (roots.isEmpty) {
                return const Text(
                  'Категории не загружены. Проверьте подключение.',
                  style: TextStyle(color: Colors.red),
                );
              }
              return Column(
                children: [
                  for (var i = 0; i < _blocks.length; i++)
                    _buildBlock(i, roots),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          setState(() => _blocks.add(_CategoryBlock())),
                      icon: const Icon(Icons.add),
                      label: const Text('Добавить ещё категорию'),
                    ),
                  ),
                ],
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

  Widget _buildBlock(int index, List<CategoryTreeModel> roots) {
    final block = _blocks[index];
    // Подкатегории (L1) выбранной главной категории (L0).
    final root =
        block.rootId == null ? null : _findRoot(roots, block.rootId!);
    final subs = root?.children ?? const <CategoryTreeModel>[];

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Категория ${index + 1}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                if (_blocks.length > 1)
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => setState(() => _blocks.removeAt(index)),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            // L0
            DropdownButtonFormField<String>(
              initialValue: block.rootId,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Главная категория',
                border: OutlineInputBorder(),
              ),
              items: roots
                  .map((r) => DropdownMenuItem(
                        value: r.id,
                        child: Text(r.name, overflow: TextOverflow.ellipsis),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  block.rootId = value;
                  block.subId = null; // сброс подкатегории и услуг
                  block.services.clear();
                });
              },
            ),
            const SizedBox(height: 12),
            // L1
            DropdownButtonFormField<String>(
              initialValue: block.subId,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Подкатегория',
                border: OutlineInputBorder(),
              ),
              items: subs
                  .map((s) => DropdownMenuItem(
                        value: s.id,
                        child: Text(s.name, overflow: TextOverflow.ellipsis),
                      ))
                  .toList(),
              onChanged: block.rootId == null
                  ? null
                  : (value) {
                      setState(() {
                        block.subId = value;
                        block.services.clear();
                      });
                      if (value != null) _loadTemplates(value);
                    },
            ),

            // Услуги
            if (block.subId != null) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Text('Услуги',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => _showTemplateSelector(block),
                  icon: const Icon(Icons.auto_awesome),
                  label: const Text('Выбрать из шаблонов'),
                ),
              ),
              const SizedBox(height: 8),
              for (var si = 0; si < block.services.length; si++)
                _buildServiceCard(block, si),
              const SizedBox(height: 4),
              OutlinedButton.icon(
                onPressed: () => setState(() =>
                    block.services.add(_emptyService(block.subId!))),
                icon: const Icon(Icons.add),
                label: const Text('Добавить свою услугу'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(_CategoryBlock block, int index) {
    final service = block.services[index];
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Услуга ${index + 1}',
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () =>
                      setState(() => block.services.removeAt(index)),
                ),
              ],
            ),
            TextFormField(
              initialValue: service['name']?.toString() ?? '',
              decoration: const InputDecoration(
                labelText: 'Название',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (v) => service['name'] = v,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: service['price']?.toString() ?? '',
                    decoration: const InputDecoration(
                      labelText: 'Цена (₽)',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => service['price'] = v,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    initialValue: service['duration']?.toString() ?? '60',
                    decoration: const InputDecoration(
                      labelText: 'Время (мин)',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => service['duration'] = v,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  CategoryTreeModel? _findRoot(List<CategoryTreeModel> roots, String id) {
    for (final r in roots) {
      if (r.id == id) return r;
    }
    return null;
  }
}
