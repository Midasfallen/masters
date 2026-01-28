import 'package:freezed_annotation/freezed_annotation.dart';

part 'auto_proposal_model.freezed.dart';
part 'auto_proposal_model.g.dart';

enum ProposalStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('accepted')
  accepted,
  @JsonValue('rejected')
  rejected,
  @JsonValue('expired')
  expired,
}

@freezed
class MatchReasonsModel with _$MatchReasonsModel {
  const factory MatchReasonsModel({
    double? locationScore,
    double? ratingScore,
    double? priceScore,
    double? availabilityScore,
    double? historyScore,
    @Default([]) List<String> reasons,
  }) = _MatchReasonsModel;

  factory MatchReasonsModel.fromJson(Map<String, dynamic> json) =>
      _$MatchReasonsModelFromJson(json);
}

@freezed
class ProposalMasterModel with _$ProposalMasterModel {
  const factory ProposalMasterModel({
    required String id,
    required String firstName,
    required String lastName,
    String? avatarUrl,
    double? rating,
  }) = _ProposalMasterModel;

  factory ProposalMasterModel.fromJson(Map<String, dynamic> json) =>
      _$ProposalMasterModelFromJson(json);
}

@freezed
class ProposalServiceModel with _$ProposalServiceModel {
  const factory ProposalServiceModel({
    required String id,
    required String title,
    required double price,
    required int durationMinutes,
  }) = _ProposalServiceModel;

  factory ProposalServiceModel.fromJson(Map<String, dynamic> json) =>
      _$ProposalServiceModelFromJson(json);
}

@freezed
class TimeSlotModel with _$TimeSlotModel {
  const factory TimeSlotModel({
    required int dayOfWeek,
    required int startHour,
    required int endHour,
  }) = _TimeSlotModel;

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) =>
      _$TimeSlotModelFromJson(json);
}

@freezed
class AutoProposalSettingsModel with _$AutoProposalSettingsModel {
  const factory AutoProposalSettingsModel({
    required String id,
    required String userId,
    required bool isEnabled,
    required int intervalDays,
    @Default([]) List<String> preferredCategories,
    double? maxPrice,
    required int maxDistanceKm,
    required double minRating,
    @Default([]) List<TimeSlotModel> preferredTimeSlots,
    DateTime? lastProposalAt,
    DateTime? nextProposalAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AutoProposalSettingsModel;

  factory AutoProposalSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$AutoProposalSettingsModelFromJson(json);
}

@freezed
class UpdateAutoProposalSettingsDto with _$UpdateAutoProposalSettingsDto {
  const factory UpdateAutoProposalSettingsDto({
    bool? isEnabled,
    int? intervalDays,
    List<String>? preferredCategories,
    double? maxPrice,
    int? maxDistanceKm,
    double? minRating,
    List<TimeSlotModel>? preferredTimeSlots,
  }) = _UpdateAutoProposalSettingsDto;

  factory UpdateAutoProposalSettingsDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateAutoProposalSettingsDtoFromJson(json);
}

@freezed
class AcceptProposalDto with _$AcceptProposalDto {
  const factory AcceptProposalDto({
    @JsonKey(name: 'preferred_datetime') String? preferredDatetime,
    String? comment,
  }) = _AcceptProposalDto;

  factory AcceptProposalDto.fromJson(Map<String, dynamic> json) =>
      _$AcceptProposalDtoFromJson(json);
}

@freezed
class AutoProposalModel with _$AutoProposalModel {
  const factory AutoProposalModel({
    required String id,
    required String userId,
    required String masterId,
    required String serviceId,
    required String categoryId,
    required ProposalStatus status,
    required int matchScore,
    required MatchReasonsModel matchReasons,
    DateTime? proposedDatetime,
    required DateTime expiresAt,
    String? bookingId,
    required DateTime createdAt,
    ProposalMasterModel? master,
    ProposalServiceModel? service,
  }) = _AutoProposalModel;

  factory AutoProposalModel.fromJson(Map<String, dynamic> json) =>
      _$AutoProposalModelFromJson(json);
}
