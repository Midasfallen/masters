import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_platform/core/api/api_endpoints.dart';
import 'package:service_platform/core/api/api_exceptions.dart';
import 'package:service_platform/core/api/api_helpers.dart';
import 'package:service_platform/core/api/dio_client.dart';
import 'package:service_platform/core/models/api/post_model.dart';

part 'post_repository.g.dart';

class PostRepository {
  final DioClient _client;

  PostRepository(this._client);

  /// Get feed posts
  Future<List<PostModel>> getFeed({
    int page = 1,
    int limit = 20,
    List<String>? categoryIds,
    double? lat,
    double? lng,
    double? radius,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {
        'page': page,
        'limit': limit,
      };

      if (categoryIds != null && categoryIds.isNotEmpty) {
        queryParams['category_ids'] = categoryIds;
      }

      if (lat != null && lng != null) {
        queryParams['lat'] = lat;
        queryParams['lng'] = lng;
        if (radius != null) {
          queryParams['radius'] = radius;
        }
      }

      final response = await _client.get(
        ApiEndpoints.postsFeed,
        queryParameters: queryParams,
      );

      final data = ApiHelpers.parseListResponse(response.data);
      return data.map((json) => PostModel.fromJson(json as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Get post by ID
  Future<PostModel> getPostById(String id) async {
    try {
      final response = await _client.get(
        ApiEndpoints.postById(int.parse(id)),
      );
      return PostModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Create new post
  Future<PostModel> createPost(CreatePostRequest request) async {
    try {
      final response = await _client.post(
        ApiEndpoints.postCreate,
        data: request.toJson(),
      );
      return PostModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Update post
  Future<PostModel> updatePost(String id, UpdatePostRequest request) async {
    try {
      final response = await _client.patch(
        ApiEndpoints.postUpdate(int.parse(id)),
        data: request.toJson(),
      );
      return PostModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Delete post
  Future<void> deletePost(String id) async {
    try {
      await _client.delete(ApiEndpoints.postDelete(int.parse(id)));
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Like post
  Future<void> likePost(String id) async {
    try {
      await _client.post(ApiEndpoints.postLike(int.parse(id)));
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Unlike post
  Future<void> unlikePost(String id) async {
    try {
      await _client.post(ApiEndpoints.postUnlike(int.parse(id)));
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Get post comments
  Future<List<CommentModel>> getComments(String postId, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _client.get(
        ApiEndpoints.postComments(int.parse(postId)),
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      final data = ApiHelpers.parseListResponse(response.data);
      return data.map((json) => CommentModel.fromJson(json as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }

  /// Create comment
  Future<CommentModel> createComment(
    String postId,
    CreateCommentRequest request,
  ) async {
    try {
      final response = await _client.post(
        ApiEndpoints.postComments(int.parse(postId)),
        data: request.toJson(),
      );
      return CommentModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }
}

@riverpod
PostRepository postRepository(PostRepositoryRef ref) {
  final client = ref.watch(dioClientProvider);
  return PostRepository(client);
}
