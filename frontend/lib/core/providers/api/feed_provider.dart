import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_platform/core/models/api/post_model.dart';
import 'package:service_platform/core/providers/api/auth_provider.dart';
import 'package:service_platform/core/repositories/post_repository.dart';

part 'feed_provider.g.dart';

/// Feed Posts Provider
@riverpod
Future<List<PostModel>> feedPosts(
  FeedPostsRef ref, {
  int page = 1,
  int limit = 20,
  List<String>? categoryIds,
  double? lat,
  double? lng,
  double? radius,
}) async {
  final repository = ref.watch(postRepositoryProvider);
  return await repository.getFeed(
    page: page,
    limit: limit,
    categoryIds: categoryIds,
    lat: lat,
    lng: lng,
    radius: radius,
  );
}

/// Post by ID Provider
@riverpod
Future<PostModel> postById(PostByIdRef ref, String postId) async {
  final repository = ref.watch(postRepositoryProvider);
  return await repository.getPostById(postId);
}

/// User Posts Provider
@riverpod
Future<List<PostModel>> userPosts(
  UserPostsRef ref,
  String userId, {
  int page = 1,
  int limit = 20,
}) async {
  final repository = ref.watch(postRepositoryProvider);
  return await repository.getUserPosts(
    userId,
    page: page,
    limit: limit,
  );
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
  final comments = await repository.getComments(
    postId,
    page: page,
    limit: limit,
  );

  // Если у комментариев нет информации об авторе, но authorId совпадает с текущим пользователем,
  // добавляем информацию о текущем пользователе
  final currentUser = ref.read(currentUserProvider);
  if (currentUser != null) {
    return comments.map((comment) {
      if (comment.author == null && comment.authorId == currentUser.id) {
        return comment.copyWith(author: currentUser);
      }
      return comment;
    }).toList();
  }

  return comments;
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

  /// Upload post media file (legacy method for mobile compatibility)
  Future<String> uploadPostMedia(String filePath) async {
    final repository = ref.read(postRepositoryProvider);
    return await repository.uploadPostMedia(filePath);
  }

  /// Upload post media from XFile (Web-compatible)
  Future<String> uploadPostMediaFromXFile(XFile file) async {
    final repository = ref.read(postRepositoryProvider);
    return await repository.uploadPostMediaFromXFile(file);
  }

  /// Create comment
  Future<CommentModel> createComment(
    String postId,
    CreateCommentRequest request,
  ) async {
    final repository = ref.read(postRepositoryProvider);
    final comment = await repository.createComment(postId, request);

    // Если сервер не вернул информацию об авторе, но authorId совпадает с текущим пользователем,
    // добавляем информацию о текущем пользователе
    final currentUser = ref.read(currentUserProvider);
    CommentModel commentWithAuthor = comment;
    if (comment.author == null && currentUser != null && comment.authorId == currentUser.id) {
      commentWithAuthor = comment.copyWith(author: currentUser);
    }

    // Invalidate comments and post to trigger refresh
    // Optimistic UI update is handled in post_detail_screen.dart
    ref.invalidate(postCommentsProvider(postId));
    ref.invalidate(postByIdProvider(postId));

    return commentWithAuthor;
  }
}
