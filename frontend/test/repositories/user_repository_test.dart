import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:service_platform/core/repositories/user_repository.dart';
import 'package:service_platform/core/api/dio_client.dart';
import 'package:service_platform/core/models/api/user_model.dart';

import 'user_repository_test.mocks.dart';

@GenerateMocks([DioClient])
void main() {
  late UserRepository repository;
  late MockDioClient mockClient;

  setUp(() {
    mockClient = MockDioClient();
    repository = UserRepository(mockClient);
  });

  group('UserRepository', () {
    final mockUserData = {
      'id': 'user1',
      'email': 'test@example.com',
      'firstName': 'John',
      'lastName': 'Doe',
      'isMaster': false,
      'isVerified': true,
      'isPremium': false,
      'rating': 4.5,
      'reviewsCount': 10,
      'postsCount': 5,
      'friendsCount': 20,
      'followersCount': 15,
      'followingCount': 8,
    };

    group('getMe', () {
      test('should return current user profile', () async {
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: mockUserData,
          statusCode: 200,
        );

        when(mockClient.get(any)).thenAnswer((_) async => mockResponse);

        final result = await repository.getMe();

        expect(result, isA<UserModel>());
        expect(result.email, 'test@example.com');
        expect(result.firstName, 'John');
      });

      test('should throw on error', () async {
        when(mockClient.get(any)).thenThrow(DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 401,
            data: {'message': 'Unauthorized'},
          ),
        ));

        expect(() => repository.getMe(), throwsA(isA<Exception>()));
      });
    });

    group('getUserById', () {
      test('should return user by ID', () async {
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: mockUserData,
          statusCode: 200,
        );

        when(mockClient.get(any)).thenAnswer((_) async => mockResponse);

        final result = await repository.getUserById('1');

        expect(result, isA<UserModel>());
        expect(result.id, 'user1');
      });
    });

    group('updateUser', () {
      test('should update user profile', () async {
        final updatedData = {
          ...mockUserData,
          'firstName': 'Jane',
        };

        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: updatedData,
          statusCode: 200,
        );

        when(mockClient.patch(any, data: anyNamed('data')))
            .thenAnswer((_) async => mockResponse);

        final request = UpdateUserRequest(firstName: 'Jane');
        final result = await repository.updateUser(request);

        expect(result.firstName, 'Jane');
      });
    });

    group('uploadAvatar', () {
      test('should upload avatar successfully', () async {
        final updatedData = {
          ...mockUserData,
          'avatarUrl': 'https://example.com/avatar.jpg',
        };

        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: updatedData,
          statusCode: 200,
        );

        when(mockClient.uploadFile(any, any))
            .thenAnswer((_) async => mockResponse);

        final result = await repository.uploadAvatar('/path/to/image.jpg');

        expect(result.avatarUrl, 'https://example.com/avatar.jpg');
        verify(mockClient.uploadFile(any, any)).called(1);
      });
    });

    group('getUsers', () {
      test('should return list of users', () async {
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {
            'data': [mockUserData],
            'total': 1,
          },
          statusCode: 200,
        );

        when(mockClient.get(any, queryParameters: anyNamed('queryParameters')))
            .thenAnswer((_) async => mockResponse);

        final result = await repository.getUsers(page: 1, limit: 20);

        expect(result, isA<List<UserModel>>());
        expect(result.length, 1);
      });

      test('should pass search parameter', () async {
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {'data': [], 'total': 0},
          statusCode: 200,
        );

        when(mockClient.get(any, queryParameters: anyNamed('queryParameters')))
            .thenAnswer((_) async => mockResponse);

        await repository.getUsers(search: 'john');

        verify(mockClient.get(
          any,
          queryParameters: anyNamed('queryParameters'),
        )).called(1);
      });
    });
  });
}
