// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_proposal_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AutoProposalModelImpl _$$AutoProposalModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AutoProposalModelImpl(
      id: json['id'] as String,
      masterId: json['masterId'] as String,
      clientId: json['clientId'] as String,
      serviceId: json['serviceId'] as String,
      proposedDate: DateTime.parse(json['proposedDate'] as String),
      proposedTime: json['proposedTime'] as String,
      duration: (json['duration'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
      message: json['message'] as String?,
      status: $enumDecode(_$ProposalStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      bookingId: json['bookingId'] as String?,
      master: json['master'],
      client: json['client'],
      service: json['service'],
    );

Map<String, dynamic> _$$AutoProposalModelImplToJson(
        _$AutoProposalModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'masterId': instance.masterId,
      'clientId': instance.clientId,
      'serviceId': instance.serviceId,
      'proposedDate': instance.proposedDate.toIso8601String(),
      'proposedTime': instance.proposedTime,
      'duration': instance.duration,
      'price': instance.price,
      'message': instance.message,
      'status': _$ProposalStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'expiresAt': instance.expiresAt.toIso8601String(),
      'bookingId': instance.bookingId,
      'master': instance.master,
      'client': instance.client,
      'service': instance.service,
    };

const _$ProposalStatusEnumMap = {
  ProposalStatus.pending: 'pending',
  ProposalStatus.accepted: 'accepted',
  ProposalStatus.rejected: 'rejected',
  ProposalStatus.expired: 'expired',
};
