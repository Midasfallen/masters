import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../shared/widgets/review_card.dart';
import '../../../shared/widgets/unreviewed_bookings_dialog.dart';
import '../../../core/providers/api/bookings_provider.dart';
import '../../../core/providers/api/masters_provider.dart';
import '../../../core/providers/api/feed_provider.dart';
import '../../../core/providers/api/user_provider.dart';
import '../../../core/models/api/booking_model.dart';
import '../../../core/models/api/master_model.dart';
import '../../../core/models/api/service_model.dart';
import '../../../core/api/api_exceptions.dart';
import '../../../core/repositories/review_reminders_repository.dart';

class MasterProfileScreen extends ConsumerStatefulWidget {
  final String masterId;
  final bool isUserId;

  const MasterProfileScreen({
    super.key,
    required this.masterId,
    this.isUserId = false,
  });

  @override
  ConsumerState<MasterProfileScreen> createState() => _MasterProfileScreenState();
}

class _MasterProfileScreenState extends ConsumerState<MasterProfileScreen>
    with SingleTickerProviderStateMixin {
  bool _isFavorite = false;
  bool _isSubscribed = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // API теперь поддерживает поиск как по ID профиля мастера, так и по user_id
    // Используем masterByProfileId, который теперь работает с обоими типами ID
    final masterAsync = ref.watch(masterByProfileIdProvider(widget.masterId));
    final theme = Theme.of(context);

    return masterAsync.when(
      data: (master) => _buildMasterProfile(master, theme),
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) {
        // Проверяем, является ли это ошибкой 404 (профиль мастера не найден)
        // или TypeError: null (когда API возвращает null)
        final errorString = error.toString();
        final isNotFound = errorString.contains('404') ||
            errorString.contains('NotFoundException') ||
            errorString.contains('not found') ||
            errorString.contains('не найден') ||
            errorString.contains('TypeError: null') ||
            errorString.contains('type \'Null\' is not a subtype') ||
            (error is ApiException && error.statusCode == 404);
        
        return Scaffold(
          appBar: AppBar(),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isNotFound ? Icons.person_off : Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isNotFound
                        ? 'Профиль мастера не найден'
                        : 'Ошибка загрузки',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  if (isNotFound) ...[
                    const SizedBox(height: 8),
                    Text(
                      'У этого пользователя еще нет профиля мастера',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ] else ...[
                    const SizedBox(height: 8),
                    Text(
                      errorString,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                      textAlign: TextAlign.center,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Назад'),
              ),
              if (!isNotFound) ...[
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    ref.invalidate(masterByProfileIdProvider(widget.masterId));
                  },
                  child: const Text('Повторить'),
                ),
              ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMasterProfile(MasterProfileModel master, ThemeData theme) {

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
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
                background: master.portfolioUrls.isNotEmpty
                    ? PageView.builder(
                        itemCount: master.portfolioUrls.length,
                        itemBuilder: (context, index) {
                          return Image.network(
                            master.portfolioUrls[index],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.image_not_supported),
                            ),
                          );
                        },
                      )
                    : master.user?.avatarUrl != null
                        ? Image.network(
                            master.user!.avatarUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.person),
                            ),
                          )
                        : Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.person, size: 64),
                          ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
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
                                      Expanded(
                                        child: Text(
                                          master.businessName ??
                                              master.user?.fullName ??
                                              (master.user != null
                                                  ? '${master.user!.firstName} ${master.user!.lastName}'
                                                  : 'Мастер'),
                                          style: theme.textTheme.headlineSmall
                                              ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      if (master.user?.isVerified ?? false) ...[
                                        const SizedBox(width: 8),
                                        Icon(
                                          Icons.verified,
                                          color: theme.colorScheme.primary,
                                          size: 24,
                                        ),
                                      ],
                                    ],
                                  ),
                                  if (master.categoryIds.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      'Категория ${master.categoryIds.length}',
                                      style: theme.textTheme.bodyLarge?.copyWith(
                                        color: theme.colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
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
                              label: '${master.rating.toStringAsFixed(1)} (${master.reviewsCount})',
                            ),
                            if (master.serviceRadiusKm != null) ...[
                              const SizedBox(width: 8),
                              _buildInfoChip(
                                context,
                                icon: Icons.location_on,
                                label: '${master.serviceRadiusKm} км',
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Subscribe button
                        FilledButton.icon(
                          onPressed: () {
                            setState(() {
                              _isSubscribed = !_isSubscribed;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(_isSubscribed
                                    ? 'Вы подписались на ${master.businessName ?? master.user?.fullName ?? 'мастера'}'
                                    : 'Вы отписались от ${master.businessName ?? master.user?.fullName ?? 'мастера'}'),
                              ),
                            );
                          },
                          icon: Icon(_isSubscribed
                              ? Icons.bookmark
                              : Icons.bookmark_outline),
                          label: Text(
                              _isSubscribed ? 'Отписаться' : 'Подписаться'),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '${master.subscribersCount} подписчиков | ${master.user?.postsCount ?? 0} постов',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        if (master.bio != null) ...[
                          const SizedBox(height: 16),
                          Text(
                            master.bio!,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                        if (master.locationAddress != null ||
                            master.locationName != null) ...[
                          const SizedBox(height: 8),
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
                                  master.locationAddress ??
                                      master.locationName ??
                                      '',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'Посты'),
                      Tab(text: 'Портфолио'),
                      Tab(text: 'Услуги'),
                      Tab(text: 'Отзывы'),
                    ],
                  ),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildPostsTab(master),
            _buildPortfolioTab(master),
            _buildServicesTab(master),
            _buildReviewsTab(master),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
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

  Widget _buildPostsTab(MasterProfileModel master) {
    final userPostsAsync = ref.watch(userPostsProvider(master.userId));

    return userPostsAsync.when(
      data: (posts) {
        if (posts.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.grid_view_outlined, size: 64),
                SizedBox(height: 16),
                Text('Нет постов'),
              ],
            ),
          );
        }

        return MasonryGridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          padding: const EdgeInsets.all(4),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return GestureDetector(
              onTap: () {
                context.push('/post/${post.id}');
              },
              child: post.media.isNotEmpty
                  ? Image.network(
                      post.media.first.url,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported),
                      ),
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.text_fields),
                    ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64),
            const SizedBox(height: 16),
            Text('Ошибка: ${error.toString()}'),
          ],
        ),
      ),
    );
  }

  Widget _buildPortfolioTab(MasterProfileModel master) {
    if (master.portfolioUrls.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.photo_library_outlined, size: 64),
            SizedBox(height: 16),
            Text('Портфолио пусто'),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(4),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemCount: master.portfolioUrls.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Просмотр фото ${index + 1}')),
            );
          },
          child: Image.network(
            master.portfolioUrls[index],
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.grey[300],
              child: const Icon(Icons.image_not_supported),
            ),
          ),
        );
      },
    );
  }

  Widget _buildServicesTab(MasterProfileModel master) {
    final servicesAsync = ref.watch(masterServicesProvider(master.id));

    return servicesAsync.when(
      data: (services) {
        if (services.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.work_outline, size: 64),
                SizedBox(height: 16),
                Text('Нет услуг'),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: services.length,
          itemBuilder: (context, index) {
            final service = services[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(service.name),
                subtitle: Text(
                  service.description ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  '${service.price.toStringAsFixed(0)} ${service.currency}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                onTap: () {
                  _showBookingDialog(context, master, service);
                },
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64),
            const SizedBox(height: 16),
            Text('Ошибка: ${error.toString()}'),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsTab(MasterProfileModel master) {
    final reviewsAsync = ref.watch(masterReviewsProvider(master.id));

    return reviewsAsync.when(
      data: (reviews) {
        if (reviews.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star_outline, size: 64),
                SizedBox(height: 16),
                Text('Нет отзывов'),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            final review = reviews[index];
            // Загружаем информацию о рецензенте
            final reviewerAsync = ref.watch(userByIdProvider(review.reviewerId));
            return reviewerAsync.when(
              data: (reviewer) => ReviewCard(
                userName: reviewer.fullName ??
                    (reviewer.firstName.isNotEmpty && reviewer.lastName.isNotEmpty
                        ? '${reviewer.firstName} ${reviewer.lastName}'
                        : 'Аноним'),
                userAvatar: reviewer.avatarUrl ?? '',
                rating: review.rating.toDouble(),
                comment: review.comment ?? '',
                date: review.createdAt,
              ),
              loading: () => const ListTile(
                leading: CircularProgressIndicator(),
                title: Text('Загрузка...'),
              ),
              error: (_, __) => ReviewCard(
                userName: 'Аноним',
                userAvatar: '',
                rating: review.rating.toDouble(),
                comment: review.comment ?? '',
                date: review.createdAt,
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64),
            const SizedBox(height: 16),
            Text('Ошибка: ${error.toString()}'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context,
      {required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
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

  void _showBookingDialog(
      BuildContext context, MasterProfileModel master, ServiceModel? service) {
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

class _BookingSheet extends ConsumerStatefulWidget {
  final MasterProfileModel master;
  final ServiceModel? service;
  final ScrollController scrollController;

  const _BookingSheet({
    required this.master,
    required this.service,
    required this.scrollController,
  });

  @override
  ConsumerState<_BookingSheet> createState() => _BookingSheetState();
}

class _BookingSheetState extends ConsumerState<_BookingSheet> {
  ServiceModel? _selectedService;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 10, minute: 0);
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedService = widget.service;
  }

  Future<void> _handleBookingCreation() async {
    if (_selectedService == null) return;

    setState(() => _isLoading = true);

    try {
      final startDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      // Создаем запрос на бронирование
      final request = CreateBookingRequest(
        serviceId: _selectedService!.id,
        masterId: widget.master.id,
        startTime: startDateTime,
        comment: null,
      );

      final notifier = ref.read(bookingNotifierProvider.notifier);
      await notifier.createBooking(request);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Запись создана на ${DateFormat('dd.MM.yyyy').format(_selectedDate)} в ${_selectedTime.format(context)}',
            ),
          ),
        );
        context.go('/bookings');
      }
    } on UnreviewedBookingsException {
      // Получаем неотзывленные бронирования
      try {
        final remindersRepo = ref.read(reviewRemindersRepositoryProvider);
        final unreviewedBookings = await remindersRepo.getUnreviewedBookings();

        if (mounted && unreviewedBookings.isNotEmpty) {
          final action = await context.showUnreviewedBookingsDialog(
            bookings: unreviewedBookings,
          );

          // Обрабатываем результат диалога
          switch (action) {
            case ReviewReminderAction.leaveReviews:
              // Перенаправляем на экран оставления отзывов
              if (mounted) {
                Navigator.pop(context);
                context.go('/bookings?tab=history');
              }
              break;
            case ReviewReminderAction.skip:
            case ReviewReminderAction.skipWithGrace:
              // Пользователь пропустил, пробуем создать бронирование снова
              await _handleBookingCreation();
              break;
            case null:
              // Диалог закрыт без действия
              break;
          }
        }
      } catch (dialogError) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ошибка: ${dialogError.toString()}'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка при создании записи: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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
          Builder(
            builder: (context) {
              final servicesAsync = ref.watch(masterServicesProvider(widget.master.id));
              return servicesAsync.when(
                data: (services) {
                  if (services.isEmpty) {
                    return const Text('Нет доступных услуг');
                  }
                  return Column(
                    children: services.map((service) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedService = service;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Checkbox(
                                value: _selectedService?.id == service.id,
                                onChanged: (value) {
                                  if (value == true) {
                                    setState(() {
                                      _selectedService = service;
                                    });
                                  }
                                },
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(service.name),
                                    Text(
                                        '${service.durationMinutes} мин • ${service.price.toStringAsFixed(0)} ${service.currency}'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, stack) => Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Ошибка: ${error.toString()}'),
                ),
              );
            },
          ),
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
            onPressed: _selectedService == null || _isLoading
                ? null
                : _handleBookingCreation,
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Записаться'),
          ),
        ],
      ),
    );
  }
}
