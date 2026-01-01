import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:service_platform/core/models/api/user_model.dart';
import 'package:service_platform/core/models/api/service_model.dart';

part 'master_model.freezed.dart';
part 'master_model.g.dart';

@freezed
class MasterProfileModel with _$MasterProfileModel {
  const factory MasterProfileModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    UserModel? user,
    @JsonKey(name: 'business_name') String? businessName,
    String? bio,
    @JsonKey(name: 'category_ids') required List<String> categoryIds,
    @JsonKey(name: 'subcategory_ids') required List<String> subcategoryIds,
    required double rating,
    @JsonKey(name: 'reviews_count') required int reviewsCount,
    @JsonKey(name: 'completed_bookings') required int completedBookings,
    @JsonKey(name: 'cancellations_count') required int cancellationsCount,
    @JsonKey(name: 'views_count') required int viewsCount,
    @JsonKey(name: 'favorites_count') required int favoritesCount,
    @JsonKey(name: 'subscribers_count') required int subscribersCount,
    @JsonKey(name: 'location_lat') double? locationLat,
    @JsonKey(name: 'location_lng') double? locationLng,
    @JsonKey(name: 'location_address') String? locationAddress,
    @JsonKey(name: 'location_name') String? locationName,
    @JsonKey(name: 'service_radius_km') int? serviceRadiusKm,
    @JsonKey(name: 'is_mobile') required bool isMobile,
    @JsonKey(name: 'has_location') required bool hasLocation,
    @JsonKey(name: 'is_online_only') required bool isOnlineOnly,
    @JsonKey(name: 'portfolio_urls') required List<String> portfolioUrls,
    @JsonKey(name: 'video_urls') required List<String> videoUrls,
    @JsonKey(name: 'social_links') Map<String, String>? socialLinks,
    @JsonKey(name: 'working_hours') Map<String, dynamic>? workingHours,
    @JsonKey(name: 'min_booking_hours') required int minBookingHours,
    @JsonKey(name: 'max_bookings_per_day') int? maxBookingsPerDay,
    @JsonKey(name: 'auto_confirm') required bool autoConfirm,
    @JsonKey(name: 'years_of_experience') int? yearsOfExperience,
    required List<String> certificates,
    required List<String> languages,
    @JsonKey(name: 'is_active') required bool isActive,
    @JsonKey(name: 'is_approved') required bool isApproved,
    @JsonKey(name: 'setup_step') required int setupStep,
    List<ServiceModel>? services,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _MasterProfileModel;

  factory MasterProfileModel.fromJson(Map<String, dynamic> json) =>
      _$MasterProfileModelFromJson(json);
}

/// Create Master Profile Request
@freezed
class CreateMasterProfileRequest with _$CreateMasterProfileRequest {
  const factory CreateMasterProfileRequest({
    @JsonKey(name: 'business_name') String? businessName,
    String? bio,
    @JsonKey(name: 'category_ids') required List<String> categoryIds,
    @JsonKey(name: 'subcategory_ids') List<String>? subcategoryIds,
    @JsonKey(name: 'location_address') String? locationAddress,
    @JsonKey(name: 'location_lat') double? locationLat,
    @JsonKey(name: 'location_lng') double? locationLng,
    @JsonKey(name: 'service_radius_km') int? serviceRadiusKm,
    @JsonKey(name: 'is_mobile') bool? isMobile,
    @JsonKey(name: 'has_location') bool? hasLocation,
    @JsonKey(name: 'is_online_only') bool? isOnlineOnly,
    @JsonKey(name: 'social_links') Map<String, String>? socialLinks,
    @JsonKey(name: 'working_hours') Map<String, dynamic>? workingHours,
    @JsonKey(name: 'years_of_experience') int? yearsOfExperience,
    List<String>? languages,
  }) = _CreateMasterProfileRequest;

  factory CreateMasterProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateMasterProfileRequestFromJson(json);
}

/// Update Master Profile Request
@freezed
class UpdateMasterProfileRequest with _$UpdateMasterProfileRequest {
  const factory UpdateMasterProfileRequest({
    @JsonKey(name: 'business_name') String? businessName,
    String? bio,
    @JsonKey(name: 'category_ids') List<String>? categoryIds,
    @JsonKey(name: 'subcategory_ids') List<String>? subcategoryIds,
    @JsonKey(name: 'location_address') String? locationAddress,
    @JsonKey(name: 'location_lat') double? locationLat,
    @JsonKey(name: 'location_lng') double? locationLng,
    @JsonKey(name: 'service_radius_km') int? serviceRadiusKm,
    @JsonKey(name: 'is_mobile') bool? isMobile,
    @JsonKey(name: 'has_location') bool? hasLocation,
    @JsonKey(name: 'is_online_only') bool? isOnlineOnly,
    @JsonKey(name: 'social_links') Map<String, String>? socialLinks,
    @JsonKey(name: 'working_hours') Map<String, dynamic>? workingHours,
    @JsonKey(name: 'min_booking_hours') int? minBookingHours,
    @JsonKey(name: 'max_bookings_per_day') int? maxBookingsPerDay,
    @JsonKey(name: 'auto_confirm') bool? autoConfirm,
    @JsonKey(name: 'years_of_experience') int? yearsOfExperience,
    List<String>? languages,
    @JsonKey(name: 'is_active') bool? isActive,
    @JsonKey(name: 'setup_step') int? setupStep,
  }) = _UpdateMasterProfileRequest;

  factory UpdateMasterProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateMasterProfileRequestFromJson(json);
}
