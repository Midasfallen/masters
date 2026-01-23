import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../api/dio_client.dart';
import '../models/unreviewed_booking.dart';
import '../models/skip_review_response.dart';

part 'review_reminders_repository.g.dart';

@riverpod
ReviewRemindersRepository reviewRemindersRepository(
    ReviewRemindersRepositoryRef ref) {
  return ReviewRemindersRepository(ref.watch(dioProvider));
}

class ReviewRemindersRepository {
  final Dio _dio;

  ReviewRemindersRepository(this._dio);

  /// Получить список неотзывленных бронирований
  Future<List<UnreviewedBooking>> getUnreviewedBookings() async {
    try {
      final response = await _dio.get('/reviews/unreviewed/bookings');
      return (response.data as List)
          .map((json) => UnreviewedBooking.fromJson(json))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Пропустить напоминание об отзыве
  Future<SkipReviewResponse> skipReview(
    String bookingId, {
    bool isGracePeriod = false,
  }) async {
    try {
      final response = await _dio.post(
        '/reviews/skip/$bookingId',
        data: {'isGracePeriod': isGracePeriod},
      );
      return SkipReviewResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
