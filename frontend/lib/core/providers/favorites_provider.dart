import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_platform/core/models/favorite.dart';
import 'package:service_platform/core/repositories/favorites_repository.dart';

part 'favorites_provider.g.dart';

/// Получить список избранного
@riverpod
Future<List<Favorite>> favoritesList(
  FavoritesListRef ref, {
  FavoriteEntityType? entityType,
}) async {
  final repository = ref.watch(favoritesRepositoryProvider);
  return await repository.getFavorites(entityType: entityType);
}

/// Получить количество избранного
@riverpod
Future<int> favoritesCount(
  FavoritesCountRef ref, {
  FavoriteEntityType? entityType,
}) async {
  final repository = ref.watch(favoritesRepositoryProvider);
  return await repository.getFavoritesCount(entityType: entityType);
}

/// Проверить статус избранного для конкретной сущности
@riverpod
Future<bool> isFavorite(
  IsFavoriteRef ref,
  FavoriteEntityType entityType,
  String entityId,
) async {
  final repository = ref.watch(favoritesRepositoryProvider);
  return await repository.isFavorite(entityType, entityId);
}

/// Notifier для управления избранным
@riverpod
class FavoritesNotifier extends _$FavoritesNotifier {
  @override
  FutureOr<Favorite?> build() async {
    return null;
  }

  /// Добавить в избранное
  Future<Favorite> addToFavorites(
    FavoriteEntityType entityType,
    String entityId,
  ) async {
    state = const AsyncValue.loading();

    return await AsyncValue.guard(() async {
      final repository = ref.read(favoritesRepositoryProvider);
      final request = AddFavoriteRequest(
        entityType: entityType,
        entityId: entityId,
      );
      final favorite = await repository.addFavorite(request);

      // Invalidate lists
      ref.invalidate(favoritesListProvider);
      ref.invalidate(favoritesCountProvider);
      ref.invalidate(isFavoriteProvider(entityType, entityId));

      return favorite;
    }).then((asyncValue) {
      state = asyncValue;
      return asyncValue.requireValue;
    });
  }

  /// Удалить из избранного
  Future<void> removeFromFavorites(
    FavoriteEntityType entityType,
    String entityId,
  ) async {
    state = const AsyncValue.loading();

    await AsyncValue.guard(() async {
      final repository = ref.read(favoritesRepositoryProvider);
      await repository.removeFavoriteByEntity(entityType, entityId);

      // Invalidate lists
      ref.invalidate(favoritesListProvider);
      ref.invalidate(favoritesCountProvider);
      ref.invalidate(isFavoriteProvider(entityType, entityId));
    }).then((asyncValue) {
      state = asyncValue as AsyncValue<Favorite?>;
    });
  }

  /// Toggle избранное (добавить если нет, удалить если есть)
  Future<bool> toggleFavorite(
    FavoriteEntityType entityType,
    String entityId,
  ) async {
    final repository = ref.read(favoritesRepositoryProvider);
    final currentStatus = await repository.isFavorite(entityType, entityId);

    if (currentStatus) {
      await removeFromFavorites(entityType, entityId);
      return false;
    } else {
      await addToFavorites(entityType, entityId);
      return true;
    }
  }
}
