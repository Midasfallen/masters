import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_platform/core/api/dio_client.dart';
import 'package:service_platform/core/api/api_exceptions.dart';
import 'package:service_platform/core/models/favorite.dart';

part 'favorites_repository.g.dart';

class FavoritesRepository {
  final DioClient _client;

  FavoritesRepository(this._client);

  /// Добавить в избранное
  Future<Favorite> addFavorite(AddFavoriteRequest request) async {
    try {
      final response = await _client.post(
        '/favorites',
        data: request.toJson(),
      );
      return Favorite.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Получить список избранного
  Future<List<Favorite>> getFavorites({
    FavoriteEntityType? entityType,
  }) async {
    try {
      final response = await _client.get(
        '/favorites',
        queryParameters: {
          if (entityType != null) 'entity_type': entityType.name,
        },
      );

      final data = response.data as List;
      return data.map((json) => Favorite.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Получить количество избранного
  Future<int> getFavoritesCount({
    FavoriteEntityType? entityType,
  }) async {
    try {
      final response = await _client.get(
        '/favorites/count',
        queryParameters: {
          if (entityType != null) 'entity_type': entityType.name,
        },
      );
      return response.data['count'] ?? 0;
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Проверить, добавлено ли в избранное
  Future<bool> isFavorite(
    FavoriteEntityType entityType,
    String entityId,
  ) async {
    try {
      final response = await _client.get(
        '/favorites/check/${entityType.name}/$entityId',
      );
      return response.data['is_favorite'] ?? false;
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Удалить из избранного по ID
  Future<void> removeFavorite(String favoriteId) async {
    try {
      await _client.delete('/favorites/$favoriteId');
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Удалить из избранного по сущности
  Future<void> removeFavoriteByEntity(
    FavoriteEntityType entityType,
    String entityId,
  ) async {
    try {
      await _client.delete('/favorites/${entityType.name}/$entityId');
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }
}

@riverpod
FavoritesRepository favoritesRepository(FavoritesRepositoryRef ref) {
  final client = ref.watch(dioClientProvider);
  return FavoritesRepository(client);
}
