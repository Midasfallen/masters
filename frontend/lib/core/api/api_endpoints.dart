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

  // ==================== USERS ====================
  static const String users = '/users';
  static String userById(String id) => '/users/$id';
  static const String userMe = '/users/me';
  static const String userAvatar = '/users/me/avatar';
  static const String userUpdate = '/users/me';

  // ==================== MASTERS ====================
  static const String masters = '/masters';
  static String masterById(String id) => '/masters/$id';
  static const String masterCreate = '/masters';
  static const String masterUpdate = '/masters/me';
  static const String masterMe = '/masters/me';
  static String masterServices(String masterId) => '/masters/$masterId/services';
  static String masterReviews(String masterId) => '/masters/$masterId/reviews';

  // ==================== SERVICES ====================
  static const String services = '/services';
  static String serviceById(String id) => '/services/$id';
  static const String serviceCreate = '/services';
  static String serviceUpdate(String id) => '/services/$id';
  static String serviceDelete(String id) => '/services/$id';

  // ==================== CATEGORIES ====================
  static const String categories = '/categories';
  static const String categoriesTree = '/categories/tree';
  static String categoryById(String id) => '/categories/$id';
  static String categoryServices(String categoryId) => '/categories/$categoryId/services';

  // ==================== BOOKINGS ====================
  static const String bookings = '/bookings';
  static String bookingById(String id) => '/bookings/$id';
  static const String bookingCreate = '/bookings';
  static String bookingConfirm(String id) => '/bookings/$id/confirm';
  static String bookingCancel(String id) => '/bookings/$id/cancel';
  static String bookingComplete(String id) => '/bookings/$id/complete';
  static const String bookingsMy = '/bookings/my';

  // ==================== REVIEWS ====================
  static const String reviews = '/reviews';
  static String reviewById(String id) => '/reviews/$id';
  static const String reviewCreate = '/reviews';
  static String reviewUpdate(String id) => '/reviews/$id';
  static String reviewDelete(String id) => '/reviews/$id';

  // ==================== SEARCH ====================
  static const String search = '/search';
  static const String searchMasters = '/search/masters';
  static const String searchServices = '/search/services';

  // ==================== POSTS (v2.0) ====================
  static const String posts = '/posts';
  static String postById(String id) => '/posts/$id';
  static const String postCreate = '/posts';
  static String postUpdate(String id) => '/posts/$id';
  static String postDelete(String id) => '/posts/$id';
  static String postLike(String id) => '/posts/$id/like';
  static String postUnlike(String id) => '/posts/$id/unlike';
  static String postComments(String id) => '/posts/$id/comments';
  static const String postsFeed = '/posts/feed';
  static String postsByUser(String userId) => '/posts/user/$userId';

  // ==================== CHATS ====================
  static const String chats = '/chats';
  static String chatById(String id) => '/chats/$id';
  static const String chatCreate = '/chats';
  static String chatMessages(String chatId) => '/chats/$chatId/messages';
  static String chatSendMessage(String chatId) => '/chats/$chatId/messages';
  static String chatMarkRead(String chatId) => '/chats/$chatId/read';

  // ==================== NOTIFICATIONS ====================
  static const String notifications = '/notifications';
  static String notificationById(String id) => '/notifications/$id';
  static String notificationMarkRead(String id) => '/notifications/$id/read';
  static const String notificationMarkAllRead = '/notifications/read-all';
  static const String notificationsUnreadCount = '/notifications/unread-count';

  // ==================== FAVORITES ====================
  static const String favorites = '/favorites';
  static const String favoriteAdd = '/favorites';
  static String favoriteRemove(String masterId) => '/favorites/$masterId';

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
  static const String uploadPost = '/upload/post';
  static const String uploadPortfolio = '/upload/portfolio';
}
