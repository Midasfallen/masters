import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:service_platform/core/repositories/review_reminders_repository.dart';
import 'package:service_platform/core/models/unreviewed_booking.dart';
import 'package:service_platform/core/models/skip_review_response.dart';

import 'review_reminders_repository_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late MockDio mockDio;
  late ReviewRemindersRepository repository;

  setUp(() {
    mockDio = MockDio();
    repository = ReviewRemindersRepository(mockDio);
  });

  group('ReviewRemindersRepository', () {
    group('getUnreviewedBookings', () {
      test('успешно получает список неотзывленных бронирований', () async {
        // Arrange
        final mockResponse = Response(
          data: [
            {
              'id': '1',
              'service_id': 'service-1',
              'service_name': 'Стрижка',
              'master_id': 'master-1',
              'master_name': 'Иван Иванов',
              'client_id': 'client-1',
              'client_name': 'Петр Петров',
              'start_time': '2026-01-20T10:00:00Z',
              'end_time': '2026-01-20T11:30:00Z',
              'total_price': 1500.0,
              'is_client': true,
              'review_target': 'master-1',
              'review_target_name': 'Иван Иванов',
              'reminder_count': 2,
              'grace_skip_allowed': false,
              'last_reminded_at': '2026-01-22T10:00:00Z',
            },
          ],
          statusCode: 200,
          requestOptions: RequestOptions(path: '/reviews/unreviewed/bookings'),
        );

        when(mockDio.get('/reviews/unreviewed/bookings'))
            .thenAnswer((_) async => mockResponse);

        // Act
        final result = await repository.getUnreviewedBookings();

        // Assert
        expect(result, isA<List<UnreviewedBooking>>());
        expect(result.length, 1);
        expect(result[0].id, '1');
        expect(result[0].serviceName, 'Стрижка');
        expect(result[0].masterName, 'Иван Иванов');
        expect(result[0].reminderCount, 2);
        expect(result[0].graceSkipAllowed, false);

        verify(mockDio.get('/reviews/unreviewed/bookings')).called(1);
      });

      test('возвращает пустой список если нет неотзывленных бронирований', () async {
        // Arrange
        final mockResponse = Response(
          data: [],
          statusCode: 200,
          requestOptions: RequestOptions(path: '/reviews/unreviewed/bookings'),
        );

        when(mockDio.get('/reviews/unreviewed/bookings'))
            .thenAnswer((_) async => mockResponse);

        // Act
        final result = await repository.getUnreviewedBookings();

        // Assert
        expect(result, isEmpty);
        verify(mockDio.get('/reviews/unreviewed/bookings')).called(1);
      });

      test('пробрасывает исключение при ошибке API', () async {
        // Arrange
        when(mockDio.get('/reviews/unreviewed/bookings'))
            .thenThrow(DioException(
          requestOptions: RequestOptions(path: '/reviews/unreviewed/bookings'),
          response: Response(
            statusCode: 500,
            requestOptions: RequestOptions(path: '/reviews/unreviewed/bookings'),
          ),
        ));

        // Act & Assert
        expect(
          () => repository.getUnreviewedBookings(),
          throwsA(isA<DioException>()),
        );

        verify(mockDio.get('/reviews/unreviewed/bookings')).called(1);
      });

      test('корректно парсит множественные бронирования', () async {
        // Arrange
        final mockResponse = Response(
          data: [
            {
              'id': '1',
              'service_id': 'service-1',
              'service_name': 'Стрижка',
              'master_id': 'master-1',
              'master_name': 'Иван Иванов',
              'client_id': 'client-1',
              'client_name': 'Петр Петров',
              'start_time': '2026-01-20T10:00:00Z',
              'end_time': '2026-01-20T11:30:00Z',
              'total_price': 1500.0,
              'is_client': true,
              'review_target': 'master-1',
              'review_target_name': 'Иван Иванов',
              'reminder_count': 0,
              'grace_skip_allowed': false,
              'last_reminded_at': null,
            },
            {
              'id': '2',
              'service_id': 'service-2',
              'service_name': 'Массаж',
              'master_id': 'master-2',
              'master_name': 'Мария Петрова',
              'client_id': 'client-1',
              'client_name': 'Петр Петров',
              'start_time': '2026-01-21T14:00:00Z',
              'end_time': '2026-01-21T15:00:00Z',
              'total_price': 2000.0,
              'is_client': true,
              'review_target': 'master-2',
              'review_target_name': 'Мария Петрова',
              'reminder_count': 3,
              'grace_skip_allowed': true,
              'last_reminded_at': '2026-01-23T10:00:00Z',
            },
          ],
          statusCode: 200,
          requestOptions: RequestOptions(path: '/reviews/unreviewed/bookings'),
        );

        when(mockDio.get('/reviews/unreviewed/bookings'))
            .thenAnswer((_) async => mockResponse);

        // Act
        final result = await repository.getUnreviewedBookings();

        // Assert
        expect(result.length, 2);
        expect(result[0].id, '1');
        expect(result[0].reminderCount, 0);
        expect(result[0].graceSkipAllowed, false);
        expect(result[1].id, '2');
        expect(result[1].reminderCount, 3);
        expect(result[1].graceSkipAllowed, true);
      });
    });

    group('skipReview', () {
      const bookingId = 'booking-123';

      test('успешно пропускает напоминание с grace period', () async {
        // Arrange
        final mockResponse = Response(
          data: {
            'reminder_count': 0,
            'grace_skip_allowed': true,
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/reviews/skip/$bookingId'),
        );

        when(mockDio.post(
          '/reviews/skip/$bookingId',
          data: {'isGracePeriod': true},
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await repository.skipReview(bookingId, isGracePeriod: true);

        // Assert
        expect(result, isA<SkipReviewResponse>());
        expect(result.reminderCount, 0);
        expect(result.graceSkipAllowed, true);

        verify(mockDio.post(
          '/reviews/skip/$bookingId',
          data: {'isGracePeriod': true},
        )).called(1);
      });

      test('успешно пропускает напоминание без grace period', () async {
        // Arrange
        final mockResponse = Response(
          data: {
            'reminder_count': 1,
            'grace_skip_allowed': false,
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/reviews/skip/$bookingId'),
        );

        when(mockDio.post(
          '/reviews/skip/$bookingId',
          data: {'isGracePeriod': false},
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await repository.skipReview(bookingId, isGracePeriod: false);

        // Assert
        expect(result.reminderCount, 1);
        expect(result.graceSkipAllowed, false);

        verify(mockDio.post(
          '/reviews/skip/$bookingId',
          data: {'isGracePeriod': false},
        )).called(1);
      });

      test('использует isGracePeriod=false по умолчанию', () async {
        // Arrange
        final mockResponse = Response(
          data: {
            'reminder_count': 2,
            'grace_skip_allowed': false,
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/reviews/skip/$bookingId'),
        );

        when(mockDio.post(
          '/reviews/skip/$bookingId',
          data: {'isGracePeriod': false},
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await repository.skipReview(bookingId);

        // Assert
        expect(result.reminderCount, 2);

        verify(mockDio.post(
          '/reviews/skip/$bookingId',
          data: {'isGracePeriod': false},
        )).called(1);
      });

      test('пробрасывает исключение при ошибке 400 (grace period уже использован)', () async {
        // Arrange
        when(mockDio.post(
          '/reviews/skip/$bookingId',
          data: {'isGracePeriod': true},
        )).thenThrow(DioException(
          requestOptions: RequestOptions(path: '/reviews/skip/$bookingId'),
          response: Response(
            statusCode: 400,
            data: {'message': 'Grace period already used'},
            requestOptions: RequestOptions(path: '/reviews/skip/$bookingId'),
          ),
        ));

        // Act & Assert
        expect(
          () => repository.skipReview(bookingId, isGracePeriod: true),
          throwsA(isA<DioException>()),
        );
      });

      test('пробрасывает исключение при ошибке 403 (нет доступа)', () async {
        // Arrange
        when(mockDio.post(
          '/reviews/skip/$bookingId',
          data: {'isGracePeriod': false},
        )).thenThrow(DioException(
          requestOptions: RequestOptions(path: '/reviews/skip/$bookingId'),
          response: Response(
            statusCode: 403,
            data: {'message': 'User not related to this booking'},
            requestOptions: RequestOptions(path: '/reviews/skip/$bookingId'),
          ),
        ));

        // Act & Assert
        expect(
          () => repository.skipReview(bookingId),
          throwsA(isA<DioException>()),
        );
      });

      test('пробрасывает исключение при ошибке 404 (бронирование не найдено)', () async {
        // Arrange
        when(mockDio.post(
          '/reviews/skip/nonexistent-booking',
          data: {'isGracePeriod': false},
        )).thenThrow(DioException(
          requestOptions: RequestOptions(path: '/reviews/skip/nonexistent-booking'),
          response: Response(
            statusCode: 404,
            data: {'message': 'Booking not found'},
            requestOptions: RequestOptions(path: '/reviews/skip/nonexistent-booking'),
          ),
        ));

        // Act & Assert
        expect(
          () => repository.skipReview('nonexistent-booking'),
          throwsA(isA<DioException>()),
        );
      });
    });
  });
}
