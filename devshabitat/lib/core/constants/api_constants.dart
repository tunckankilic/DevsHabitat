class ApiConstants {
  // Base URLs
  static const String baseUrl = 'https://api.devsHabitat.com';
  static const String wsUrl = 'wss://ws.devsHabitat.com';

  // Auth Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';

  // User Endpoints
  static const String profile = '/users/profile';
  static const String updateProfile = '/users/profile';
  static const String uploadAvatar = '/users/avatar';

  // Discovery Endpoints
  static const String discover = '/discover';
  static const String search = '/search';

  // Chat Endpoints
  static const String conversations = '/conversations';
  static const String messages = '/messages';

  // Video Endpoints
  static const String rooms = '/rooms';
  static const String joinRoom = '/rooms/join';
  static const String leaveRoom = '/rooms/leave';

  // Community Endpoints
  static const String posts = '/posts';
  static const String comments = '/comments';
  static const String likes = '/likes';

  // Headers
  static const String authorizationHeader = 'Authorization';
  static const String bearerPrefix = 'Bearer ';

  // Query Parameters
  static const String page = 'page';
  static const String limit = 'limit';
  static const String searchQuery = 'searchQuery';
  static const String sort = 'sort';
  static const String filter = 'filter';
}
