import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:service_platform/core/repositories/search_repository.dart';
import 'package:service_platform/core/api/dio_client.dart';
import 'package:service_platform/core/models/api/master_model.dart';
import 'package:service_platform/core/models/api/service_model.dart';

import 'search_repository_test.mocks.dart';

@GenerateMocks([DioClient])
void main() {
  late SearchRepository repository;
  late MockDioClient mockClient;

  setUp(() {
    mockClient = MockDioClient();
    repository = SearchRepository(mockClient);
  });

  group('SearchRepository', () {
    final mockMasterData = {
      'id': 'master1',
      'userId': 'user1',
      'categoryIds': ['cat1'],
      'subcategoryIds': [],
      'rating': 4.5,
      'reviewsCount': 20,
      'completedBookings': 50,
      'cancellationsCount': 2,
      'viewsCount': 100,
      'favoritesCount': 10,
      'subscribersCount': 5,
      'isMobile': true,
      'hasLocation': true,
      'isOnlineOnly': false,
      'portfolioUrls': [],
      'videoUrls': [],
      'minBookingHours': 1,
      'autoConfirm': false,
      'certificates': [],
      'languages': ['ru'],
      'isActive': true,
      'isApproved': true,
      'setupStep': 3,
      'createdAt': '2024-01-01T00:00:00Z',
      'updatedAt': '2024-01-01T00:00:00Z',
    };

    final mockServiceData = {
      'id': 'service1',
      'masterId': 'master1',
      'categoryId': 'cat1',
      'name': 'Массаж',
      'price': 2000.0,
      'currency': 'RUB',
      'durationMinutes': 60,
      'isBookableOnline': true,
      'isMobile': false,
      'isInSalon': true,
      'isActive': true,
      'tags': ['релакс', 'спа'],
      'photoUrls': [],
      'bookingsCount': 30,
      'averageRating': 4.8,
      'displayOrder': 1,
      'createdAt': '2024-01-01T00:00:00Z',
      'updatedAt': '2024-01-01T00:00:00Z',
    };

    group('searchMasters', () {
      test('should return list of masters', () async {
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {'data': [mockMasterData], 'total': 1},
          statusCode: 200,
        );

        when(mockClient.get(any, queryParameters: anyNamed('queryParameters')))
            .thenAnswer((_) async => mockResponse);

        final result = await repository.searchMasters(query: 'массаж');

        expect(result, isA<List<MasterProfileModel>>());
        expect(result.length, 1);
        expect(result.first.rating, 4.5);
      });

      test('should pass all filters', () async {
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {'data': [], 'total': 0},
          statusCode: 200,
        );

        when(mockClient.get(any, queryParameters: anyNamed('queryParameters')))
            .thenAnswer((_) async => mockResponse);

        await repository.searchMasters(
          query: 'парикмахер',
          categoryId: 'cat2',
          lat: 55.75,
          lng: 37.61,
          radius: 5,
          minRating: 4.0,
          maxPrice: 3000,
        );

        verify(mockClient.get(
          any,
          queryParameters: anyNamed('queryParameters'),
        )).called(1);
      });

      test('should throw on error', () async {
        when(mockClient.get(any, queryParameters: anyNamed('queryParameters')))
            .thenThrow(DioException(
              requestOptions: RequestOptions(path: ''),
              type: DioExceptionType.badResponse,
              response: Response(
                requestOptions: RequestOptions(path: ''),
                statusCode: 500,
                data: {'message': 'Server error'},
              ),
            ));

        expect(
          () => repository.searchMasters(query: 'test'),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('searchServices', () {
      test('should return list of services', () async {
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {'data': [mockServiceData], 'total': 1},
          statusCode: 200,
        );

        when(mockClient.get(any, queryParameters: anyNamed('queryParameters')))
            .thenAnswer((_) async => mockResponse);

        final result = await repository.searchServices(query: 'массаж');

        expect(result, isA<List<ServiceModel>>());
        expect(result.length, 1);
        expect(result.first.name, 'Массаж');
        expect(result.first.price, 2000.0);
      });

      test('should pass price filters', () async {
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {'data': [], 'total': 0},
          statusCode: 200,
        );

        when(mockClient.get(any, queryParameters: anyNamed('queryParameters')))
            .thenAnswer((_) async => mockResponse);

        await repository.searchServices(
          query: 'стрижка',
          minPrice: 500,
          maxPrice: 1500,
        );

        verify(mockClient.get(
          any,
          queryParameters: anyNamed('queryParameters'),
        )).called(1);
      });
    });
  });
}
