// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_proposal_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MatchReasonsModelImpl _$$MatchReasonsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$MatchReasonsModelImpl(
      locationScore: (json['locationScore'] as num?)?.toDouble(),
      ratingScore: (json['ratingScore'] as num?)?.toDouble(),
      priceScore: (json['priceScore'] as num?)?.toDouble(),
      availabilityScore: (json['availabilityScore'] as num?)?.toDouble(),
      historyScore: (json['historyScore'] as num?)?.toDouble(),
      reasons: (json['reasons'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$MatchReasonsModelImplToJson(
        _$MatchReasonsModelImpl instance) =>
    <String, dynamic>{
      'locationScore': instance.locationScore,
      'ratingScore': instance.ratingScore,
      'priceScore': instance.priceScore,
      'availabilityScore': instance.availabilityScore,
      'historyScore': instance.historyScore,
      'reasons': instance.reasons,
    };

_$ProposalMasterModelImpl _$$ProposalMasterModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ProposalMasterModelImpl(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$ProposalMasterModelImplToJson(
        _$ProposalMasterModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'avatarUrl': instance.avatarUrl,
      'rating': instance.rating,
    };

_$ProposalServiceModelImpl _$$ProposalServiceModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ProposalServiceModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      durationMinutes: (json['durationMinutes'] as num).toInt(),
    );

Map<String, dynamic> _$$ProposalServiceModelImplToJson(
        _$ProposalServiceModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'price': instance.price,
      'durationMinutes': instance.durationMinutes,
    };

_$TimeSlotModelImpl _$$TimeSlotModelImplFromJson(Map<String, dynamic> json) =>
    _$TimeSlotModelImpl(
      dayOfWeek: (json['dayOfWeek'] as num).toInt(),
      startHour: (json['startHour'] as num).toInt(),
      endHour: (json['endHour'] as num).toInt(),
    );

Map<String, dynamic> _$$TimeSlotModelImplToJson(_$TimeSlotModelImpl instance) =>
    <String, dynamic>{
      'dayOfWeek': instance.dayOfWeek,
      'startHour': instance.startHour,
      'endHour': instance.endHour,
    };

_$AutoProposalSettingsModelImpl _$$AutoProposalSettingsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AutoProposalSettingsModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      isEnabled: json['isEnabled'] as bool,
      intervalDays: (json['intervalDays'] as num).toInt(),
      preferredCategories: (json['preferredCategories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      maxPrice: (json['maxPrice'] as num?)?.toDouble(),
      maxDistanceKm: (json['maxDistanceKm'] as num).toInt(),
      minRating: (json['minRating'] as num).toDouble(),
      preferredTimeSlots: (json['preferredTimeSlots'] as List<dynamic>?)
              ?.map((e) => TimeSlotModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      lastProposalAt: json['lastProposalAt'] == null
          ? null
          : DateTime.parse(json['lastProposalAt'] as String),
      nextProposalAt: json['nextProposalAt'] == null
          ? null
          : DateTime.parse(json['nextProposalAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$AutoProposalSettingsModelImplToJson(
        _$AutoProposalSettingsModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'isEnabled': instance.isEnabled,
      'intervalDays': instance.intervalDays,
      'preferredCategories': instance.preferredCategories,
      'maxPrice': instance.maxPrice,
      'maxDistanceKm': instance.maxDistanceKm,
      'minRating': instance.minRating,
      'preferredTimeSlots': instance.preferredTimeSlots,
      'lastProposalAt': instance.lastProposalAt?.toIso8601String(),
      'nextProposalAt': instance.nextProposalAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_$UpdateAutoProposalSettingsDtoImpl
    _$$UpdateAutoProposalSettingsDtoImplFromJson(Map<String, dynamic> json) =>
        _$UpdateAutoProposalSettingsDtoImpl(
          isEnabled: json['isEnabled'] as bool?,
          intervalDays: (json['intervalDays'] as num?)?.toInt(),
          preferredCategories: (json['preferredCategories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
          maxPrice: (json['maxPrice'] as num?)?.toDouble(),
          maxDistanceKm: (json['maxDistanceKm'] as num?)?.toInt(),
          minRating: (json['minRating'] as num?)?.toDouble(),
          preferredTimeSlots: (json['preferredTimeSlots'] as List<dynamic>?)
              ?.map((e) => TimeSlotModel.fromJson(e as Map<String, dynamic>))
              .toList(),
        );

Map<String, dynamic> _$$UpdateAutoProposalSettingsDtoImplToJson(
        _$UpdateAutoProposalSettingsDtoImpl instance) =>
    <String, dynamic>{
      'isEnabled': instance.isEnabled,
      'intervalDays': instance.intervalDays,
      'preferredCategories': instance.preferredCategories,
      'maxPrice': instance.maxPrice,
      'maxDistanceKm': instance.maxDistanceKm,
      'minRating': instance.minRating,
      'preferredTimeSlots': instance.preferredTimeSlots,
    };

_$AcceptProposalDtoImpl _$$AcceptProposalDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$AcceptProposalDtoImpl(
      preferredDatetime: json['preferred_datetime'] as String?,
      comment: json['comment'] as String?,
    );

Map<String, dynamic> _$$AcceptProposalDtoImplToJson(
        _$AcceptProposalDtoImpl instance) =>
    <String, dynamic>{
      'preferred_datetime': instance.preferredDatetime,
      'comment': instance.comment,
    };

_$AutoProposalModelImpl _$$AutoProposalModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AutoProposalModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      masterId: json['masterId'] as String,
      serviceId: json['serviceId'] as String,
      categoryId: json['categoryId'] as String,
      status: $enumDecode(_$ProposalStatusEnumMap, json['status']),
      matchScore: (json['matchScore'] as num).toInt(),
      matchReasons: MatchReasonsModel.fromJson(
          json['matchReasons'] as Map<String, dynamic>),
      proposedDatetime: json['proposedDatetime'] == null
          ? null
          : DateTime.parse(json['proposedDatetime'] as String),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      bookingId: json['bookingId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      master: json['master'] == null
          ? null
          : ProposalMasterModel.fromJson(
              json['master'] as Map<String, dynamic>),
      service: json['service'] == null
          ? null
          : ProposalServiceModel.fromJson(
              json['service'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AutoProposalModelImplToJson(
        _$AutoProposalModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'masterId': instance.masterId,
      'serviceId': instance.serviceId,
      'categoryId': instance.categoryId,
      'status': _$ProposalStatusEnumMap[instance.status]!,
      'matchScore': instance.matchScore,
      'matchReasons': instance.matchReasons,
      'proposedDatetime': instance.proposedDatetime?.toIso8601String(),
      'expiresAt': instance.expiresAt.toIso8601String(),
      'bookingId': instance.bookingId,
      'createdAt': instance.createdAt.toIso8601String(),
      'master': instance.master,
      'service': instance.service,
    };

const _$ProposalStatusEnumMap = {
  ProposalStatus.pending: 'pending',
  ProposalStatus.accepted: 'accepted',
  ProposalStatus.rejected: 'rejected',
  ProposalStatus.expired: 'expired',
};
