import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_model.freezed.dart';
part 'service_model.g.dart';

@freezed
class ServiceModel with _$ServiceModel {
  const factory ServiceModel({
    required String id,
    required String masterId,
    required String categoryId,
    @JsonKey(name: 'service_template_id') String? serviceTemplateId,
    String? subcategoryId,
    required String name,
    String? description,
    required double price,
    required String currency,
    double? priceFrom,
    double? priceTo,
    required int durationMinutes,
    required bool isBookableOnline,
    required bool isMobile,
    required bool isInSalon,
    required List<String> tags,
    required List<String> photoUrls,
    required int bookingsCount,
    required double averageRating,
    required bool isActive,
    required int displayOrder,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ServiceModel;

  factory ServiceModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceModelFromJson(json);
}

/// Create Service Request
@freezed
class CreateServiceRequest with _$CreateServiceRequest {
  const factory CreateServiceRequest({
    @JsonKey(name: 'category_id') required String categoryId,
    @JsonKey(name: 'service_template_id') String? serviceTemplateId,
    @JsonKey(name: 'subcategory_id') String? subcategoryId,
    String? name,
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
