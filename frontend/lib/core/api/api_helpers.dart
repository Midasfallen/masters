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
}
