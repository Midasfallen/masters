import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/feed/screens/feed_screen.dart';
import '../../features/search/screens/search_screen.dart';
import '../../features/chats/screens/chats_list_screen.dart';
import '../../features/bookings/screens/bookings_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../core/providers/api/chats_provider.dart';
import '../../core/providers/api/notifications_provider.dart';
import '../../core/providers/main_nav_provider.dart';

class MainNavigationScreen extends ConsumerWidget {
  const MainNavigationScreen({super.key});

  // v2.0 Bottom Navigation: Feed, Search, Chats, Bookings, Profile
  static const List<Widget> _screens = [
    FeedScreen(),
    SearchScreen(),
    ChatsListScreen(),
    BookingsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(mainNavIndexProvider);
    final unreadMessages = ref.watch(unreadChatsCountProvider);
    // Реальный счётчик непрочитанных уведомлений (async); до загрузки — 0
    final unreadNotifications =
        ref.watch(notificationsUnreadCountProvider).valueOrNull ?? 0;

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          ref.read(mainNavIndexProvider.notifier).state = index;
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view),
            label: 'Feed',
          ),
          const NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: 'Поиск',
          ),
          NavigationDestination(
            icon: Badge(
              label: Text('$unreadMessages'),
              isLabelVisible: unreadMessages > 0,
              child: const Icon(Icons.chat_bubble_outline),
            ),
            selectedIcon: Badge(
              label: Text('$unreadMessages'),
              isLabelVisible: unreadMessages > 0,
              child: const Icon(Icons.chat_bubble),
            ),
            label: 'Чаты',
          ),
          NavigationDestination(
            icon: Badge(
              label: Text('$unreadNotifications'),
              isLabelVisible: unreadNotifications > 0,
              child: const Icon(Icons.calendar_today_outlined),
            ),
            selectedIcon: Badge(
              label: Text('$unreadNotifications'),
              isLabelVisible: unreadNotifications > 0,
              child: const Icon(Icons.calendar_today),
            ),
            label: 'Записи',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }
}
