import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/feed/screens/feed_screen.dart';
import '../../features/search/screens/search_screen.dart';
import '../../features/chats/screens/chats_list_screen.dart';
import '../../features/bookings/screens/bookings_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../core/providers/api/chats_provider.dart';
import '../../core/providers/mock_data_provider.dart';

class MainNavigationScreen extends ConsumerStatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  ConsumerState<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  int _currentIndex = 0;

  // v2.0 Bottom Navigation: Feed, Search, Chats, Bookings, Profile
  final List<Widget> _screens = const [
    FeedScreen(),
    SearchScreen(),
    ChatsListScreen(),
    BookingsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final unreadMessages = ref.watch(unreadChatsCountProvider);
    final unreadNotifications = ref.watch(unreadNotificationsCountProvider);

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
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
