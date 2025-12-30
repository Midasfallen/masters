import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_platform/core/models/api/post_model.dart';
import 'package:service_platform/core/repositories/post_repository.dart';

part 'feed_provider.g.dart';

/// Feed Posts Provider
@riverpod
Future<List<PostModel>> feedPosts(
  FeedPostsRef ref, {
  int page = 1,
  int limit = 20,
}) async {
  final repository = ref.watch(postRepositoryProvider);
  return await repository.getFeed(page: page, limit: limit);
}

/// Post by ID Provider
@riverpod
Future<PostModel> postById(PostByIdRef ref, String postId) async {
  final repository = ref.watch(postRepositoryProvider);
  return await repository.getPostById(postId);
}

/// Post Comments Provider
@riverpod
Future<List<CommentModel>> postComments(
  PostCommentsRef ref,
  String postId, {
  int page = 1,
  int limit = 20,
}) async {
  final repository = ref.watch(postRepositoryProvider);
  return await repository.getComments(
    postId,
    page: page,
    limit: limit,
  );
}

/// Post Notifier for mutations
@riverpod
class PostNotifier extends _$PostNotifier {
  @override
  FutureOr<PostModel?> build() async {
    return null;
  }

  /// Create post
  Future<PostModel> createPost(CreatePostRequest request) async {
    state = const AsyncValue.loading();

    return await AsyncValue.guard(() async {
      final repository = ref.read(postRepositoryProvider);
      final post = await repository.createPost(request);

      // Invalidate feed
      ref.invalidate(feedPostsProvider);

      return post;
    }).then((asyncValue) {
      state = asyncValue;
      return asyncValue.requireValue;
    });
  }

  /// Update post
  Future<PostModel> updatePost(String postId, UpdatePostRequest request) async {
    state = const AsyncValue.loading();

    return await AsyncValue.guard(() async {
      final repository = ref.read(postRepositoryProvider);
      final post = await repository.updatePost(postId, request);

      // Invalidate post
      ref.invalidate(postByIdProvider(postId));
      ref.invalidate(feedPostsProvider);

      return post;
    }).then((asyncValue) {
      state = asyncValue;
      return asyncValue.requireValue;
    });
  }

  /// Delete post
  Future<void> deletePost(String postId) async {
    state = const AsyncValue.loading();

    await AsyncValue.guard(() async {
      final repository = ref.read(postRepositoryProvider);
      await repository.deletePost(postId);

      // Invalidate feed
      ref.invalidate(feedPostsProvider);
    });
  }

  /// Like post
  Future<void> likePost(String postId) async {
    final repository = ref.read(postRepositoryProvider);
    await repository.likePost(postId);

    // Invalidate post
    ref.invalidate(postByIdProvider(postId));
    ref.invalidate(feedPostsProvider);
  }

  /// Unlike post
  Future<void> unlikePost(String postId) async {
    final repository = ref.read(postRepositoryProvider);
    await repository.unlikePost(postId);

    // Invalidate post
    ref.invalidate(postByIdProvider(postId));
    ref.invalidate(feedPostsProvider);
  }

  /// Create comment
  Future<CommentModel> createComment(
    String postId,
    CreateCommentRequest request,
  ) async {
    final repository = ref.read(postRepositoryProvider);
    final comment = await repository.createComment(postId, request);

    // Invalidate comments
    ref.invalidate(postCommentsProvider(postId));
    ref.invalidate(postByIdProvider(postId));

    return comment;
  }
}
