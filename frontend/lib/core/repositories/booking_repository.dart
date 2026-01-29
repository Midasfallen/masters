import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_platform/core/api/api_endpoints.dart';
import 'package:service_platform/core/api/api_exceptions.dart';
import 'package:service_platform/core/api/dio_client.dart';
import 'package:service_platform/core/api/api_helpers.dart';
import 'package:service_platform/core/models/api/booking_model.dart';

part 'booking_repository.g.dart';

class BookingRepository {
  final DioClient _client;

  BookingRepository(this._client);

  /// Create new booking
  Future<BookingModel> createBooking(CreateBookingRequest request) async {
    try {
      final response = await _client.post(
        ApiEndpoints.bookingCreate,
        data: request.toJson(),
      );
      return BookingModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Get user's bookings
  Future<List<BookingModel>> getMyBookings({
    int page = 1,
    int limit = 20,
    BookingStatus? status,
    String? role, // 'client' or 'master'
  }) async {
    try {
      final response = await _client.get(
        ApiEndpoints.bookingsMy,
        queryParameters: {
          'page': page,
          'limit': limit,
          if (status != null) 'status': status.name,
          if (role != null) 'role': role,
        },
      );

      final data = ApiHelpers.parseListResponse(response.data);
      return data.map((json) => BookingModel.fromJson(json as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Get booking by ID
  Future<BookingModel> getBookingById(String id) async {
    try {
      final response = await _client.get(
        ApiEndpoints.bookingById(id),
      );
      return BookingModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Confirm booking (master only)
  Future<BookingModel> confirmBooking(String id) async {
    try {
      final response = await _client.post(
        ApiEndpoints.bookingConfirm(id),
      );
      return BookingModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Cancel booking
  Future<BookingModel> cancelBooking(
    String id,
    CancelBookingRequest request,
  ) async {
    try {
      final response = await _client.post(
        ApiEndpoints.bookingCancel(id),
        data: request.toJson(),
      );
      return BookingModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Complete booking (master only)
  Future<BookingModel> completeBooking(String id) async {
    try {
      final response = await _client.post(
        ApiEndpoints.bookingComplete(id),
      );
      return BookingModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Update booking status
  Future<BookingModel> updateBookingStatus(
    String id,
    UpdateBookingStatusRequest request,
  ) async {
    try {
      final response = await _client.patch(
        ApiEndpoints.bookingById(id),
        data: request.toJson(),
      );
      return BookingModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }
}

@riverpod
BookingRepository bookingRepository(BookingRepositoryRef ref) {
  final client = ref.watch(dioClientProvider);
  return BookingRepository(client);
}
