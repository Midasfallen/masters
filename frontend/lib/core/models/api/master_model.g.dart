// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'master_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MasterProfileModelImpl _$$MasterProfileModelImplFromJson(
        Map<String, dynamic> json) =>
    _$MasterProfileModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      user: json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
      businessName: json['businessName'] as String?,
      bio: json['bio'] as String?,
      categoryIds: (json['categoryIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      subcategoryIds: (json['subcategoryIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      rating: (json['rating'] as num).toDouble(),
      reviewsCount: (json['reviewsCount'] as num).toInt(),
      completedBookings: (json['completedBookings'] as num).toInt(),
      cancellationsCount: (json['cancellationsCount'] as num).toInt(),
      viewsCount: (json['viewsCount'] as num).toInt(),
      favoritesCount: (json['favoritesCount'] as num).toInt(),
      subscribersCount: (json['subscribersCount'] as num).toInt(),
      locationLat: (json['locationLat'] as num?)?.toDouble(),
      locationLng: (json['locationLng'] as num?)?.toDouble(),
      locationAddress: json['locationAddress'] as String?,
      locationName: json['locationName'] as String?,
      serviceRadiusKm: (json['serviceRadiusKm'] as num?)?.toInt(),
      isMobile: json['isMobile'] as bool,
      hasLocation: json['hasLocation'] as bool,
      isOnlineOnly: json['isOnlineOnly'] as bool,
      portfolioUrls: (json['portfolioUrls'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      videoUrls:
          (json['videoUrls'] as List<dynamic>).map((e) => e as String).toList(),
      socialLinks: (json['socialLinks'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      workingHours: json['workingHours'] as Map<String, dynamic>?,
      minBookingHours: (json['minBookingHours'] as num).toInt(),
      maxBookingsPerDay: (json['maxBookingsPerDay'] as num?)?.toInt(),
      autoConfirm: json['autoConfirm'] as bool,
      yearsOfExperience: (json['yearsOfExperience'] as num?)?.toInt(),
      certificates: (json['certificates'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      languages:
          (json['languages'] as List<dynamic>).map((e) => e as String).toList(),
      isActive: json['isActive'] as bool,
      isApproved: json['isApproved'] as bool,
      setupStep: (json['setupStep'] as num).toInt(),
      services: (json['services'] as List<dynamic>?)
          ?.map((e) => ServiceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$MasterProfileModelImplToJson(
        _$MasterProfileModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'user': instance.user,
      'businessName': instance.businessName,
      'bio': instance.bio,
      'categoryIds': instance.categoryIds,
      'subcategoryIds': instance.subcategoryIds,
      'rating': instance.rating,
      'reviewsCount': instance.reviewsCount,
      'completedBookings': instance.completedBookings,
      'cancellationsCount': instance.cancellationsCount,
      'viewsCount': instance.viewsCount,
      'favoritesCount': instance.favoritesCount,
      'subscribersCount': instance.subscribersCount,
      'locationLat': instance.locationLat,
      'locationLng': instance.locationLng,
      'locationAddress': instance.locationAddress,
      'locationName': instance.locationName,
      'serviceRadiusKm': instance.serviceRadiusKm,
      'isMobile': instance.isMobile,
      'hasLocation': instance.hasLocation,
      'isOnlineOnly': instance.isOnlineOnly,
      'portfolioUrls': instance.portfolioUrls,
      'videoUrls': instance.videoUrls,
      'socialLinks': instance.socialLinks,
      'workingHours': instance.workingHours,
      'minBookingHours': instance.minBookingHours,
      'maxBookingsPerDay': instance.maxBookingsPerDay,
      'autoConfirm': instance.autoConfirm,
      'yearsOfExperience': instance.yearsOfExperience,
      'certificates': instance.certificates,
      'languages': instance.languages,
      'isActive': instance.isActive,
      'isApproved': instance.isApproved,
      'setupStep': instance.setupStep,
      'services': instance.services,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
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
