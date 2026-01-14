// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'master_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MasterProfileModelImpl _$$MasterProfileModelImplFromJson(
        Map<String, dynamic> json) =>
    _$MasterProfileModelImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      user: json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
      businessName: json['business_name'] as String?,
      bio: json['bio'] as String?,
      categoryIds: (json['category_ids'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      subcategoryIds: (json['subcategory_ids'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      rating: (json['rating'] as num).toDouble(),
      reviewsCount: (json['reviews_count'] as num).toInt(),
      completedBookings: (json['completed_bookings'] as num).toInt(),
      cancellationsCount: (json['cancellations_count'] as num).toInt(),
      viewsCount: (json['views_count'] as num).toInt(),
      favoritesCount: (json['favorites_count'] as num).toInt(),
      subscribersCount: (json['subscribers_count'] as num).toInt(),
      locationLat: (json['location_lat'] as num?)?.toDouble(),
      locationLng: (json['location_lng'] as num?)?.toDouble(),
      locationAddress: json['location_address'] as String?,
      locationName: json['location_name'] as String?,
      serviceRadiusKm: (json['service_radius_km'] as num?)?.toInt(),
      isMobile: json['is_mobile'] as bool,
      hasLocation: json['has_location'] as bool,
      isOnlineOnly: json['is_online_only'] as bool,
      portfolioUrls: (json['portfolio_urls'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      videoUrls: (json['video_urls'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      socialLinks: (json['social_links'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      workingHours: json['working_hours'] as Map<String, dynamic>?,
      minBookingHours: (json['min_booking_hours'] as num).toInt(),
      maxBookingsPerDay: (json['max_bookings_per_day'] as num?)?.toInt(),
      autoConfirm: json['auto_confirm'] as bool,
      yearsOfExperience: (json['years_of_experience'] as num?)?.toInt(),
      certificates: (json['certificates'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      languages:
          (json['languages'] as List<dynamic>).map((e) => e as String).toList(),
      isActive: json['is_active'] as bool,
      isApproved: json['is_approved'] as bool,
      setupStep: (json['setup_step'] as num).toInt(),
      services: (json['services'] as List<dynamic>?)
          ?.map((e) => ServiceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$MasterProfileModelImplToJson(
        _$MasterProfileModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'user': instance.user,
      'business_name': instance.businessName,
      'bio': instance.bio,
      'category_ids': instance.categoryIds,
      'subcategory_ids': instance.subcategoryIds,
      'rating': instance.rating,
      'reviews_count': instance.reviewsCount,
      'completed_bookings': instance.completedBookings,
      'cancellations_count': instance.cancellationsCount,
      'views_count': instance.viewsCount,
      'favorites_count': instance.favoritesCount,
      'subscribers_count': instance.subscribersCount,
      'location_lat': instance.locationLat,
      'location_lng': instance.locationLng,
      'location_address': instance.locationAddress,
      'location_name': instance.locationName,
      'service_radius_km': instance.serviceRadiusKm,
      'is_mobile': instance.isMobile,
      'has_location': instance.hasLocation,
      'is_online_only': instance.isOnlineOnly,
      'portfolio_urls': instance.portfolioUrls,
      'video_urls': instance.videoUrls,
      'social_links': instance.socialLinks,
      'working_hours': instance.workingHours,
      'min_booking_hours': instance.minBookingHours,
      'max_bookings_per_day': instance.maxBookingsPerDay,
      'auto_confirm': instance.autoConfirm,
      'years_of_experience': instance.yearsOfExperience,
      'certificates': instance.certificates,
      'languages': instance.languages,
      'is_active': instance.isActive,
      'is_approved': instance.isApproved,
      'setup_step': instance.setupStep,
      'services': instance.services,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

_$CreateMasterProfileRequestImpl _$$CreateMasterProfileRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateMasterProfileRequestImpl(
      businessName: json['business_name'] as String?,
      bio: json['bio'] as String?,
      categoryIds: (json['category_ids'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      subcategoryIds: (json['subcategory_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      locationAddress: json['location_address'] as String?,
      locationLat: (json['location_lat'] as num?)?.toDouble(),
      locationLng: (json['location_lng'] as num?)?.toDouble(),
      serviceRadiusKm: (json['service_radius_km'] as num?)?.toInt(),
      isMobile: json['is_mobile'] as bool?,
      hasLocation: json['has_location'] as bool?,
      isOnlineOnly: json['is_online_only'] as bool?,
      socialLinks: (json['social_links'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      workingHours: json['working_hours'] as Map<String, dynamic>?,
      yearsOfExperience: (json['years_of_experience'] as num?)?.toInt(),
      languages: (json['languages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$CreateMasterProfileRequestImplToJson(
        _$CreateMasterProfileRequestImpl instance) =>
    <String, dynamic>{
      'business_name': instance.businessName,
      'bio': instance.bio,
      'category_ids': instance.categoryIds,
      'subcategory_ids': instance.subcategoryIds,
      'location_address': instance.locationAddress,
      'location_lat': instance.locationLat,
      'location_lng': instance.locationLng,
      'service_radius_km': instance.serviceRadiusKm,
      'is_mobile': instance.isMobile,
      'has_location': instance.hasLocation,
      'is_online_only': instance.isOnlineOnly,
      'social_links': instance.socialLinks,
      'working_hours': instance.workingHours,
      'years_of_experience': instance.yearsOfExperience,
      'languages': instance.languages,
    };

_$UpdateMasterProfileRequestImpl _$$UpdateMasterProfileRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$UpdateMasterProfileRequestImpl(
      businessName: json['business_name'] as String?,
      bio: json['bio'] as String?,
      categoryIds: (json['category_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      subcategoryIds: (json['subcategory_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      locationAddress: json['location_address'] as String?,
      locationLat: (json['location_lat'] as num?)?.toDouble(),
      locationLng: (json['location_lng'] as num?)?.toDouble(),
      serviceRadiusKm: (json['service_radius_km'] as num?)?.toInt(),
      isMobile: json['is_mobile'] as bool?,
      hasLocation: json['has_location'] as bool?,
      isOnlineOnly: json['is_online_only'] as bool?,
      socialLinks: (json['social_links'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      workingHours: json['working_hours'] as Map<String, dynamic>?,
      minBookingHours: (json['min_booking_hours'] as num?)?.toInt(),
      maxBookingsPerDay: (json['max_bookings_per_day'] as num?)?.toInt(),
      autoConfirm: json['auto_confirm'] as bool?,
      yearsOfExperience: (json['years_of_experience'] as num?)?.toInt(),
      languages: (json['languages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      isActive: json['is_active'] as bool?,
      setupStep: (json['setup_step'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$UpdateMasterProfileRequestImplToJson(
        _$UpdateMasterProfileRequestImpl instance) =>
    <String, dynamic>{
      'business_name': instance.businessName,
      'bio': instance.bio,
      'category_ids': instance.categoryIds,
      'subcategory_ids': instance.subcategoryIds,
      'location_address': instance.locationAddress,
      'location_lat': instance.locationLat,
      'location_lng': instance.locationLng,
      'service_radius_km': instance.serviceRadiusKm,
      'is_mobile': instance.isMobile,
      'has_location': instance.hasLocation,
      'is_online_only': instance.isOnlineOnly,
      'social_links': instance.socialLinks,
      'working_hours': instance.workingHours,
      'min_booking_hours': instance.minBookingHours,
      'max_bookings_per_day': instance.maxBookingsPerDay,
      'auto_confirm': instance.autoConfirm,
      'years_of_experience': instance.yearsOfExperience,
      'languages': instance.languages,
      'is_active': instance.isActive,
      'setup_step': instance.setupStep,
    };
