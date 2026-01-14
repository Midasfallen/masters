// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      fullName: json['full_name'] as String,
      avatarUrl: json['avatar_url'] as String?,
      isMaster: json['is_master'] as bool,
      masterProfileCompleted: json['master_profile_completed'] as bool,
      isVerified: json['is_verified'] as bool,
      isPremium: json['is_premium'] as bool,
      premiumUntil: json['premium_until'] == null
          ? null
          : DateTime.parse(json['premium_until'] as String),
      rating: (json['rating'] as num).toDouble(),
      reviewsCount: (json['reviews_count'] as num).toInt(),
      postsCount: (json['posts_count'] as num).toInt(),
      friendsCount: (json['friends_count'] as num).toInt(),
      followersCount: (json['followers_count'] as num).toInt(),
      followingCount: (json['following_count'] as num).toInt(),
      language: json['language'] as String,
      timezone: json['timezone'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'phone': instance.phone,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'full_name': instance.fullName,
      'avatar_url': instance.avatarUrl,
      'is_master': instance.isMaster,
      'master_profile_completed': instance.masterProfileCompleted,
      'is_verified': instance.isVerified,
      'is_premium': instance.isPremium,
      'premium_until': instance.premiumUntil?.toIso8601String(),
      'rating': instance.rating,
      'reviews_count': instance.reviewsCount,
      'posts_count': instance.postsCount,
      'friends_count': instance.friendsCount,
      'followers_count': instance.followersCount,
      'following_count': instance.followingCount,
      'language': instance.language,
      'timezone': instance.timezone,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

_$AuthResponseModelImpl _$$AuthResponseModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AuthResponseModelImpl(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      tokenType: json['token_type'] as String,
      expiresIn: (json['expires_in'] as num).toInt(),
      user: AuthUserModel.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AuthResponseModelImplToJson(
        _$AuthResponseModelImpl instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'token_type': instance.tokenType,
      'expires_in': instance.expiresIn,
      'user': instance.user,
    };

_$AuthUserModelImpl _$$AuthUserModelImplFromJson(Map<String, dynamic> json) =>
    _$AuthUserModelImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      avatarUrl: json['avatar_url'] as String?,
      isMaster: json['is_master'] as bool,
      isVerified: json['is_verified'] as bool,
      isPremium: json['is_premium'] as bool,
    );

Map<String, dynamic> _$$AuthUserModelImplToJson(_$AuthUserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'avatar_url': instance.avatarUrl,
      'is_master': instance.isMaster,
      'is_verified': instance.isVerified,
      'is_premium': instance.isPremium,
    };

_$LoginRequestImpl _$$LoginRequestImplFromJson(Map<String, dynamic> json) =>
    _$LoginRequestImpl(
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$$LoginRequestImplToJson(_$LoginRequestImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
    };

_$RegisterRequestImpl _$$RegisterRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$RegisterRequestImpl(
      email: json['email'] as String,
      password: json['password'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      phone: json['phone'] as String?,
    );

Map<String, dynamic> _$$RegisterRequestImplToJson(
        _$RegisterRequestImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'phone': instance.phone,
    };

_$UpdateUserRequestImpl _$$UpdateUserRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$UpdateUserRequestImpl(
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      phone: json['phone'] as String?,
      language: json['language'] as String?,
      timezone: json['timezone'] as String?,
    );

Map<String, dynamic> _$$UpdateUserRequestImplToJson(
        _$UpdateUserRequestImpl instance) =>
    <String, dynamic>{
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'phone': instance.phone,
      'language': instance.language,
      'timezone': instance.timezone,
    };
