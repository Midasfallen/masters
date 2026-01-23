import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../core/models/api/notification_model.dart';
import '../../../core/providers/api/notifications_provider.dart';
import '../../../core/services/websocket_service.dart';

enum NotificationFilter {
  all,
  bookings,
  social,
  system,
}

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  final List<NotificationModel> _notifications = [];
  StreamSubscription? _wsSubscription;
  late TabController _tabController;
  NotificationFilter _currentFilter = NotificationFilter.all;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_onTabChanged);
    _setupWebSocketListener();
  }

  @override
  void dispose() {
    _wsSubscription?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      setState(() {
        _currentFilter = NotificationFilter.values[_tabController.index];
      });
    }
  }

  String? _getTypeFilter() {
    switch (_currentFilter) {
      case NotificationFilter.all:
        return null;
      case NotificationFilter.bookings:
        return 'booking'; // This will match booking_created, booking_confirmed, etc.
      case NotificationFilter.social:
        return 'social'; // This will match review_received, review_response, new_message
      case NotificationFilter.system:
        return 'system';
    }
  }

  /// Настройка слушателя WebSocket для новых уведомлений
  void _setupWebSocketListener() {
    final wsService = ref.read(webSocketServiceProvider);

    _wsSubscription = wsService.messages.listen((wsMessage) {
      if (wsMessage.event == 'notification:new') {
        final data = wsMessage.data as Map<String, dynamic>;
        final newNotification = NotificationModel.fromJson(data);

        if (mounted) {
          setState(() {
            _notifications.insert(0, newNotification);
          });

          // Показываем SnackBar о новом уведомлении
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(newNotification.title),
              duration: const Duration(seconds: 2),
              action: SnackBarAction(
                label: 'Открыть',
                onPressed: () {
                  if (newNotification.actionUrl != null) {
                    context.push(newNotification.actionUrl!);
                  }
                },
              ),
            ),
          );

          // Обновляем unread count
          ref.invalidate(notificationsUnreadCountProvider);
        }
      }
    });
  }

  /// Отметить все как прочитанные
  Future<void> _markAllAsRead() async {
    try {
      await ref.read(notificationNotifierProvider.notifier).markAllAsRead();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Все уведомления прочитаны')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final typeFilter = _getTypeFilter();
    final notificationsAsync = ref.watch(
      notificationsListProvider(type: typeFilter),
    );
    final unreadCountAsync = ref.watch(notificationsUnreadCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text(
              'Уведомления',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            // Unread count badge
            unreadCountAsync.when(
              data: (count) => count > 0
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        count.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: _markAllAsRead,
            child: const Text('Прочитать все'),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).primaryColor,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey[600],
          tabs: const [
            Tab(text: 'Все'),
            Tab(text: 'Записи'),
            Tab(text: 'Социальные'),
            Tab(text: 'Система'),
          ],
        ),
      ),
      body: notificationsAsync.when(
        data: (notifications) {
          // Merge with local notifications from WebSocket
          final allNotifications = [..._notifications];
          for (final notification in notifications) {
            if (!allNotifications.any((n) => n.id == notification.id)) {
              allNotifications.add(notification);
            }
          }

          // Filter по типу на клиенте (дополнительная фильтрация)
          final filteredNotifications = _filterNotificationsByTab(allNotifications);

          if (filteredNotifications.isEmpty) {
            return _buildEmptyState();
          }

          // Группировка по датам
          final groupedNotifications = _groupNotificationsByDate(filteredNotifications);

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(notificationsListProvider(type: typeFilter));
            },
            child: ListView.builder(
              itemCount: groupedNotifications.length,
              itemBuilder: (context, index) {
                final group = groupedNotifications[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date header
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      color: Colors.grey[100],
                      child: Text(
                        group['date'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    // Notifications for this date
                    ...(group['notifications'] as List<NotificationModel>)
                        .map(
                          (notification) => _NotificationTile(
                            notification: notification,
                            onTap: () => _handleNotificationTap(notification),
                          ),
                        ),
                  ],
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Ошибка: ${error.toString()}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(notificationsListProvider(type: typeFilter));
                },
                child: const Text('Повторить'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Фильтрация уведомлений по выбранному табу (клиентская фильтрация)
  List<NotificationModel> _filterNotificationsByTab(
      List<NotificationModel> notifications) {
    switch (_currentFilter) {
      case NotificationFilter.all:
        return notifications;
      case NotificationFilter.bookings:
        return notifications.where((n) =>
            n.type.startsWith('booking_') || n.type == 'booking_reminder').toList();
      case NotificationFilter.social:
        return notifications.where((n) =>
            n.type.startsWith('review_') ||
            n.type == 'new_message' ||
            n.type == 'review_reminder').toList();
      case NotificationFilter.system:
        return notifications.where((n) => n.type == 'system').toList();
    }
  }

  /// Группировка уведомлений по датам
  List<Map<String, dynamic>> _groupNotificationsByDate(
      List<NotificationModel> notifications) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final groups = <String, List<NotificationModel>>{};

    for (final notification in notifications) {
      final notificationDate = DateTime(
        notification.createdAt.year,
        notification.createdAt.month,
        notification.createdAt.day,
      );

      String dateKey;
      if (notificationDate == today) {
        dateKey = 'Сегодня';
      } else if (notificationDate == yesterday) {
        dateKey = 'Вчера';
      } else {
        final difference = today.difference(notificationDate).inDays;
        if (difference <= 7) {
          dateKey = '$difference дн назад';
        } else {
          dateKey = DateFormat('d MMMM', 'ru').format(notificationDate);
        }
      }

      groups.putIfAbsent(dateKey, () => []);
      groups[dateKey]!.add(notification);
    }

    // Convert to list and maintain order
    return groups.entries.map((entry) {
      return {
        'date': entry.key,
        'notifications': entry.value,
      };
    }).toList();
  }

  Widget _buildEmptyState() {
    String emptyMessage = 'Нет уведомлений';
    switch (_currentFilter) {
      case NotificationFilter.bookings:
        emptyMessage = 'Нет уведомлений о записях';
        break;
      case NotificationFilter.social:
        emptyMessage = 'Нет социальных уведомлений';
        break;
      case NotificationFilter.system:
        emptyMessage = 'Нет системных уведомлений';
        break;
      case NotificationFilter.all:
        emptyMessage = 'Нет уведомлений';
        break;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            emptyMessage,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  /// Обработка нажатия на уведомление
  Future<void> _handleNotificationTap(NotificationModel notification) async {
    // Отмечаем как прочитанное
    if (!notification.isRead) {
      try {
        await ref
            .read(notificationNotifierProvider.notifier)
            .markAsRead(notification.id);

        // Также отправляем через WebSocket
        final wsService = ref.read(webSocketServiceProvider);
        wsService.markNotificationAsRead(notification.id);

        // Обновляем локальный список
        setState(() {
          final index =
              _notifications.indexWhere((n) => n.id == notification.id);
          if (index != -1) {
            _notifications[index] = notification.copyWith(isRead: true);
          }
        });
      } catch (e) {
        // Ignore error, notification will be marked as read on backend anyway
      }
    }

    // Переходим по action URL
    if (notification.actionUrl != null && mounted) {
      context.push(notification.actionUrl!);
    }
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const _NotificationTile({
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {
        // TODO: Implement delete notification
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${notification.title} удалено')),
        );
      },
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: notification.isRead ? Colors.white : Colors.blue[50],
            border: Border(
              bottom: BorderSide(
                color: Colors.grey[200]!,
                width: 1,
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              CircleAvatar(
                radius: 24,
                backgroundColor: _getNotificationColor(notification.type),
                child: Icon(
                  _getNotificationIcon(notification.type),
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),

              // Notification content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      notification.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: notification.isRead
                            ? FontWeight.normal
                            : FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),

                    // Message
                    Text(
                      notification.message,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Time
                    Text(
                      timeago.format(notification.createdAt, locale: 'ru'),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),

              // Unread indicator
              if (!notification.isRead)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(top: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'booking_created':
      case 'booking_confirmed':
      case 'booking_started':
      case 'booking_completed':
        return Icons.calendar_today;
      case 'booking_rejected':
      case 'booking_cancelled':
        return Icons.cancel;
      case 'booking_reminder':
        return Icons.alarm;
      case 'review_received':
      case 'review_response':
      case 'review_reminder':
        return Icons.star;
      case 'new_message':
        return Icons.message;
      case 'system':
        return Icons.info;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'booking_created':
        return Colors.orange;
      case 'booking_confirmed':
        return Colors.teal;
      case 'booking_rejected':
      case 'booking_cancelled':
        return Colors.red;
      case 'booking_started':
        return Colors.blue;
      case 'booking_completed':
        return Colors.green;
      case 'booking_reminder':
        return Colors.amber;
      case 'review_received':
      case 'review_response':
      case 'review_reminder':
        return Colors.amber;
      case 'new_message':
        return Colors.indigo;
      case 'system':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}
