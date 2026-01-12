import 'package:freezed_annotation/freezed_annotation.dart';

part 'auto_proposal_model.freezed.dart';
part 'auto_proposal_model.g.dart';

/// Статус предложения
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

/// Интервал предложений
enum ProposalInterval {
  @JsonValue(7)
  weekly(7),
  @JsonValue(14)
  biweekly(14),
  @JsonValue(21)
  triweekly(21),
  @JsonValue(30)
  monthly(30);

  const ProposalInterval(this.days);
  final int days;
}

/// Причины совместимости
@freezed
class MatchReasons with _$MatchReasons {
  const factory MatchReasons({
    @JsonKey(name: 'location_score') double? locationScore,
    @JsonKey(name: 'rating_score') double? ratingScore,
    @JsonKey(name: 'price_score') double? priceScore,
    @JsonKey(name: 'availability_score') double? availabilityScore,
    @JsonKey(name: 'history_score') double? historyScore,
    @Default([]) List<String> reasons,
  }) = _MatchReasons;

  factory MatchReasons.fromJson(Map<String, dynamic> json) =>
      _$MatchReasonsFromJson(json);
}

/// Информация о мастере в предложении
@freezed
class ProposalMaster with _$ProposalMaster {
  const factory ProposalMaster({
    required String id,
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') required String lastName,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    double? rating,
  }) = _ProposalMaster;

  factory ProposalMaster.fromJson(Map<String, dynamic> json) =>
      _$ProposalMasterFromJson(json);
}

/// Информация об услуге в предложении
@freezed
class ProposalService with _$ProposalService {
  const factory ProposalService({
    required String id,
    required String title,
    required double price,
    @JsonKey(name: 'duration_minutes') required int durationMinutes,
  }) = _ProposalService;

  factory ProposalService.fromJson(Map<String, dynamic> json) =>
      _$ProposalServiceFromJson(json);
}

/// Автоматическое предложение
@freezed
class AutoProposalModel with _$AutoProposalModel {
  const factory AutoProposalModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'master_id') required String masterId,
    @JsonKey(name: 'service_id') required String serviceId,
    @JsonKey(name: 'category_id') required String categoryId,
    required ProposalStatus status,
    @JsonKey(name: 'match_score') @Default(0) int matchScore,
    @JsonKey(name: 'match_reasons') required MatchReasons matchReasons,
    @JsonKey(name: 'proposed_datetime') DateTime? proposedDatetime,
    @JsonKey(name: 'expires_at') required DateTime expiresAt,
    @JsonKey(name: 'booking_id') String? bookingId,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    ProposalMaster? master,
    ProposalService? service,
  }) = _AutoProposalModel;

  factory AutoProposalModel.fromJson(Map<String, dynamic> json) =>
      _$AutoProposalModelFromJson(json);
}

/// Временной слот для предпочтений
@freezed
class PreferredTimeSlot with _$PreferredTimeSlot {
  const factory PreferredTimeSlot({
    @JsonKey(name: 'day_of_week') required int dayOfWeek, // 0 = Sunday, 6 = Saturday
    @JsonKey(name: 'start_hour') required int startHour, // 0-23
    @JsonKey(name: 'end_hour') required int endHour, // 0-23
  }) = _PreferredTimeSlot;

  factory PreferredTimeSlot.fromJson(Map<String, dynamic> json) =>
      _$PreferredTimeSlotFromJson(json);
}

/// Настройки автоматических предложений
@freezed
class AutoProposalSettingsModel with _$AutoProposalSettingsModel {
  const factory AutoProposalSettingsModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'is_enabled') @Default(true) bool isEnabled,
    @JsonKey(name: 'interval_days') @Default(ProposalInterval.weekly) ProposalInterval intervalDays,
    @JsonKey(name: 'preferred_categories') List<String>? preferredCategories,
    @JsonKey(name: 'max_price') double? maxPrice,
    @JsonKey(name: 'max_distance_km') @Default(10) int maxDistanceKm,
    @JsonKey(name: 'min_rating') @Default(4.0) double minRating,
    @JsonKey(name: 'preferred_time_slots') List<PreferredTimeSlot>? preferredTimeSlots,
    @JsonKey(name: 'last_proposal_at') DateTime? lastProposalAt,
    @JsonKey(name: 'next_proposal_at') DateTime? nextProposalAt,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _AutoProposalSettingsModel;

  factory AutoProposalSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$AutoProposalSettingsModelFromJson(json);
}

/// DTO для обновления настроек
@freezed
class UpdateAutoProposalSettingsDto with _$UpdateAutoProposalSettingsDto {
  const factory UpdateAutoProposalSettingsDto({
    @JsonKey(name: 'is_enabled') bool? isEnabled,
    @JsonKey(name: 'interval_days') ProposalInterval? intervalDays,
    @JsonKey(name: 'preferred_categories') List<String>? preferredCategories,
    @JsonKey(name: 'max_price') double? maxPrice,
    @JsonKey(name: 'max_distance_km') int? maxDistanceKm,
    @JsonKey(name: 'min_rating') double? minRating,
    @JsonKey(name: 'preferred_time_slots') List<PreferredTimeSlot>? preferredTimeSlots,
  }) = _UpdateAutoProposalSettingsDto;

  factory UpdateAutoProposalSettingsDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateAutoProposalSettingsDtoFromJson(json);

  Map<String, dynamic> toJson() => {};
}

/// DTO для принятия предложения
@freezed
class AcceptProposalDto with _$AcceptProposalDto {
  const factory AcceptProposalDto({
    @JsonKey(name: 'proposed_datetime') required DateTime proposedDatetime,
    String? notes,
  }) = _AcceptProposalDto;

  factory AcceptProposalDto.fromJson(Map<String, dynamic> json) =>
      _$AcceptProposalDtoFromJson(json);

  Map<String, dynamic> toJson() => {};
}
