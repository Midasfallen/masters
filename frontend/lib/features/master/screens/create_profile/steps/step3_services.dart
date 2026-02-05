import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/providers/api/service_templates_provider.dart';
import '../../../../../core/models/api/service_template_model.dart';

class Step3Services extends ConsumerStatefulWidget {
  final Map<String, dynamic> initialData;
  final Function(Map<String, dynamic>) onNext;
  final VoidCallback onBack;

  const Step3Services({
    super.key,
    required this.initialData,
    required this.onNext,
    required this.onBack,
  });

  @override
  ConsumerState<Step3Services> createState() => _Step3ServicesState();
}

class _Step3ServicesState extends ConsumerState<Step3Services> {
  List<Map<String, dynamic>> _services = [];
  final Map<String, List<ServiceTemplateModel>> _templatesByCategory = {};
  final Map<String, bool> _loadingTemplates = {};

  @override
  void initState() {
    super.initState();
    _services = List<Map<String, dynamic>>.from(widget.initialData['services'] ?? []);
    if (_services.isEmpty) {
      _services.add(_createEmptyService());
    }
    _loadTemplates();
  }

  Future<void> _loadTemplates() async {
    final categoryIds = List<String>.from(widget.initialData['category_ids'] ?? []);
    if (categoryIds.isEmpty) return;

    for (final categoryId in categoryIds) {
      setState(() {
        _loadingTemplates[categoryId] = true;
      });
      try {
        final response = await ref.read(
          serviceTemplatesByCategoryIdProvider(categoryId, language: 'ru').future,
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
    return {
      'category_id': '',
      'service_template_id': null,
      'name': '',
      'price': '',
      'duration': '60',
      'description': '',
    };
  }

  Map<String, dynamic> _createServiceFromTemplate(ServiceTemplateModel template) {
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

  void _showTemplateSelector() {
    final categoryIds = List<String>.from(widget.initialData['category_ids'] ?? []);
    if (categoryIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Сначала выберите категории на предыдущем шаге')),
      );
      return;
    }

    final allTemplates = <ServiceTemplateModel>[];
    for (final categoryId in categoryIds) {
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

  void _removeService(int index) {
    setState(() {
      _services.removeAt(index);
    });
  }

  void _continue() {
    final categoryIds = List<String>.from(widget.initialData['category_ids'] ?? []);
    final firstCategoryId = categoryIds.isNotEmpty ? categoryIds.first : null;

    final validServices = <Map<String, dynamic>>[];
    for (final service in _services) {
      if (service['name'].toString().trim().isEmpty ||
          service['price'].toString().trim().isEmpty) {
        continue;
      }
      final map = Map<String, dynamic>.from(service);
      if ((map['category_id'] == null || map['category_id'].toString().isEmpty) &&
          firstCategoryId != null) {
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

    widget.onNext({'services': validServices});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Услуги и цены',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Добавьте услуги, которые вы предоставляете',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          const SizedBox(height: 24),
          
          // Кнопка выбора из шаблонов
          FilledButton.icon(
            onPressed: _showTemplateSelector,
            icon: const Icon(Icons.auto_awesome),
            label: const Text('Выбрать из шаблонов'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
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
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: _addService,
            icon: const Icon(Icons.add),
            label: const Text('Добавить кастомную услугу'),
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
                Text('Услуга ${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                if (_services.length > 1)
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _removeService(index),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: TextEditingController(text: _services[index]['name']?.toString() ?? ''),
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
                      text: _services[index]['duration']?.toString() ?? '60',
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
