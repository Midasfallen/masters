/// API response parsing helpers
class ApiHelpers {
  ApiHelpers._();

  /// Parse API response that may be wrapped in { "data": [...], "meta": {...} }
  /// or returned as a direct array [...]
  static List<dynamic> parseListResponse(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      // Response has wrapper with 'data' key
      return responseData['data'] as List<dynamic>? ?? [];
    } else if (responseData is List) {
      // Direct array response
      return responseData;
    } else {
      // Unexpected format, return empty list
      return [];
    }
  }

  /// Parse API response for a single object
  static Map<String, dynamic> parseObjectResponse(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      // Check if wrapped in 'data' key
      if (responseData.containsKey('data') && responseData['data'] is Map) {
        return responseData['data'] as Map<String, dynamic>;
      }
      // Direct object response
      return responseData;
    } else {
      // Unexpected format, return empty map
      return {};
    }
  }

  /// Parse a numeric value from various types (int, double, String) to double
  static double parseNumber(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }

  /// Parse a boolean value from various types (bool, String, int)
  static bool parseBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    return false;
  }

  /// Format API error response into a readable string
  static String formatError(dynamic error) {
    if (error == null) return 'Неизвестная ошибка';

    if (error is Map<String, dynamic>) {
      if (error.containsKey('message')) {
        final message = error['message'];
        if (message is List) {
          return message.join(', ');
        }
        return message.toString();
      }
      if (error.containsKey('error')) {
        return error['error'].toString();
      }
    }

    return 'Неизвестная ошибка';
  }
}
