import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_platform/core/api/api_endpoints.dart';
import 'package:service_platform/core/api/api_exceptions.dart';
import 'package:service_platform/core/api/dio_client.dart';
import 'package:service_platform/core/models/api/friend_model.dart';

part 'friend_repository.g.dart';

class FriendRepository {
  final DioClient _client;

  FriendRepository(this._client);

  /// Get list of friends
  Future<List<FriendModel>> getFriends({
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final response = await _client.get(
        ApiEndpoints.friendsList,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => FriendModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Get incoming friend requests
  Future<List<FriendshipModel>> getIncomingRequests({
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final response = await _client.get(
        ApiEndpoints.friendsIncoming,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => FriendshipModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Get outgoing friend requests
  Future<List<FriendshipModel>> getOutgoingRequests({
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final response = await _client.get(
        ApiEndpoints.friendsOutgoing,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => FriendshipModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Send friend request
  Future<FriendshipModel> sendFriendRequest(String userId) async {
    try {
      final response = await _client.post(
        ApiEndpoints.friendshipRequest(userId),
      );
      return FriendshipModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Accept friend request
  Future<FriendshipModel> acceptFriendRequest(String friendshipId) async {
    try {
      final response = await _client.patch(
        ApiEndpoints.friendshipAccept(friendshipId),
      );
      return FriendshipModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Decline friend request
  Future<void> declineFriendRequest(String friendshipId) async {
    try {
      await _client.patch(
        ApiEndpoints.friendshipDecline(friendshipId),
      );
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Remove friend
  Future<void> removeFriend(String userId) async {
    try {
      await _client.delete(
        ApiEndpoints.friendshipRemove(userId),
      );
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Get friendship by ID
  Future<FriendshipModel> getFriendshipById(String friendshipId) async {
    try {
      final response = await _client.get(
        ApiEndpoints.friendshipById(friendshipId),
      );
      return FriendshipModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }
}

@riverpod
FriendRepository friendRepository(FriendRepositoryRef ref) {
  final client = ref.watch(dioClientProvider);
  return FriendRepository(client);
}
