import { Injectable, Logger } from '@nestjs/common';
import { Cron, CronExpression } from '@nestjs/schedule';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, LessThan } from 'typeorm';
import { Booking, BookingStatus } from '../bookings/entities/booking.entity';
import { ReviewReminder } from '../reviews/entities/review-reminder.entity';
import { NotificationsService } from '../notifications/notifications.service';

@Injectable()
export class ReviewRemindersScheduler {
  private readonly logger = new Logger(ReviewRemindersScheduler.name);

  constructor(
    @InjectRepository(Booking)
    private readonly bookingRepository: Repository<Booking>,
    @InjectRepository(ReviewReminder)
    private readonly reviewReminderRepository: Repository<ReviewReminder>,
    private readonly notificationsService: NotificationsService,
  ) {}

  /**
   * Runs every day at 10:00 AM to check for unreviewed bookings
   * and send reminders to users
   */
  @Cron(CronExpression.EVERY_DAY_AT_10AM)
  async handleReviewReminders() {
    this.logger.log('Starting review reminders check...');

    try {
      // Find all completed bookings without reviews older than 24 hours
      const oneDayAgo = new Date();
      oneDayAgo.setHours(oneDayAgo.getHours() - 24);

      const unreviewedBookings = await this.bookingRepository.find({
        where: {
          status: BookingStatus.COMPLETED,
        },
        relations: ['client', 'master', 'service'],
      });

      this.logger.log(
        `Found ${unreviewedBookings.length} completed bookings to check`,
      );

      let remindersSent = 0;

      for (const booking of unreviewedBookings) {
        // Skip if booking ended less than 24 hours ago
        if (booking.end_time > oneDayAgo) {
          continue;
        }

        // Process reminder for client if they haven't reviewed
        if (!booking.client_review_left) {
          const sent = await this.processReminderForUser(
            booking.client_id,
            booking.id,
            booking,
          );
          if (sent) remindersSent++;
        }

        // Process reminder for master if they haven't reviewed
        if (!booking.master_review_left) {
          const sent = await this.processReminderForUser(
            booking.master_id,
            booking.id,
            booking,
          );
          if (sent) remindersSent++;
        }
      }

      this.logger.log(
        `Review reminders check completed. Sent ${remindersSent} reminders.`,
      );
    } catch (error) {
      this.logger.error('Error processing review reminders', error.stack);
    }
  }

  /**
   * Process reminder for a specific user
   * Returns true if reminder was sent
   */
  private async processReminderForUser(
    userId: string,
    bookingId: string,
    booking: Booking,
  ): Promise<boolean> {
    try {
      // Find or create reminder
      let reminder = await this.reviewReminderRepository.findOne({
        where: { user_id: userId, booking_id: bookingId },
      });

      if (!reminder) {
        // Create new reminder
        reminder = this.reviewReminderRepository.create({
          user_id: userId,
          booking_id: bookingId,
          reminder_count: 0,
          grace_skip_allowed: false,
          last_reminded_at: null,
        });
      }

      // Check if we should send a reminder
      const shouldSend = this.shouldSendReminder(reminder);

      if (shouldSend) {
        // Update reminder
        reminder.reminder_count += 1;
        reminder.last_reminded_at = new Date();
        await this.reviewReminderRepository.save(reminder);

        // Send notification
        await this.sendReminderNotification(userId, booking, reminder);

        this.logger.debug(
          `Sent reminder #${reminder.reminder_count} to user ${userId} for booking ${bookingId}`,
        );

        return true;
      }

      return false;
    } catch (error) {
      this.logger.error(
        `Error processing reminder for user ${userId}`,
        error.stack,
      );
      return false;
    }
  }

  /**
   * Determine if a reminder should be sent based on reminder history
   */
  private shouldSendReminder(reminder: ReviewReminder): boolean {
    // If no reminder has been sent yet, send it
    if (!reminder.last_reminded_at) {
      return true;
    }

    const now = new Date();
    const lastReminded = new Date(reminder.last_reminded_at);
    const hoursSinceLastReminder =
      (now.getTime() - lastReminded.getTime()) / (1000 * 60 * 60);

    // Send reminder based on count and time since last reminder
    if (reminder.reminder_count === 0) {
      // First reminder - send after 24 hours
      return hoursSinceLastReminder >= 24;
    } else if (reminder.reminder_count === 1) {
      // Second reminder - send after 48 hours
      return hoursSinceLastReminder >= 48;
    } else if (reminder.reminder_count === 2) {
      // Third reminder - send after 72 hours
      return hoursSinceLastReminder >= 72;
    } else if (reminder.reminder_count >= 3 && reminder.reminder_count < 7) {
      // Reminders 4-7 - send weekly
      return hoursSinceLastReminder >= 24 * 7;
    }

    // After 7 reminders, stop sending
    return false;
  }

  /**
   * Send reminder notification to user
   */
  private async sendReminderNotification(
    userId: string,
    booking: Booking,
    reminder: ReviewReminder,
  ) {
    const serviceName = booking.service?.name || 'услугу';

    let title: string;
    let body: string;

    if (reminder.reminder_count === 1) {
      title = 'Не забудьте оставить отзыв';
      body = `Пожалуйста, оставьте отзыв о посещении "${serviceName}"`;
    } else if (reminder.reminder_count === 2) {
      title = 'Напоминание об отзыве';
      body = `Мы ждем ваш отзыв о посещении "${serviceName}". Это займет всего минуту!`;
    } else {
      title = 'Последнее напоминание об отзыве';
      body = `Пожалуйста, поделитесь своим опытом посещения "${serviceName}"`;
    }

    try {
      await this.notificationsService.create(
        userId,
        'review_reminder' as any,
        title,
        body,
        {
          related_id: booking.id,
          related_type: 'booking',
          action_url: `/bookings/${booking.id}/review`,
        },
      );
    } catch (error) {
      this.logger.error(
        `Failed to send notification to user ${userId}`,
        error.stack,
      );
    }
  }
}
