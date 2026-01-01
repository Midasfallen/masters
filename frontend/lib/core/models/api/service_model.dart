import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_model.freezed.dart';
part 'service_model.g.dart';

@freezed
class ServiceModel with _$ServiceModel {
  const factory ServiceModel({
    required String id,
    @JsonKey(name: 'master_id') required String masterId,
    @JsonKey(name: 'category_id') required String categoryId,
    @JsonKey(name: 'subcategory_id') String? subcategoryId,
    required String name,
    String? description,
    required double price,
    required String currency,
    @JsonKey(name: 'price_from') double? priceFrom,
    @JsonKey(name: 'price_to') double? priceTo,
    @JsonKey(name: 'duration_minutes') required int durationMinutes,
    @JsonKey(name: 'is_bookable_online') required bool isBookableOnline,
    @JsonKey(name: 'is_mobile') required bool isMobile,
    @JsonKey(name: 'is_in_salon') required bool isInSalon,
    required List<String> tags,
    @JsonKey(name: 'photo_urls') required List<String> photoUrls,
    @JsonKey(name: 'bookings_count') required int bookingsCount,
    @JsonKey(name: 'average_rating') required double averageRating,
    @JsonKey(name: 'is_active') required bool isActive,
    @JsonKey(name: 'display_order') required int displayOrder,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _ServiceModel;

  factory ServiceModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceModelFromJson(json);
}

/// Create Service Request
@freezed
class CreateServiceRequest with _$CreateServiceRequest {
  const factory CreateServiceRequest({
    @JsonKey(name: 'category_id') required String categoryId,
    @JsonKey(name: 'subcategory_id') String? subcategoryId,
    required String name,
    String? description,
    required double price,
    String? currency,
    @JsonKey(name: 'price_from') double? priceFrom,
    @JsonKey(name: 'price_to') double? priceTo,
    @JsonKey(name: 'duration_minutes') required int durationMinutes,
    @JsonKey(name: 'is_bookable_online') bool? isBookableOnline,
    @JsonKey(name: 'is_mobile') bool? isMobile,
    @JsonKey(name: 'is_in_salon') bool? isInSalon,
    List<String>? tags,
  }) = _CreateServiceRequest;

  factory CreateServiceRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateServiceRequestFromJson(json);
}

/// Update Service Request
@freezed
class UpdateServiceRequest with _$UpdateServiceRequest {
  const factory UpdateServiceRequest({
    String? name,
    String? description,
    double? price,
    @JsonKey(name: 'price_from') double? priceFrom,
    @JsonKey(name: 'price_to') double? priceTo,
    @JsonKey(name: 'duration_minutes') int? durationMinutes,
    @JsonKey(name: 'is_bookable_online') bool? isBookableOnline,
    @JsonKey(name: 'is_mobile') bool? isMobile,
    @JsonKey(name: 'is_in_salon') bool? isInSalon,
    List<String>? tags,
    @JsonKey(name: 'is_active') bool? isActive,
    @JsonKey(name: 'display_order') int? displayOrder,
  }) = _UpdateServiceRequest;

  factory UpdateServiceRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateServiceRequestFromJson(json);
}
