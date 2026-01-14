// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReviewModelImpl _$$ReviewModelImplFromJson(Map<String, dynamic> json) =>
    _$ReviewModelImpl(
      id: json['id'] as String,
      bookingId: json['booking_id'] as String,
      reviewerId: json['reviewer_id'] as String,
      reviewedUserId: json['reviewed_user_id'] as String,
      reviewerType: $enumDecode(_$ReviewerTypeEnumMap, json['reviewer_type']),
      rating: (json['rating'] as num).toInt(),
      comment: json['comment'] as String?,
      photoUrls: (json['photo_urls'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      response: json['response'] as String?,
      responseAt: json['response_at'] == null
          ? null
          : DateTime.parse(json['response_at'] as String),
      isVisible: json['is_visible'] as bool,
      reportsCount: (json['reports_count'] as num).toInt(),
      isApproved: json['is_approved'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$ReviewModelImplToJson(_$ReviewModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'booking_id': instance.bookingId,
      'reviewer_id': instance.reviewerId,
      'reviewed_user_id': instance.reviewedUserId,
      'reviewer_type': _$ReviewerTypeEnumMap[instance.reviewerType]!,
      'rating': instance.rating,
      'comment': instance.comment,
      'photo_urls': instance.photoUrls,
      'response': instance.response,
      'response_at': instance.responseAt?.toIso8601String(),
      'is_visible': instance.isVisible,
      'reports_count': instance.reportsCount,
      'is_approved': instance.isApproved,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$ReviewerTypeEnumMap = {
  ReviewerType.client: 'client',
  ReviewerType.master: 'master',
};

_$CreateReviewRequestImpl _$$CreateReviewRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateReviewRequestImpl(
      bookingId: json['booking_id'] as String,
      rating: (json['rating'] as num).toInt(),
      comment: json['comment'] as String?,
      photoUrls: (json['photo_urls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$CreateReviewRequestImplToJson(
        _$CreateReviewRequestImpl instance) =>
    <String, dynamic>{
      'booking_id': instance.bookingId,
      'rating': instance.rating,
      'comment': instance.comment,
      'photo_urls': instance.photoUrls,
    };

_$UpdateReviewRequestImpl _$$UpdateReviewRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$UpdateReviewRequestImpl(
      rating: (json['rating'] as num?)?.toInt(),
      comment: json['comment'] as String?,
    );

Map<String, dynamic> _$$UpdateReviewRequestImplToJson(
        _$UpdateReviewRequestImpl instance) =>
    <String, dynamic>{
      'rating': instance.rating,
      'comment': instance.comment,
    };

_$ReviewResponseRequestImpl _$$ReviewResponseRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$ReviewResponseRequestImpl(
      response: json['response'] as String,
    );

Map<String, dynamic> _$$ReviewResponseRequestImplToJson(
        _$ReviewResponseRequestImpl instance) =>
    <String, dynamic>{
      'response': instance.response,
    };
