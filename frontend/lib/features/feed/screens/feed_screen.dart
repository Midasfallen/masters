import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/api/feed_provider.dart';
import '../../../core/models/api/post_model.dart';
import '../widgets/post_card.dart';

/// Feed Screen State Providers для infinite scroll
final feedPageProvider = StateProvider<int>((ref) => 1);
final feedPostsListProvider = StateProvider<List<PostModel>>((ref) => []);
final feedHasMoreProvider = StateProvider<bool>((ref) => true);

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFeed();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingMore && ref.read(feedHasMoreProvider)) {
        _loadMore();
      }
    }
  }

  Future<void> _loadFeed({bool refresh = false}) async {
    if (refresh) {
      ref.read(feedPageProvider.notifier).state = 1;
      ref.read(feedPostsListProvider.notifier).state = [];
      ref.read(feedHasMoreProvider.notifier).state = true;
    }

    try {
      final page = ref.read(feedPageProvider);
      print('🔵 Loading feed page: $page');
      final newPosts = await ref.read(feedPostsProvider(page: page, limit: 20).future);
      print('🟢 Loaded ${newPosts.length} posts');

      if (newPosts.isNotEmpty) {
        print('🖼️ First post has ${newPosts.first.media.length} media items');
        if (newPosts.first.media.isNotEmpty) {
          print('🌐 First media URL: ${newPosts.first.media.first.url}');
        }
      }

      if (mounted) {
        if (refresh) {
          ref.read(feedPostsListProvider.notifier).state = newPosts;
        } else {
          final currentPosts = ref.read(feedPostsListProvider);
          ref.read(feedPostsListProvider.notifier).state = [...currentPosts, ...newPosts];
        }

        if (newPosts.isEmpty || newPosts.length < 20) {
          ref.read(feedHasMoreProvider.notifier).state = false;
        }
      }
    } catch (e) {
      print('🔴 Feed error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка загрузки: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore) return;
    setState(() => _isLoadingMore = true);

    try {
      final currentPage = ref.read(feedPageProvider);
      ref.read(feedPageProvider.notifier).state = currentPage + 1;

      final newPosts = await ref.read(feedPostsProvider(page: currentPage + 1, limit: 20).future);

      if (mounted) {
        final currentPosts = ref.read(feedPostsListProvider);
        ref.read(feedPostsListProvider.notifier).state = [...currentPosts, ...newPosts];

        if (newPosts.isEmpty || newPosts.length < 20) {
          ref.read(feedHasMoreProvider.notifier).state = false;
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingMore = false);
      }
    }
  }

  Future<void> _handleRefresh() async {
    await _loadFeed(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final posts = ref.watch(feedPostsListProvider);
    final hasMore = ref.watch(feedHasMoreProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: () {
            // TODO: Add filters bottom sheet
            // showModalBottomSheet(
            //   context: context,
            //   builder: (context) => FeedFiltersSheet(...),
            // );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Фильтры готовы к интеграции')),
            );
          },
          tooltip: 'Фильтры',
        ),
        title: const Text(
          'SERVICE',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              context.push('/search');
            },
          ),
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
      body: posts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    'Загрузка ленты...',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _handleRefresh,
              child: GridView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(4),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  childAspectRatio: 1.0,
                ),
                itemCount: posts.length + (hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == posts.length) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: _isLoadingMore
                            ? const CircularProgressIndicator()
                            : const SizedBox.shrink(),
                      ),
                    );
                  }
                  return PostCard(post: posts[index]);
                },
              ),
            ),
    );
  }

}
