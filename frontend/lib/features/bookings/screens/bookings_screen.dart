import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/models/booking.dart';
import '../../../shared/widgets/booking_card.dart';
import '../../../data/mock/mock_bookings.dart';

enum BookingMode { client, master, all }

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Booking> _bookings = mockBookings;
  BookingMode _currentMode = BookingMode.client;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _getTabLength(), vsync: this);
  }

  int _getTabLength() {
    switch (_currentMode) {
      case BookingMode.client:
        return 2; // Предстоящие, История
      case BookingMode.master:
        return 3; // Неподтвержденные, Подтвержденные, История
      case BookingMode.all:
        return 2; // Предстоящие, История
    }
  }

  void _switchMode(BookingMode newMode) {
    if (_currentMode != newMode) {
      setState(() {
        _currentMode = newMode;
        _tabController.dispose();
        _tabController = TabController(length: _getTabLength(), vsync: this);
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Booking> get _upcomingBookings {
    return _bookings
        .where((b) =>
            b.status == BookingStatus.pending ||
            b.status == BookingStatus.confirmed ||
            b.status == BookingStatus.inProgress)
        .toList();
  }

  List<Booking> get _pastBookings {
    return _bookings
        .where((b) =>
            b.status == BookingStatus.completed ||
            b.status == BookingStatus.cancelled)
        .toList();
  }

  // Master mode getters
  List<Booking> get _pendingMasterBookings {
    return _bookings.where((b) => b.status == BookingStatus.pending).toList();
  }

  List<Booking> get _confirmedMasterBookings {
    return _bookings
        .where((b) =>
            b.status == BookingStatus.confirmed ||
            b.status == BookingStatus.inProgress)
        .toList();
  }

  List<Booking> get _completedMasterBookings {
    return _bookings
        .where((b) =>
            b.status == BookingStatus.completed ||
            b.status == BookingStatus.cancelled)
        .toList();
  }

  void _cancelBooking(Booking booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Отменить запись?'),
        content: const Text(
          'Вы уверены, что хотите отменить эту запись?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Нет'),
          ),
          FilledButton(
            onPressed: () {
              setState(() {
                _bookings = _bookings.map<Booking>((b) {
                  if (b.id == booking.id) {
                    return Booking(
                      id: b.id,
                      masterId: b.masterId,
                      masterName: b.masterName,
                      masterAvatar: b.masterAvatar,
                      dateTime: b.dateTime,
                      status: BookingStatus.cancelled,
                      serviceId: b.serviceId,
                      serviceName: b.serviceName,
                      durationMinutes: b.durationMinutes,
                      price: b.price,
                      comment: b.comment,
                    );
                  }
                  return b;
                }).toList();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Запись отменена')),
              );
            },
            child: const Text('Да, отменить'),
          ),
        ],
      ),
    );
  }

  // Master actions
  void _confirmBooking(Booking booking) {
    setState(() {
      _bookings = _bookings.map<Booking>((b) {
        if (b.id == booking.id) {
          return Booking(
            id: b.id,
            masterId: b.masterId,
            masterName: b.masterName,
            masterAvatar: b.masterAvatar,
            dateTime: b.dateTime,
            status: BookingStatus.confirmed,
            serviceId: b.serviceId,
            serviceName: b.serviceName,
            durationMinutes: b.durationMinutes,
            price: b.price,
            comment: b.comment,
          );
        }
        return b;
      }).toList();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Запись подтверждена')),
    );
  }

  void _rejectBooking(Booking booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Отклонить запись?'),
        content: const Text(
          'Вы уверены, что хотите отклонить эту запись?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Нет'),
          ),
          FilledButton(
            onPressed: () {
              setState(() {
                _bookings = _bookings.map<Booking>((b) {
                  if (b.id == booking.id) {
                    return Booking(
                      id: b.id,
                      masterId: b.masterId,
                      masterName: b.masterName,
                      masterAvatar: b.masterAvatar,
                      dateTime: b.dateTime,
                      status: BookingStatus.cancelled,
                      serviceId: b.serviceId,
                      serviceName: b.serviceName,
                      durationMinutes: b.durationMinutes,
                      price: b.price,
                      comment: b.comment,
                    );
                  }
                  return b;
                }).toList();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Запись отклонена')),
              );
            },
            child: const Text('Да, отклонить'),
          ),
        ],
      ),
    );
  }

  void _suggestAlternativeTime(Booking booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Предложить другое время'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Выберите альтернативное время для записи:'),
            const SizedBox(height: 16),
            // TODO: Add date/time picker
            Text(
              'Текущее время: ${booking.dateTime.day}.${booking.dateTime.month}.${booking.dateTime.year} ${booking.dateTime.hour}:${booking.dateTime.minute.toString().padLeft(2, '0')}',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Предложение отправлено клиенту')),
              );
            },
            child: const Text('Отправить'),
          ),
        ],
      ),
    );
  }

  void _completeBooking(Booking booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Завершить запись'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('После завершения клиент должен оставить отзыв.'),
            SizedBox(height: 16),
            Text('Завершить запись?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () {
              setState(() {
                _bookings = _bookings.map<Booking>((b) {
                  if (b.id == booking.id) {
                    return Booking(
                      id: b.id,
                      masterId: b.masterId,
                      masterName: b.masterName,
                      masterAvatar: b.masterAvatar,
                      dateTime: b.dateTime,
                      status: BookingStatus.completed,
                      serviceId: b.serviceId,
                      serviceName: b.serviceName,
                      durationMinutes: b.durationMinutes,
                      price: b.price,
                      comment: b.comment,
                    );
                  }
                  return b;
                }).toList();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Запись завершена. Ожидание отзыва клиента')),
              );
            },
            child: const Text('Завершить'),
          ),
        ],
      ),
    );
  }

  void _offerBookingToClient(Booking booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Предложить запись клиенту'),
        content: const Text(
          'Отправить предложение о записи этому клиенту?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Предложение отправлено')),
              );
            },
            child: const Text('Отправить'),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingsList(List<Booking> bookings,
      {String? masterActionType}) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 80,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'Нет записей',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];

        // Build action buttons for master mode
        Widget? masterActions;
        if (_currentMode == BookingMode.master && masterActionType != null) {
          if (masterActionType == 'pending') {
            masterActions = Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => _confirmBooking(booking),
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text('Подтвердить'),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _rejectBooking(booking),
                      icon: const Icon(Icons.close, size: 18),
                      label: const Text('Отклонить'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => _suggestAlternativeTime(booking),
                    icon: const Icon(Icons.schedule),
                    tooltip: 'Предложить другое время',
                  ),
                ],
              ),
            );
          } else if (masterActionType == 'confirmed') {
            masterActions = Padding(
              padding: const EdgeInsets.only(top: 8),
              child: FilledButton.icon(
                onPressed: () => _completeBooking(booking),
                icon: const Icon(Icons.check_circle, size: 18),
                label: const Text('Завершить'),
              ),
            );
          } else if (masterActionType == 'history') {
            masterActions = Padding(
              padding: const EdgeInsets.only(top: 8),
              child: OutlinedButton.icon(
                onPressed: () => _offerBookingToClient(booking),
                icon: const Icon(Icons.replay, size: 18),
                label: const Text('Предложить запись клиенту'),
              ),
            );
          }
        }

        return Column(
          children: [
            BookingCard(
              booking: booking,
              onTap: () {
                // Show booking details
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Запись #${booking.id}')),
                );
              },
              onCancel: _currentMode == BookingMode.client &&
                      (booking.status == BookingStatus.pending ||
                          booking.status == BookingStatus.confirmed)
                  ? () => _cancelBooking(booking)
                  : null,
            ),
            if (masterActions != null) masterActions,
          ],
        );
      },
    );
  }

  Widget _buildModeSwitcher() {
    return Container(
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
          ButtonSegment<BookingMode>(
            value: BookingMode.all,
            label: Text('Все записи'),
            icon: Icon(Icons.list, size: 18),
          ),
        ],
        selected: {_currentMode},
        onSelectionChanged: (Set<BookingMode> selected) {
          _switchMode(selected.first);
        },
      ),
    );
  }

  List<Tab> _getTabs() {
    switch (_currentMode) {
      case BookingMode.client:
        return const [
          Tab(text: 'Предстоящие'),
          Tab(text: 'История'),
        ];
      case BookingMode.master:
        return const [
          Tab(text: 'Неподтвержденные'),
          Tab(text: 'Подтвержденные'),
          Tab(text: 'История'),
        ];
      case BookingMode.all:
        return const [
          Tab(text: 'Предстоящие'),
          Tab(text: 'История'),
        ];
    }
  }

  List<Widget> _getTabViews() {
    switch (_currentMode) {
      case BookingMode.client:
        return [
          _buildBookingsList(_upcomingBookings),
          _buildBookingsList(_pastBookings),
        ];
      case BookingMode.master:
        return [
          _buildBookingsList(_pendingMasterBookings,
              masterActionType: 'pending'),
          _buildBookingsList(_confirmedMasterBookings,
              masterActionType: 'confirmed'),
          _buildBookingsList(_completedMasterBookings,
              masterActionType: 'history'),
        ];
      case BookingMode.all:
        return [
          _buildBookingsList(_upcomingBookings),
          _buildBookingsList(_pastBookings),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Записи'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(96),
          child: Column(
            children: [
              _buildModeSwitcher(),
              TabBar(
                controller: _tabController,
                tabs: _getTabs(),
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _getTabViews(),
      ),
      floatingActionButton: _currentMode == BookingMode.client
          ? FloatingActionButton.extended(
              onPressed: () => context.go('/search'),
              icon: const Icon(Icons.add),
              label: const Text('Новая запись'),
            )
          : null,
    );
  }
}
