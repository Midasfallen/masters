// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_proposal_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MatchReasonsImpl _$$MatchReasonsImplFromJson(Map<String, dynamic> json) =>
    _$MatchReasonsImpl(
      locationScore: (json['location_score'] as num?)?.toDouble(),
      ratingScore: (json['rating_score'] as num?)?.toDouble(),
      priceScore: (json['price_score'] as num?)?.toDouble(),
      availabilityScore: (json['availability_score'] as num?)?.toDouble(),
      historyScore: (json['history_score'] as num?)?.toDouble(),
      reasons: (json['reasons'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$MatchReasonsImplToJson(_$MatchReasonsImpl instance) =>
    <String, dynamic>{
      'location_score': instance.locationScore,
      'rating_score': instance.ratingScore,
      'price_score': instance.priceScore,
      'availability_score': instance.availabilityScore,
      'history_score': instance.historyScore,
      'reasons': instance.reasons,
    };

_$ProposalMasterImpl _$$ProposalMasterImplFromJson(Map<String, dynamic> json) =>
    _$ProposalMasterImpl(
      id: json['id'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      avatarUrl: json['avatar_url'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$ProposalMasterImplToJson(
        _$ProposalMasterImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'avatar_url': instance.avatarUrl,
      'rating': instance.rating,
    };

_$ProposalServiceImpl _$$ProposalServiceImplFromJson(
        Map<String, dynamic> json) =>
    _$ProposalServiceImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      durationMinutes: (json['duration_minutes'] as num).toInt(),
    );

Map<String, dynamic> _$$ProposalServiceImplToJson(
        _$ProposalServiceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'price': instance.price,
      'duration_minutes': instance.durationMinutes,
    };

_$AutoProposalModelImpl _$$AutoProposalModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AutoProposalModelImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      masterId: json['master_id'] as String,
      serviceId: json['service_id'] as String,
      categoryId: json['category_id'] as String,
      status: $enumDecode(_$ProposalStatusEnumMap, json['status']),
      matchScore: (json['match_score'] as num?)?.toInt() ?? 0,
      matchReasons:
          MatchReasons.fromJson(json['match_reasons'] as Map<String, dynamic>),
      proposedDatetime: json['proposed_datetime'] == null
          ? null
          : DateTime.parse(json['proposed_datetime'] as String),
      expiresAt: DateTime.parse(json['expires_at'] as String),
      bookingId: json['booking_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      master: json['master'] == null
          ? null
          : ProposalMaster.fromJson(json['master'] as Map<String, dynamic>),
      service: json['service'] == null
          ? null
          : ProposalService.fromJson(json['service'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AutoProposalModelImplToJson(
        _$AutoProposalModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'master_id': instance.masterId,
      'service_id': instance.serviceId,
      'category_id': instance.categoryId,
      'status': _$ProposalStatusEnumMap[instance.status]!,
      'match_score': instance.matchScore,
      'match_reasons': instance.matchReasons,
      'proposed_datetime': instance.proposedDatetime?.toIso8601String(),
      'expires_at': instance.expiresAt.toIso8601String(),
      'booking_id': instance.bookingId,
      'created_at': instance.createdAt.toIso8601String(),
      'master': instance.master,
      'service': instance.service,
    };

const _$ProposalStatusEnumMap = {
  ProposalStatus.pending: 'pending',
  ProposalStatus.accepted: 'accepted',
  ProposalStatus.rejected: 'rejected',
  ProposalStatus.expired: 'expired',
};

_$PreferredTimeSlotImpl _$$PreferredTimeSlotImplFromJson(
        Map<String, dynamic> json) =>
    _$PreferredTimeSlotImpl(
      dayOfWeek: (json['day_of_week'] as num).toInt(),
      startHour: (json['start_hour'] as num).toInt(),
      endHour: (json['end_hour'] as num).toInt(),
    );

Map<String, dynamic> _$$PreferredTimeSlotImplToJson(
        _$PreferredTimeSlotImpl instance) =>
    <String, dynamic>{
      'day_of_week': instance.dayOfWeek,
      'start_hour': instance.startHour,
      'end_hour': instance.endHour,
    };

_$AutoProposalSettingsModelImpl _$$AutoProposalSettingsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AutoProposalSettingsModelImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      isEnabled: json['is_enabled'] as bool? ?? true,
      intervalDays: $enumDecodeNullable(
              _$ProposalIntervalEnumMap, json['interval_days']) ??
          ProposalInterval.weekly,
      preferredCategories: (json['preferred_categories'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      maxPrice: (json['max_price'] as num?)?.toDouble(),
      maxDistanceKm: (json['max_distance_km'] as num?)?.toInt() ?? 10,
      minRating: (json['min_rating'] as num?)?.toDouble() ?? 4.0,
      preferredTimeSlots: (json['preferred_time_slots'] as List<dynamic>?)
          ?.map((e) => PreferredTimeSlot.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastProposalAt: json['last_proposal_at'] == null
          ? null
          : DateTime.parse(json['last_proposal_at'] as String),
      nextProposalAt: json['next_proposal_at'] == null
          ? null
          : DateTime.parse(json['next_proposal_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$AutoProposalSettingsModelImplToJson(
        _$AutoProposalSettingsModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'is_enabled': instance.isEnabled,
      'interval_days': _$ProposalIntervalEnumMap[instance.intervalDays]!,
      'preferred_categories': instance.preferredCategories,
      'max_price': instance.maxPrice,
      'max_distance_km': instance.maxDistanceKm,
      'min_rating': instance.minRating,
      'preferred_time_slots': instance.preferredTimeSlots,
      'last_proposal_at': instance.lastProposalAt?.toIso8601String(),
      'next_proposal_at': instance.nextProposalAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$ProposalIntervalEnumMap = {
  ProposalInterval.weekly: 7,
  ProposalInterval.biweekly: 14,
  ProposalInterval.triweekly: 21,
  ProposalInterval.monthly: 30,
};

_$UpdateAutoProposalSettingsDtoImpl
    _$$UpdateAutoProposalSettingsDtoImplFromJson(Map<String, dynamic> json) =>
        _$UpdateAutoProposalSettingsDtoImpl(
          isEnabled: json['is_enabled'] as bool?,
          intervalDays: $enumDecodeNullable(
              _$ProposalIntervalEnumMap, json['interval_days']),
          preferredCategories: (json['preferred_categories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
          maxPrice: (json['max_price'] as num?)?.toDouble(),
          maxDistanceKm: (json['max_distance_km'] as num?)?.toInt(),
          minRating: (json['min_rating'] as num?)?.toDouble(),
          preferredTimeSlots: (json['preferred_time_slots'] as List<dynamic>?)
              ?.map(
                  (e) => PreferredTimeSlot.fromJson(e as Map<String, dynamic>))
              .toList(),
        );

Map<String, dynamic> _$$UpdateAutoProposalSettingsDtoImplToJson(
        _$UpdateAutoProposalSettingsDtoImpl instance) =>
    <String, dynamic>{
      'is_enabled': instance.isEnabled,
      'interval_days': _$ProposalIntervalEnumMap[instance.intervalDays],
      'preferred_categories': instance.preferredCategories,
      'max_price': instance.maxPrice,
      'max_distance_km': instance.maxDistanceKm,
      'min_rating': instance.minRating,
      'preferred_time_slots': instance.preferredTimeSlots,
    };

_$AcceptProposalDtoImpl _$$AcceptProposalDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$AcceptProposalDtoImpl(
      proposedDatetime: DateTime.parse(json['proposed_datetime'] as String),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$AcceptProposalDtoImplToJson(
        _$AcceptProposalDtoImpl instance) =>
    <String, dynamic>{
      'proposed_datetime': instance.proposedDatetime.toIso8601String(),
      'notes': instance.notes,
    };
