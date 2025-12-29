// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String,
      role: json['role'] as String,
      bio: json['bio'] as String?,
      phone: json['phone'] as String?,
      city: json['city'] as String?,
      followersCount: (json['followersCount'] as num?)?.toInt(),
      followingCount: (json['followingCount'] as num?)?.toInt(),
      isFollowing: json['isFollowing'] as bool?,
      isFriend: json['isFriend'] as bool?,
      rating: (json['rating'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'avatar': instance.avatar,
      'role': instance.role,
      'bio': instance.bio,
      'phone': instance.phone,
      'city': instance.city,
      'followersCount': instance.followersCount,
      'followingCount': instance.followingCount,
      'isFollowing': instance.isFollowing,
      'isFriend': instance.isFriend,
      'rating': instance.rating,
    };
