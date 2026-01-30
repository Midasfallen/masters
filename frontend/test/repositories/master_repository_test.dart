import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:service_platform/core/repositories/master_repository.dart';
import 'package:service_platform/core/api/dio_client.dart';
import 'package:service_platform/core/models/api/master_model.dart';
import 'package:service_platform/core/models/api/service_model.dart';
import 'package:service_platform/core/models/api/review_model.dart';

import 'master_repository_test.mocks.dart';

@GenerateMocks([DioClient])
void main() {
  late MasterRepository repository;
  late MockDioClient mockClient;

  setUp(() {
    mockClient = MockDioClient();
    repository = MasterRepository(mockClient);
  });

  group('MasterRepository', () {
    final mockMasterData = {
      'id': 'master-uuid-1',
      'userId': 'user-uuid-1',
      'businessName': 'Test Salon',
      'bio': 'Professional hairdresser',
      'categoryIds': ['cat-1', 'cat-2'],
      'subcategoryIds': ['sub-1'],
      'rating': 4.8,
      'reviewsCount': 25,
      'completedBookings': 100,
      'cancellationsCount': 2,
      'viewsCount': 500,
      'favoritesCount': 50,
      'subscribersCount': 30,
      'locationLat': 55.7558,
      'locationLng': 37.6173,
      'locationAddress': 'Moscow, Russia',
      'locationName': 'City Center',
      'serviceRadiusKm': 10,
      'isMobile': true,
      'hasLocation': true,
      'isOnlineOnly': false,
      'portfolioUrls': ['https://example.com/photo1.jpg'],
      'videoUrls': [],
      'socialLinks': {'instagram': '@testsalon'},
      'workingHours': {
        'monday': {'start': '09:00', 'end': '18:00'}
      },
      'minBookingHours': 2,
      'maxBookingsPerDay': 8,
      'autoConfirm': false,
      'yearsOfExperience': 5,
      'certificates': ['Certificate 1'],
      'languages': ['ru', 'en'],
      'isActive': true,
      'isApproved': true,
      'setupStep': 5,
      'createdAt': '2024-01-01T00:00:00.000Z',
      'updatedAt': '2024-01-15T00:00:00.000Z',
    };

    final mockServiceData = {
      'id': 'service-uuid-1',
      'masterId': 'master-uuid-1',
      'categoryId': 'cat-1',
      'subcategoryId': 'sub-1',
      'name': 'Haircut',
      'description': 'Professional haircut',
      'price': 50.0,
      'currency': 'RUB',
      'priceFrom': null,
      'priceTo': null,
      'durationMinutes': 60,
      'isBookableOnline': true,
      'isMobile': false,
      'isInSalon': true,
      'tags': ['haircut', 'styling'],
      'photoUrls': ['https://example.com/service.jpg'],
      'bookingsCount': 50,
      'averageRating': 4.9,
      'isActive': true,
      'displayOrder': 1,
      'createdAt': '2024-01-01T00:00:00.000Z',
      'updatedAt': '2024-01-15T00:00:00.000Z',
    };

    final mockReviewData = {
      'id': 'review-uuid-1',
      'bookingId': 'booking-uuid-1',
      'reviewerId': 'user-uuid-2',
      'reviewedUserId': 'user-uuid-1',
      'reviewerType': 'client',
      'rating': 5,
      'comment': 'Excellent service!',
      'photoUrls': [],
      'response': null,
      'responseAt': null,
      'isVisible': true,
      'reportsCount': 0,
      'isApproved': true,
      'createdAt': '2024-01-10T00:00:00.000Z',
      'updatedAt': '2024-01-10T00:00:00.000Z',
    };

    group('getMasters', () {
      test('should return list of masters', () async {
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {
            'data': [mockMasterData],
            'total': 1,
          },
          statusCode: 200,
        );

        when(mockClient.get(any, queryParameters: anyNamed('queryParameters')))
            .thenAnswer((_) async => mockResponse);

        final result = await repository.getMasters();

        expect(result, isA<List<MasterProfileModel>>());
        expect(result.length, 1);
        expect(result.first.businessName, 'Test Salon');
      });

      test('should pass filter parameters', () async {
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {'data': [], 'total': 0},
          statusCode: 200,
        );

        when(mockClient.get(any, queryParameters: anyNamed('queryParameters')))
            .thenAnswer((_) async => mockResponse);

        await repository.getMasters(
          page: 2,
          limit: 10,
          categoryId: 'cat-1',
          lat: 55.75,
          lng: 37.61,
          radius: 5,
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

        expect(() => repository.getMasters(), throwsA(isA<Exception>()));
      });
    });

    group('getMasterById', () {
      test('should return master by ID', () async {
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: mockMasterData,
          statusCode: 200,
        );

        when(mockClient.get(any)).thenAnswer((_) async => mockResponse);

        final result = await repository.getMasterById('master-uuid-1');

        expect(result, isA<MasterProfileModel>());
        expect(result.id, 'master-uuid-1');
        expect(result.businessName, 'Test Salon');
        expect(result.rating, 4.8);
      });

      test('should throw on not found', () async {
        when(mockClient.get(any)).thenThrow(DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 404,
            data: {'message': 'Master not found'},
          ),
        ));

        expect(
          () => repository.getMasterById('nonexistent'),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('createMasterProfile', () {
      test('should create master profile', () async {
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: mockMasterData,
          statusCode: 201,
        );

        when(mockClient.post(any, data: anyNamed('data')))
            .thenAnswer((_) async => mockResponse);

        final request = CreateMasterProfileRequest(
          categoryIds: ['cat-1', 'cat-2'],
          businessName: 'Test Salon',
          bio: 'Professional hairdresser',
        );

        final result = await repository.createMasterProfile(request);

        expect(result, isA<MasterProfileModel>());
        expect(result.businessName, 'Test Salon');
        verify(mockClient.post(any, data: anyNamed('data'))).called(1);
      });

      test('should throw on validation error', () async {
        when(mockClient.post(any, data: anyNamed('data'))).thenThrow(DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 400,
            data: {'message': 'Category is required'},
          ),
        ));

        final request = CreateMasterProfileRequest(categoryIds: []);

        expect(
          () => repository.createMasterProfile(request),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('updateMasterProfile', () {
      test('should update master profile', () async {
        final updatedData = {
          ...mockMasterData,
          'businessName': 'Updated Salon',
          'bio': 'Updated bio',
        };

        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: updatedData,
          statusCode: 200,
        );

        when(mockClient.patch(any, data: anyNamed('data')))
            .thenAnswer((_) async => mockResponse);

        final request = UpdateMasterProfileRequest(
          businessName: 'Updated Salon',
          bio: 'Updated bio',
        );

        final result = await repository.updateMasterProfile(request);

        expect(result.businessName, 'Updated Salon');
        verify(mockClient.patch(any, data: anyNamed('data'))).called(1);
      });

      test('should throw on unauthorized', () async {
        when(mockClient.patch(any, data: anyNamed('data'))).thenThrow(DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 401,
            data: {'message': 'Unauthorized'},
          ),
        ));

        final request = UpdateMasterProfileRequest(businessName: 'Test');

        expect(
          () => repository.updateMasterProfile(request),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('getMasterServices', () {
      test('should return list of master services', () async {
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {
            'data': [mockServiceData],
            'total': 1,
          },
          statusCode: 200,
        );

        when(mockClient.get(any)).thenAnswer((_) async => mockResponse);

        final result = await repository.getMasterServices('master-uuid-1');

        expect(result, isA<List<ServiceModel>>());
        expect(result.length, 1);
        expect(result.first.name, 'Haircut');
        expect(result.first.price, 50.0);
      });

      test('should return empty list when no services', () async {
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {'data': [], 'total': 0},
          statusCode: 200,
        );

        when(mockClient.get(any)).thenAnswer((_) async => mockResponse);

        final result = await repository.getMasterServices('master-uuid-1');

        expect(result, isEmpty);
      });
    });

    group('getMasterReviews', () {
      test('should return list of master reviews', () async {
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {
            'data': [mockReviewData],
            'total': 1,
          },
          statusCode: 200,
        );

        when(mockClient.get(any, queryParameters: anyNamed('queryParameters')))
            .thenAnswer((_) async => mockResponse);

        final result = await repository.getMasterReviews('master-uuid-1');

        expect(result, isA<List<ReviewModel>>());
        expect(result.length, 1);
        expect(result.first.rating, 5);
        expect(result.first.comment, 'Excellent service!');
      });

      test('should pass pagination parameters', () async {
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {'data': [], 'total': 0},
          statusCode: 200,
        );

        when(mockClient.get(any, queryParameters: anyNamed('queryParameters')))
            .thenAnswer((_) async => mockResponse);

        await repository.getMasterReviews(
          'master-uuid-1',
          page: 2,
          limit: 10,
        );

        verify(mockClient.get(
          any,
          queryParameters: anyNamed('queryParameters'),
        )).called(1);
      });
    });

    group('getMyMasterProfile', () {
      test('should return current user master profile', () async {
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: mockMasterData,
          statusCode: 200,
        );

        when(mockClient.get(any)).thenAnswer((_) async => mockResponse);

        final result = await repository.getMyMasterProfile();

        expect(result, isA<MasterProfileModel>());
        expect(result.businessName, 'Test Salon');
        expect(result.isApproved, true);
      });

      test('should throw when user is not a master', () async {
        when(mockClient.get(any)).thenThrow(DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 404,
            data: {'message': 'Master profile not found'},
          ),
        ));

        expect(
          () => repository.getMyMasterProfile(),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}
