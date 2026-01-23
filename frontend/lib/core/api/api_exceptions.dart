import 'package:dio/dio.dart';

/// Base API Exception
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException({
    required this.message,
    this.statusCode,
    this.data,
  });

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

/// Network connection exception
class NetworkException extends ApiException {
  NetworkException({String? message})
      : super(
          message: message ?? 'No internet connection',
          statusCode: null,
        );
}

/// Timeout exception
class TimeoutException extends ApiException {
  TimeoutException({String? message})
      : super(
          message: message ?? 'Request timeout',
          statusCode: 408,
        );
}

/// Unauthorized exception (401)
class UnauthorizedException extends ApiException {
  UnauthorizedException({String? message})
      : super(
          message: message ?? 'Unauthorized',
          statusCode: 401,
        );
}

/// Forbidden exception (403)
class ForbiddenException extends ApiException {
  ForbiddenException({String? message})
      : super(
          message: message ?? 'Access forbidden',
          statusCode: 403,
        );
}

/// Not found exception (404)
class NotFoundException extends ApiException {
  NotFoundException({String? message})
      : super(
          message: message ?? 'Resource not found',
          statusCode: 404,
        );
}

/// Validation exception (422)
class ValidationException extends ApiException {
  final Map<String, dynamic>? errors;

  ValidationException({
    String? message,
    this.errors,
  }) : super(
          message: message ?? 'Validation failed',
          statusCode: 422,
          data: errors,
        );

  String? getFieldError(String field) {
    if (errors == null) return null;
    final fieldErrors = errors![field];
    if (fieldErrors is List && fieldErrors.isNotEmpty) {
      return fieldErrors.first.toString();
    }
    return fieldErrors?.toString();
  }
}

/// Server error exception (500+)
class ServerException extends ApiException {
  ServerException({String? message, int? statusCode})
      : super(
          message: message ?? 'Internal server error',
          statusCode: statusCode ?? 500,
        );
}

/// Bad request exception (400)
class BadRequestException extends ApiException {
  BadRequestException({String? message, super.data})
      : super(
          message: message ?? 'Bad request',
          statusCode: 400,
        );
}

/// Cancel exception
class CancelException extends ApiException {
  CancelException()
      : super(
          message: 'Request cancelled',
          statusCode: null,
        );
}

/// Unreviewed bookings exception
/// Thrown when trying to create a booking but there are unreviewed completed bookings
class UnreviewedBookingsException extends BadRequestException {
  final List<String> unreviewedBookingIds;

  UnreviewedBookingsException({
    String? message,
    required this.unreviewedBookingIds,
    super.data,
  }) : super(
          message: message ?? 'У вас есть завершенные записи без отзывов',
        );
}

/// Exception handler utility
class ApiExceptionHandler {
  static ApiException handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(message: error.message);

      case DioExceptionType.badResponse:
        return _handleResponseError(error);

      case DioExceptionType.cancel:
        return CancelException();

      case DioExceptionType.connectionError:
        return NetworkException(message: error.message);

      case DioExceptionType.unknown:
      default:
        return NetworkException(
          message: error.message ?? 'Unknown error occurred',
        );
    }
  }

  static ApiException _handleResponseError(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;
    final message = _extractErrorMessage(data);

    switch (statusCode) {
      case 400:
        // Check if this is an unreviewed bookings error
        if (data is Map<String, dynamic> &&
            data['error'] == 'UNREVIEWED_BOOKINGS_EXIST' &&
            data['unreviewed_booking_ids'] is List) {
          return UnreviewedBookingsException(
            message: message,
            unreviewedBookingIds: List<String>.from(data['unreviewed_booking_ids']),
            data: data,
          );
        }
        return BadRequestException(message: message, data: data);

      case 401:
        return UnauthorizedException(message: message);

      case 403:
        return ForbiddenException(message: message);

      case 404:
        return NotFoundException(message: message);

      case 422:
        return ValidationException(
          message: message,
          errors: data is Map<String, dynamic> ? data['errors'] : null,
        );

      case 500:
      case 502:
      case 503:
        return ServerException(
          message: message,
          statusCode: statusCode,
        );

      default:
        return ApiException(
          message: message ?? 'Unknown error',
          statusCode: statusCode,
          data: data,
        );
    }
  }

  static String? _extractErrorMessage(dynamic data) {
    if (data == null) return null;

    if (data is Map<String, dynamic>) {
      // Try different common error message keys
      if (data['message'] != null) return data['message'].toString();
      if (data['error'] != null) return data['error'].toString();
      if (data['detail'] != null) return data['detail'].toString();
    }

    if (data is String) return data;

    return null;
  }
}
