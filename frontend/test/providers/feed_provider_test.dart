import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_platform/core/models/api/post_model.dart';
import 'package:service_platform/core/providers/api/feed_provider.dart';
import 'package:service_platform/core/repositories/post_repository.dart';

import 'feed_provider_test.mocks.dart';

@GenerateMocks([PostRepository])
void main() {
  late MockPostRepository mockRepo;
  late ProviderContainer container;

  final mockPost = PostModel(
    id: 'post1',
    authorId: 'author1',
    content: 'Тестовый пост',
    likesCount: 5,
    commentsCount: 2,
    sharesCount: 0,
    repostsCount: 0,
    isLiked: false,
    isPinned: false,
    isArchived: false,
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  final mockComment = CommentModel(
    id: 'comment1',
    postId: 'post1',
    authorId: 'author1',
    content: 'Тестовый комментарий',
    likesCount: 0,
    isLiked: false,
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  setUp(() {
    mockRepo = MockPostRepository();
    container = ProviderContainer(
      overrides: [
        postRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('feedPosts provider', () {
    test('returns list of posts', () async {
      when(mockRepo.getFeed(
        page: anyNamed('page'),
        limit: anyNamed('limit'),
        categoryIds: anyNamed('categoryIds'),
        lat: anyNamed('lat'),
        lng: anyNamed('lng'),
        radius: anyNamed('radius'),
      )).thenAnswer((_) async => [mockPost]);

      final posts = await container.read(feedPostsProvider().future);

      expect(posts.length, 1);
      expect(posts.first.content, 'Тестовый пост');
    });

    test('returns empty list when no posts', () async {
      when(mockRepo.getFeed(
        page: anyNamed('page'),
        limit: anyNamed('limit'),
        categoryIds: anyNamed('categoryIds'),
        lat: anyNamed('lat'),
        lng: anyNamed('lng'),
        radius: anyNamed('radius'),
      )).thenAnswer((_) async => []);

      final posts = await container.read(feedPostsProvider().future);

      expect(posts, isEmpty);
    });

    test('throws on error', () async {
      when(mockRepo.getFeed(
        page: anyNamed('page'),
        limit: anyNamed('limit'),
        categoryIds: anyNamed('categoryIds'),
        lat: anyNamed('lat'),
        lng: anyNamed('lng'),
        radius: anyNamed('radius'),
      )).thenThrow(Exception('Network error'));

      expect(
        () => container.read(feedPostsProvider().future),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('postById provider', () {
    test('returns post by ID', () async {
      when(mockRepo.getPostById('post1'))
          .thenAnswer((_) async => mockPost);

      final post = await container.read(postByIdProvider('post1').future);

      expect(post.id, 'post1');
      expect(post.content, 'Тестовый пост');
    });
  });

  group('postComments provider', () {
    test('returns list of comments', () async {
      when(mockRepo.getComments(
        'post1',
        page: anyNamed('page'),
        limit: anyNamed('limit'),
      )).thenAnswer((_) async => [mockComment]);

      final comments = await container.read(
        postCommentsProvider('post1').future,
      );

      expect(comments.length, 1);
      expect(comments.first.content, 'Тестовый комментарий');
    });
  });

  group('PostNotifier', () {
    test('createPost — creates post and invalidates feed', () async {
      when(mockRepo.createPost(any)).thenAnswer((_) async => mockPost);

      final notifier = container.read(postNotifierProvider.notifier);
      final result = await notifier.createPost(
        const CreatePostRequest(
          type: PostType.text,
          content: 'Новый пост',
        ),
      );

      expect(result.id, 'post1');
      verify(mockRepo.createPost(any)).called(1);
    });

    test('likePost — calls repository like', () async {
      when(mockRepo.likePost('post1')).thenAnswer((_) async => {});

      final notifier = container.read(postNotifierProvider.notifier);
      await notifier.likePost('post1');

      verify(mockRepo.likePost('post1')).called(1);
    });

    test('unlikePost — calls repository unlike', () async {
      when(mockRepo.unlikePost('post1')).thenAnswer((_) async => {});

      final notifier = container.read(postNotifierProvider.notifier);
      await notifier.unlikePost('post1');

      verify(mockRepo.unlikePost('post1')).called(1);
    });

    test('deletePost — calls repository delete', () async {
      when(mockRepo.deletePost('post1')).thenAnswer((_) async => {});

      final notifier = container.read(postNotifierProvider.notifier);
      await notifier.deletePost('post1');

      verify(mockRepo.deletePost('post1')).called(1);
    });

    test('createComment — creates comment', () async {
      when(mockRepo.createComment('post1', any))
          .thenAnswer((_) async => mockComment);

      final notifier = container.read(postNotifierProvider.notifier);
      final result = await notifier.createComment(
        'post1',
        const CreateCommentRequest(content: 'Комментарий'),
      );

      expect(result.id, 'comment1');
    });
  });
}
