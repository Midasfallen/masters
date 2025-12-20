import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../shared/models/master.dart';
import '../../../shared/models/service.dart';
import '../../../shared/widgets/service_card.dart';
import '../../../shared/widgets/review_card.dart';
import '../../../data/mock/mock_masters.dart';
import '../../../data/mock/mock_services.dart';

class MasterProfileScreen extends StatefulWidget {
  final String masterId;

  const MasterProfileScreen({super.key, required this.masterId});

  @override
  State<MasterProfileScreen> createState() => _MasterProfileScreenState();
}

class _MasterProfileScreenState extends State<MasterProfileScreen> {
  bool _isFavorite = false;

  Master? get _master {
    try {
      return mockMasters.firstWhere((m) => m.id == widget.masterId);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_master == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: Text('Мастер не найден'),
        ),
      );
    }

    final master = _master!;
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_outline,
                ),
                onPressed: () {
                  setState(() {
                    _isFavorite = !_isFavorite;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        _isFavorite
                            ? 'Добавлено в избранное'
                            : 'Удалено из избранного',
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Поделиться профилем')),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: master.portfolio != null &&
                      master.portfolio!.isNotEmpty
                  ? PageView.builder(
                      itemCount: master.portfolio!.length,
                      itemBuilder: (context, index) {
                        return Image.network(
                          master.portfolio![index],
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : Image.network(
                      master.avatar,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  master.name,
                                  style: theme.textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                if (master.verified) ...[
                                  const SizedBox(width: 8),
                                  Icon(
                                    Icons.verified,
                                    color: theme.colorScheme.primary,
                                    size: 24,
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              master.category,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildInfoChip(
                        context,
                        icon: Icons.star,
                        label: '${master.rating} (${master.reviewsCount})',
                      ),
                      const SizedBox(width: 8),
                      _buildInfoChip(
                        context,
                        icon: Icons.location_on,
                        label: '${master.distance} км',
                      ),
                      const SizedBox(width: 8),
                      _buildInfoChip(
                        context,
                        icon: Icons.payments,
                        label: 'от ${master.priceFrom}',
                      ),
                    ],
                  ),
                  if (master.bio != null) ...[
                    const SizedBox(height: 24),
                    Text(
                      'О мастере',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      master.bio!,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                  if (master.address != null) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 20,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            master.address!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 24),
                  Text(
                    'Услуги',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final service = mockServices[index];
                  return ServiceCard(
                    service: service,
                    onTap: () {
                      _showBookingDialog(context, master, service);
                    },
                  );
                },
                childCount: mockServices.length,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    'Отзывы (${master.reviewsCount})',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  // Mock reviews
                  final reviews = [
                    {
                      'name': 'Мария Иванова',
                      'avatar': 'https://i.pravatar.cc/100?img=10',
                      'rating': 5.0,
                      'comment':
                          'Отличный мастер! Очень профессионально выполнила работу. Обязательно вернусь снова!',
                      'date': DateTime.now().subtract(const Duration(days: 5)),
                    },
                    {
                      'name': 'Анна Петрова',
                      'avatar': 'https://i.pravatar.cc/100?img=20',
                      'rating': 4.5,
                      'comment':
                          'Хорошее качество работы, приятная атмосфера. Рекомендую!',
                      'date': DateTime.now().subtract(const Duration(days: 15)),
                    },
                    {
                      'name': 'Екатерина Смирнова',
                      'avatar': 'https://i.pravatar.cc/100?img=30',
                      'rating': 5.0,
                      'comment':
                          'Супер! Именно то, что я хотела. Мастер учла все мои пожелания.',
                      'date': DateTime.now().subtract(const Duration(days: 30)),
                    },
                  ];

                  if (index >= reviews.length) return null;

                  final review = reviews[index];
                  return ReviewCard(
                    userName: review['name'] as String,
                    userAvatar: review['avatar'] as String,
                    rating: review['rating'] as double,
                    comment: review['comment'] as String,
                    date: review['date'] as DateTime,
                  );
                },
                childCount: 3,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Открыть чат')),
                    );
                  },
                  icon: const Icon(Icons.chat_outlined),
                  label: const Text('Написать'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 56),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    _showBookingDialog(context, master, null);
                  },
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('Записаться'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(0, 56),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context,
      {required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  void _showBookingDialog(BuildContext context, Master master, Service? service) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return _BookingSheet(
              master: master,
              service: service,
              scrollController: scrollController,
            );
          },
        );
      },
    );
  }
}

class _BookingSheet extends StatefulWidget {
  final Master master;
  final Service? service;
  final ScrollController scrollController;

  const _BookingSheet({
    required this.master,
    required this.service,
    required this.scrollController,
  });

  @override
  State<_BookingSheet> createState() => _BookingSheetState();
}

class _BookingSheetState extends State<_BookingSheet> {
  Service? _selectedService;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 10, minute: 0);

  @override
  void initState() {
    super.initState();
    _selectedService = widget.service;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      child: ListView(
        controller: widget.scrollController,
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
          Text(
            'Запись к мастеру',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Выберите услугу',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          ...mockServices.map((service) {
            return RadioListTile<Service>(
              value: service,
              groupValue: _selectedService,
              onChanged: (value) {
                setState(() {
                  _selectedService = value;
                });
              },
              title: Text(service.name),
              subtitle: Text('${service.durationMinutes} мин • ${service.price}'),
            );
          }),
          const SizedBox(height: 16),
          Text(
            'Выберите дату',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 90)),
              );
              if (date != null) {
                setState(() {
                  _selectedDate = date;
                });
              }
            },
            icon: const Icon(Icons.calendar_today),
            label: Text(DateFormat('dd MMMM yyyy', 'ru').format(_selectedDate)),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Выберите время',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: _selectedTime,
              );
              if (time != null) {
                setState(() {
                  _selectedTime = time;
                });
              }
            },
            icon: const Icon(Icons.access_time),
            label: Text(_selectedTime.format(context)),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
          const SizedBox(height: 32),
          FilledButton(
            onPressed: _selectedService == null
                ? null
                : () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Запись создана на ${DateFormat('dd.MM.yyyy').format(_selectedDate)} в ${_selectedTime.format(context)}',
                        ),
                      ),
                    );
                    context.go('/bookings');
                  },
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
            ),
            child: const Text('Записаться'),
          ),
        ],
      ),
    );
  }
}
