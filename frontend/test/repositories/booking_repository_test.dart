import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:service_platform/core/repositories/booking_repository.dart';
import 'package:service_platform/core/api/dio_client.dart';
import 'package:service_platform/core/models/api/booking_model.dart';

import 'booking_repository_test.mocks.dart';

@GenerateMocks([DioClient])
void main() {
  late BookingRepository repository;
  late MockDioClient mockClient;

  setUp(() {
    mockClient = MockDioClient();
    repository = BookingRepository(mockClient);
  });

  group('BookingRepository', () {
    final mockBookingData = {
      'id': 'booking1',
      'clientId': 'client1',
      'masterId': 'master1',
      'serviceId': 'service1',
      'startTime': '2024-06-15T10:00:00Z',
      'endTime': '2024-06-15T11:00:00Z',
      'durationMinutes': 60,
      'price': 1500.0,
      'status': 'pending',
      'clientReviewLeft': false,
      'masterReviewLeft': false,
      'locationType': 'online',
      'reminderSent': false,
      'createdAt': '2024-06-10T12:00:00Z',
      'updatedAt': '2024-06-10T12:00:00Z',
    };

    group('createBooking', () {
      test('should create booking successfully', () async {
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: mockBookingData,
          statusCode: 201,
        );

        when(mockClient.post(any, data: anyNamed('data')))
            .thenAnswer((_) async => mockResponse);

        final request = CreateBookingRequest(
          masterId: 'master1',
          serviceId: 'service1',
          startTime: DateTime(2024, 6, 15, 10, 0),
        );
        final result = await repository.createBooking(request);

        expect(result, isA<BookingModel>());
        expect(result.id, 'booking1');
        expect(result.status, BookingStatus.pending);
        expect(result.price, 1500.0);
      });

      test('should throw on error', () async {
        when(mockClient.post(any, data: anyNamed('data')))
            .thenThrow(DioException(
              requestOptions: RequestOptions(path: ''),
              type: DioExceptionType.badResponse,
              response: Response(
                requestOptions: RequestOptions(path: ''),
                statusCode: 400,
                data: {'message': 'Service unavailable'},
              ),
            ));

        final request = CreateBookingRequest(
          masterId: 'master1',
          serviceId: 'service1',
          startTime: DateTime(2024, 6, 15, 10, 0),
        );

        expect(() => repository.createBooking(request), throwsA(isA<Exception>()));
      });
    });

    group('getMyBookings', () {
      test('should return list of bookings', () async {
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {
            'data': [mockBookingData],
            'total': 1,
          },
          statusCode: 200,
        );

        when(mockClient.get(any, queryParameters: anyNamed('queryParameters')))
            .thenAnswer((_) async => mockResponse);

        final result = await repository.getMyBookings(page: 1, limit: 20);

        expect(result, isA<List<BookingModel>>());
        expect(result.length, 1);
        expect(result.first.masterId, 'master1');
      });

      test('should pass status filter', () async {
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {'data': [], 'total': 0},
          statusCode: 200,
        );

        when(mockClient.get(any, queryParameters: anyNamed('queryParameters')))
            .thenAnswer((_) async => mockResponse);

        await repository.getMyBookings(status: BookingStatus.confirmed);

        verify(mockClient.get(
          any,
          queryParameters: anyNamed('queryParameters'),
        )).called(1);
      });
    });

    group('getBookingById', () {
      test('should return booking by ID', () async {
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: mockBookingData,
          statusCode: 200,
        );

        when(mockClient.get(any)).thenAnswer((_) async => mockResponse);

        final result = await repository.getBookingById('1');

        expect(result, isA<BookingModel>());
        expect(result.id, 'booking1');
      });
    });

    group('confirmBooking', () {
      test('should confirm booking successfully', () async {
        final confirmedData = {...mockBookingData, 'status': 'confirmed'};
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: confirmedData,
          statusCode: 200,
        );

        when(mockClient.post(any)).thenAnswer((_) async => mockResponse);

        final result = await repository.confirmBooking('1');

        expect(result.status, BookingStatus.confirmed);
      });
    });

    group('cancelBooking', () {
      test('should cancel booking successfully', () async {
        final cancelledData = {...mockBookingData, 'status': 'cancelled'};
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: cancelledData,
          statusCode: 200,
        );

        when(mockClient.post(any, data: anyNamed('data')))
            .thenAnswer((_) async => mockResponse);

        final cancelRequest = CancelBookingRequest(reason: 'Test');
        final result = await repository.cancelBooking('1', cancelRequest);

        expect(result.status, BookingStatus.cancelled);
      });
    });

    group('completeBooking', () {
      test('should complete booking successfully', () async {
        final completedData = {...mockBookingData, 'status': 'completed'};
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: completedData,
          statusCode: 200,
        );

        when(mockClient.post(any)).thenAnswer((_) async => mockResponse);

        final result = await repository.completeBooking('1');

        expect(result.status, BookingStatus.completed);
      });
    });
  });
}
