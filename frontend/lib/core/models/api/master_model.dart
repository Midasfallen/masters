import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:service_platform/core/models/api/user_model.dart';
import 'package:service_platform/core/models/api/service_model.dart';

part 'master_model.freezed.dart';
part 'master_model.g.dart';

@freezed
class MasterProfileModel with _$MasterProfileModel {
  const factory MasterProfileModel({
    required String id,
    required String userId,
    UserModel? user,
    String? bio,
    required List<String> categoryIds,
    required List<String> subcategoryIds,
    required double rating,
    required int reviewsCount,
    required int completedBookings,
    required int cancellationsCount,
    required int viewsCount,
    required int favoritesCount,
    required int subscribersCount,
    double? locationLat,
    double? locationLng,
    String? locationAddress,
    String? locationName,
    int? serviceRadiusKm,
    required bool isMobile,
    required bool hasLocation,
    required bool isOnlineOnly,
    required List<String> portfolioUrls,
    required List<String> videoUrls,
    Map<String, String>? socialLinks,
    Map<String, dynamic>? workingHours,
    required int minBookingHours,
    int? maxBookingsPerDay,
    required bool autoConfirm,
    int? yearsOfExperience,
    required List<String> certificates,
    required List<String> languages,
    required bool isActive,
    required bool isApproved,
    required int setupStep,
    List<ServiceModel>? services,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _MasterProfileModel;

  factory MasterProfileModel.fromJson(Map<String, dynamic> json) =>
      _$MasterProfileModelFromJson(json);
}

/// Результат поиска мастера (упрощенная модель для поиска)
@freezed
class MasterSearchResultModel with _$MasterSearchResultModel {
  const factory MasterSearchResultModel({
    required String id,
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') required String lastName,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'average_rating') required double averageRating,
    @JsonKey(name: 'reviews_count') required int reviewsCount,
    @JsonKey(name: 'category_names') @Default([]) List<String> categoryNames,
    String? description,
    @Default([]) List<String> tags,
    @JsonKey(name: 'location_address') String? locationAddress,
    @JsonKey(name: 'distance_km') double? distanceKm,
  }) = _MasterSearchResultModel;

  factory MasterSearchResultModel.fromJson(Map<String, dynamic> json) =>
      _$MasterSearchResultModelFromJson(json);
}

/// Create Master Profile Request
@freezed
class CreateMasterProfileRequest with _$CreateMasterProfileRequest {
  const factory CreateMasterProfileRequest({
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
