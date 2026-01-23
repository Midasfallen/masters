import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_platform/core/models/api/friend_model.dart';
import 'package:service_platform/core/providers/api/friends_provider.dart';
import 'package:service_platform/core/theme/app_colors.dart';
import 'package:service_platform/core/constants/app_sizes.dart';

class FriendsScreen extends ConsumerStatefulWidget {
  const FriendsScreen({super.key});

  @override
  ConsumerState<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends ConsumerState<FriendsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Друзья'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Друзья'),
            Tab(text: 'Входящие'),
            Tab(text: 'Исходящие'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _FriendsTab(),
          _IncomingRequestsTab(),
          _OutgoingRequestsTab(),
        ],
      ),
    );
  }
}

/// Friends List Tab
class _FriendsTab extends ConsumerWidget {
  const _FriendsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendsAsync = ref.watch(friendsListProvider());

    return friendsAsync.when(
      data: (friends) {
        if (friends.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline, size: 64, color: Colors.grey),
                SizedBox(height: AppSizes.paddingMd),
                Text(
                  'У вас пока нет друзей',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(friendsListProvider);
          },
          child: ListView.separated(
            padding: const EdgeInsets.all(AppSizes.paddingMd),
            itemCount: friends.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppSizes.paddingSm),
            itemBuilder: (context, index) {
              final friend = friends[index];
              return _FriendCard(friend: friend);
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: AppSizes.paddingMd),
            Text('Ошибка: $error'),
            const SizedBox(height: AppSizes.paddingMd),
            ElevatedButton(
              onPressed: () => ref.invalidate(friendsListProvider),
              child: const Text('Повторить'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Incoming Friend Requests Tab
class _IncomingRequestsTab extends ConsumerWidget {
  const _IncomingRequestsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsync = ref.watch(incomingFriendRequestsProvider());

    return requestsAsync.when(
      data: (requests) {
        if (requests.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
                SizedBox(height: AppSizes.paddingMd),
                Text(
                  'Нет входящих заявок',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(incomingFriendRequestsProvider);
          },
          child: ListView.separated(
            padding: const EdgeInsets.all(AppSizes.paddingMd),
            itemCount: requests.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppSizes.paddingSm),
            itemBuilder: (context, index) {
              final request = requests[index];
              return _IncomingRequestCard(friendship: request);
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: AppSizes.paddingMd),
            Text('Ошибка: $error'),
            const SizedBox(height: AppSizes.paddingMd),
            ElevatedButton(
              onPressed: () => ref.invalidate(incomingFriendRequestsProvider),
              child: const Text('Повторить'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Outgoing Friend Requests Tab
class _OutgoingRequestsTab extends ConsumerWidget {
  const _OutgoingRequestsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsync = ref.watch(outgoingFriendRequestsProvider());

    return requestsAsync.when(
      data: (requests) {
        if (requests.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.outbox_outlined, size: 64, color: Colors.grey),
                SizedBox(height: AppSizes.paddingMd),
                Text(
                  'Нет исходящих заявок',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(outgoingFriendRequestsProvider);
          },
          child: ListView.separated(
            padding: const EdgeInsets.all(AppSizes.paddingMd),
            itemCount: requests.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppSizes.paddingSm),
            itemBuilder: (context, index) {
              final request = requests[index];
              return _OutgoingRequestCard(friendship: request);
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: AppSizes.paddingMd),
            Text('Ошибка: $error'),
            const SizedBox(height: AppSizes.paddingMd),
            ElevatedButton(
              onPressed: () => ref.invalidate(outgoingFriendRequestsProvider),
              child: const Text('Повторить'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Friend Card Widget
class _FriendCard extends ConsumerWidget {
  const _FriendCard({required this.friend});

  final FriendModel friend;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: AppSizes.elevation2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppSizes.paddingMd),
        leading: CircleAvatar(
          radius: 28,
          backgroundImage: friend.avatarUrl != null
              ? NetworkImage(friend.avatarUrl!)
              : null,
          child: friend.avatarUrl == null
              ? Text(
                  friend.firstName[0] + friend.lastName[0],
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                )
              : null,
        ),
        title: Text(
          '${friend.firstName} ${friend.lastName}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (friend.bio != null) ...[
              const SizedBox(height: 4),
              Text(
                friend.bio!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12),
              ),
            ],
            if (friend.mutualFriendsCount > 0) ...[
              const SizedBox(height: 4),
              Text(
                'Общих друзей: ${friend.mutualFriendsCount}',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.primary,
                ),
              ),
            ],
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) async {
            if (value == 'remove') {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Удалить из друзей?'),
                  content: Text(
                    'Вы уверены, что хотите удалить ${friend.firstName} из друзей?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Отмена'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Удалить'),
                    ),
                  ],
                ),
              );

              if (confirmed == true) {
                await ref
                    .read(friendNotifierProvider.notifier)
                    .removeFriend(friend.userId);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Друг удален')),
                  );
                }
              }
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'remove',
              child: Row(
                children: [
                  Icon(Icons.person_remove, size: 20),
                  SizedBox(width: 8),
                  Text('Удалить из друзей'),
                ],
              ),
            ),
          ],
        ),
        onTap: () {
          // Navigate to user profile - implementation depends on routing setup
        },
      ),
    );
  }
}

/// Incoming Friend Request Card
class _IncomingRequestCard extends ConsumerWidget {
  const _IncomingRequestCard({required this.friendship});

  final FriendshipModel friendship;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requester = friendship.requester;
    if (requester == null) return const SizedBox.shrink();

    return Card(
      elevation: AppSizes.elevation2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppSizes.paddingMd),
        leading: CircleAvatar(
          radius: 28,
          backgroundImage: requester.avatarUrl != null
              ? NetworkImage(requester.avatarUrl!)
              : null,
          child: requester.avatarUrl == null
              ? Text(
                  requester.firstName[0] + requester.lastName[0],
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                )
              : null,
        ),
        title: Text(
          '${requester.firstName} ${requester.lastName}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSizes.paddingSm),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await ref
                          .read(friendNotifierProvider.notifier)
                          .acceptFriendRequest(friendship.id);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Заявка принята')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSizes.paddingSm,
                      ),
                    ),
                    child: const Text('Принять'),
                  ),
                ),
                const SizedBox(width: AppSizes.paddingSm),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      await ref
                          .read(friendNotifierProvider.notifier)
                          .declineFriendRequest(friendship.id);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Заявка отклонена')),
                        );
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSizes.paddingSm,
                      ),
                    ),
                    child: const Text('Отклонить'),
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () {
          // Navigate to user profile - implementation depends on routing setup
        },
      ),
    );
  }
}

/// Outgoing Friend Request Card
class _OutgoingRequestCard extends ConsumerWidget {
  const _OutgoingRequestCard({required this.friendship});

  final FriendshipModel friendship;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressee = friendship.addressee;
    if (addressee == null) return const SizedBox.shrink();

    return Card(
      elevation: AppSizes.elevation2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppSizes.paddingMd),
        leading: CircleAvatar(
          radius: 28,
          backgroundImage: addressee.avatarUrl != null
              ? NetworkImage(addressee.avatarUrl!)
              : null,
          child: addressee.avatarUrl == null
              ? Text(
                  addressee.firstName[0] + addressee.lastName[0],
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                )
              : null,
        ),
        title: Text(
          '${addressee.firstName} ${addressee.lastName}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            const Text(
              'Заявка отправлена',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.close, color: Colors.grey),
          onPressed: () async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Отменить заявку?'),
                content: const Text(
                  'Вы уверены, что хотите отменить заявку в друзья?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Нет'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Да'),
                  ),
                ],
              ),
            );

            if (confirmed == true) {
              await ref
                  .read(friendNotifierProvider.notifier)
                  .declineFriendRequest(friendship.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Заявка отменена')),
                );
              }
            }
          },
        ),
        onTap: () {
          // Navigate to user profile - implementation depends on routing setup
        },
      ),
    );
  }
}
