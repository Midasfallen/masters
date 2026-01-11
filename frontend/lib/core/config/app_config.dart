/// Application configuration
/// Contains all API endpoints and application settings
class AppConfig {
  // Prevent instantiation
  AppConfig._();

  /// API Configuration
  static const String apiVersion = 'v2';

  /// Base URL for API requests
  /// Change this to your backend URL
  static const String apiBaseUrl = 'http://localhost:3000';

  /// Full API URL with version
  static String get apiUrl => '$apiBaseUrl/api/$apiVersion';

  /// Connection timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  /// Token storage keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';

  /// WebSocket configuration
  static String get wsUrl => 'ws://localhost:3000';

  /// Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  /// File upload limits
  static const int maxImageSizeMB = 10;
  static const int maxFileSizeMB = 20;

  /// Supported image formats
  static const List<String> supportedImageFormats = [
    'jpg',
    'jpeg',
    'png',
    'webp',
  ];

  /// Environment check
  static bool get isProduction => apiBaseUrl.contains('production-domain.com');
  static bool get isDevelopment => !isProduction;
}
