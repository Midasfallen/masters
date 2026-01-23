import 'package:json_annotation/json_annotation.dart';

part 'unreviewed_booking.g.dart';

@JsonSerializable()
class UnreviewedBooking {
  final String id;
  @JsonKey(name: 'service_id')
  final String serviceId;
  @JsonKey(name: 'service_name')
  final String? serviceName;
  @JsonKey(name: 'master_id')
  final String masterId;
  @JsonKey(name: 'master_name')
  final String masterName;
  @JsonKey(name: 'client_id')
  final String clientId;
  @JsonKey(name: 'client_name')
  final String clientName;
  @JsonKey(name: 'start_time')
  final DateTime startTime;
  @JsonKey(name: 'end_time')
  final DateTime endTime;
  @JsonKey(name: 'total_price')
  final double totalPrice;
  @JsonKey(name: 'is_client')
  final bool isClient;
  @JsonKey(name: 'review_target')
  final String reviewTarget;
  @JsonKey(name: 'review_target_name')
  final String reviewTargetName;
  @JsonKey(name: 'reminder_count')
  final int reminderCount;
  @JsonKey(name: 'grace_skip_allowed')
  final bool graceSkipAllowed;
  @JsonKey(name: 'last_reminded_at')
  final DateTime? lastRemindedAt;

  UnreviewedBooking({
    required this.id,
    required this.serviceId,
    this.serviceName,
    required this.masterId,
    required this.masterName,
    required this.clientId,
    required this.clientName,
    required this.startTime,
    required this.endTime,
    required this.totalPrice,
    required this.isClient,
    required this.reviewTarget,
    required this.reviewTargetName,
    required this.reminderCount,
    required this.graceSkipAllowed,
    this.lastRemindedAt,
  });

  factory UnreviewedBooking.fromJson(Map<String, dynamic> json) =>
      _$UnreviewedBookingFromJson(json);

  Map<String, dynamic> toJson() => _$UnreviewedBookingToJson(this);
}
