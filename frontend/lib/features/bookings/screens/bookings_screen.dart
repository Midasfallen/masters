import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/models/booking.dart';
import '../../../shared/widgets/booking_card.dart';
import '../../../data/mock/mock_bookings.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Booking> _bookings = mockBookings;

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
                _bookings = _bookings.map((b) {
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

  Widget _buildBookingsList(List<Booking> bookings) {
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
        return BookingCard(
          booking: booking,
          onTap: () {
            // Show booking details
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Запись #${booking.id}')),
            );
          },
          onCancel:
              booking.status == BookingStatus.pending ||
                      booking.status == BookingStatus.confirmed
                  ? () => _cancelBooking(booking)
                  : null,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои записи'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Предстоящие'),
            Tab(text: 'История'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBookingsList(_upcomingBookings),
          _buildBookingsList(_pastBookings),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/search'),
        icon: const Icon(Icons.add),
        label: const Text('Новая запись'),
      ),
    );
  }
}
