import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_platform/core/api/api_endpoints.dart';
import 'package:service_platform/core/api/api_exceptions.dart';
import 'package:service_platform/core/api/dio_client.dart';
import 'package:service_platform/core/models/api/review_model.dart';

part 'review_repository.g.dart';

/// Репозиторий отзывов. Создание отзыва по завершённому бронированию.
/// Бэк сам определяет направление (клиент→мастер / мастер→клиент) по booking.
class ReviewRepository {
  final DioClient _client;

  ReviewRepository(this._client);

  /// Создать отзыв. Только по COMPLETED-бронированию; повторный → 409.
  Future<ReviewModel> createReview(CreateReviewRequest request) async {
    try {
      final response = await _client.post(
        ApiEndpoints.reviewCreate,
        data: request.toJson(),
      );
      return ReviewModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioError(e);
    }
  }
}

@riverpod
ReviewRepository reviewRepository(ReviewRepositoryRef ref) {
  final client = ref.watch(dioClientProvider);
  return ReviewRepository(client);
}
