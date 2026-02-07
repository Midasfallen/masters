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
      'type': 'direct',
      'name': null,
      'avatarUrl': null,
      'creatorId': 'user1',
      'lastMessageId': null,
      'lastMessageAt': null,
      'createdAt': '2024-01-01T00:00:00Z',
      'updatedAt': '2024-01-01T00:00:00Z',
      'myParticipant': {
        'id': 'participant1',
        'chatId': 'chat1',
        'userId': 'user1',
        'role': 'member',
        'lastReadMessageId': null,
        'lastReadAt': null,
        'unreadCount': 3,
        'notificationsEnabled': true,
        'isArchived': false,
        'isPinned': false,
        'isRemoved': false,
        'joinedAt': '2024-01-01T00:00:00Z',
        'updatedAt': '2024-01-01T00:00:00Z',
      },
      'otherUser': {
        'id': 'user2',
        'firstName': 'Иван',
        'lastName': 'Петров',
        'fullName': 'Иван Петров',
        'avatarUrl': null,
        'isMaster': false,
        'isVerified': false,
      },
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
        expect(result.myParticipant?.unreadCount, 3);
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

        final request = CreateChatRequest(
          type: ChatType.direct,
          participantIds: ['user2'],
        );
        final result = await repository.createChat(request);

        expect(result, isA<ChatModel>());
        expect(result.otherUser?.id, 'user2');
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

        final request = SendMessageRequest(chatId: '1', content: 'Привет!', type: MessageType.text);
        final result = await repository.sendMessage(request);

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

        when(mockClient.post(any, data: anyNamed('data'))).thenAnswer((_) async => mockResponse);

        await repository.markAsRead('1', messageId: 'msg-1');

        verify(mockClient.post(any)).called(1);
      });
    });
  });
}
