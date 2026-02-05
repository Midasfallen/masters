import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/api/master_model.dart';
import '../../../core/models/api/search_aggregation_model.dart';

/// Вкладки с результатами поиска: только те табы, где список не пуст.
/// Принимает [SearchAggregationModel] и рендерит Мастера | Услуги | Категории.
class SearchResultsTabs extends StatefulWidget {
  const SearchResultsTabs({
    super.key,
    required this.result,
  });

  final SearchAggregationModel result;

  @override
  State<SearchResultsTabs> createState() => _SearchResultsTabsState();
}

class _SearchResultsTabsState extends State<SearchResultsTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    final tabCount = _nonEmptyTabCount();
    _tabController = TabController(length: tabCount, vsync: this);
  }

  @override
  void didUpdateWidget(SearchResultsTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newCount = _nonEmptyTabCount();
    if (newCount != _tabController.length) {
      _tabController.dispose();
      _tabController = TabController(length: newCount, vsync: this);
    }
  }

  int _nonEmptyTabCount() {
    int n = 0;
    if (widget.result.masters.isNotEmpty) n++;
    if (widget.result.services.isNotEmpty) n++;
    if (widget.result.categories.isNotEmpty) n++;
    return n.clamp(1, 3);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasMasters = widget.result.masters.isNotEmpty;
    final hasServices = widget.result.services.isNotEmpty;
    final hasCategories = widget.result.categories.isNotEmpty;

    final tabs = <Tab>[];
    if (hasMasters) tabs.add(const Tab(text: 'Мастера'));
    if (hasServices) tabs.add(const Tab(text: 'Услуги'));
    if (hasCategories) tabs.add(const Tab(text: 'Категории'));

    if (tabs.isEmpty) {
      return const SliverFillRemaining(
        child: Center(
          child: Text(
            'Ничего не найдено',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ),
      );
    }

    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: tabs,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              if (hasMasters) _MastersList(masters: widget.result.masters),
              if (hasServices) _ServicesList(services: widget.result.services),
              if (hasCategories)
                _CategoriesList(categories: widget.result.categories),
            ],
          ),
        ),
      ],
    );
  }
}

class _MastersList extends StatelessWidget {
  const _MastersList({required this.masters});

  final List<MasterSearchResultModel> masters;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: masters.length,
      itemBuilder: (context, index) => _MasterCard(master: masters[index]),
    );
  }
}

class _MasterCard extends StatelessWidget {
  const _MasterCard({required this.master});

  final MasterSearchResultModel master;

  @override
  Widget build(BuildContext context) {
    final fullName = '${master.firstName} ${master.lastName}';
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => context.push('/master/${master.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 32,
                backgroundImage: master.avatarUrl != null
                    ? CachedNetworkImageProvider(master.avatarUrl!)
                    : null,
                child: master.avatarUrl == null
                    ? Text(
                        fullName.isNotEmpty ? fullName[0].toUpperCase() : 'M',
                        style: const TextStyle(fontSize: 24),
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (master.description != null &&
                        master.description!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        master.description!,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.star, size: 16, color: Colors.amber[700]),
                        const SizedBox(width: 4),
                        Text(
                          master.averageRating.toStringAsFixed(1),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${master.reviewsCount})',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        if (master.locationAddress != null &&
                            master.locationAddress!.isNotEmpty) ...[
                          const SizedBox(width: 16),
                          Icon(Icons.location_on,
                              size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              master.locationAddress!,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ServicesList extends StatelessWidget {
  const _ServicesList({required this.services});

  final List<ServiceSearchResultModel> services;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: services.length,
      itemBuilder: (context, index) => _ServiceCard(service: services[index]),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.service});

  final ServiceSearchResultModel service;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          context.push('/master/${service.master.id}');
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      service.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    '${service.price.toStringAsFixed(0)} ₽',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              if (service.description != null &&
                  service.description!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  service.description!,
                  style: TextStyle(color: Colors.grey[600]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '${service.durationMinutes} мин',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${service.master.firstName} ${service.master.lastName}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoriesList extends StatelessWidget {
  const _CategoriesList({required this.categories});

  final List<CategorySearchResultModel> categories;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: categories.length,
      itemBuilder: (context, index) => _CategoryCard(category: categories[index]),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.category});

  final CategorySearchResultModel category;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          context.push(
            '/search/category/${category.id}',
            extra: {'categoryName': category.name},
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.category_outlined,
                size: 32,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category.slug,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
