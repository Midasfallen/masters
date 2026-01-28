import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/api/feed_provider.dart';
import '../../../core/models/api/post_model.dart';
import '../widgets/post_card.dart';
import '../widgets/feed_filters_sheet.dart';

/// Feed Screen State Providers для infinite scroll
final feedPageProvider = StateProvider<int>((ref) => 1);
final feedPostsListProvider = StateProvider<List<PostModel>>((ref) => []);
final feedHasMoreProvider = StateProvider<bool>((ref) => true);
final feedFiltersProvider = StateProvider<FeedFilters>((ref) => const FeedFilters());

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
      final filters = ref.read(feedFiltersProvider);
      final queryParams = filters.toQueryParams();

      final newPosts = await ref.read(feedPostsProvider(
        page: page,
        limit: 20,
        lat: queryParams['lat'] as double?,
        lng: queryParams['lng'] as double?,
        radius: queryParams['radius'] as double?,
        categoryIds: queryParams['category_ids'] as List<String>?,
      ).future);

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

      final filters = ref.read(feedFiltersProvider);
      final queryParams = filters.toQueryParams();

      final newPosts = await ref.read(feedPostsProvider(
        page: currentPage + 1,
        limit: 20,
        lat: queryParams['lat'] as double?,
        lng: queryParams['lng'] as double?,
        radius: queryParams['radius'] as double?,
        categoryIds: queryParams['category_ids'] as List<String>?,
      ).future);

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

  void _onSearchTap() => context.push('/search');
  void _onNotificationsTap() => context.push('/notifications');
  void _onCreatePostTap() => context.push('/create-post');

  Future<void> _onFiltersTap() async {
    final currentFilters = ref.read(feedFiltersProvider);
    final result = await showModalBottomSheet<FeedFilters>(
      context: context,
      isScrollControlled: true,
      builder: (context) => FeedFiltersSheet(
        initialFilters: currentFilters,
        availableCategories: const [
          CategoryOption(id: 'cat-1', name: 'Парикмахер', icon: '💇'),
          CategoryOption(id: 'cat-2', name: 'Косметолог', icon: '💆'),
          CategoryOption(id: 'cat-3', name: 'Маникюр', icon: '💅'),
          CategoryOption(id: 'cat-4', name: 'Массажист', icon: '💆'),
        ],
      ),
    );

    if (result != null && mounted) {
      ref.read(feedFiltersProvider.notifier).state = result;
      await _loadFeed(refresh: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final posts = ref.watch(feedPostsListProvider);
    final hasMore = ref.watch(feedHasMoreProvider);
    final hasActiveFilters = ref.watch(feedFiltersProvider).hasActiveFilters;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.filter_list,
            color: hasActiveFilters
                ? Theme.of(context).colorScheme.primary
                : null,
          ),
          onPressed: _onFiltersTap,
          tooltip: 'Фильтры',
        ),
        title: const Text(
          'SERVICE',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _onSearchTap,
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: _onNotificationsTap,
          ),
          IconButton(
            icon: const Icon(Icons.add_box_outlined),
            onPressed: _onCreatePostTap,
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
                  const Text(
                    'Загрузка ленты...',
                    style: TextStyle(color: Color(0xFF757575)),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _handleRefresh,
              child: GridView.builder(
                controller: _scrollController,
                addAutomaticKeepAlives: false,
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
