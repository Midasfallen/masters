import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:faker/faker.dart';

import '../models/post.dart';
import '../models/user.dart';
import '../models/message.dart';
import '../models/chat.dart';
import '../models/notification.dart';
import '../../shared/models/service.dart';
import '../../data/mock/mock_services.dart';

final faker = Faker();
final random = Random();

// Mock Posts Provider
final mockPostsProvider = Provider<List<Post>>((ref) {
  return List.generate(50, (index) {
    final imageCount = random.nextInt(3) + 1;
    return Post(
      id: faker.guid.guid(),
      masterId: faker.guid.guid(),
      masterName: faker.person.name(),
      masterAvatar: 'https://i.pravatar.cc/150?img=$index',
      description: faker.lorem.sentence(),
      mediaUrls: List.generate(
        imageCount,
        (i) => 'https://picsum.photos/400/${400 + random.nextInt(200)}?random=${index}_$i',
      ),
      likesCount: random.nextInt(500),
      commentsCount: random.nextInt(100),
      isLiked: random.nextBool(),
      createdAt: DateTime.now().subtract(Duration(hours: random.nextInt(48))),
      tags: ['Маникюр', 'Красота', 'Стрижка', 'Макияж', 'Массаж']
          .take(random.nextInt(3) + 1)
          .toList(),
      location: ['Москва', 'Санкт-Петербург', 'Казань', 'Новосибирск'][random.nextInt(4)],
    );
  });
});

// Mock Users Provider
final mockUsersProvider = Provider<List<User>>((ref) {
  return List.generate(20, (index) {
    final isMaster = index % 3 == 0;
    return User(
      id: faker.guid.guid(),
      name: faker.person.name(),
      email: faker.internet.email(),
      avatar: 'https://i.pravatar.cc/150?img=${index + 50}',
      role: isMaster ? 'master' : 'client',
      bio: isMaster ? 'Профессиональный мастер с опытом ${random.nextInt(10) + 1} лет' : null,
      phone: faker.phoneNumber.us(),
      city: ['Москва', 'СПб', 'Казань'][random.nextInt(3)],
      followersCount: isMaster ? random.nextInt(1000) : random.nextInt(100),
      followingCount: random.nextInt(500),
      isFollowing: random.nextBool(),
      isFriend: random.nextBool(),
      rating: isMaster ? 4.0 + random.nextDouble() : null,
    );
  });
});

// Mock Chats Provider
final mockChatsProvider = Provider<List<Chat>>((ref) {
  return List.generate(10, (index) {
    final lastMessageTime = DateTime.now().subtract(Duration(minutes: index * 15));
    return Chat(
      id: 'chat_$index',
      participantId: faker.guid.guid(),
      participantName: faker.person.name(),
      participantAvatar: 'https://i.pravatar.cc/150?img=${index + 100}',
      lastMessage: Message(
        id: faker.guid.guid(),
        chatId: 'chat_$index',
        senderId: random.nextBool() ? 'me' : 'other',
        senderName: faker.person.name(),
        senderAvatar: 'https://i.pravatar.cc/150?img=${index + 100}',
        type: 'text',
        content: faker.lorem.sentence(),
        createdAt: lastMessageTime,
        status: ['sent', 'delivered', 'read'][random.nextInt(3)],
      ),
      unreadCount: random.nextInt(5),
      updatedAt: lastMessageTime,
      isOnline: random.nextBool(),
    );
  });
});

// Mock Messages Provider (for specific chat)
final mockMessagesProvider = Provider.family<List<Message>, String>((ref, chatId) {
  return List.generate(20, (index) {
    final isMine = index % 2 == 0;
    return Message(
      id: faker.guid.guid(),
      chatId: chatId,
      senderId: isMine ? 'me' : 'other',
      senderName: isMine ? 'Вы' : faker.person.name(),
      senderAvatar: isMine
          ? 'https://i.pravatar.cc/150?img=1'
          : 'https://i.pravatar.cc/150?img=${index + 100}',
      type: 'text',
      content: faker.lorem.sentence(),
      createdAt: DateTime.now().subtract(Duration(minutes: (20 - index) * 5)),
      status: isMine ? ['sent', 'delivered', 'read'][random.nextInt(3)] : 'read',
    );
  });
});

// Mock Notifications Provider
final mockNotificationsProvider = Provider<List<AppNotification>>((ref) {
  final types = [
    'like',
    'comment',
    'friend_request',
    'friend_accepted',
    'message',
    'booking_new',
    'booking_confirmed',
    'booking_completed',
    'review',
    'subscription',
    'mention'
  ];

  return List.generate(15, (index) {
    final type = types[random.nextInt(types.length)];
    final title = _getNotificationTitle(type);
    final body = _getNotificationBody(type);

    return AppNotification(
      id: faker.guid.guid(),
      type: type,
      title: title,
      body: body,
      createdAt: DateTime.now().subtract(Duration(hours: index)),
      isRead: random.nextBool(),
      userId: faker.guid.guid(),
      userAvatar: 'https://i.pravatar.cc/150?img=${index + 200}',
      actionUrl: '/post/${faker.guid.guid()}',
    );
  });
});

String _getNotificationTitle(String type) {
  switch (type) {
    case 'like':
      return 'Новый лайк';
    case 'comment':
      return 'Новый комментарий';
    case 'friend_request':
      return 'Запрос в друзья';
    case 'friend_accepted':
      return 'Запрос принят';
    case 'message':
      return 'Новое сообщение';
    case 'booking_new':
      return 'Новая запись';
    case 'booking_confirmed':
      return 'Запись подтверждена';
    case 'booking_completed':
      return 'Услуга выполнена';
    case 'review':
      return 'Новый отзыв';
    case 'subscription':
      return 'Новый подписчик';
    case 'mention':
      return 'Вас упомянули';
    default:
      return 'Уведомление';
  }
}

String _getNotificationBody(String type) {
  final name = faker.person.name();
  switch (type) {
    case 'like':
      return '$name оценил ваш пост';
    case 'comment':
      return '$name прокомментировал ваш пост';
    case 'friend_request':
      return '$name хочет добавить вас в друзья';
    case 'friend_accepted':
      return '$name принял ваш запрос в друзья';
    case 'message':
      return '$name отправил вам сообщение';
    case 'booking_new':
      return '$name записался к вам на услугу';
    case 'booking_confirmed':
      return 'Ваша запись подтверждена';
    case 'booking_completed':
      return 'Услуга выполнена. Оставьте отзыв!';
    case 'review':
      return '$name оставил отзыв';
    case 'subscription':
      return '$name подписался на вас';
    case 'mention':
      return '$name упомянул вас в посте';
    default:
      return faker.lorem.sentence();
  }
}

// Current User Provider (mock)
final currentUserProvider = Provider<User>((ref) {
  return User(
    id: 'current_user_id',
    name: 'Анна Иванова',
    email: 'anna@example.com',
    avatar: 'https://i.pravatar.cc/150?img=1',
    role: 'client',
    bio: 'Люблю красоту и стиль',
    phone: '+7 999 123 45 67',
    city: 'Москва',
    followersCount: 250,
    followingCount: 180,
    isFollowing: false,
    isFriend: false,
  );
});

// Unread Messages Count Provider
final unreadMessagesCountProvider = Provider<int>((ref) {
  final chats = ref.watch(mockChatsProvider);
  return chats.fold<int>(0, (sum, chat) => sum + chat.unreadCount);
});

// Unread Notifications Count Provider
final unreadNotificationsCountProvider = Provider<int>((ref) {
  final notifications = ref.watch(mockNotificationsProvider);
  return notifications.where((n) => !n.isRead).length;
});

// Mock Services Provider
final mockServicesProvider = Provider<List<Service>>((ref) {
  return mockServices;
});
