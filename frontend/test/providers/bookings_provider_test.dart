import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_platform/core/models/api/booking_model.dart';
import 'package:service_platform/core/providers/api/bookings_provider.dart';
import 'package:service_platform/core/repositories/booking_repository.dart';

import 'bookings_provider_test.mocks.dart';

@GenerateMocks([BookingRepository])
void main() {
  late MockBookingRepository mockRepo;
  late ProviderContainer container;

  final now = DateTime(2024, 6, 15, 10, 0);

  final mockBooking = BookingModel(
    id: 'booking1',
    clientId: 'client1',
    masterId: 'master1',
    serviceId: 'service1',
    startTime: now,
    endTime: now.add(const Duration(hours: 1)),
    durationMinutes: 60,
    price: 2000.0,
    status: BookingStatus.confirmed,
    clientReviewLeft: false,
    masterReviewLeft: false,
    locationType: 'salon',
    reminderSent: false,
    createdAt: now,
    updatedAt: now,
  );

  setUp(() {
    mockRepo = MockBookingRepository();
    container = ProviderContainer(
      overrides: [
        bookingRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('myBookings provider', () {
    test('returns list of bookings', () async {
      when(mockRepo.getMyBookings(
        page: anyNamed('page'),
        limit: anyNamed('limit'),
        status: anyNamed('status'),
        role: anyNamed('role'),
      )).thenAnswer((_) async => [mockBooking]);

      final bookings = await container.read(myBookingsProvider().future);

      expect(bookings.length, 1);
      expect(bookings.first.status, BookingStatus.confirmed);
    });

    test('returns empty list when no bookings', () async {
      when(mockRepo.getMyBookings(
        page: anyNamed('page'),
        limit: anyNamed('limit'),
        status: anyNamed('status'),
        role: anyNamed('role'),
      )).thenAnswer((_) async => []);

      final bookings = await container.read(myBookingsProvider().future);

      expect(bookings, isEmpty);
    });

    test('throws on error', () async {
      when(mockRepo.getMyBookings(
        page: anyNamed('page'),
        limit: anyNamed('limit'),
        status: anyNamed('status'),
        role: anyNamed('role'),
      )).thenThrow(Exception('Server error'));

      expect(
        () => container.read(myBookingsProvider().future),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('bookingById provider', () {
    test('returns booking by ID', () async {
      when(mockRepo.getBookingById('booking1'))
          .thenAnswer((_) async => mockBooking);

      final booking = await container.read(
        bookingByIdProvider('booking1').future,
      );

      expect(booking.id, 'booking1');
      expect(booking.price, 2000.0);
    });
  });

  group('BookingNotifier', () {
    test('createBooking — creates and returns booking', () async {
      when(mockRepo.createBooking(any)).thenAnswer((_) async => mockBooking);

      final notifier = container.read(bookingNotifierProvider.notifier);
      final result = await notifier.createBooking(
        CreateBookingRequest(
          masterId: 'master1',
          serviceId: 'service1',
          startTime: now,
        ),
      );

      expect(result.id, 'booking1');
      verify(mockRepo.createBooking(any)).called(1);
    });

    test('confirmBooking — confirms booking', () async {
      final confirmed = mockBooking.copyWith(status: BookingStatus.confirmed);
      when(mockRepo.confirmBooking('booking1'))
          .thenAnswer((_) async => confirmed);

      final notifier = container.read(bookingNotifierProvider.notifier);
      final result = await notifier.confirmBooking('booking1');

      expect(result.status, BookingStatus.confirmed);
    });

    test('cancelBooking — cancels booking with reason', () async {
      final cancelled = mockBooking.copyWith(status: BookingStatus.cancelled);
      when(mockRepo.cancelBooking('booking1', any))
          .thenAnswer((_) async => cancelled);

      final notifier = container.read(bookingNotifierProvider.notifier);
      final result = await notifier.cancelBooking('booking1', 'Не могу');

      expect(result.status, BookingStatus.cancelled);
    });

    test('completeBooking — completes booking', () async {
      final completed = mockBooking.copyWith(status: BookingStatus.completed);
      when(mockRepo.completeBooking('booking1'))
          .thenAnswer((_) async => completed);

      final notifier = container.read(bookingNotifierProvider.notifier);
      final result = await notifier.completeBooking('booking1');

      expect(result.status, BookingStatus.completed);
    });

    test('createBooking throws on error', () async {
      when(mockRepo.createBooking(any)).thenThrow(Exception('Booking failed'));

      final notifier = container.read(bookingNotifierProvider.notifier);
      expect(
        () => notifier.createBooking(
          CreateBookingRequest(
            masterId: 'master1',
            serviceId: 'service1',
            startTime: now,
          ),
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}
