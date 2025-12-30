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
    String? businessName,
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

/// Create Master Profile Request
@freezed
class CreateMasterProfileRequest with _$CreateMasterProfileRequest {
  const factory CreateMasterProfileRequest({
    String? businessName,
    String? bio,
    required List<String> categoryIds,
    List<String>? subcategoryIds,
    String? locationAddress,
    double? locationLat,
    double? locationLng,
    int? serviceRadiusKm,
    bool? isMobile,
    bool? hasLocation,
    bool? isOnlineOnly,
    Map<String, String>? socialLinks,
    Map<String, dynamic>? workingHours,
    int? yearsOfExperience,
    List<String>? languages,
  }) = _CreateMasterProfileRequest;

  factory CreateMasterProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateMasterProfileRequestFromJson(json);
}

/// Update Master Profile Request
@freezed
class UpdateMasterProfileRequest with _$UpdateMasterProfileRequest {
  const factory UpdateMasterProfileRequest({
    String? businessName,
    String? bio,
    List<String>? categoryIds,
    List<String>? subcategoryIds,
    String? locationAddress,
    double? locationLat,
    double? locationLng,
    int? serviceRadiusKm,
    bool? isMobile,
    bool? hasLocation,
    bool? isOnlineOnly,
    Map<String, String>? socialLinks,
    Map<String, dynamic>? workingHours,
    int? minBookingHours,
    int? maxBookingsPerDay,
    bool? autoConfirm,
    int? yearsOfExperience,
    List<String>? languages,
    bool? isActive,
    int? setupStep,
  }) = _UpdateMasterProfileRequest;

  factory UpdateMasterProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateMasterProfileRequestFromJson(json);
}
