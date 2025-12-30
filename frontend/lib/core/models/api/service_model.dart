import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_model.freezed.dart';
part 'service_model.g.dart';

@freezed
class ServiceModel with _$ServiceModel {
  const factory ServiceModel({
    required String id,
    required String masterId,
    required String categoryId,
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
    required String categoryId,
    String? subcategoryId,
    required String name,
    String? description,
    required double price,
    String? currency,
    double? priceFrom,
    double? priceTo,
    required int durationMinutes,
    bool? isBookableOnline,
    bool? isMobile,
    bool? isInSalon,
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
    double? priceFrom,
    double? priceTo,
    int? durationMinutes,
    bool? isBookableOnline,
    bool? isMobile,
    bool? isInSalon,
    List<String>? tags,
    bool? isActive,
    int? displayOrder,
  }) = _UpdateServiceRequest;

  factory UpdateServiceRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateServiceRequestFromJson(json);
}
