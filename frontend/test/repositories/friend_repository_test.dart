import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:service_platform/core/repositories/friend_repository.dart';
import 'package:service_platform/core/api/dio_client.dart';
import 'package:service_platform/core/models/api/friend_model.dart';

import 'friend_repository_test.mocks.dart';

@GenerateMocks([DioClient])
void main() {
  late FriendRepository repository;
  late MockDioClient mockClient;

  setUp(() {
    mockClient = MockDioClient();
    repository = FriendRepository(mockClient);
  });

  group('FriendRepository', () {
    final mockFriendData = {
      'id': 'friend1',
      'friendshipId': 'fs1',
      'userId': 'user2',
      'firstName': 'Jane',
      'lastName': 'Smith',
      'isMaster': false,
      'mutualFriendsCount': 3,
      'createdAt': '2024-01-01T00:00:00Z',
    };

    final mockFriendshipData = {
      'id': 'fs1',
      'requesterId': 'user1',
      'addresseeId': 'user2',
      'status': 'pending',
      'createdAt': '2024-01-01T00:00:00Z',
      'updatedAt': '2024-01-01T00:00:00Z',
    };

    group('getFriends', () {
      test('should return list of friends', () async {
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {'data': [mockFriendData], 'total': 1},
          statusCode: 200,
        );

        when(mockClient.get(any, queryParameters: anyNamed('queryParameters')))
            .thenAnswer((_) async => mockResponse);

        final result = await repository.getFriends();

        expect(result, isA<List<FriendModel>>());
        expect(result.length, 1);
        expect(result.first.firstName, 'Jane');
      });
    });

    group('getIncomingRequests', () {
      test('should return incoming friend requests', () async {
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {'data': [mockFriendshipData], 'total': 1},
          statusCode: 200,
        );

        when(mockClient.get(any, queryParameters: anyNamed('queryParameters')))
            .thenAnswer((_) async => mockResponse);

        final result = await repository.getIncomingRequests();

        expect(result, isA<List<FriendshipModel>>());
        expect(result.length, 1);
        expect(result.first.status, 'pending');
      });
    });

    group('sendFriendRequest', () {
      test('should send friend request successfully', () async {
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: mockFriendshipData,
          statusCode: 201,
        );

        when(mockClient.post(any)).thenAnswer((_) async => mockResponse);

        final result = await repository.sendFriendRequest('user2');

        expect(result, isA<FriendshipModel>());
        expect(result.addresseeId, 'user2');
      });
    });

    group('acceptFriendRequest', () {
      test('should accept request successfully', () async {
        final acceptedData = {...mockFriendshipData, 'status': 'accepted'};
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: acceptedData,
          statusCode: 200,
        );

        when(mockClient.patch(any)).thenAnswer((_) async => mockResponse);

        final result = await repository.acceptFriendRequest('fs1');

        expect(result.status, 'accepted');
      });
    });

    group('declineFriendRequest', () {
      test('should decline request successfully', () async {
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {},
          statusCode: 200,
        );

        when(mockClient.patch(any)).thenAnswer((_) async => mockResponse);

        await repository.declineFriendRequest('fs1');

        verify(mockClient.patch(any)).called(1);
      });
    });

    group('removeFriend', () {
      test('should remove friend successfully', () async {
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {},
          statusCode: 204,
        );

        when(mockClient.delete(any)).thenAnswer((_) async => mockResponse);

        await repository.removeFriend('user2');

        verify(mockClient.delete(any)).called(1);
      });
    });

    group('getFriendshipById', () {
      test('should return friendship by ID', () async {
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: mockFriendshipData,
          statusCode: 200,
        );

        when(mockClient.get(any)).thenAnswer((_) async => mockResponse);

        final result = await repository.getFriendshipById('fs1');

        expect(result, isA<FriendshipModel>());
        expect(result.id, 'fs1');
      });
    });
  });
}
