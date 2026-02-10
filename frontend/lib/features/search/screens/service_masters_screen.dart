import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/providers/api/services_provider.dart';
import '../../../core/providers/api/masters_provider.dart';
import '../../../core/models/api/master_model.dart';

class ServiceMastersScreen extends ConsumerStatefulWidget {
  final String serviceId;
  final String serviceName;
  final String categoryId;

  const ServiceMastersScreen({
    super.key,
    required this.serviceId,
    required this.serviceName,
    required this.categoryId,
  });

  @override
  ConsumerState<ServiceMastersScreen> createState() => _ServiceMastersScreenState();
}

class _ServiceMastersScreenState extends ConsumerState<ServiceMastersScreen> {
  Position? _userPosition;
  String? _locationError;
  static const double _defaultRadius = 10.0; // км

  @override
  void initState() {
    super.initState();
    _requestLocation();
  }

  Future<void> _requestLocation() async {
    setState(() {
      _locationError = null;
    });

    try {
      // Проверяем, включены ли службы геолокации
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _locationError = 'Службы геолокации отключены';
        });
        return;
      }

      // Проверяем разрешения
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _locationError = 'Разрешение на геолокацию отклонено';
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _locationError = 'Разрешение на геолокацию отклонено навсегда';
        });
        return;
      }

      // Получаем текущую позицию
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
        ),
      );

      setState(() {
        _userPosition = position;
      });
    } catch (e) {
      setState(() {
        _locationError = 'Ошибка получения геолокации: ${e.toString()}';
      });
    }
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
              widget.serviceName,
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
    // Сначала получаем услугу, чтобы узнать masterId
    final serviceAsync = ref.watch(serviceByIdProvider(widget.serviceId));

    return serviceAsync.when(
      data: (service) {
        // Получаем мастера по masterId из услуги (это ID профиля мастера)
        final masterAsync = ref.watch(masterByProfileIdProvider(service.masterId));

        return masterAsync.when(
          data: (master) {
            // Проверяем геолокацию для фильтрации
            if (_userPosition != null && master.locationLat != null && master.locationLng != null) {
              final distance = Geolocator.distanceBetween(
                _userPosition!.latitude,
                _userPosition!.longitude,
                master.locationLat!,
                master.locationLng!,
              ) / 1000; // в км

              if (distance > _defaultRadius) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_search_outlined, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'Мастер не найден',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'В радиусе ${_defaultRadius.toInt()} км нет мастеров, оказывающих эту услугу',
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
            }

            // Показываем мастера
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildMasterCard(master),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.person_off_outlined, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'Мастер не найден',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Мастер, предоставляющий эту услугу, больше не доступен.\nВозможно, профиль был удален или деактивирован.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.pop(),
                  child: const Text('Вернуться назад'),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Услуга не найдена',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Эта услуга больше не доступна или была удалена.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Вернуться назад'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMasterCard(MasterProfileModel master) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          context.push('/master/${master.id}');
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              CircleAvatar(
                radius: 32,
                backgroundImage: master.user?.avatarUrl != null
                    ? CachedNetworkImageProvider(master.user!.avatarUrl!)
                    : null,
                child: master.user?.avatarUrl == null
                    ? Text(
                        (master.user?.fullName ?? 'M')[0].toUpperCase(),
                        style: const TextStyle(fontSize: 24),
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      master.user?.fullName ?? 'Мастер',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (master.bio != null) ...[
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
                        Icon(Icons.star, size: 16, color: Colors.amber[700]),
                        const SizedBox(width: 4),
                        Text(
                          master.rating.toStringAsFixed(1),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${master.reviewsCount})',
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                        if (_userPosition != null && master.locationLat != null && master.locationLng != null) ...[
                          const SizedBox(width: 16),
                          Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            _calculateDistance(master.locationLat!, master.locationLng!),
                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
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

  String _calculateDistance(double lat, double lng) {
    if (_userPosition == null) return '';
    final distance = Geolocator.distanceBetween(
      _userPosition!.latitude,
      _userPosition!.longitude,
      lat,
      lng,
    );
    if (distance < 1000) {
      return '${distance.toInt()} м';
    } else {
      return '${(distance / 1000).toStringAsFixed(1)} км';
    }
  }
}
