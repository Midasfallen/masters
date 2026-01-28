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
    required String masterId,
    required String clientId,
    required String serviceId,
    required DateTime proposedDate,
    required String proposedTime,
    required int duration,
    required double price,
    String? message,
    required ProposalStatus status,
    required DateTime createdAt,
    required DateTime expiresAt,
    String? bookingId,
    dynamic master,
    dynamic client,
    dynamic service,
  }) = _AutoProposalModel;

  factory AutoProposalModel.fromJson(Map<String, dynamic> json) =>
      _$AutoProposalModelFromJson(json);
}
