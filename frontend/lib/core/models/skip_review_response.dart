import 'package:json_annotation/json_annotation.dart';

part 'skip_review_response.g.dart';

@JsonSerializable()
class SkipReviewResponse {
  @JsonKey(name: 'reminder_count')
  final int reminderCount;
  @JsonKey(name: 'grace_skip_allowed')
  final bool graceSkipAllowed;

  SkipReviewResponse({
    required this.reminderCount,
    required this.graceSkipAllowed,
  });

  factory SkipReviewResponse.fromJson(Map<String, dynamic> json) =>
      _$SkipReviewResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SkipReviewResponseToJson(this);
}
