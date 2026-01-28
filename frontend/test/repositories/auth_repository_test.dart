import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:service_platform/core/repositories/auth_repository.dart';
import 'package:service_platform/core/api/dio_client.dart';
import 'package:service_platform/core/api/api_exceptions.dart';
import 'package:service_platform/core/models/api/user_model.dart';

import 'auth_repository_test.mocks.dart';

@GenerateMocks([DioClient, FlutterSecureStorage])
void main() {
  late AuthRepository repository;
  late MockDioClient mockClient;
  late MockFlutterSecureStorage mockStorage;

  setUp(() {
    mockClient = MockDioClient();
    mockStorage = MockFlutterSecureStorage();
    repository = AuthRepository(mockClient, mockStorage);
  });

  group('AuthRepository', () {
    final mockAuthResponse = {
      'accessToken': 'test-access-token',
      'refreshToken': 'test-refresh-token',
      'tokenType': 'Bearer',
      'expiresIn': 3600,
      'user': {
        'id': 'user1',
        'email': 'test@example.com',
        'firstName': 'Test',
        'lastName': 'User',
        'isMaster': false,
        'isVerified': true,
        'isPremium': false,
      },
    };

    final mockUserResponse = {
      'id': 'user1',
      'email': 'test@example.com',
      'firstName': 'Test',
      'lastName': 'User',
      'isMaster': false,
      'isVerified': true,
      'isPremium': false,
    };

    group('login', () {
      test('should return AuthResponseModel on success', () async {
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: mockAuthResponse,
          statusCode: 200,
        );

        when(mockClient.post(any, data: anyNamed('data')))
            .thenAnswer((_) async => mockResponse);
        when(mockStorage.write(key: anyNamed('key'), value: anyNamed('value')))
            .thenAnswer((_) async => {});

        final request =
            LoginRequest(email: 'test@example.com', password: '123456');
        final result = await repository.login(request);

        expect(result.accessToken, 'test-access-token');
        expect(result.user.email, 'test@example.com');
        verify(mockStorage.write(
          key: anyNamed('key'),
          value: anyNamed('value'),
        )).called(3);
      });

      test('should throw on DioException', () async {
        when(mockClient.post(any, data: anyNamed('data')))
            .thenThrow(DioException(
              requestOptions: RequestOptions(path: ''),
              type: DioExceptionType.badResponse,
              response: Response(
                requestOptions: RequestOptions(path: ''),
                statusCode: 401,
                data: {'message': 'Invalid credentials'},
              ),
            ));

        final request =
            LoginRequest(email: 'test@example.com', password: 'wrong');

        expect(() => repository.login(request), throwsA(isA<Exception>()));
      });
    });

    group('register', () {
      test('should return AuthResponseModel on success', () async {
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: mockAuthResponse,
          statusCode: 201,
        );

        when(mockClient.post(any, data: anyNamed('data')))
            .thenAnswer((_) async => mockResponse);
        when(mockStorage.write(key: anyNamed('key'), value: anyNamed('value')))
            .thenAnswer((_) async => {});

        final request = RegisterRequest(
          email: 'test@example.com',
          password: '123456',
          firstName: 'Test',
          lastName: 'User',
        );
        final result = await repository.register(request);

        expect(result.accessToken, 'test-access-token');
        expect(result.user.firstName, 'Test');
      });
    });

    group('getMe', () {
      test('should return UserModel on success', () async {
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: mockUserResponse,
          statusCode: 200,
        );

        when(mockClient.get(any)).thenAnswer((_) async => mockResponse);

        final result = await repository.getMe();

        expect(result, isA<UserModel>());
        expect(result.email, 'test@example.com');
      });
    });

    group('logout', () {
      test('should clear tokens on success', () async {
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {},
          statusCode: 200,
        );

        when(mockClient.post(any)).thenAnswer((_) async => mockResponse);
        when(mockStorage.delete(key: anyNamed('key')))
            .thenAnswer((_) async => {});

        await repository.logout();

        verify(mockStorage.delete(key: anyNamed('key'))).called(3);
      });

      test('should clear tokens even if API call fails', () async {
        when(mockClient.post(any)).thenThrow(Exception('Network error'));
        when(mockStorage.delete(key: anyNamed('key')))
            .thenAnswer((_) async => {});

        await repository.logout();

        verify(mockStorage.delete(key: anyNamed('key'))).called(3);
      });
    });

    group('isLoggedIn', () {
      test('should return true when token exists', () async {
        when(mockStorage.read(key: anyNamed('key')))
            .thenAnswer((_) async => 'some-token');

        final result = await repository.isLoggedIn();

        expect(result, true);
      });

      test('should return false when no token', () async {
        when(mockStorage.read(key: anyNamed('key')))
            .thenAnswer((_) async => null);

        final result = await repository.isLoggedIn();

        expect(result, false);
      });
    });

    group('refresh', () {
      test('should return new tokens on success', () async {
        when(mockStorage.read(key: anyNamed('key')))
            .thenAnswer((_) async => 'old-refresh-token');

        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: mockAuthResponse,
          statusCode: 200,
        );

        when(mockClient.post(any, data: anyNamed('data')))
            .thenAnswer((_) async => mockResponse);
        when(mockStorage.write(key: anyNamed('key'), value: anyNamed('value')))
            .thenAnswer((_) async => {});

        final result = await repository.refresh();

        expect(result.accessToken, 'test-access-token');
      });

      test('should throw UnauthorizedException when no refresh token', () async {
        when(mockStorage.read(key: anyNamed('key')))
            .thenAnswer((_) async => null);

        expect(() => repository.refresh(), throwsA(isA<UnauthorizedException>()));
      });
    });
  });
}
