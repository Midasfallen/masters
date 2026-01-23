import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_platform/core/models/api/booking_model.dart';
import 'package:service_platform/core/repositories/booking_repository.dart';

part 'bookings_provider.g.dart';

/// My Bookings Provider
@riverpod
Future<List<BookingModel>> myBookings(
  MyBookingsRef ref, {
  int page = 1,
  int limit = 20,
  BookingStatus? status,
  String? role,
}) async {
  final repository = ref.watch(bookingRepositoryProvider);
  return await repository.getMyBookings(
    page: page,
    limit: limit,
    status: status,
    role: role,
  );
}

/// Booking by ID Provider
@riverpod
Future<BookingModel> bookingById(BookingByIdRef ref, String bookingId) async {
  final repository = ref.watch(bookingRepositoryProvider);
  return await repository.getBookingById(bookingId);
}

/// Booking Notifier for mutations
@riverpod
class BookingNotifier extends _$BookingNotifier {
  @override
  FutureOr<BookingModel?> build() async {
    return null;
  }

  /// Create booking
  /// Throws [UnreviewedBookingsException] if there are unreviewed bookings
  Future<BookingModel> createBooking(CreateBookingRequest request) async {
    state = const AsyncValue.loading();

    return await AsyncValue.guard(() async {
      final repository = ref.read(bookingRepositoryProvider);
      final booking = await repository.createBooking(request);

      // Invalidate bookings list
      ref.invalidate(myBookingsProvider);

      return booking;
    }).then((asyncValue) {
      state = asyncValue;
      if (asyncValue.hasError) {
        throw asyncValue.error!;
      }
      return asyncValue.requireValue;
    });
  }

  /// Confirm booking
  Future<BookingModel> confirmBooking(String bookingId) async {
    state = const AsyncValue.loading();

    return await AsyncValue.guard(() async {
      final repository = ref.read(bookingRepositoryProvider);
      final booking = await repository.confirmBooking(bookingId);

      // Invalidate bookings
      ref.invalidate(myBookingsProvider);
      ref.invalidate(bookingByIdProvider(bookingId));

      return booking;
    }).then((asyncValue) {
      state = asyncValue;
      return asyncValue.requireValue;
    });
  }

  /// Cancel booking
  Future<BookingModel> cancelBooking(
    String bookingId,
    String reason,
  ) async {
    state = const AsyncValue.loading();

    return await AsyncValue.guard(() async {
      final repository = ref.read(bookingRepositoryProvider);
      final booking = await repository.cancelBooking(
        bookingId,
        CancelBookingRequest(reason: reason),
      );

      // Invalidate bookings
      ref.invalidate(myBookingsProvider);
      ref.invalidate(bookingByIdProvider(bookingId));

      return booking;
    }).then((asyncValue) {
      state = asyncValue;
      return asyncValue.requireValue;
    });
  }

  /// Complete booking
  Future<BookingModel> completeBooking(String bookingId) async {
    state = const AsyncValue.loading();

    return await AsyncValue.guard(() async {
      final repository = ref.read(bookingRepositoryProvider);
      final booking = await repository.completeBooking(bookingId);

      // Invalidate bookings
      ref.invalidate(myBookingsProvider);
      ref.invalidate(bookingByIdProvider(bookingId));

      return booking;
    }).then((asyncValue) {
      state = asyncValue;
      return asyncValue.requireValue;
    });
  }
}
