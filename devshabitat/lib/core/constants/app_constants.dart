class AppConstants {
  static const String appName = 'DevHabitat';
  static const String appVersion = '1.0.0';

  // API Timeouts
  static const int connectionTimeout = 5000; // 5 seconds
  static const int receiveTimeout = 3000; // 3 seconds

  // Cache
  static const String tokenKey = 'token';
  static const String userKey = 'user';

  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 32;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 20;

  // Pagination
  static const int defaultPageSize = 20;

  // File Upload
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedImageTypes = [
    'image/jpeg',
    'image/png',
    'image/gif'
  ];
  static const List<String> allowedVideoTypes = [
    'video/mp4',
    'video/quicktime'
  ];
}
