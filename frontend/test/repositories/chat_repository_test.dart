import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:service_platform/core/repositories/chat_repository.dart';
import 'package:service_platform/core/api/dio_client.dart';
import 'package:service_platform/core/models/api/chat_model.dart';

import 'chat_repository_test.mocks.dart';

@GenerateMocks([DioClient])
void main() {
  late ChatRepository repository;
  late MockDioClient mockClient;

  setUp(() {
    mockClient = MockDioClient();
    repository = ChatRepository(mockClient);
  });

  group('ChatRepository', () {
    final mockChatData = {
      'id': 'chat1',
      'user1Id': 'user1',
      'user2Id': 'user2',
      'unreadCount': 3,
      'createdAt': '2024-01-01T00:00:00Z',
      'updatedAt': '2024-01-01T00:00:00Z',
    };

    final mockMessageData = {
      'id': 'msg1',
      'chatId': 'chat1',
      'senderId': 'user1',
      'receiverId': 'user2',
      'content': 'Привет!',
      'type': 'text',
      'isRead': false,
      'createdAt': '2024-01-01T00:00:00Z',
      'updatedAt': '2024-01-01T00:00:00Z',
    };

    group('getChats', () {
      test('should return list of chats', () async {
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {'data': [mockChatData], 'total': 1},
          statusCode: 200,
        );

        when(mockClient.get(any, queryParameters: anyNamed('queryParameters')))
            .thenAnswer((_) async => mockResponse);

        final result = await repository.getChats();

        expect(result, isA<List<ChatModel>>());
        expect(result.length, 1);
        expect(result.first.id, 'chat1');
      });
    });

    group('getChatById', () {
      test('should return chat by ID', () async {
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: mockChatData,
          statusCode: 200,
        );

        when(mockClient.get(any)).thenAnswer((_) async => mockResponse);

        final result = await repository.getChatById('1');

        expect(result, isA<ChatModel>());
        expect(result.unreadCount, 3);
      });
    });

    group('createChat', () {
      test('should create chat successfully', () async {
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: mockChatData,
          statusCode: 201,
        );

        when(mockClient.post(any, data: anyNamed('data')))
            .thenAnswer((_) async => mockResponse);

        final request = CreateChatRequest(userId: 'user2');
        final result = await repository.createChat(request);

        expect(result, isA<ChatModel>());
        expect(result.user2Id, 'user2');
      });
    });

    group('getMessages', () {
      test('should return list of messages', () async {
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {'data': [mockMessageData], 'total': 1},
          statusCode: 200,
        );

        when(mockClient.get(any, queryParameters: anyNamed('queryParameters')))
            .thenAnswer((_) async => mockResponse);

        final result = await repository.getMessages('1');

        expect(result, isA<List<MessageModel>>());
        expect(result.length, 1);
        expect(result.first.content, 'Привет!');
      });
    });

    group('sendMessage', () {
      test('should send message successfully', () async {
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: mockMessageData,
          statusCode: 201,
        );

        when(mockClient.post(any, data: anyNamed('data')))
            .thenAnswer((_) async => mockResponse);

        final request = SendMessageRequest(content: 'Привет!', type: MessageType.text);
        final result = await repository.sendMessage('1', request);

        expect(result, isA<MessageModel>());
        expect(result.content, 'Привет!');
      });
    });

    group('markAsRead', () {
      test('should mark chat as read', () async {
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {},
          statusCode: 200,
        );

        when(mockClient.post(any)).thenAnswer((_) async => mockResponse);

        await repository.markAsRead('1');

        verify(mockClient.post(any)).called(1);
      });
    });
  });
}
