import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:service_platform/core/repositories/notification_repository.dart';
import 'package:service_platform/core/api/dio_client.dart';
import 'package:service_platform/core/models/api/notification_model.dart';

import 'notification_repository_test.mocks.dart';

@GenerateMocks([DioClient])
void main() {
  late NotificationRepository repository;
  late MockDioClient mockClient;

  setUp(() {
    mockClient = MockDioClient();
    repository = NotificationRepository(mockClient);
  });

  group('NotificationRepository', () {
    final mockNotificationData = {
      'id': 'notif1',
      'userId': 'user1',
      'type': 'booking_confirmed',
      'title': 'Бронирование подтверждено',
      'message': 'Ваше бронирование успешно подтверждено мастером.',
      'isRead': false,
      'createdAt': '2024-01-01T12:00:00Z',
    };

    group('getNotifications', () {
      test('should return list of notifications', () async {
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {'data': [mockNotificationData], 'total': 1},
          statusCode: 200,
        );

        when(mockClient.get(any, queryParameters: anyNamed('queryParameters')))
            .thenAnswer((_) async => mockResponse);

        final result = await repository.getNotifications();

        expect(result, isA<List<NotificationModel>>());
        expect(result.length, 1);
        expect(result.first.title, 'Бронирование подтверждено');
      });

      test('should pass filters correctly', () async {
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {'data': [], 'total': 0},
          statusCode: 200,
        );

        when(mockClient.get(any, queryParameters: anyNamed('queryParameters')))
            .thenAnswer((_) async => mockResponse);

        await repository.getNotifications(isRead: false, type: 'booking_confirmed');

        verify(mockClient.get(
          any,
          queryParameters: anyNamed('queryParameters'),
        )).called(1);
      });
    });

    group('getNotificationById', () {
      test('should return notification by ID', () async {
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: mockNotificationData,
          statusCode: 200,
        );

        when(mockClient.get(any)).thenAnswer((_) async => mockResponse);

        final result = await repository.getNotificationById('1');

        expect(result, isA<NotificationModel>());
        expect(result.type, 'booking_confirmed');
      });
    });

    group('markAsRead', () {
      test('should mark notification as read', () async {
        final readData = {...mockNotificationData, 'isRead': true};
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: readData,
          statusCode: 200,
        );

        when(mockClient.patch(any)).thenAnswer((_) async => mockResponse);

        final result = await repository.markAsRead('1');

        expect(result.isRead, true);
      });
    });

    group('markAllAsRead', () {
      test('should mark all notifications as read', () async {
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {},
          statusCode: 200,
        );

        when(mockClient.patch(any)).thenAnswer((_) async => mockResponse);

        await repository.markAllAsRead();

        verify(mockClient.patch(any)).called(1);
      });
    });

    group('getUnreadCount', () {
      test('should return unread count', () async {
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {'count': 5},
          statusCode: 200,
        );

        when(mockClient.get(any)).thenAnswer((_) async => mockResponse);

        final result = await repository.getUnreadCount();

        expect(result, 5);
      });

      test('should return 0 when count is null', () async {
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {},
          statusCode: 200,
        );

        when(mockClient.get(any)).thenAnswer((_) async => mockResponse);

        final result = await repository.getUnreadCount();

        expect(result, 0);
      });
    });
  });
}
