// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skip_review_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SkipReviewResponse _$SkipReviewResponseFromJson(Map<String, dynamic> json) =>
    SkipReviewResponse(
      reminderCount: (json['reminder_count'] as num).toInt(),
      graceSkipAllowed: json['grace_skip_allowed'] as bool,
    );

Map<String, dynamic> _$SkipReviewResponseToJson(SkipReviewResponse instance) =>
    <String, dynamic>{
      'reminder_count': instance.reminderCount,
      'grace_skip_allowed': instance.graceSkipAllowed,
    };
