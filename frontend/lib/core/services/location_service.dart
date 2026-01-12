import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location_service.g.dart';

@riverpod
LocationService locationService(LocationServiceRef ref) {
  return LocationService();
}

/// Service для работы с геолокацией
class LocationService {
  /// Проверить разрешения на геолокацию
  Future<bool> checkPermissions() async {
    final status = await Permission.location.status;
    return status.isGranted;
  }

  /// Запросить разрешения на геолокацию
  Future<bool> requestPermissions() async {
    final status = await Permission.location.request();
    return status.isGranted;
  }

  /// Получить текущее местоположение
  Future<Position?> getCurrentPosition() async {
    try {
      // Проверяем разрешения
      final hasPermission = await checkPermissions();
      if (!hasPermission) {
        final granted = await requestPermissions();
        if (!granted) return null;
      }

      // Проверяем доступность служб геолокации
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      // Получаем текущую позицию
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      );

      return position;
    } catch (e) {
      return null;
    }
  }

  /// Рассчитать расстояние между двумя точками в километрах
  double calculateDistance({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  }) {
    return Geolocator.distanceBetween(
          startLat,
          startLng,
          endLat,
          endLng,
        ) /
        1000; // конвертируем в км
  }

  /// Форматировать расстояние для отображения
  String formatDistance(double distanceInKm) {
    if (distanceInKm < 1) {
      return '${(distanceInKm * 1000).round()} м';
    } else if (distanceInKm < 10) {
      return '${distanceInKm.toStringAsFixed(1)} км';
    } else {
      return '${distanceInKm.round()} км';
    }
  }

  /// Проверить, находится ли точка в радиусе
  bool isWithinRadius({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
    required double radiusInKm,
  }) {
    final distance = calculateDistance(
      startLat: startLat,
      startLng: startLng,
      endLat: endLat,
      endLng: endLng,
    );
    return distance <= radiusInKm;
  }
}

/// Provider для текущей позиции пользователя
@riverpod
class CurrentLocation extends _$CurrentLocation {
  @override
  Future<Position?> build() async {
    final service = ref.watch(locationServiceProvider);
    return await service.getCurrentPosition();
  }

  /// Обновить текущую позицию
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final service = ref.read(locationServiceProvider);
    state = await AsyncValue.guard(() => service.getCurrentPosition());
  }
}
