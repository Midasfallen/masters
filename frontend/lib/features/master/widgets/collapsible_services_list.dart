import 'package:flutter/material.dart';
import '../../../shared/models/service.dart';

class CollapsibleServicesList extends StatefulWidget {
  final List<Service> services;
  final void Function(Service service) onServiceTap;

  const CollapsibleServicesList({
    super.key,
    required this.services,
    required this.onServiceTap,
  });

  @override
  State<CollapsibleServicesList> createState() =>
      _CollapsibleServicesListState();
}

class _CollapsibleServicesListState extends State<CollapsibleServicesList> {
  bool _isExpanded = false;
  String? _expandedCategory;

  Map<String, List<Service>> get _groupedServices {
    final Map<String, List<Service>> grouped = {};
    for (final service in widget.services) {
      if (!grouped.containsKey(service.category)) {
        grouped[service.category] = [];
      }
      grouped[service.category]!.add(service);
    }
    return grouped;
  }

  List<Service> get _displayedServices {
    if (_isExpanded) {
      return widget.services;
    }
    return widget.services.take(3).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final groupedServices = _groupedServices;

    if (widget.services.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.work_outline, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Услуги пока не добавлены',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_isExpanded) ...[
          // Expanded view with category grouping
          ...groupedServices.entries.map((entry) {
            final category = entry.key;
            final services = entry.value;
            final isExpanded = _expandedCategory == category;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _expandedCategory = isExpanded ? null : category;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            category,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          '${services.length}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                ),
                if (isExpanded)
                  ...services.map((service) => _buildServiceCard(
                        context,
                        service,
                        theme,
                      )),
                const Divider(height: 1),
              ],
            );
          }),
        ] else ...[
          // Collapsed view - first 3 services
          ..._displayedServices.map((service) => _buildServiceCard(
                context,
                service,
                theme,
              )),
        ],
        // Expand/Collapse button
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: OutlinedButton.icon(
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
                if (!_isExpanded) {
                  _expandedCategory = null;
                }
              });
            },
            icon: Icon(_isExpanded
                ? Icons.keyboard_arrow_up
                : Icons.keyboard_arrow_down),
            label: Text(_isExpanded
                ? 'Свернуть услуги'
                : 'Развернуть услуги (${widget.services.length})'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard(
    BuildContext context,
    Service service,
    ThemeData theme,
  ) {
    return InkWell(
      onTap: () {
        _showServiceDetailSheet(context, service);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${service.durationMinutes} мин',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (service.description != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      service.description!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  service.price,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                FilledButton(
                  onPressed: () {
                    widget.onServiceTap(service);
                  },
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(100, 36),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: const Text('Записаться'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showServiceDetailSheet(BuildContext context, Service service) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return _ServiceDetailSheet(
              service: service,
              scrollController: scrollController,
              onBook: () {
                Navigator.pop(context);
                widget.onServiceTap(service);
              },
            );
          },
        );
      },
    );
  }
}

class _ServiceDetailSheet extends StatelessWidget {
  final Service service;
  final ScrollController scrollController;
  final VoidCallback onBook;

  const _ServiceDetailSheet({
    required this.service,
    required this.scrollController,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      child: ListView(
        controller: scrollController,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.name,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        service.category,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                service.price,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildInfoRow(
            context,
            Icons.access_time,
            'Длительность',
            '${service.durationMinutes} минут',
          ),
          const SizedBox(height: 16),
          if (service.description != null) ...[
            Text(
              'Описание',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              service.description!,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
          ],
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: onBook,
            icon: const Icon(Icons.calendar_today),
            label: const Text('Записаться'),
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
