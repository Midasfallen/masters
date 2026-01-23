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
class AutoProposalModel with _$AutoProposalModel {
  const factory AutoProposalModel({
    required String id,
    @JsonKey(name: 'master_id') required String masterId,
    @JsonKey(name: 'client_id') required String clientId,
    @JsonKey(name: 'service_id') required String serviceId,
    @JsonKey(name: 'proposed_date') required DateTime proposedDate,
    @JsonKey(name: 'proposed_time') required String proposedTime,
    required int duration,
    required double price,
    String? message,
    required ProposalStatus status,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'expires_at') required DateTime expiresAt,
    @JsonKey(name: 'booking_id') String? bookingId,
    dynamic master,
    dynamic client,
    dynamic service,
  }) = _AutoProposalModel;

  factory AutoProposalModel.fromJson(Map<String, dynamic> json) =>
      _$AutoProposalModelFromJson(json);
}
