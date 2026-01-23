import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:service_platform/core/repositories/favorites_repository.dart';
import 'package:service_platform/core/api/dio_client.dart';
import 'package:service_platform/core/models/favorite.dart';

import 'favorites_repository_test.mocks.dart';

@GenerateMocks([DioClient])
void main() {
  late FavoritesRepository repository;
  late MockDioClient mockClient;

  setUp(() {
    mockClient = MockDioClient();
    repository = FavoritesRepository(mockClient);
  });

  group('FavoritesRepository', () {
    group('getFavorites', () {
      test('should return list of favorites', () async {
        // Arrange
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: [
            {
              'id': '1',
              'user_id': 'user1',
              'entity_type': 'master',
              'entity_id': 'master123',
              'created_at': '2024-01-01T00:00:00Z',
              'entity': {
                'full_name': 'John Doe',
                'rating': 4.5,
              },
            },
          ],
          statusCode: 200,
        );

        when(mockClient.get(
          any,
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await repository.getFavorites();

        // Assert
        expect(result, isA<List<Favorite>>());
        expect(result.length, 1);
        expect(result.first.id, '1');
        expect(result.first.entityType, FavoriteEntityType.master);
      });

      test('should filter by entity type', () async {
        // Arrange
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: [],
          statusCode: 200,
        );

        when(mockClient.get(
          any,
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => mockResponse);

        // Act
        await repository.getFavorites(entityType: FavoriteEntityType.post);

        // Assert
        verify(mockClient.get(
          any,
          queryParameters: {'entity_type': 'post'},
        )).called(1);
      });
    });

    group('getFavoritesCount', () {
      test('should return count of favorites', () async {
        // Arrange
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {'count': 42},
          statusCode: 200,
        );

        when(mockClient.get(
          any,
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await repository.getFavoritesCount();

        // Assert
        expect(result, 42);
      });

      test('should return 0 if count is null', () async {
        // Arrange
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {},
          statusCode: 200,
        );

        when(mockClient.get(
          any,
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await repository.getFavoritesCount();

        // Assert
        expect(result, 0);
      });
    });

    group('isFavorite', () {
      test('should return true if favorite', () async {
        // Arrange
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {'is_favorite': true},
          statusCode: 200,
        );

        when(mockClient.get(any)).thenAnswer((_) async => mockResponse);

        // Act
        final result = await repository.isFavorite(
          FavoriteEntityType.master,
          'master123',
        );

        // Assert
        expect(result, true);
      });

      test('should return false if not favorite', () async {
        // Arrange
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {'is_favorite': false},
          statusCode: 200,
        );

        when(mockClient.get(any)).thenAnswer((_) async => mockResponse);

        // Act
        final result = await repository.isFavorite(
          FavoriteEntityType.post,
          'post456',
        );

        // Assert
        expect(result, false);
      });
    });

    group('addFavorite', () {
      test('should add favorite successfully', () async {
        // Arrange
        final request = AddFavoriteRequest(
          entityType: FavoriteEntityType.master,
          entityId: 'master123',
        );

        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {
            'id': 'fav1',
            'user_id': 'user1',
            'entity_type': 'master',
            'entity_id': 'master123',
            'created_at': '2024-01-01T00:00:00Z',
          },
          statusCode: 201,
        );

        when(mockClient.post(
          any,
          data: anyNamed('data'),
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await repository.addFavorite(request);

        // Assert
        expect(result, isA<Favorite>());
        expect(result.id, 'fav1');
        expect(result.entityId, 'master123');
      });
    });

    group('removeFavorite', () {
      test('should remove favorite by ID', () async {
        // Arrange
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 204,
        );

        when(mockClient.delete(any)).thenAnswer((_) async => mockResponse);

        // Act
        await repository.removeFavorite('fav123');

        // Assert
        verify(mockClient.delete('/favorites/fav123')).called(1);
      });
    });

    group('removeFavoriteByEntity', () {
      test('should remove favorite by entity', () async {
        // Arrange
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 204,
        );

        when(mockClient.delete(any)).thenAnswer((_) async => mockResponse);

        // Act
        await repository.removeFavoriteByEntity(
          FavoriteEntityType.post,
          'post456',
        );

        // Assert
        verify(mockClient.delete('/favorites/post/post456')).called(1);
      });
    });
  });
}
