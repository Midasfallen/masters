import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:service_platform/core/repositories/post_repository.dart';
import 'package:service_platform/core/api/dio_client.dart';
import 'package:service_platform/core/models/api/post_model.dart';

import 'post_repository_test.mocks.dart';

@GenerateMocks([DioClient])
void main() {
  late PostRepository repository;
  late MockDioClient mockClient;

  setUp(() {
    mockClient = MockDioClient();
    repository = PostRepository(mockClient);
  });

  group('PostRepository', () {
    group('getFeed', () {
      test('should return list of posts on success', () async {
        // Arrange
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {
            'data': [
              {
                'id': '1',
                'authorId': 'user1',
                'content': 'Test post',
                'media': [],
                'likesCount': 10,
                'commentsCount': 5,
                'isLiked': false,
                'createdAt': '2024-01-01T00:00:00Z',
                'updatedAt': '2024-01-01T00:00:00Z',
              },
            ],
          },
          statusCode: 200,
        );

        when(mockClient.get(
          any,
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await repository.getFeed(page: 1, limit: 20);

        // Assert
        expect(result, isA<List<PostModel>>());
        expect(result.length, 1);
        expect(result.first.id, '1');
        expect(result.first.content, 'Test post');
        verify(mockClient.get(
          any,
          queryParameters: anyNamed('queryParameters'),
        )).called(1);
      });

      test('should pass correct parameters', () async {
        // Arrange
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {'data': []},
          statusCode: 200,
        );

        when(mockClient.get(
          any,
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => mockResponse);

        // Act
        await repository.getFeed(
          page: 2,
          limit: 10,
          lat: 55.75,
          lng: 37.61,
          radius: 5.0,
        );

        // Assert
        verify(mockClient.get(
          any,
          queryParameters: {
            'page': 2,
            'limit': 10,
            'lat': 55.75,
            'lng': 37.61,
            'radius': 5.0,
          },
        )).called(1);
      });
    });

    group('getPostById', () {
      test('should return single post on success', () async {
        // Arrange
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {
            'id': '123',
            'authorId': 'user1',
            'content': 'Detailed post',
            'media': [],
            'likesCount': 50,
            'commentsCount': 10,
            'isLiked': true,
            'createdAt': '2024-01-01T00:00:00Z',
            'updatedAt': '2024-01-01T00:00:00Z',
          },
          statusCode: 200,
        );

        when(mockClient.get(any)).thenAnswer((_) async => mockResponse);

        // Act
        final result = await repository.getPostById('123');

        // Assert
        expect(result, isA<PostModel>());
        expect(result.id, '123');
        expect(result.content, 'Detailed post');
        expect(result.isLiked, true);
      });
    });

    group('createPost', () {
      test('should create post successfully', () async {
        // Arrange
        final request = CreatePostRequest(
          type: PostType.photo,
          content: 'New post content',
          media: [
            CreatePostMediaDto(
              type: MediaType.photo,
              url: 'https://example.com/image.jpg',
            ),
          ],
        );

        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {
            'id': 'new123',
            'authorId': 'user1',
            'content': 'New post content',
            'media': [],
            'likesCount': 0,
            'commentsCount': 0,
            'isLiked': false,
            'createdAt': '2024-01-01T00:00:00Z',
            'updatedAt': '2024-01-01T00:00:00Z',
          },
          statusCode: 201,
        );

        when(mockClient.post(
          any,
          data: anyNamed('data'),
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await repository.createPost(request);

        // Assert
        expect(result, isA<PostModel>());
        expect(result.id, 'new123');
        expect(result.content, 'New post content');
        verify(mockClient.post(
          any,
          data: anyNamed('data'),
        )).called(1);
      });
    });

    group('likePost', () {
      test('should like post successfully', () async {
        // Arrange
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {'message': 'Post liked'},
          statusCode: 200,
        );

        when(mockClient.post(any)).thenAnswer((_) async => mockResponse);

        // Act
        await repository.likePost('123');

        // Assert
        verify(mockClient.post(any)).called(1);
      });
    });

    group('deletePost', () {
      test('should delete post successfully', () async {
        // Arrange
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 204,
        );

        when(mockClient.delete(any)).thenAnswer((_) async => mockResponse);

        // Act
        await repository.deletePost('123');

        // Assert
        verify(mockClient.delete(any)).called(1);
      });
    });
  });
}
