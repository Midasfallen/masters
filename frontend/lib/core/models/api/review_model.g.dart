// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReviewModelImpl _$$ReviewModelImplFromJson(Map<String, dynamic> json) =>
    _$ReviewModelImpl(
      id: json['id'] as String,
      bookingId: json['bookingId'] as String,
      reviewerId: json['reviewerId'] as String,
      reviewedUserId: json['reviewedUserId'] as String,
      reviewerType: $enumDecode(_$ReviewerTypeEnumMap, json['reviewerType']),
      rating: (json['rating'] as num).toInt(),
      comment: json['comment'] as String?,
      photoUrls:
          (json['photoUrls'] as List<dynamic>).map((e) => e as String).toList(),
      response: json['response'] as String?,
      responseAt: json['responseAt'] == null
          ? null
          : DateTime.parse(json['responseAt'] as String),
      isVisible: json['isVisible'] as bool,
      reportsCount: (json['reportsCount'] as num).toInt(),
      isApproved: json['isApproved'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ReviewModelImplToJson(_$ReviewModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bookingId': instance.bookingId,
      'reviewerId': instance.reviewerId,
      'reviewedUserId': instance.reviewedUserId,
      'reviewerType': _$ReviewerTypeEnumMap[instance.reviewerType]!,
      'rating': instance.rating,
      'comment': instance.comment,
      'photoUrls': instance.photoUrls,
      'response': instance.response,
      'responseAt': instance.responseAt?.toIso8601String(),
      'isVisible': instance.isVisible,
      'reportsCount': instance.reportsCount,
      'isApproved': instance.isApproved,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
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
