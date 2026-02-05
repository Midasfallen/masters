import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/api/categories_tree_provider.dart';
import '../../../core/providers/api/services_provider.dart';
import '../../../core/providers/api/service_templates_provider.dart';
import '../../../core/models/api/category_tree_model.dart';
import '../../../core/models/api/service_model.dart';
import '../../../core/models/api/service_template_model.dart';

class CategoryServicesScreen extends ConsumerStatefulWidget {
  final String categoryId;
  final String categoryName;

  const CategoryServicesScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  ConsumerState<CategoryServicesScreen> createState() => _CategoryServicesScreenState();
}

class _CategoryServicesScreenState extends ConsumerState<CategoryServicesScreen> {
  CategoryTreeModel? _findCategoryInTree(List<CategoryTreeModel> categories) {
    CategoryTreeModel? found;
    void searchInTree(List<CategoryTreeModel> tree) {
      for (final cat in tree) {
        if (cat.id == widget.categoryId) {
          found = cat;
          return;
        }
        if (cat.children.isNotEmpty) {
          searchInTree(cat.children);
        }
      }
    }
    searchInTree(categories);
    return found;
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesTreeProvider(language: 'ru'));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: categoriesAsync.when(
        data: (categories) {
          final category = _findCategoryInTree(categories);
          if (category == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text('Категория не найдена'),
                ],
              ),
            );
          }
          return _buildContent(category);
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
      ),
    );
  }

  Widget _buildContent(CategoryTreeModel category) {
    // Level 0: показываем дочерние категории (level 1)
    if (category.level == 0 && category.children.isNotEmpty) {
      return _buildSubcategoriesList(category.children);
    }
    // Level 1: показываем шаблоны услуг (вместо level 2 категорий)
    else if (category.level == 1) {
      return _buildServiceTemplatesList();
    }
    // Fallback: показываем услуги (для обратной совместимости)
    else {
      return _buildServicesList();
    }
  }

  Widget _buildSubcategoriesList(List<CategoryTreeModel> subcategories) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: subcategories.length,
      itemBuilder: (context, index) {
        final subcategory = subcategories[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: subcategory.color != null
                    ? Color(int.parse(subcategory.color!.replaceFirst('#', '0xFF')))
                    : Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: subcategory.iconUrl != null && subcategory.iconUrl!.startsWith('emoji:')
                    ? Text(
                        subcategory.iconUrl!.substring(6),
                        style: const TextStyle(fontSize: 24),
                      )
                    : Icon(
                        Icons.category,
                        color: subcategory.color != null
                            ? Colors.white
                            : Theme.of(context).primaryColor,
                      ),
              ),
            ),
            title: Text(
              subcategory.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: subcategory.mastersCount > 0
                ? Text('${subcategory.mastersCount} мастеров')
                : null,
            trailing: subcategory.children.isNotEmpty
                ? const Icon(Icons.arrow_forward_ios, size: 16)
                : null,
            onTap: () {
              // Level 1 категории больше не содержат children (level 2 удалены)
              // При клике на level 1 показываем шаблоны услуг
              context.push(
                '/search/category/${subcategory.id}',
                extra: {
                  'categoryName': subcategory.name,
                  'categoryId': subcategory.id,
                },
              );
            },
          ),
        );
      },
    );
  }

  /// Показывает шаблоны услуг для категории level 1
  Widget _buildServiceTemplatesList() {
    final templatesAsync = ref.watch(
      serviceTemplatesByCategoryIdProvider(
        widget.categoryId,
        language: 'ru',
      ),
    );

    return templatesAsync.when(
      data: (response) {
        if (response.data.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.work_outline, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Шаблоны услуг не найдены',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'В этой категории пока нет шаблонов услуг.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: response.data.length,
          itemBuilder: (context, index) {
            final template = response.data[index];
            return _buildServiceTemplateCard(template);
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
            Text('Ошибка загрузки шаблонов: ${error.toString()}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.invalidate(serviceTemplatesByCategoryIdProvider),
              child: const Text('Повторить'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceTemplateCard(ServiceTemplateModel template) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          // Переходим на экран мастеров по этому шаблону услуги
          // Используем slug для SEO-friendly URL
          context.push(
            '/search/template/${template.slug}',
            extra: {
              'templateName': template.name,
              'templateId': template.id,
              'categoryId': template.categoryId,
            },
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      template.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (template.defaultPriceRangeMin != null ||
                      template.defaultPriceRangeMax != null)
                    Text(
                      template.defaultPriceRangeMin != null &&
                              template.defaultPriceRangeMax != null
                          ? '${template.defaultPriceRangeMin!.toStringAsFixed(0)}-${template.defaultPriceRangeMax!.toStringAsFixed(0)} ₽'
                          : template.defaultPriceRangeMin != null
                              ? 'от ${template.defaultPriceRangeMin!.toStringAsFixed(0)} ₽'
                              : 'до ${template.defaultPriceRangeMax!.toStringAsFixed(0)} ₽',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                ],
              ),
              if (template.description != null) ...[
                const SizedBox(height: 8),
                Text(
                  template.description!,
                  style: TextStyle(color: Colors.grey[600]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (template.defaultDurationMinutes != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      '${template.defaultDurationMinutes} мин',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServicesList() {
    final servicesAsync = ref.watch(servicesByCategoryIdsProvider([widget.categoryId]));

    return servicesAsync.when(
      data: (services) {
        if (services.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.work_outline, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Услуги не найдены',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'В этой категории пока нет доступных услуг.\nМастера еще не добавили услуги в эту категорию.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: services.length,
          itemBuilder: (context, index) {
            final service = services[index];
            return _buildServiceCard(service);
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
            Text('Ошибка загрузки услуг: ${error.toString()}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.invalidate(servicesByCategoryIdsProvider),
              child: const Text('Повторить'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(ServiceModel service) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          // Переходим на экран мастеров по этой услуге
          context.push(
            '/search/service/${service.id}',
            extra: {
              'serviceName': service.name,
              'serviceId': service.id,
              'categoryId': service.categoryId,
            },
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      service.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    '${service.price.toStringAsFixed(0)} ₽',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              if (service.description != null) ...[
                const SizedBox(height: 8),
                Text(
                  service.description!,
                  style: TextStyle(color: Colors.grey[600]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '${service.durationMinutes} мин',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  if (service.averageRating > 0) ...[
                    const SizedBox(width: 16),
                    Icon(Icons.star, size: 16, color: Colors.amber[700]),
                    const SizedBox(width: 4),
                    Text(
                      service.averageRating.toStringAsFixed(1),
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
