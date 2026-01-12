/// API Endpoints
/// All backend API endpoints are defined here
class ApiEndpoints {
  // Prevent instantiation
  ApiEndpoints._();

  // ==================== AUTH ====================
  static const String authLogin = '/auth/login';
  static const String authRegister = '/auth/register';
  static const String authRefresh = '/auth/refresh';
  static const String authLogout = '/auth/logout';
  static const String authMe = '/auth/me';

  // ==================== USERS ====================
  static const String users = '/users';
  static String userById(int id) => '/users/$id';
  static const String userMe = '/users/me';
  static const String userAvatar = '/users/me/avatar';
  static const String userUpdate = '/users/me';

  // ==================== MASTERS ====================
  static const String masters = '/masters';
  static String masterById(int id) => '/masters/$id';
  static const String masterCreate = '/masters';
  static const String masterUpdate = '/masters/me';
  static const String masterMe = '/masters/me';
  static String masterServices(int masterId) => '/masters/$masterId/services';
  static String masterReviews(int masterId) => '/masters/$masterId/reviews';

  // ==================== SERVICES ====================
  static const String services = '/services';
  static String serviceById(int id) => '/services/$id';
  static const String serviceCreate = '/services';
  static String serviceUpdate(int id) => '/services/$id';
  static String serviceDelete(int id) => '/services/$id';

  // ==================== CATEGORIES ====================
  static const String categories = '/categories';
  static String categoryById(int id) => '/categories/$id';
  static String categoryServices(int categoryId) => '/categories/$categoryId/services';

  // ==================== BOOKINGS ====================
  static const String bookings = '/bookings';
  static String bookingById(int id) => '/bookings/$id';
  static const String bookingCreate = '/bookings';
  static String bookingConfirm(int id) => '/bookings/$id/confirm';
  static String bookingCancel(int id) => '/bookings/$id/cancel';
  static String bookingComplete(int id) => '/bookings/$id/complete';
  static const String bookingsMy = '/bookings/my';

  // ==================== REVIEWS ====================
  static const String reviews = '/reviews';
  static String reviewById(int id) => '/reviews/$id';
  static const String reviewCreate = '/reviews';
  static String reviewUpdate(int id) => '/reviews/$id';
  static String reviewDelete(int id) => '/reviews/$id';

  // ==================== SEARCH ====================
  static const String search = '/search';
  static const String searchMasters = '/search/masters';
  static const String searchServices = '/search/services';

  // ==================== POSTS (v2.0) ====================
  static const String posts = '/posts';
  static String postById(int id) => '/posts/$id';
  static const String postCreate = '/posts';
  static String postUpdate(int id) => '/posts/$id';
  static String postDelete(int id) => '/posts/$id';
  static String postLike(int id) => '/posts/$id/like';
  static String postUnlike(int id) => '/posts/$id/unlike';
  static String postComments(int id) => '/posts/$id/comments';
  static const String postsFeed = '/posts/feed';

  // ==================== CHATS ====================
  static const String chats = '/chats';
  static String chatById(int id) => '/chats/$id';
  static const String chatCreate = '/chats';
  static String chatMessages(int chatId) => '/chats/$chatId/messages';
  static String chatSendMessage(int chatId) => '/chats/$chatId/messages';
  static String chatMarkRead(int chatId) => '/chats/$chatId/read';

  // ==================== NOTIFICATIONS ====================
  static const String notifications = '/notifications';
  static String notificationById(int id) => '/notifications/$id';
  static String notificationMarkRead(int id) => '/notifications/$id/read';
  static const String notificationMarkAllRead = '/notifications/read-all';
  static const String notificationsUnreadCount = '/notifications/unread-count';

  // ==================== FAVORITES ====================
  static const String favorites = '/favorites';
  static const String favoriteAdd = '/favorites';
  static String favoriteRemove(int masterId) => '/favorites/$masterId';

  // ==================== FRIENDS (v2.0) ====================
  static const String friendships = '/friendships';
  static String friendshipById(String id) => '/friendships/$id';
  static String friendshipRequest(String userId) => '/friendships/$userId';
  static String friendshipAccept(String id) => '/friendships/$id/accept';
  static String friendshipDecline(String id) => '/friendships/$id/decline';
  static String friendshipRemove(String userId) => '/friendships/$userId';
  static const String friendsList = '/friendships/friends';
  static const String friendsIncoming = '/friendships/incoming';
  static const String friendsOutgoing = '/friendships/outgoing';

  // ==================== SUBSCRIPTIONS (v2.0) ====================
  static const String subscriptions = '/subscriptions';
  static String subscriptionCreate(String userId) => '/subscriptions/$userId';
  static String subscriptionRemove(String userId) => '/subscriptions/$userId';
  static const String subscriptionsList = '/subscriptions/my';
  static const String subscribersList = '/subscriptions/followers';

  // ==================== AUTO PROPOSALS (v2.0) ====================
  static const String autoProposalsList = '/auto-proposals';
  static const String autoProposalsActive = '/auto-proposals/active';
  static String autoProposalById(String id) => '/auto-proposals/$id';
  static const String autoProposalSettings = '/auto-proposals/settings';
  static const String autoProposalGenerate = '/auto-proposals/generate';
  static String autoProposalAccept(String id) => '/auto-proposals/$id/accept';
  static String autoProposalReject(String id) => '/auto-proposals/$id/reject';

  // ==================== UPLOAD ====================
  static const String upload = '/upload';
  static const String uploadImage = '/upload/image';
  static const String uploadAvatar = '/upload/avatar';
}
