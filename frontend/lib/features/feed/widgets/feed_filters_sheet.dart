import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/providers/api/categories_tree_provider.dart';
import '../../../core/models/api/category_tree_model.dart';

/// Модель фильтров feed
class FeedFilters {
  final bool locationEnabled;
  final double? latitude;
  final double? longitude;
  final double radiusKm;
  final List<String> selectedCategoryIds; // Может содержать ID категорий любого уровня

  const FeedFilters({
    this.locationEnabled = false,
    this.latitude,
    this.longitude,
    this.radiusKm = 10.0,
    this.selectedCategoryIds = const [],
  });

  FeedFilters copyWith({
    bool? locationEnabled,
    double? latitude,
    double? longitude,
    double? radiusKm,
    List<String>? selectedCategoryIds,
  }) {
    return FeedFilters(
      locationEnabled: locationEnabled ?? this.locationEnabled,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radiusKm: radiusKm ?? this.radiusKm,
      selectedCategoryIds: selectedCategoryIds ?? this.selectedCategoryIds,
    );
  }

  bool get hasActiveFilters =>
      locationEnabled || selectedCategoryIds.isNotEmpty;

  Map<String, dynamic> toQueryParams() {
    return {
      if (locationEnabled && latitude != null && longitude != null) ...{
        'lat': latitude,
        'lng': longitude,
        'radius': radiusKm,
      },
      if (selectedCategoryIds.isNotEmpty)
        'category_ids': selectedCategoryIds,
    };
  }
}

/// Предустановленные значения радиуса
const List<double> _radiusOptions = [5.0, 10.0, 15.0, 20.0];

/// Bottom sheet для фильтров feed
class FeedFiltersSheet extends ConsumerStatefulWidget {
  final FeedFilters initialFilters;

  const FeedFiltersSheet({
    super.key,
    required this.initialFilters,
  });

  @override
  ConsumerState<FeedFiltersSheet> createState() => _FeedFiltersSheetState();
}

class _FeedFiltersSheetState extends ConsumerState<FeedFiltersSheet> {
  late FeedFilters _filters;
  bool _isLoadingLocation = false;
  String? _locationError;
  final Map<String, bool> _expandedCategories = {}; // Для отслеживания раскрытых категорий

  @override
  void initState() {
    super.initState();
    _filters = widget.initialFilters;
  }

  Future<void> _requestLocation() async {
    setState(() {
      _isLoadingLocation = true;
      _locationError = null;
    });

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _locationError = 'Службы геолокации отключены';
          _isLoadingLocation = false;
        });
        return;
      }

      // Check permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _locationError = 'Доступ к геолокации отклонён';
            _isLoadingLocation = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _locationError = 'Доступ к геолокации запрещён навсегда';
          _isLoadingLocation = false;
        });
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      setState(() {
        _filters = _filters.copyWith(
          locationEnabled: true,
          latitude: position.latitude,
          longitude: position.longitude,
        );
        _isLoadingLocation = false;
      });
    } catch (e) {
      setState(() {
        _locationError = 'Ошибка получения геолокации: ${e.toString()}';
        _isLoadingLocation = false;
      });
    }
  }

  /// Получить все дочерние категории (рекурсивно)
  List<String> _getAllChildCategoryIds(CategoryTreeModel category) {
    final List<String> ids = [category.id];
    for (final child in category.children) {
      ids.addAll(_getAllChildCategoryIds(child));
    }
    return ids;
  }

  /// Найти категорию по ID в дереве
  CategoryTreeModel? _findCategoryById(
    List<CategoryTreeModel> categories,
    String categoryId,
  ) {
    for (final category in categories) {
      if (category.id == categoryId) {
        return category;
      }
      final found = _findCategoryById(category.children, categoryId);
      if (found != null) {
        return found;
      }
    }
    return null;
  }

  void _toggleCategory(String categoryId) {
    final categoriesAsync = ref.read(categoriesTreeProvider(language: 'ru'));
    final categories = categoriesAsync.value;
    
    if (categories == null) {
      // Если категории еще не загружены, просто переключаем выбранную
      final newCategories = List<String>.from(_filters.selectedCategoryIds);
      if (newCategories.contains(categoryId)) {
        newCategories.remove(categoryId);
      } else {
        newCategories.add(categoryId);
      }
      setState(() {
        _filters = _filters.copyWith(selectedCategoryIds: newCategories);
      });
      return;
    }

    // Находим категорию в дереве
    final category = _findCategoryById(categories, categoryId);
    if (category == null) {
      // Если категория не найдена, просто переключаем
      final newCategories = List<String>.from(_filters.selectedCategoryIds);
      if (newCategories.contains(categoryId)) {
        newCategories.remove(categoryId);
      } else {
        newCategories.add(categoryId);
      }
      setState(() {
        _filters = _filters.copyWith(selectedCategoryIds: newCategories);
      });
      return;
    }

    // Получаем все дочерние категории
    final allChildIds = _getAllChildCategoryIds(category);
    
    final newCategories = List<String>.from(_filters.selectedCategoryIds);
    final isCurrentlySelected = newCategories.contains(categoryId);
    
    if (isCurrentlySelected) {
      // Удаляем категорию и все её дочерние
      newCategories.remove(categoryId);
      for (final childId in allChildIds) {
        newCategories.remove(childId);
      }
    } else {
      // Добавляем категорию и все её дочерние
      newCategories.add(categoryId);
      for (final childId in allChildIds) {
        if (childId != categoryId) {
          newCategories.add(childId);
        }
      }
    }

    setState(() {
      _filters = _filters.copyWith(selectedCategoryIds: newCategories);
    });
  }

  void _toggleExpanded(String categoryId) {
    setState(() {
      _expandedCategories[categoryId] = !(_expandedCategories[categoryId] ?? false);
    });
  }

  void _resetFilters() {
    setState(() {
      _filters = const FeedFilters();
      _locationError = null;
      _expandedCategories.clear();
    });
  }

  /// Получить название категории (уже приходит из API)
  String _getCategoryName(CategoryTreeModel category) {
    return category.name;
  }

  /// Получить иконку категории
  String _getCategoryIcon(CategoryTreeModel category) {
    if (category.iconUrl != null && category.iconUrl!.startsWith('emoji:')) {
      return category.iconUrl!.substring(6);
    }
    // Fallback иконки по уровню
    switch (category.level) {
      case 0:
        return '📂';
      case 1:
        return '📁';
      case 2:
        return '📄';
      default:
        return '📋';
    }
  }

  /// Построить виджет для категории с детьми
  Widget _buildCategoryItem(CategoryTreeModel category, int indentLevel) {
    final theme = Theme.of(context);
    final isSelected = _filters.selectedCategoryIds.contains(category.id);
    final hasChildren = category.children.isNotEmpty;
    final isExpanded = _expandedCategories[category.id] ?? false;
    final categoryName = _getCategoryName(category);
    final categoryIcon = _getCategoryIcon(category);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => _toggleCategory(category.id),
          child: Container(
            padding: EdgeInsets.only(
              left: 16.0 + (indentLevel * 16.0),
              right: 16.0,
              top: 8.0,
              bottom: 8.0,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                // Иконка раскрытия/сворачивания для категорий с детьми
                if (hasChildren)
                  IconButton(
                    icon: Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                      size: 20,
                    ),
                    onPressed: () => _toggleExpanded(category.id),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  )
                else
                  const SizedBox(width: 32),
                // Иконка категории
                Text(
                  categoryIcon,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(width: 8),
                // Название категории
                Expanded(
                  child: Text(
                    categoryName,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: category.level == 0
                          ? FontWeight.w600
                          : category.level == 1
                              ? FontWeight.w500
                              : FontWeight.normal,
                    ),
                  ),
                ),
                // Чекбокс выбора
                Checkbox(
                  value: isSelected,
                  onChanged: (_) => _toggleCategory(category.id),
                ),
              ],
            ),
          ),
        ),
        // Дочерние категории (если раскрыто)
        if (hasChildren && isExpanded)
          ...category.children
              .map((child) => _buildCategoryItem(child, indentLevel + 1)),
      ],
    );
  }

  /// Построить секцию фильтров по категориям
  Widget _buildCategoriesFilter() {
    final theme = Theme.of(context);
    final categoriesAsync = ref.watch(categoriesTreeProvider(language: 'ru'));

    return categoriesAsync.when(
      data: (categories) {
        if (categories.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'Категории не найдены',
              style: TextStyle(color: Colors.grey[600]),
            ),
          );
        }

        // Фильтруем только корневые категории (level 0)
        // Бэкенд уже возвращает только активные категории
        final rootCategories = categories
            .where((cat) => cat.level == 0)
            .toList();

        if (rootCategories.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'Нет доступных категорий',
              style: TextStyle(color: Colors.grey[600]),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Каталог услуг',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Выберите категории, подкатегории или конкретные услуги',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: theme.dividerColor),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: rootCategories
                    .map((category) => _buildCategoryItem(category, 0))
                    .toList(),
              ),
            ),
          ],
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          'Ошибка загрузки категорий: ${error.toString()}',
          style: TextStyle(color: theme.colorScheme.error),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  'Фильтры',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (_filters.hasActiveFilters)
                  TextButton(
                    key: const Key('feed-filters-reset-button'),
                    onPressed: _resetFilters,
                    child: const Text('Сбросить'),
                  ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location filter section
                  Text(
                    'Геолокация',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Показать мастеров рядом'),
                    subtitle: _filters.locationEnabled && _filters.latitude != null
                        ? Text('В радиусе ${_filters.radiusKm.toInt()} км')
                        : _locationError != null
                            ? Text(
                                _locationError!,
                                style: TextStyle(color: theme.colorScheme.error),
                              )
                            : const Text('Использовать текущее местоположение'),
                    value: _filters.locationEnabled,
                    onChanged: _isLoadingLocation
                        ? null
                        : (value) {
                            if (value) {
                              _requestLocation();
                            } else {
                              setState(() {
                                _filters = _filters.copyWith(
                                  locationEnabled: false,
                                  latitude: null,
                                  longitude: null,
                                );
                                _locationError = null;
                              });
                            }
                          },
                  ),

                  if (_isLoadingLocation)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: LinearProgressIndicator(),
                    ),

                  // Радиус поиска (предустановленные значения)
                  if (_filters.locationEnabled && _filters.latitude != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Радиус поиска',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _radiusOptions.map((radius) {
                        final isSelected = _filters.radiusKm == radius;
                        return FilterChip(
                          label: Text('${radius.toInt()} км'),
                          selected: isSelected,
                          onSelected: (_) {
                            setState(() {
                              _filters = _filters.copyWith(radiusKm: radius);
                            });
                          },
                          selectedColor: theme.colorScheme.primaryContainer,
                          checkmarkColor: theme.colorScheme.onPrimaryContainer,
                        );
                      }).toList(),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Categories filter section
                  _buildCategoriesFilter(),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Action buttons
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Отмена'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: FilledButton(
                      key: const Key('feed-filters-apply-button'),
                      onPressed: () => Navigator.of(context).pop(_filters),
                      child: Text(
                        _filters.hasActiveFilters
                            ? 'Применить фильтры'
                            : 'Показать все',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
