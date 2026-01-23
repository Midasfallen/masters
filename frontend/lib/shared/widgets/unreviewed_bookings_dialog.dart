import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/models/unreviewed_booking.dart';
import '../../core/repositories/review_reminders_repository.dart';

/// Result of the unreviewed bookings dialog
enum ReviewReminderAction {
  /// User chose to leave reviews
  leaveReviews,

  /// User chose to skip normally
  skip,

  /// User chose to skip using grace period (one-time free skip)
  skipWithGrace,
}

/// Dialog that displays a list of unreviewed bookings
/// and prompts the user to leave reviews
class UnreviewedBookingsDialog extends ConsumerStatefulWidget {
  final List<UnreviewedBooking> bookings;

  const UnreviewedBookingsDialog({
    super.key,
    required this.bookings,
  });

  @override
  ConsumerState<UnreviewedBookingsDialog> createState() =>
      _UnreviewedBookingsDialogState();
}

class _UnreviewedBookingsDialogState
    extends ConsumerState<UnreviewedBookingsDialog> {
  bool _isLoading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Определяем максимальное количество напоминаний среди всех бронирований
    final maxReminderCount = widget.bookings.fold<int>(
      0,
      (max, booking) => booking.reminderCount > max ? booking.reminderCount : max,
    );

    // Можно ли пропустить (после 3+ напоминаний)
    final canSkip = maxReminderCount >= 3;

    // Есть ли хотя бы одно бронирование с доступным grace period
    final hasGraceAvailable =
        widget.bookings.any((b) => !b.graceSkipAllowed);

    return AlertDialog(
      icon: Icon(
        Icons.rate_review_outlined,
        size: 48,
        color: theme.colorScheme.primary,
      ),
      title: const Text(
        'Оставьте отзывы',
        textAlign: TextAlign.center,
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'У вас ${_pluralBookings(widget.bookings.length)} без отзывов.',
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            if (_error != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline,
                        color: theme.colorScheme.onErrorContainer),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _error!,
                        style: TextStyle(
                          color: theme.colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: widget.bookings.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final booking = widget.bookings[index];
                  return _BookingCard(booking: booking);
                },
              ),
            ),
            const SizedBox(height: 16),
            if (hasGraceAvailable) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 20,
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Вы можете один раз напомнить позже без последствий',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ] else if (canSkip) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_outlined,
                      size: 20,
                      color: theme.colorScheme.onTertiaryContainer,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Вы уже использовали возможность напомнить позже',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onTertiaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        if (canSkip)
          TextButton(
            onPressed: _isLoading ? null : () => _handleSkip(false),
            child: _isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Пропустить'),
          ),
        if (hasGraceAvailable)
          TextButton(
            onPressed: _isLoading ? null : () => _handleSkip(true),
            child: const Text('Напомнить позже'),
          ),
        FilledButton(
          onPressed: _isLoading
              ? null
              : () => Navigator.of(context).pop(ReviewReminderAction.leaveReviews),
          child: const Text('Оставить отзывы'),
        ),
      ],
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
    );
  }

  Future<void> _handleSkip(bool useGracePeriod) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final repository = ref.read(reviewRemindersRepositoryProvider);

      // Пропускаем все неотзывленные бронирования
      for (final booking in widget.bookings) {
        // Используем grace period только если он еще доступен для этого бронирования
        final canUseGrace = useGracePeriod && !booking.graceSkipAllowed;
        await repository.skipReview(
          booking.id,
          isGracePeriod: canUseGrace,
        );
      }

      if (mounted) {
        Navigator.of(context).pop(
          useGracePeriod
              ? ReviewReminderAction.skipWithGrace
              : ReviewReminderAction.skip,
        );
      }
    } catch (e) {
      setState(() {
        _error = 'Ошибка при пропуске: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  String _pluralBookings(int count) {
    if (count == 1) return 'есть 1 завершённая запись';
    if (count >= 2 && count <= 4) return 'есть $count завершённые записи';
    return 'есть $count завершённых записей';
  }
}

class _BookingCard extends StatelessWidget {
  final UnreviewedBooking booking;

  const _BookingCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('d MMM yyyy, HH:mm', 'ru');

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    booking.serviceName ?? 'Услуга',
                    style: theme.textTheme.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (booking.reminderCount > 0) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: booking.reminderCount >= 3
                          ? theme.colorScheme.errorContainer
                          : theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${booking.reminderCount}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: booking.reminderCount >= 3
                            ? theme.colorScheme.onErrorContainer
                            : theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 4),
            Text(
              booking.reviewTargetName,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Text(
              dateFormat.format(booking.endTime),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Extension for easy dialog showing
extension UnreviewedBookingsDialogExtension on BuildContext {
  Future<ReviewReminderAction?> showUnreviewedBookingsDialog({
    required List<UnreviewedBooking> bookings,
  }) {
    return showDialog<ReviewReminderAction>(
      context: this,
      barrierDismissible: false,
      builder: (context) => UnreviewedBookingsDialog(
        bookings: bookings,
      ),
    );
  }
}
