import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/mock_data_provider.dart';
import '../widgets/post_card.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(mockPostsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Feed',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              context.push('/notifications');
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_box_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Создание поста (в разработке)')),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Refresh logic (для прототипа просто задержка)
          await Future.delayed(const Duration(seconds: 1));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Обновлено!')),
          );
        },
        child: MasonryGridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          padding: const EdgeInsets.all(4),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            return PostCard(post: posts[index]);
          },
        ),
      ),
    );
  }
}
