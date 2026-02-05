import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/providers/api/search_provider.dart';
import '../../../core/models/api/master_model.dart';

class TemplateMastersScreen extends ConsumerStatefulWidget {
  final String templateId;
  final String templateSlug;
  final String templateName;
  final String categoryId;

  const TemplateMastersScreen({
    super.key,
    required this.templateId,
    required this.templateSlug,
    required this.templateName,
    required this.categoryId,
  });

  @override
  ConsumerState<TemplateMastersScreen> createState() => _TemplateMastersScreenState();
}

class _TemplateMastersScreenState extends ConsumerState<TemplateMastersScreen> {
  Position? _userPosition;
  String? _locationError;
  static const double _defaultRadius = 10.0;

  @override
  void initState() {
    super.initState();
    _requestLocation();
  }

  Future<void> _requestLocation() async {
    try {
      final locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.medium,
      );

      final position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      setState(() {
        _userPosition = position;
        _locationError = null;
      });
    } catch (e) {
      setState(() {
        _locationError = e.toString();
      });
    }
  }

  double _calculateDistance(
    double? lat1,
    double? lon1,
    double? lat2,
    double? lon2,
  ) {
    if (lat1 == null || lon1 == null || lat2 == null || lon2 == null) {
      return double.infinity;
    }
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2) / 1000; // км
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.templateName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            if (_userPosition != null)
              Text(
                'Радиус поиска: ${_defaultRadius.toInt()} км',
                style: const TextStyle(fontSize: 12),
              )
            else if (_locationError != null)
              const Text(
                'Геолокация недоступна',
                style: TextStyle(fontSize: 12),
              ),
          ],
        ),
      ),
      body: _buildMastersList(),
    );
  }

  Widget _buildMastersList() {
    // Поиск мастеров по категории шаблона
    final mastersAsync = ref.watch(
      searchMastersProvider(
        query: widget.templateName, // Используем название шаблона для поиска
        categoryIds: [widget.categoryId],
        lat: _userPosition?.latitude,
        lng: _userPosition?.longitude,
        radius: _defaultRadius.toInt(),
      ),
    );

    return mastersAsync.when(
      data: (masters) {
        if (masters.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_search_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Мастера не найдены',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'В радиусе ${_defaultRadius.toInt()} км нет мастеров,\nкоторые предоставляют услугу "${widget.templateName}".',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Вернуться назад'),
                ),
              ],
            ),
          );
        }

        // Фильтруем мастеров по расстоянию, если есть геолокация
        List<MasterProfileModel> filteredMasters = masters;
        if (_userPosition != null) {
          filteredMasters = masters.where((master) {
            if (master.locationLat == null || master.locationLng == null) {
              return false; // Пропускаем мастеров без геолокации
            }
            final distance = _calculateDistance(
              _userPosition!.latitude,
              _userPosition!.longitude,
              master.locationLat,
              master.locationLng,
            );
            return distance <= _defaultRadius;
          }).toList();
        }

        if (filteredMasters.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_off_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Мастера не найдены в радиусе',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'В радиусе ${_defaultRadius.toInt()} км нет мастеров,\nкоторые предоставляют услугу "${widget.templateName}".',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Вернуться назад'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filteredMasters.length,
          itemBuilder: (context, index) {
            final master = filteredMasters[index];
            return _buildMasterCard(master);
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
            Text('Ошибка загрузки мастеров: ${error.toString()}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.invalidate(searchMastersProvider),
              child: const Text('Повторить'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Вернуться назад'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMasterCard(MasterProfileModel master) {
    double? distance;
    if (_userPosition != null &&
        master.locationLat != null &&
        master.locationLng != null) {
      distance = _calculateDistance(
        _userPosition!.latitude,
        _userPosition!.longitude,
        master.locationLat,
        master.locationLng,
      );
    }

    final user = master.user;
    final firstName = user?.firstName ?? '';
    final lastName = user?.lastName ?? '';
    final avatarUrl = user?.avatarUrl ?? (master.portfolioUrls.isNotEmpty ? master.portfolioUrls.first : null);
    final bool hasAvatar = avatarUrl != null && avatarUrl.isNotEmpty;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          context.push('/master/${master.userId}');
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: hasAvatar
                    ? CachedNetworkImage(
                        imageUrl: avatarUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey[300],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey[300],
                          child: const Icon(Icons.person, size: 40),
                        ),
                      )
                    : Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[300],
                        child: const Icon(Icons.person, size: 40),
                      ),
              ),
              const SizedBox(width: 16),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$firstName $lastName',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (master.bio != null && master.bio!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        master.bio!,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (master.rating > 0) ...[
                          Icon(Icons.star, size: 16, color: Colors.amber[700]),
                          const SizedBox(width: 4),
                          Text(
                            master.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '(${master.reviewsCount})',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                        if (distance != null) ...[
                          if (master.rating > 0) const SizedBox(width: 16),
                          Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            '${distance.toStringAsFixed(1)} км',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
