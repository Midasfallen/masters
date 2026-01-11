import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/api/booking_model.dart';
import '../../../core/providers/api/auth_provider.dart';
import '../../../core/providers/api/bookings_provider.dart';

enum BookingMode { client, master }

/// State providers for bookings screen
final bookingsModeProvider = StateProvider<BookingMode>((ref) => BookingMode.client);

class BookingsScreen extends ConsumerStatefulWidget {
  const BookingsScreen({super.key});

  @override
  ConsumerState<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends ConsumerState<BookingsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  int _getTabLength(BookingMode mode) {
    switch (mode) {
      case BookingMode.client:
        return 2; // Предстоящие, История
      case BookingMode.master:
        return 3; // Неподтвержденные, Подтвержденные, История
    }
  }

  void _switchMode(BookingMode newMode) {
    final currentMode = ref.read(bookingsModeProvider);
    if (currentMode != newMode) {
      ref.read(bookingsModeProvider.notifier).state = newMode;
      _tabController.dispose();
      _tabController = TabController(length: _getTabLength(newMode), vsync: this);
      setState(() {});
    }
  }

  Future<void> _confirmBooking(String bookingId) async {
    try {
      await ref.read(bookingNotifierProvider.notifier).confirmBooking(bookingId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Запись подтверждена')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _cancelBooking(BookingModel booking) async {
    final reason = await showDialog<String>(
      context: context,
      builder: (context) {
        String cancelReason = '';
        return AlertDialog(
          title: const Text('Отменить запись?'),
          content: TextField(
            decoration: const InputDecoration(
              hintText: 'Причина отмены (необязательно)',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            onChanged: (value) => cancelReason = value,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, cancelReason.isEmpty ? 'Отменено клиентом' : cancelReason),
              style: FilledButton.styleFrom(backgroundColor: Colors.red[700]),
              child: const Text('Отменить запись'),
            ),
          ],
        );
      },
    );

    if (reason == null) return;

    try {
      await ref.read(bookingNotifierProvider.notifier).cancelBooking(booking.id, reason);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Запись отменена')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _completeBooking(String bookingId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Завершить запись'),
        content: const Text(
          'После завершения клиент должен оставить отзыв. Завершить запись?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Завершить'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ref.read(bookingNotifierProvider.notifier).completeBooking(bookingId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Запись завершена. Ожидание отзыва клиента')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: ${e.toString()}')),
        );
      }
    }
  }

  Widget _buildBookingsList({
    required List<BookingModel> bookings,
    BookingStatus? filterStatus,
    String? masterActionType,
  }) {
    final filteredBookings = filterStatus == null
        ? bookings
        : bookings.where((b) => b.status == filterStatus).toList();

    if (filteredBookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Нет записей',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(myBookingsProvider);
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredBookings.length,
        itemBuilder: (context, index) {
          final booking = filteredBookings[index];
          return _buildBookingCard(booking, masterActionType);
        },
      ),
    );
  }

  Widget _buildBookingCard(BookingModel booking, String? masterActionType) {
    final currentMode = ref.watch(bookingsModeProvider);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  _formatDateTime(booking.startTime),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                _buildStatusChip(booking.status),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                const Icon(Icons.access_time, size: 18),
                const SizedBox(width: 8),
                Text('${booking.durationMinutes} мин'),
                const SizedBox(width: 24),
                const Icon(Icons.attach_money, size: 18),
                const SizedBox(width: 8),
                Text('${booking.price.toStringAsFixed(0)} ₽'),
              ],
            ),
            if (booking.comment != null) ...[
              const SizedBox(height: 12),
              Text(
                booking.comment!,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
            if (booking.locationAddress != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 18),
                  const SizedBox(width: 8),
                  Expanded(child: Text(booking.locationAddress!)),
                ],
              ),
            ],

            // Master actions
            if (currentMode == BookingMode.master && masterActionType != null) ...[
              const SizedBox(height: 16),
              if (masterActionType == 'pending') ...[
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => _confirmBooking(booking.id),
                        icon: const Icon(Icons.check, size: 18),
                        label: const Text('Подтвердить'),
                        style: FilledButton.styleFrom(backgroundColor: Colors.green),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _cancelBooking(booking),
                        icon: const Icon(Icons.close, size: 18),
                        label: const Text('Отклонить'),
                      ),
                    ),
                  ],
                ),
              ] else if (masterActionType == 'confirmed') ...[
                FilledButton.icon(
                  onPressed: () => _completeBooking(booking.id),
                  icon: const Icon(Icons.check_circle, size: 18),
                  label: const Text('Завершить'),
                ),
              ],
            ],

            // Client actions
            if (currentMode == BookingMode.client &&
                (booking.status == BookingStatus.pending ||
                    booking.status == BookingStatus.confirmed)) ...[
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () => _cancelBooking(booking),
                icon: const Icon(Icons.cancel, size: 18),
                label: const Text('Отменить запись'),
                style: OutlinedButton.styleFrom(foregroundColor: Colors.red[700]),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(BookingStatus status) {
    Color color;
    String label;
    switch (status) {
      case BookingStatus.pending:
        color = Colors.orange;
        label = 'Ожидание';
        break;
      case BookingStatus.confirmed:
        color = Colors.blue;
        label = 'Подтверждено';
        break;
      case BookingStatus.inProgress:
        color = Colors.purple;
        label = 'В процессе';
        break;
      case BookingStatus.completed:
        color = Colors.green;
        label = 'Завершено';
        break;
      case BookingStatus.cancelled:
        color = Colors.red;
        label = 'Отменено';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    final months = [
      'янв', 'фев', 'мар', 'апр', 'май', 'июн',
      'июл', 'авг', 'сен', 'окт', 'ноя', 'дек'
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}, ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }

  List<Widget> _buildTabViews(BookingMode mode, AsyncValue<List<BookingModel>> bookingsAsync) {
    return bookingsAsync.when(
      data: (bookings) {
        if (mode == BookingMode.client) {
          final upcoming = bookings.where((b) =>
              b.status == BookingStatus.pending ||
              b.status == BookingStatus.confirmed ||
              b.status == BookingStatus.inProgress).toList();
          final past = bookings.where((b) =>
              b.status == BookingStatus.completed ||
              b.status == BookingStatus.cancelled).toList();

          return [
            _buildBookingsList(bookings: upcoming),
            _buildBookingsList(bookings: past),
          ];
        } else {
          // Master mode
          final pending = bookings.where((b) => b.status == BookingStatus.pending).toList();
          final confirmed = bookings.where((b) =>
              b.status == BookingStatus.confirmed ||
              b.status == BookingStatus.inProgress).toList();
          final completed = bookings.where((b) =>
              b.status == BookingStatus.completed ||
              b.status == BookingStatus.cancelled).toList();

          return [
            _buildBookingsList(bookings: pending, masterActionType: 'pending'),
            _buildBookingsList(bookings: confirmed, masterActionType: 'confirmed'),
            _buildBookingsList(bookings: completed, masterActionType: 'history'),
          ];
        }
      },
      loading: () => List.generate(
        mode == BookingMode.client ? 2 : 3,
        (_) => const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => List.generate(
        mode == BookingMode.client ? 2 : 3,
        (_) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Ошибка: ${error.toString()}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(myBookingsProvider),
                child: const Text('Повторить'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentMode = ref.watch(bookingsModeProvider);
    final authState = ref.watch(authNotifierProvider);
    final isMaster = authState.value?.user?.isMaster ?? false;

    // Get bookings with appropriate role filter
    final role = currentMode == BookingMode.client ? 'client' : 'master';
    final bookingsAsync = ref.watch(myBookingsProvider(role: role));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Записи'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(isMaster ? 96 : 48),
          child: Column(
            children: [
              if (isMaster)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: SegmentedButton<BookingMode>(
                    segments: const [
                      ButtonSegment<BookingMode>(
                        value: BookingMode.client,
                        label: Text('Клиент'),
                        icon: Icon(Icons.person_outline, size: 18),
                      ),
                      ButtonSegment<BookingMode>(
                        value: BookingMode.master,
                        label: Text('Мастер'),
                        icon: Icon(Icons.work_outline, size: 18),
                      ),
                    ],
                    selected: {currentMode},
                    onSelectionChanged: (Set<BookingMode> selected) {
                      _switchMode(selected.first);
                    },
                  ),
                ),
              TabBar(
                controller: _tabController,
                tabs: currentMode == BookingMode.client
                    ? const [
                        Tab(text: 'Предстоящие'),
                        Tab(text: 'История'),
                      ]
                    : const [
                        Tab(text: 'Неподтвержденные'),
                        Tab(text: 'Подтвержденные'),
                        Tab(text: 'История'),
                      ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _buildTabViews(currentMode, bookingsAsync),
      ),
      floatingActionButton: currentMode == BookingMode.client
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/search'),
              icon: const Icon(Icons.add),
              label: const Text('Новая запись'),
            )
          : null,
    );
  }
}
