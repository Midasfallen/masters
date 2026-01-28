import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

/// Модель фильтров feed
class FeedFilters {
  final bool locationEnabled;
  final double? latitude;
  final double? longitude;
  final double radiusKm;
  final List<String> selectedCategoryIds;

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

/// Bottom sheet для фильтров feed
class FeedFiltersSheet extends StatefulWidget {
  final FeedFilters initialFilters;
  final List<CategoryOption> availableCategories;

  const FeedFiltersSheet({
    super.key,
    required this.initialFilters,
    this.availableCategories = const [],
  });

  @override
  State<FeedFiltersSheet> createState() => _FeedFiltersSheetState();
}

class _FeedFiltersSheetState extends State<FeedFiltersSheet> {
  late FeedFilters _filters;
  bool _isLoadingLocation = false;
  String? _locationError;

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

  void _toggleCategory(String categoryId) {
    final newCategories = List<String>.from(_filters.selectedCategoryIds);
    if (newCategories.contains(categoryId)) {
      newCategories.remove(categoryId);
    } else {
      newCategories.add(categoryId);
    }

    setState(() {
      _filters = _filters.copyWith(selectedCategoryIds: newCategories);
    });
  }

  void _resetFilters() {
    setState(() {
      _filters = const FeedFilters();
      _locationError = null;
    });
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

                  if (_filters.locationEnabled && _filters.latitude != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Радиус поиска: ${_filters.radiusKm.toInt()} км',
                      style: theme.textTheme.bodyMedium,
                    ),
                    Slider(
                      value: _filters.radiusKm,
                      min: 1,
                      max: 50,
                      divisions: 49,
                      label: '${_filters.radiusKm.toInt()} км',
                      onChanged: (value) {
                        setState(() {
                          _filters = _filters.copyWith(radiusKm: value);
                        });
                      },
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Categories filter section
                  if (widget.availableCategories.isNotEmpty) ...[
                    Text(
                      'Категории мастеров',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.availableCategories.map((category) {
                        final isSelected = _filters.selectedCategoryIds
                            .contains(category.id);

                        return FilterChip(
                          label: Text(category.name),
                          avatar: Text(
                            category.icon,
                            style: const TextStyle(fontSize: 16),
                          ),
                          selected: isSelected,
                          onSelected: (_) => _toggleCategory(category.id),
                          selectedColor: theme.colorScheme.primaryContainer,
                          checkmarkColor: theme.colorScheme.onPrimaryContainer,
                        );
                      }).toList(),
                    ),
                  ],

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

/// Category option for filters
class CategoryOption {
  final String id;
  final String name;
  final String icon;

  const CategoryOption({
    required this.id,
    required this.name,
    required this.icon,
  });
}
