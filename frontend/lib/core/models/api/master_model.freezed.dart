// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'master_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MasterProfileModel _$MasterProfileModelFromJson(Map<String, dynamic> json) {
  return _MasterProfileModel.fromJson(json);
}

/// @nodoc
mixin _$MasterProfileModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  UserModel? get user => throw _privateConstructorUsedError;
  String? get businessName => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  List<String> get categoryIds => throw _privateConstructorUsedError;
  List<String> get subcategoryIds => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  int get reviewsCount => throw _privateConstructorUsedError;
  int get completedBookings => throw _privateConstructorUsedError;
  int get cancellationsCount => throw _privateConstructorUsedError;
  int get viewsCount => throw _privateConstructorUsedError;
  int get favoritesCount => throw _privateConstructorUsedError;
  int get subscribersCount => throw _privateConstructorUsedError;
  double? get locationLat => throw _privateConstructorUsedError;
  double? get locationLng => throw _privateConstructorUsedError;
  String? get locationAddress => throw _privateConstructorUsedError;
  String? get locationName => throw _privateConstructorUsedError;
  int? get serviceRadiusKm => throw _privateConstructorUsedError;
  bool get isMobile => throw _privateConstructorUsedError;
  bool get hasLocation => throw _privateConstructorUsedError;
  bool get isOnlineOnly => throw _privateConstructorUsedError;
  List<String> get portfolioUrls => throw _privateConstructorUsedError;
  List<String> get videoUrls => throw _privateConstructorUsedError;
  Map<String, String>? get socialLinks => throw _privateConstructorUsedError;
  Map<String, dynamic>? get workingHours => throw _privateConstructorUsedError;
  int get minBookingHours => throw _privateConstructorUsedError;
  int? get maxBookingsPerDay => throw _privateConstructorUsedError;
  bool get autoConfirm => throw _privateConstructorUsedError;
  int? get yearsOfExperience => throw _privateConstructorUsedError;
  List<String> get certificates => throw _privateConstructorUsedError;
  List<String> get languages => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  bool get isApproved => throw _privateConstructorUsedError;
  int get setupStep => throw _privateConstructorUsedError;
  List<ServiceModel>? get services => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this MasterProfileModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MasterProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MasterProfileModelCopyWith<MasterProfileModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MasterProfileModelCopyWith<$Res> {
  factory $MasterProfileModelCopyWith(
          MasterProfileModel value, $Res Function(MasterProfileModel) then) =
      _$MasterProfileModelCopyWithImpl<$Res, MasterProfileModel>;
  @useResult
  $Res call(
      {String id,
      String userId,
      UserModel? user,
      String? businessName,
      String? bio,
      List<String> categoryIds,
      List<String> subcategoryIds,
      double rating,
      int reviewsCount,
      int completedBookings,
      int cancellationsCount,
      int viewsCount,
      int favoritesCount,
      int subscribersCount,
      double? locationLat,
      double? locationLng,
      String? locationAddress,
      String? locationName,
      int? serviceRadiusKm,
      bool isMobile,
      bool hasLocation,
      bool isOnlineOnly,
      List<String> portfolioUrls,
      List<String> videoUrls,
      Map<String, String>? socialLinks,
      Map<String, dynamic>? workingHours,
      int minBookingHours,
      int? maxBookingsPerDay,
      bool autoConfirm,
      int? yearsOfExperience,
      List<String> certificates,
      List<String> languages,
      bool isActive,
      bool isApproved,
      int setupStep,
      List<ServiceModel>? services,
      DateTime createdAt,
      DateTime updatedAt});

  $UserModelCopyWith<$Res>? get user;
}

/// @nodoc
class _$MasterProfileModelCopyWithImpl<$Res, $Val extends MasterProfileModel>
    implements $MasterProfileModelCopyWith<$Res> {
  _$MasterProfileModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MasterProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? user = freezed,
    Object? businessName = freezed,
    Object? bio = freezed,
    Object? categoryIds = null,
    Object? subcategoryIds = null,
    Object? rating = null,
    Object? reviewsCount = null,
    Object? completedBookings = null,
    Object? cancellationsCount = null,
    Object? viewsCount = null,
    Object? favoritesCount = null,
    Object? subscribersCount = null,
    Object? locationLat = freezed,
    Object? locationLng = freezed,
    Object? locationAddress = freezed,
    Object? locationName = freezed,
    Object? serviceRadiusKm = freezed,
    Object? isMobile = null,
    Object? hasLocation = null,
    Object? isOnlineOnly = null,
    Object? portfolioUrls = null,
    Object? videoUrls = null,
    Object? socialLinks = freezed,
    Object? workingHours = freezed,
    Object? minBookingHours = null,
    Object? maxBookingsPerDay = freezed,
    Object? autoConfirm = null,
    Object? yearsOfExperience = freezed,
    Object? certificates = null,
    Object? languages = null,
    Object? isActive = null,
    Object? isApproved = null,
    Object? setupStep = null,
    Object? services = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      businessName: freezed == businessName
          ? _value.businessName
          : businessName // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryIds: null == categoryIds
          ? _value.categoryIds
          : categoryIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      subcategoryIds: null == subcategoryIds
          ? _value.subcategoryIds
          : subcategoryIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      reviewsCount: null == reviewsCount
          ? _value.reviewsCount
          : reviewsCount // ignore: cast_nullable_to_non_nullable
              as int,
      completedBookings: null == completedBookings
          ? _value.completedBookings
          : completedBookings // ignore: cast_nullable_to_non_nullable
              as int,
      cancellationsCount: null == cancellationsCount
          ? _value.cancellationsCount
          : cancellationsCount // ignore: cast_nullable_to_non_nullable
              as int,
      viewsCount: null == viewsCount
          ? _value.viewsCount
          : viewsCount // ignore: cast_nullable_to_non_nullable
              as int,
      favoritesCount: null == favoritesCount
          ? _value.favoritesCount
          : favoritesCount // ignore: cast_nullable_to_non_nullable
              as int,
      subscribersCount: null == subscribersCount
          ? _value.subscribersCount
          : subscribersCount // ignore: cast_nullable_to_non_nullable
              as int,
      locationLat: freezed == locationLat
          ? _value.locationLat
          : locationLat // ignore: cast_nullable_to_non_nullable
              as double?,
      locationLng: freezed == locationLng
          ? _value.locationLng
          : locationLng // ignore: cast_nullable_to_non_nullable
              as double?,
      locationAddress: freezed == locationAddress
          ? _value.locationAddress
          : locationAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      locationName: freezed == locationName
          ? _value.locationName
          : locationName // ignore: cast_nullable_to_non_nullable
              as String?,
      serviceRadiusKm: freezed == serviceRadiusKm
          ? _value.serviceRadiusKm
          : serviceRadiusKm // ignore: cast_nullable_to_non_nullable
              as int?,
      isMobile: null == isMobile
          ? _value.isMobile
          : isMobile // ignore: cast_nullable_to_non_nullable
              as bool,
      hasLocation: null == hasLocation
          ? _value.hasLocation
          : hasLocation // ignore: cast_nullable_to_non_nullable
              as bool,
      isOnlineOnly: null == isOnlineOnly
          ? _value.isOnlineOnly
          : isOnlineOnly // ignore: cast_nullable_to_non_nullable
              as bool,
      portfolioUrls: null == portfolioUrls
          ? _value.portfolioUrls
          : portfolioUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      videoUrls: null == videoUrls
          ? _value.videoUrls
          : videoUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      socialLinks: freezed == socialLinks
          ? _value.socialLinks
          : socialLinks // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      workingHours: freezed == workingHours
          ? _value.workingHours
          : workingHours // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      minBookingHours: null == minBookingHours
          ? _value.minBookingHours
          : minBookingHours // ignore: cast_nullable_to_non_nullable
              as int,
      maxBookingsPerDay: freezed == maxBookingsPerDay
          ? _value.maxBookingsPerDay
          : maxBookingsPerDay // ignore: cast_nullable_to_non_nullable
              as int?,
      autoConfirm: null == autoConfirm
          ? _value.autoConfirm
          : autoConfirm // ignore: cast_nullable_to_non_nullable
              as bool,
      yearsOfExperience: freezed == yearsOfExperience
          ? _value.yearsOfExperience
          : yearsOfExperience // ignore: cast_nullable_to_non_nullable
              as int?,
      certificates: null == certificates
          ? _value.certificates
          : certificates // ignore: cast_nullable_to_non_nullable
              as List<String>,
      languages: null == languages
          ? _value.languages
          : languages // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isApproved: null == isApproved
          ? _value.isApproved
          : isApproved // ignore: cast_nullable_to_non_nullable
              as bool,
      setupStep: null == setupStep
          ? _value.setupStep
          : setupStep // ignore: cast_nullable_to_non_nullable
              as int,
      services: freezed == services
          ? _value.services
          : services // ignore: cast_nullable_to_non_nullable
              as List<ServiceModel>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  /// Create a copy of MasterProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $UserModelCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MasterProfileModelImplCopyWith<$Res>
    implements $MasterProfileModelCopyWith<$Res> {
  factory _$$MasterProfileModelImplCopyWith(_$MasterProfileModelImpl value,
          $Res Function(_$MasterProfileModelImpl) then) =
      __$$MasterProfileModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      UserModel? user,
      String? businessName,
      String? bio,
      List<String> categoryIds,
      List<String> subcategoryIds,
      double rating,
      int reviewsCount,
      int completedBookings,
      int cancellationsCount,
      int viewsCount,
      int favoritesCount,
      int subscribersCount,
      double? locationLat,
      double? locationLng,
      String? locationAddress,
      String? locationName,
      int? serviceRadiusKm,
      bool isMobile,
      bool hasLocation,
      bool isOnlineOnly,
      List<String> portfolioUrls,
      List<String> videoUrls,
      Map<String, String>? socialLinks,
      Map<String, dynamic>? workingHours,
      int minBookingHours,
      int? maxBookingsPerDay,
      bool autoConfirm,
      int? yearsOfExperience,
      List<String> certificates,
      List<String> languages,
      bool isActive,
      bool isApproved,
      int setupStep,
      List<ServiceModel>? services,
      DateTime createdAt,
      DateTime updatedAt});

  @override
  $UserModelCopyWith<$Res>? get user;
}

/// @nodoc
class __$$MasterProfileModelImplCopyWithImpl<$Res>
    extends _$MasterProfileModelCopyWithImpl<$Res, _$MasterProfileModelImpl>
    implements _$$MasterProfileModelImplCopyWith<$Res> {
  __$$MasterProfileModelImplCopyWithImpl(_$MasterProfileModelImpl _value,
      $Res Function(_$MasterProfileModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of MasterProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? user = freezed,
    Object? businessName = freezed,
    Object? bio = freezed,
    Object? categoryIds = null,
    Object? subcategoryIds = null,
    Object? rating = null,
    Object? reviewsCount = null,
    Object? completedBookings = null,
    Object? cancellationsCount = null,
    Object? viewsCount = null,
    Object? favoritesCount = null,
    Object? subscribersCount = null,
    Object? locationLat = freezed,
    Object? locationLng = freezed,
    Object? locationAddress = freezed,
    Object? locationName = freezed,
    Object? serviceRadiusKm = freezed,
    Object? isMobile = null,
    Object? hasLocation = null,
    Object? isOnlineOnly = null,
    Object? portfolioUrls = null,
    Object? videoUrls = null,
    Object? socialLinks = freezed,
    Object? workingHours = freezed,
    Object? minBookingHours = null,
    Object? maxBookingsPerDay = freezed,
    Object? autoConfirm = null,
    Object? yearsOfExperience = freezed,
    Object? certificates = null,
    Object? languages = null,
    Object? isActive = null,
    Object? isApproved = null,
    Object? setupStep = null,
    Object? services = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$MasterProfileModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      businessName: freezed == businessName
          ? _value.businessName
          : businessName // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryIds: null == categoryIds
          ? _value._categoryIds
          : categoryIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      subcategoryIds: null == subcategoryIds
          ? _value._subcategoryIds
          : subcategoryIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      reviewsCount: null == reviewsCount
          ? _value.reviewsCount
          : reviewsCount // ignore: cast_nullable_to_non_nullable
              as int,
      completedBookings: null == completedBookings
          ? _value.completedBookings
          : completedBookings // ignore: cast_nullable_to_non_nullable
              as int,
      cancellationsCount: null == cancellationsCount
          ? _value.cancellationsCount
          : cancellationsCount // ignore: cast_nullable_to_non_nullable
              as int,
      viewsCount: null == viewsCount
          ? _value.viewsCount
          : viewsCount // ignore: cast_nullable_to_non_nullable
              as int,
      favoritesCount: null == favoritesCount
          ? _value.favoritesCount
          : favoritesCount // ignore: cast_nullable_to_non_nullable
              as int,
      subscribersCount: null == subscribersCount
          ? _value.subscribersCount
          : subscribersCount // ignore: cast_nullable_to_non_nullable
              as int,
      locationLat: freezed == locationLat
          ? _value.locationLat
          : locationLat // ignore: cast_nullable_to_non_nullable
              as double?,
      locationLng: freezed == locationLng
          ? _value.locationLng
          : locationLng // ignore: cast_nullable_to_non_nullable
              as double?,
      locationAddress: freezed == locationAddress
          ? _value.locationAddress
          : locationAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      locationName: freezed == locationName
          ? _value.locationName
          : locationName // ignore: cast_nullable_to_non_nullable
              as String?,
      serviceRadiusKm: freezed == serviceRadiusKm
          ? _value.serviceRadiusKm
          : serviceRadiusKm // ignore: cast_nullable_to_non_nullable
              as int?,
      isMobile: null == isMobile
          ? _value.isMobile
          : isMobile // ignore: cast_nullable_to_non_nullable
              as bool,
      hasLocation: null == hasLocation
          ? _value.hasLocation
          : hasLocation // ignore: cast_nullable_to_non_nullable
              as bool,
      isOnlineOnly: null == isOnlineOnly
          ? _value.isOnlineOnly
          : isOnlineOnly // ignore: cast_nullable_to_non_nullable
              as bool,
      portfolioUrls: null == portfolioUrls
          ? _value._portfolioUrls
          : portfolioUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      videoUrls: null == videoUrls
          ? _value._videoUrls
          : videoUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      socialLinks: freezed == socialLinks
          ? _value._socialLinks
          : socialLinks // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      workingHours: freezed == workingHours
          ? _value._workingHours
          : workingHours // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      minBookingHours: null == minBookingHours
          ? _value.minBookingHours
          : minBookingHours // ignore: cast_nullable_to_non_nullable
              as int,
      maxBookingsPerDay: freezed == maxBookingsPerDay
          ? _value.maxBookingsPerDay
          : maxBookingsPerDay // ignore: cast_nullable_to_non_nullable
              as int?,
      autoConfirm: null == autoConfirm
          ? _value.autoConfirm
          : autoConfirm // ignore: cast_nullable_to_non_nullable
              as bool,
      yearsOfExperience: freezed == yearsOfExperience
          ? _value.yearsOfExperience
          : yearsOfExperience // ignore: cast_nullable_to_non_nullable
              as int?,
      certificates: null == certificates
          ? _value._certificates
          : certificates // ignore: cast_nullable_to_non_nullable
              as List<String>,
      languages: null == languages
          ? _value._languages
          : languages // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isApproved: null == isApproved
          ? _value.isApproved
          : isApproved // ignore: cast_nullable_to_non_nullable
              as bool,
      setupStep: null == setupStep
          ? _value.setupStep
          : setupStep // ignore: cast_nullable_to_non_nullable
              as int,
      services: freezed == services
          ? _value._services
          : services // ignore: cast_nullable_to_non_nullable
              as List<ServiceModel>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MasterProfileModelImpl implements _MasterProfileModel {
  const _$MasterProfileModelImpl(
      {required this.id,
      required this.userId,
      this.user,
      this.businessName,
      this.bio,
      required final List<String> categoryIds,
      required final List<String> subcategoryIds,
      required this.rating,
      required this.reviewsCount,
      required this.completedBookings,
      required this.cancellationsCount,
      required this.viewsCount,
      required this.favoritesCount,
      required this.subscribersCount,
      this.locationLat,
      this.locationLng,
      this.locationAddress,
      this.locationName,
      this.serviceRadiusKm,
      required this.isMobile,
      required this.hasLocation,
      required this.isOnlineOnly,
      required final List<String> portfolioUrls,
      required final List<String> videoUrls,
      final Map<String, String>? socialLinks,
      final Map<String, dynamic>? workingHours,
      required this.minBookingHours,
      this.maxBookingsPerDay,
      required this.autoConfirm,
      this.yearsOfExperience,
      required final List<String> certificates,
      required final List<String> languages,
      required this.isActive,
      required this.isApproved,
      required this.setupStep,
      final List<ServiceModel>? services,
      required this.createdAt,
      required this.updatedAt})
      : _categoryIds = categoryIds,
        _subcategoryIds = subcategoryIds,
        _portfolioUrls = portfolioUrls,
        _videoUrls = videoUrls,
        _socialLinks = socialLinks,
        _workingHours = workingHours,
        _certificates = certificates,
        _languages = languages,
        _services = services;

  factory _$MasterProfileModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MasterProfileModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final UserModel? user;
  @override
  final String? businessName;
  @override
  final String? bio;
  final List<String> _categoryIds;
  @override
  List<String> get categoryIds {
    if (_categoryIds is EqualUnmodifiableListView) return _categoryIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categoryIds);
  }

  final List<String> _subcategoryIds;
  @override
  List<String> get subcategoryIds {
    if (_subcategoryIds is EqualUnmodifiableListView) return _subcategoryIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_subcategoryIds);
  }

  @override
  final double rating;
  @override
  final int reviewsCount;
  @override
  final int completedBookings;
  @override
  final int cancellationsCount;
  @override
  final int viewsCount;
  @override
  final int favoritesCount;
  @override
  final int subscribersCount;
  @override
  final double? locationLat;
  @override
  final double? locationLng;
  @override
  final String? locationAddress;
  @override
  final String? locationName;
  @override
  final int? serviceRadiusKm;
  @override
  final bool isMobile;
  @override
  final bool hasLocation;
  @override
  final bool isOnlineOnly;
  final List<String> _portfolioUrls;
  @override
  List<String> get portfolioUrls {
    if (_portfolioUrls is EqualUnmodifiableListView) return _portfolioUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_portfolioUrls);
  }

  final List<String> _videoUrls;
  @override
  List<String> get videoUrls {
    if (_videoUrls is EqualUnmodifiableListView) return _videoUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_videoUrls);
  }

  final Map<String, String>? _socialLinks;
  @override
  Map<String, String>? get socialLinks {
    final value = _socialLinks;
    if (value == null) return null;
    if (_socialLinks is EqualUnmodifiableMapView) return _socialLinks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _workingHours;
  @override
  Map<String, dynamic>? get workingHours {
    final value = _workingHours;
    if (value == null) return null;
    if (_workingHours is EqualUnmodifiableMapView) return _workingHours;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final int minBookingHours;
  @override
  final int? maxBookingsPerDay;
  @override
  final bool autoConfirm;
  @override
  final int? yearsOfExperience;
  final List<String> _certificates;
  @override
  List<String> get certificates {
    if (_certificates is EqualUnmodifiableListView) return _certificates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_certificates);
  }

  final List<String> _languages;
  @override
  List<String> get languages {
    if (_languages is EqualUnmodifiableListView) return _languages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_languages);
  }

  @override
  final bool isActive;
  @override
  final bool isApproved;
  @override
  final int setupStep;
  final List<ServiceModel>? _services;
  @override
  List<ServiceModel>? get services {
    final value = _services;
    if (value == null) return null;
    if (_services is EqualUnmodifiableListView) return _services;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'MasterProfileModel(id: $id, userId: $userId, user: $user, businessName: $businessName, bio: $bio, categoryIds: $categoryIds, subcategoryIds: $subcategoryIds, rating: $rating, reviewsCount: $reviewsCount, completedBookings: $completedBookings, cancellationsCount: $cancellationsCount, viewsCount: $viewsCount, favoritesCount: $favoritesCount, subscribersCount: $subscribersCount, locationLat: $locationLat, locationLng: $locationLng, locationAddress: $locationAddress, locationName: $locationName, serviceRadiusKm: $serviceRadiusKm, isMobile: $isMobile, hasLocation: $hasLocation, isOnlineOnly: $isOnlineOnly, portfolioUrls: $portfolioUrls, videoUrls: $videoUrls, socialLinks: $socialLinks, workingHours: $workingHours, minBookingHours: $minBookingHours, maxBookingsPerDay: $maxBookingsPerDay, autoConfirm: $autoConfirm, yearsOfExperience: $yearsOfExperience, certificates: $certificates, languages: $languages, isActive: $isActive, isApproved: $isApproved, setupStep: $setupStep, services: $services, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MasterProfileModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.businessName, businessName) ||
                other.businessName == businessName) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            const DeepCollectionEquality()
                .equals(other._categoryIds, _categoryIds) &&
            const DeepCollectionEquality()
                .equals(other._subcategoryIds, _subcategoryIds) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.reviewsCount, reviewsCount) ||
                other.reviewsCount == reviewsCount) &&
            (identical(other.completedBookings, completedBookings) ||
                other.completedBookings == completedBookings) &&
            (identical(other.cancellationsCount, cancellationsCount) ||
                other.cancellationsCount == cancellationsCount) &&
            (identical(other.viewsCount, viewsCount) ||
                other.viewsCount == viewsCount) &&
            (identical(other.favoritesCount, favoritesCount) ||
                other.favoritesCount == favoritesCount) &&
            (identical(other.subscribersCount, subscribersCount) ||
                other.subscribersCount == subscribersCount) &&
            (identical(other.locationLat, locationLat) ||
                other.locationLat == locationLat) &&
            (identical(other.locationLng, locationLng) ||
                other.locationLng == locationLng) &&
            (identical(other.locationAddress, locationAddress) ||
                other.locationAddress == locationAddress) &&
            (identical(other.locationName, locationName) ||
                other.locationName == locationName) &&
            (identical(other.serviceRadiusKm, serviceRadiusKm) ||
                other.serviceRadiusKm == serviceRadiusKm) &&
            (identical(other.isMobile, isMobile) ||
                other.isMobile == isMobile) &&
            (identical(other.hasLocation, hasLocation) ||
                other.hasLocation == hasLocation) &&
            (identical(other.isOnlineOnly, isOnlineOnly) ||
                other.isOnlineOnly == isOnlineOnly) &&
            const DeepCollectionEquality()
                .equals(other._portfolioUrls, _portfolioUrls) &&
            const DeepCollectionEquality()
                .equals(other._videoUrls, _videoUrls) &&
            const DeepCollectionEquality()
                .equals(other._socialLinks, _socialLinks) &&
            const DeepCollectionEquality()
                .equals(other._workingHours, _workingHours) &&
            (identical(other.minBookingHours, minBookingHours) ||
                other.minBookingHours == minBookingHours) &&
            (identical(other.maxBookingsPerDay, maxBookingsPerDay) ||
                other.maxBookingsPerDay == maxBookingsPerDay) &&
            (identical(other.autoConfirm, autoConfirm) ||
                other.autoConfirm == autoConfirm) &&
            (identical(other.yearsOfExperience, yearsOfExperience) ||
                other.yearsOfExperience == yearsOfExperience) &&
            const DeepCollectionEquality()
                .equals(other._certificates, _certificates) &&
            const DeepCollectionEquality()
                .equals(other._languages, _languages) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isApproved, isApproved) ||
                other.isApproved == isApproved) &&
            (identical(other.setupStep, setupStep) ||
                other.setupStep == setupStep) &&
            const DeepCollectionEquality().equals(other._services, _services) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        userId,
        user,
        businessName,
        bio,
        const DeepCollectionEquality().hash(_categoryIds),
        const DeepCollectionEquality().hash(_subcategoryIds),
        rating,
        reviewsCount,
        completedBookings,
        cancellationsCount,
        viewsCount,
        favoritesCount,
        subscribersCount,
        locationLat,
        locationLng,
        locationAddress,
        locationName,
        serviceRadiusKm,
        isMobile,
        hasLocation,
        isOnlineOnly,
        const DeepCollectionEquality().hash(_portfolioUrls),
        const DeepCollectionEquality().hash(_videoUrls),
        const DeepCollectionEquality().hash(_socialLinks),
        const DeepCollectionEquality().hash(_workingHours),
        minBookingHours,
        maxBookingsPerDay,
        autoConfirm,
        yearsOfExperience,
        const DeepCollectionEquality().hash(_certificates),
        const DeepCollectionEquality().hash(_languages),
        isActive,
        isApproved,
        setupStep,
        const DeepCollectionEquality().hash(_services),
        createdAt,
        updatedAt
      ]);

  /// Create a copy of MasterProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MasterProfileModelImplCopyWith<_$MasterProfileModelImpl> get copyWith =>
      __$$MasterProfileModelImplCopyWithImpl<_$MasterProfileModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MasterProfileModelImplToJson(
      this,
    );
  }
}

abstract class _MasterProfileModel implements MasterProfileModel {
  const factory _MasterProfileModel(
      {required final String id,
      required final String userId,
      final UserModel? user,
      final String? businessName,
      final String? bio,
      required final List<String> categoryIds,
      required final List<String> subcategoryIds,
      required final double rating,
      required final int reviewsCount,
      required final int completedBookings,
      required final int cancellationsCount,
      required final int viewsCount,
      required final int favoritesCount,
      required final int subscribersCount,
      final double? locationLat,
      final double? locationLng,
      final String? locationAddress,
      final String? locationName,
      final int? serviceRadiusKm,
      required final bool isMobile,
      required final bool hasLocation,
      required final bool isOnlineOnly,
      required final List<String> portfolioUrls,
      required final List<String> videoUrls,
      final Map<String, String>? socialLinks,
      final Map<String, dynamic>? workingHours,
      required final int minBookingHours,
      final int? maxBookingsPerDay,
      required final bool autoConfirm,
      final int? yearsOfExperience,
      required final List<String> certificates,
      required final List<String> languages,
      required final bool isActive,
      required final bool isApproved,
      required final int setupStep,
      final List<ServiceModel>? services,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$MasterProfileModelImpl;

  factory _MasterProfileModel.fromJson(Map<String, dynamic> json) =
      _$MasterProfileModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  UserModel? get user;
  @override
  String? get businessName;
  @override
  String? get bio;
  @override
  List<String> get categoryIds;
  @override
  List<String> get subcategoryIds;
  @override
  double get rating;
  @override
  int get reviewsCount;
  @override
  int get completedBookings;
  @override
  int get cancellationsCount;
  @override
  int get viewsCount;
  @override
  int get favoritesCount;
  @override
  int get subscribersCount;
  @override
  double? get locationLat;
  @override
  double? get locationLng;
  @override
  String? get locationAddress;
  @override
  String? get locationName;
  @override
  int? get serviceRadiusKm;
  @override
  bool get isMobile;
  @override
  bool get hasLocation;
  @override
  bool get isOnlineOnly;
  @override
  List<String> get portfolioUrls;
  @override
  List<String> get videoUrls;
  @override
  Map<String, String>? get socialLinks;
  @override
  Map<String, dynamic>? get workingHours;
  @override
  int get minBookingHours;
  @override
  int? get maxBookingsPerDay;
  @override
  bool get autoConfirm;
  @override
  int? get yearsOfExperience;
  @override
  List<String> get certificates;
  @override
  List<String> get languages;
  @override
  bool get isActive;
  @override
  bool get isApproved;
  @override
  int get setupStep;
  @override
  List<ServiceModel>? get services;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of MasterProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MasterProfileModelImplCopyWith<_$MasterProfileModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateMasterProfileRequest _$CreateMasterProfileRequestFromJson(
    Map<String, dynamic> json) {
  return _CreateMasterProfileRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateMasterProfileRequest {
  @JsonKey(name: 'business_name')
  String? get businessName => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_ids')
  List<String> get categoryIds => throw _privateConstructorUsedError;
  @JsonKey(name: 'subcategory_ids')
  List<String>? get subcategoryIds => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_address')
  String? get locationAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_lat')
  double? get locationLat => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_lng')
  double? get locationLng => throw _privateConstructorUsedError;
  @JsonKey(name: 'service_radius_km')
  int? get serviceRadiusKm => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_mobile')
  bool? get isMobile => throw _privateConstructorUsedError;
  @JsonKey(name: 'has_location')
  bool? get hasLocation => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_online_only')
  bool? get isOnlineOnly => throw _privateConstructorUsedError;
  @JsonKey(name: 'social_links')
  Map<String, String>? get socialLinks => throw _privateConstructorUsedError;
  @JsonKey(name: 'working_hours')
  Map<String, dynamic>? get workingHours => throw _privateConstructorUsedError;
  @JsonKey(name: 'years_of_experience')
  int? get yearsOfExperience => throw _privateConstructorUsedError;
  List<String>? get languages => throw _privateConstructorUsedError;

  /// Serializes this CreateMasterProfileRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateMasterProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateMasterProfileRequestCopyWith<CreateMasterProfileRequest>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateMasterProfileRequestCopyWith<$Res> {
  factory $CreateMasterProfileRequestCopyWith(CreateMasterProfileRequest value,
          $Res Function(CreateMasterProfileRequest) then) =
      _$CreateMasterProfileRequestCopyWithImpl<$Res,
          CreateMasterProfileRequest>;
  @useResult
  $Res call(
      {@JsonKey(name: 'business_name') String? businessName,
      String? bio,
      @JsonKey(name: 'category_ids') List<String> categoryIds,
      @JsonKey(name: 'subcategory_ids') List<String>? subcategoryIds,
      @JsonKey(name: 'location_address') String? locationAddress,
      @JsonKey(name: 'location_lat') double? locationLat,
      @JsonKey(name: 'location_lng') double? locationLng,
      @JsonKey(name: 'service_radius_km') int? serviceRadiusKm,
      @JsonKey(name: 'is_mobile') bool? isMobile,
      @JsonKey(name: 'has_location') bool? hasLocation,
      @JsonKey(name: 'is_online_only') bool? isOnlineOnly,
      @JsonKey(name: 'social_links') Map<String, String>? socialLinks,
      @JsonKey(name: 'working_hours') Map<String, dynamic>? workingHours,
      @JsonKey(name: 'years_of_experience') int? yearsOfExperience,
      List<String>? languages});
}

/// @nodoc
class _$CreateMasterProfileRequestCopyWithImpl<$Res,
        $Val extends CreateMasterProfileRequest>
    implements $CreateMasterProfileRequestCopyWith<$Res> {
  _$CreateMasterProfileRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateMasterProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? businessName = freezed,
    Object? bio = freezed,
    Object? categoryIds = null,
    Object? subcategoryIds = freezed,
    Object? locationAddress = freezed,
    Object? locationLat = freezed,
    Object? locationLng = freezed,
    Object? serviceRadiusKm = freezed,
    Object? isMobile = freezed,
    Object? hasLocation = freezed,
    Object? isOnlineOnly = freezed,
    Object? socialLinks = freezed,
    Object? workingHours = freezed,
    Object? yearsOfExperience = freezed,
    Object? languages = freezed,
  }) {
    return _then(_value.copyWith(
      businessName: freezed == businessName
          ? _value.businessName
          : businessName // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryIds: null == categoryIds
          ? _value.categoryIds
          : categoryIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      subcategoryIds: freezed == subcategoryIds
          ? _value.subcategoryIds
          : subcategoryIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      locationAddress: freezed == locationAddress
          ? _value.locationAddress
          : locationAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      locationLat: freezed == locationLat
          ? _value.locationLat
          : locationLat // ignore: cast_nullable_to_non_nullable
              as double?,
      locationLng: freezed == locationLng
          ? _value.locationLng
          : locationLng // ignore: cast_nullable_to_non_nullable
              as double?,
      serviceRadiusKm: freezed == serviceRadiusKm
          ? _value.serviceRadiusKm
          : serviceRadiusKm // ignore: cast_nullable_to_non_nullable
              as int?,
      isMobile: freezed == isMobile
          ? _value.isMobile
          : isMobile // ignore: cast_nullable_to_non_nullable
              as bool?,
      hasLocation: freezed == hasLocation
          ? _value.hasLocation
          : hasLocation // ignore: cast_nullable_to_non_nullable
              as bool?,
      isOnlineOnly: freezed == isOnlineOnly
          ? _value.isOnlineOnly
          : isOnlineOnly // ignore: cast_nullable_to_non_nullable
              as bool?,
      socialLinks: freezed == socialLinks
          ? _value.socialLinks
          : socialLinks // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      workingHours: freezed == workingHours
          ? _value.workingHours
          : workingHours // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      yearsOfExperience: freezed == yearsOfExperience
          ? _value.yearsOfExperience
          : yearsOfExperience // ignore: cast_nullable_to_non_nullable
              as int?,
      languages: freezed == languages
          ? _value.languages
          : languages // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateMasterProfileRequestImplCopyWith<$Res>
    implements $CreateMasterProfileRequestCopyWith<$Res> {
  factory _$$CreateMasterProfileRequestImplCopyWith(
          _$CreateMasterProfileRequestImpl value,
          $Res Function(_$CreateMasterProfileRequestImpl) then) =
      __$$CreateMasterProfileRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'business_name') String? businessName,
      String? bio,
      @JsonKey(name: 'category_ids') List<String> categoryIds,
      @JsonKey(name: 'subcategory_ids') List<String>? subcategoryIds,
      @JsonKey(name: 'location_address') String? locationAddress,
      @JsonKey(name: 'location_lat') double? locationLat,
      @JsonKey(name: 'location_lng') double? locationLng,
      @JsonKey(name: 'service_radius_km') int? serviceRadiusKm,
      @JsonKey(name: 'is_mobile') bool? isMobile,
      @JsonKey(name: 'has_location') bool? hasLocation,
      @JsonKey(name: 'is_online_only') bool? isOnlineOnly,
      @JsonKey(name: 'social_links') Map<String, String>? socialLinks,
      @JsonKey(name: 'working_hours') Map<String, dynamic>? workingHours,
      @JsonKey(name: 'years_of_experience') int? yearsOfExperience,
      List<String>? languages});
}

/// @nodoc
class __$$CreateMasterProfileRequestImplCopyWithImpl<$Res>
    extends _$CreateMasterProfileRequestCopyWithImpl<$Res,
        _$CreateMasterProfileRequestImpl>
    implements _$$CreateMasterProfileRequestImplCopyWith<$Res> {
  __$$CreateMasterProfileRequestImplCopyWithImpl(
      _$CreateMasterProfileRequestImpl _value,
      $Res Function(_$CreateMasterProfileRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateMasterProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? businessName = freezed,
    Object? bio = freezed,
    Object? categoryIds = null,
    Object? subcategoryIds = freezed,
    Object? locationAddress = freezed,
    Object? locationLat = freezed,
    Object? locationLng = freezed,
    Object? serviceRadiusKm = freezed,
    Object? isMobile = freezed,
    Object? hasLocation = freezed,
    Object? isOnlineOnly = freezed,
    Object? socialLinks = freezed,
    Object? workingHours = freezed,
    Object? yearsOfExperience = freezed,
    Object? languages = freezed,
  }) {
    return _then(_$CreateMasterProfileRequestImpl(
      businessName: freezed == businessName
          ? _value.businessName
          : businessName // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryIds: null == categoryIds
          ? _value._categoryIds
          : categoryIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      subcategoryIds: freezed == subcategoryIds
          ? _value._subcategoryIds
          : subcategoryIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      locationAddress: freezed == locationAddress
          ? _value.locationAddress
          : locationAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      locationLat: freezed == locationLat
          ? _value.locationLat
          : locationLat // ignore: cast_nullable_to_non_nullable
              as double?,
      locationLng: freezed == locationLng
          ? _value.locationLng
          : locationLng // ignore: cast_nullable_to_non_nullable
              as double?,
      serviceRadiusKm: freezed == serviceRadiusKm
          ? _value.serviceRadiusKm
          : serviceRadiusKm // ignore: cast_nullable_to_non_nullable
              as int?,
      isMobile: freezed == isMobile
          ? _value.isMobile
          : isMobile // ignore: cast_nullable_to_non_nullable
              as bool?,
      hasLocation: freezed == hasLocation
          ? _value.hasLocation
          : hasLocation // ignore: cast_nullable_to_non_nullable
              as bool?,
      isOnlineOnly: freezed == isOnlineOnly
          ? _value.isOnlineOnly
          : isOnlineOnly // ignore: cast_nullable_to_non_nullable
              as bool?,
      socialLinks: freezed == socialLinks
          ? _value._socialLinks
          : socialLinks // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      workingHours: freezed == workingHours
          ? _value._workingHours
          : workingHours // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      yearsOfExperience: freezed == yearsOfExperience
          ? _value.yearsOfExperience
          : yearsOfExperience // ignore: cast_nullable_to_non_nullable
              as int?,
      languages: freezed == languages
          ? _value._languages
          : languages // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateMasterProfileRequestImpl implements _CreateMasterProfileRequest {
  const _$CreateMasterProfileRequestImpl(
      {@JsonKey(name: 'business_name') this.businessName,
      this.bio,
      @JsonKey(name: 'category_ids') required final List<String> categoryIds,
      @JsonKey(name: 'subcategory_ids') final List<String>? subcategoryIds,
      @JsonKey(name: 'location_address') this.locationAddress,
      @JsonKey(name: 'location_lat') this.locationLat,
      @JsonKey(name: 'location_lng') this.locationLng,
      @JsonKey(name: 'service_radius_km') this.serviceRadiusKm,
      @JsonKey(name: 'is_mobile') this.isMobile,
      @JsonKey(name: 'has_location') this.hasLocation,
      @JsonKey(name: 'is_online_only') this.isOnlineOnly,
      @JsonKey(name: 'social_links') final Map<String, String>? socialLinks,
      @JsonKey(name: 'working_hours') final Map<String, dynamic>? workingHours,
      @JsonKey(name: 'years_of_experience') this.yearsOfExperience,
      final List<String>? languages})
      : _categoryIds = categoryIds,
        _subcategoryIds = subcategoryIds,
        _socialLinks = socialLinks,
        _workingHours = workingHours,
        _languages = languages;

  factory _$CreateMasterProfileRequestImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$CreateMasterProfileRequestImplFromJson(json);

  @override
  @JsonKey(name: 'business_name')
  final String? businessName;
  @override
  final String? bio;
  final List<String> _categoryIds;
  @override
  @JsonKey(name: 'category_ids')
  List<String> get categoryIds {
    if (_categoryIds is EqualUnmodifiableListView) return _categoryIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categoryIds);
  }

  final List<String>? _subcategoryIds;
  @override
  @JsonKey(name: 'subcategory_ids')
  List<String>? get subcategoryIds {
    final value = _subcategoryIds;
    if (value == null) return null;
    if (_subcategoryIds is EqualUnmodifiableListView) return _subcategoryIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'location_address')
  final String? locationAddress;
  @override
  @JsonKey(name: 'location_lat')
  final double? locationLat;
  @override
  @JsonKey(name: 'location_lng')
  final double? locationLng;
  @override
  @JsonKey(name: 'service_radius_km')
  final int? serviceRadiusKm;
  @override
  @JsonKey(name: 'is_mobile')
  final bool? isMobile;
  @override
  @JsonKey(name: 'has_location')
  final bool? hasLocation;
  @override
  @JsonKey(name: 'is_online_only')
  final bool? isOnlineOnly;
  final Map<String, String>? _socialLinks;
  @override
  @JsonKey(name: 'social_links')
  Map<String, String>? get socialLinks {
    final value = _socialLinks;
    if (value == null) return null;
    if (_socialLinks is EqualUnmodifiableMapView) return _socialLinks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _workingHours;
  @override
  @JsonKey(name: 'working_hours')
  Map<String, dynamic>? get workingHours {
    final value = _workingHours;
    if (value == null) return null;
    if (_workingHours is EqualUnmodifiableMapView) return _workingHours;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(name: 'years_of_experience')
  final int? yearsOfExperience;
  final List<String>? _languages;
  @override
  List<String>? get languages {
    final value = _languages;
    if (value == null) return null;
    if (_languages is EqualUnmodifiableListView) return _languages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'CreateMasterProfileRequest(businessName: $businessName, bio: $bio, categoryIds: $categoryIds, subcategoryIds: $subcategoryIds, locationAddress: $locationAddress, locationLat: $locationLat, locationLng: $locationLng, serviceRadiusKm: $serviceRadiusKm, isMobile: $isMobile, hasLocation: $hasLocation, isOnlineOnly: $isOnlineOnly, socialLinks: $socialLinks, workingHours: $workingHours, yearsOfExperience: $yearsOfExperience, languages: $languages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateMasterProfileRequestImpl &&
            (identical(other.businessName, businessName) ||
                other.businessName == businessName) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            const DeepCollectionEquality()
                .equals(other._categoryIds, _categoryIds) &&
            const DeepCollectionEquality()
                .equals(other._subcategoryIds, _subcategoryIds) &&
            (identical(other.locationAddress, locationAddress) ||
                other.locationAddress == locationAddress) &&
            (identical(other.locationLat, locationLat) ||
                other.locationLat == locationLat) &&
            (identical(other.locationLng, locationLng) ||
                other.locationLng == locationLng) &&
            (identical(other.serviceRadiusKm, serviceRadiusKm) ||
                other.serviceRadiusKm == serviceRadiusKm) &&
            (identical(other.isMobile, isMobile) ||
                other.isMobile == isMobile) &&
            (identical(other.hasLocation, hasLocation) ||
                other.hasLocation == hasLocation) &&
            (identical(other.isOnlineOnly, isOnlineOnly) ||
                other.isOnlineOnly == isOnlineOnly) &&
            const DeepCollectionEquality()
                .equals(other._socialLinks, _socialLinks) &&
            const DeepCollectionEquality()
                .equals(other._workingHours, _workingHours) &&
            (identical(other.yearsOfExperience, yearsOfExperience) ||
                other.yearsOfExperience == yearsOfExperience) &&
            const DeepCollectionEquality()
                .equals(other._languages, _languages));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      businessName,
      bio,
      const DeepCollectionEquality().hash(_categoryIds),
      const DeepCollectionEquality().hash(_subcategoryIds),
      locationAddress,
      locationLat,
      locationLng,
      serviceRadiusKm,
      isMobile,
      hasLocation,
      isOnlineOnly,
      const DeepCollectionEquality().hash(_socialLinks),
      const DeepCollectionEquality().hash(_workingHours),
      yearsOfExperience,
      const DeepCollectionEquality().hash(_languages));

  /// Create a copy of CreateMasterProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateMasterProfileRequestImplCopyWith<_$CreateMasterProfileRequestImpl>
      get copyWith => __$$CreateMasterProfileRequestImplCopyWithImpl<
          _$CreateMasterProfileRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateMasterProfileRequestImplToJson(
      this,
    );
  }
}

abstract class _CreateMasterProfileRequest
    implements CreateMasterProfileRequest {
  const factory _CreateMasterProfileRequest(
      {@JsonKey(name: 'business_name') final String? businessName,
      final String? bio,
      @JsonKey(name: 'category_ids') required final List<String> categoryIds,
      @JsonKey(name: 'subcategory_ids') final List<String>? subcategoryIds,
      @JsonKey(name: 'location_address') final String? locationAddress,
      @JsonKey(name: 'location_lat') final double? locationLat,
      @JsonKey(name: 'location_lng') final double? locationLng,
      @JsonKey(name: 'service_radius_km') final int? serviceRadiusKm,
      @JsonKey(name: 'is_mobile') final bool? isMobile,
      @JsonKey(name: 'has_location') final bool? hasLocation,
      @JsonKey(name: 'is_online_only') final bool? isOnlineOnly,
      @JsonKey(name: 'social_links') final Map<String, String>? socialLinks,
      @JsonKey(name: 'working_hours') final Map<String, dynamic>? workingHours,
      @JsonKey(name: 'years_of_experience') final int? yearsOfExperience,
      final List<String>? languages}) = _$CreateMasterProfileRequestImpl;

  factory _CreateMasterProfileRequest.fromJson(Map<String, dynamic> json) =
      _$CreateMasterProfileRequestImpl.fromJson;

  @override
  @JsonKey(name: 'business_name')
  String? get businessName;
  @override
  String? get bio;
  @override
  @JsonKey(name: 'category_ids')
  List<String> get categoryIds;
  @override
  @JsonKey(name: 'subcategory_ids')
  List<String>? get subcategoryIds;
  @override
  @JsonKey(name: 'location_address')
  String? get locationAddress;
  @override
  @JsonKey(name: 'location_lat')
  double? get locationLat;
  @override
  @JsonKey(name: 'location_lng')
  double? get locationLng;
  @override
  @JsonKey(name: 'service_radius_km')
  int? get serviceRadiusKm;
  @override
  @JsonKey(name: 'is_mobile')
  bool? get isMobile;
  @override
  @JsonKey(name: 'has_location')
  bool? get hasLocation;
  @override
  @JsonKey(name: 'is_online_only')
  bool? get isOnlineOnly;
  @override
  @JsonKey(name: 'social_links')
  Map<String, String>? get socialLinks;
  @override
  @JsonKey(name: 'working_hours')
  Map<String, dynamic>? get workingHours;
  @override
  @JsonKey(name: 'years_of_experience')
  int? get yearsOfExperience;
  @override
  List<String>? get languages;

  /// Create a copy of CreateMasterProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateMasterProfileRequestImplCopyWith<_$CreateMasterProfileRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

UpdateMasterProfileRequest _$UpdateMasterProfileRequestFromJson(
    Map<String, dynamic> json) {
  return _UpdateMasterProfileRequest.fromJson(json);
}

/// @nodoc
mixin _$UpdateMasterProfileRequest {
  @JsonKey(name: 'business_name')
  String? get businessName => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_ids')
  List<String>? get categoryIds => throw _privateConstructorUsedError;
  @JsonKey(name: 'subcategory_ids')
  List<String>? get subcategoryIds => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_address')
  String? get locationAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_lat')
  double? get locationLat => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_lng')
  double? get locationLng => throw _privateConstructorUsedError;
  @JsonKey(name: 'service_radius_km')
  int? get serviceRadiusKm => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_mobile')
  bool? get isMobile => throw _privateConstructorUsedError;
  @JsonKey(name: 'has_location')
  bool? get hasLocation => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_online_only')
  bool? get isOnlineOnly => throw _privateConstructorUsedError;
  @JsonKey(name: 'social_links')
  Map<String, String>? get socialLinks => throw _privateConstructorUsedError;
  @JsonKey(name: 'working_hours')
  Map<String, dynamic>? get workingHours => throw _privateConstructorUsedError;
  @JsonKey(name: 'min_booking_hours')
  int? get minBookingHours => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_bookings_per_day')
  int? get maxBookingsPerDay => throw _privateConstructorUsedError;
  @JsonKey(name: 'auto_confirm')
  bool? get autoConfirm => throw _privateConstructorUsedError;
  @JsonKey(name: 'years_of_experience')
  int? get yearsOfExperience => throw _privateConstructorUsedError;
  List<String>? get languages => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool? get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'setup_step')
  int? get setupStep => throw _privateConstructorUsedError;

  /// Serializes this UpdateMasterProfileRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateMasterProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateMasterProfileRequestCopyWith<UpdateMasterProfileRequest>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateMasterProfileRequestCopyWith<$Res> {
  factory $UpdateMasterProfileRequestCopyWith(UpdateMasterProfileRequest value,
          $Res Function(UpdateMasterProfileRequest) then) =
      _$UpdateMasterProfileRequestCopyWithImpl<$Res,
          UpdateMasterProfileRequest>;
  @useResult
  $Res call(
      {@JsonKey(name: 'business_name') String? businessName,
      String? bio,
      @JsonKey(name: 'category_ids') List<String>? categoryIds,
      @JsonKey(name: 'subcategory_ids') List<String>? subcategoryIds,
      @JsonKey(name: 'location_address') String? locationAddress,
      @JsonKey(name: 'location_lat') double? locationLat,
      @JsonKey(name: 'location_lng') double? locationLng,
      @JsonKey(name: 'service_radius_km') int? serviceRadiusKm,
      @JsonKey(name: 'is_mobile') bool? isMobile,
      @JsonKey(name: 'has_location') bool? hasLocation,
      @JsonKey(name: 'is_online_only') bool? isOnlineOnly,
      @JsonKey(name: 'social_links') Map<String, String>? socialLinks,
      @JsonKey(name: 'working_hours') Map<String, dynamic>? workingHours,
      @JsonKey(name: 'min_booking_hours') int? minBookingHours,
      @JsonKey(name: 'max_bookings_per_day') int? maxBookingsPerDay,
      @JsonKey(name: 'auto_confirm') bool? autoConfirm,
      @JsonKey(name: 'years_of_experience') int? yearsOfExperience,
      List<String>? languages,
      @JsonKey(name: 'is_active') bool? isActive,
      @JsonKey(name: 'setup_step') int? setupStep});
}

/// @nodoc
class _$UpdateMasterProfileRequestCopyWithImpl<$Res,
        $Val extends UpdateMasterProfileRequest>
    implements $UpdateMasterProfileRequestCopyWith<$Res> {
  _$UpdateMasterProfileRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateMasterProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? businessName = freezed,
    Object? bio = freezed,
    Object? categoryIds = freezed,
    Object? subcategoryIds = freezed,
    Object? locationAddress = freezed,
    Object? locationLat = freezed,
    Object? locationLng = freezed,
    Object? serviceRadiusKm = freezed,
    Object? isMobile = freezed,
    Object? hasLocation = freezed,
    Object? isOnlineOnly = freezed,
    Object? socialLinks = freezed,
    Object? workingHours = freezed,
    Object? minBookingHours = freezed,
    Object? maxBookingsPerDay = freezed,
    Object? autoConfirm = freezed,
    Object? yearsOfExperience = freezed,
    Object? languages = freezed,
    Object? isActive = freezed,
    Object? setupStep = freezed,
  }) {
    return _then(_value.copyWith(
      businessName: freezed == businessName
          ? _value.businessName
          : businessName // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryIds: freezed == categoryIds
          ? _value.categoryIds
          : categoryIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      subcategoryIds: freezed == subcategoryIds
          ? _value.subcategoryIds
          : subcategoryIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      locationAddress: freezed == locationAddress
          ? _value.locationAddress
          : locationAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      locationLat: freezed == locationLat
          ? _value.locationLat
          : locationLat // ignore: cast_nullable_to_non_nullable
              as double?,
      locationLng: freezed == locationLng
          ? _value.locationLng
          : locationLng // ignore: cast_nullable_to_non_nullable
              as double?,
      serviceRadiusKm: freezed == serviceRadiusKm
          ? _value.serviceRadiusKm
          : serviceRadiusKm // ignore: cast_nullable_to_non_nullable
              as int?,
      isMobile: freezed == isMobile
          ? _value.isMobile
          : isMobile // ignore: cast_nullable_to_non_nullable
              as bool?,
      hasLocation: freezed == hasLocation
          ? _value.hasLocation
          : hasLocation // ignore: cast_nullable_to_non_nullable
              as bool?,
      isOnlineOnly: freezed == isOnlineOnly
          ? _value.isOnlineOnly
          : isOnlineOnly // ignore: cast_nullable_to_non_nullable
              as bool?,
      socialLinks: freezed == socialLinks
          ? _value.socialLinks
          : socialLinks // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      workingHours: freezed == workingHours
          ? _value.workingHours
          : workingHours // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      minBookingHours: freezed == minBookingHours
          ? _value.minBookingHours
          : minBookingHours // ignore: cast_nullable_to_non_nullable
              as int?,
      maxBookingsPerDay: freezed == maxBookingsPerDay
          ? _value.maxBookingsPerDay
          : maxBookingsPerDay // ignore: cast_nullable_to_non_nullable
              as int?,
      autoConfirm: freezed == autoConfirm
          ? _value.autoConfirm
          : autoConfirm // ignore: cast_nullable_to_non_nullable
              as bool?,
      yearsOfExperience: freezed == yearsOfExperience
          ? _value.yearsOfExperience
          : yearsOfExperience // ignore: cast_nullable_to_non_nullable
              as int?,
      languages: freezed == languages
          ? _value.languages
          : languages // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
      setupStep: freezed == setupStep
          ? _value.setupStep
          : setupStep // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateMasterProfileRequestImplCopyWith<$Res>
    implements $UpdateMasterProfileRequestCopyWith<$Res> {
  factory _$$UpdateMasterProfileRequestImplCopyWith(
          _$UpdateMasterProfileRequestImpl value,
          $Res Function(_$UpdateMasterProfileRequestImpl) then) =
      __$$UpdateMasterProfileRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'business_name') String? businessName,
      String? bio,
      @JsonKey(name: 'category_ids') List<String>? categoryIds,
      @JsonKey(name: 'subcategory_ids') List<String>? subcategoryIds,
      @JsonKey(name: 'location_address') String? locationAddress,
      @JsonKey(name: 'location_lat') double? locationLat,
      @JsonKey(name: 'location_lng') double? locationLng,
      @JsonKey(name: 'service_radius_km') int? serviceRadiusKm,
      @JsonKey(name: 'is_mobile') bool? isMobile,
      @JsonKey(name: 'has_location') bool? hasLocation,
      @JsonKey(name: 'is_online_only') bool? isOnlineOnly,
      @JsonKey(name: 'social_links') Map<String, String>? socialLinks,
      @JsonKey(name: 'working_hours') Map<String, dynamic>? workingHours,
      @JsonKey(name: 'min_booking_hours') int? minBookingHours,
      @JsonKey(name: 'max_bookings_per_day') int? maxBookingsPerDay,
      @JsonKey(name: 'auto_confirm') bool? autoConfirm,
      @JsonKey(name: 'years_of_experience') int? yearsOfExperience,
      List<String>? languages,
      @JsonKey(name: 'is_active') bool? isActive,
      @JsonKey(name: 'setup_step') int? setupStep});
}

/// @nodoc
class __$$UpdateMasterProfileRequestImplCopyWithImpl<$Res>
    extends _$UpdateMasterProfileRequestCopyWithImpl<$Res,
        _$UpdateMasterProfileRequestImpl>
    implements _$$UpdateMasterProfileRequestImplCopyWith<$Res> {
  __$$UpdateMasterProfileRequestImplCopyWithImpl(
      _$UpdateMasterProfileRequestImpl _value,
      $Res Function(_$UpdateMasterProfileRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateMasterProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? businessName = freezed,
    Object? bio = freezed,
    Object? categoryIds = freezed,
    Object? subcategoryIds = freezed,
    Object? locationAddress = freezed,
    Object? locationLat = freezed,
    Object? locationLng = freezed,
    Object? serviceRadiusKm = freezed,
    Object? isMobile = freezed,
    Object? hasLocation = freezed,
    Object? isOnlineOnly = freezed,
    Object? socialLinks = freezed,
    Object? workingHours = freezed,
    Object? minBookingHours = freezed,
    Object? maxBookingsPerDay = freezed,
    Object? autoConfirm = freezed,
    Object? yearsOfExperience = freezed,
    Object? languages = freezed,
    Object? isActive = freezed,
    Object? setupStep = freezed,
  }) {
    return _then(_$UpdateMasterProfileRequestImpl(
      businessName: freezed == businessName
          ? _value.businessName
          : businessName // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryIds: freezed == categoryIds
          ? _value._categoryIds
          : categoryIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      subcategoryIds: freezed == subcategoryIds
          ? _value._subcategoryIds
          : subcategoryIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      locationAddress: freezed == locationAddress
          ? _value.locationAddress
          : locationAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      locationLat: freezed == locationLat
          ? _value.locationLat
          : locationLat // ignore: cast_nullable_to_non_nullable
              as double?,
      locationLng: freezed == locationLng
          ? _value.locationLng
          : locationLng // ignore: cast_nullable_to_non_nullable
              as double?,
      serviceRadiusKm: freezed == serviceRadiusKm
          ? _value.serviceRadiusKm
          : serviceRadiusKm // ignore: cast_nullable_to_non_nullable
              as int?,
      isMobile: freezed == isMobile
          ? _value.isMobile
          : isMobile // ignore: cast_nullable_to_non_nullable
              as bool?,
      hasLocation: freezed == hasLocation
          ? _value.hasLocation
          : hasLocation // ignore: cast_nullable_to_non_nullable
              as bool?,
      isOnlineOnly: freezed == isOnlineOnly
          ? _value.isOnlineOnly
          : isOnlineOnly // ignore: cast_nullable_to_non_nullable
              as bool?,
      socialLinks: freezed == socialLinks
          ? _value._socialLinks
          : socialLinks // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      workingHours: freezed == workingHours
          ? _value._workingHours
          : workingHours // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      minBookingHours: freezed == minBookingHours
          ? _value.minBookingHours
          : minBookingHours // ignore: cast_nullable_to_non_nullable
              as int?,
      maxBookingsPerDay: freezed == maxBookingsPerDay
          ? _value.maxBookingsPerDay
          : maxBookingsPerDay // ignore: cast_nullable_to_non_nullable
              as int?,
      autoConfirm: freezed == autoConfirm
          ? _value.autoConfirm
          : autoConfirm // ignore: cast_nullable_to_non_nullable
              as bool?,
      yearsOfExperience: freezed == yearsOfExperience
          ? _value.yearsOfExperience
          : yearsOfExperience // ignore: cast_nullable_to_non_nullable
              as int?,
      languages: freezed == languages
          ? _value._languages
          : languages // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
      setupStep: freezed == setupStep
          ? _value.setupStep
          : setupStep // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateMasterProfileRequestImpl implements _UpdateMasterProfileRequest {
  const _$UpdateMasterProfileRequestImpl(
      {@JsonKey(name: 'business_name') this.businessName,
      this.bio,
      @JsonKey(name: 'category_ids') final List<String>? categoryIds,
      @JsonKey(name: 'subcategory_ids') final List<String>? subcategoryIds,
      @JsonKey(name: 'location_address') this.locationAddress,
      @JsonKey(name: 'location_lat') this.locationLat,
      @JsonKey(name: 'location_lng') this.locationLng,
      @JsonKey(name: 'service_radius_km') this.serviceRadiusKm,
      @JsonKey(name: 'is_mobile') this.isMobile,
      @JsonKey(name: 'has_location') this.hasLocation,
      @JsonKey(name: 'is_online_only') this.isOnlineOnly,
      @JsonKey(name: 'social_links') final Map<String, String>? socialLinks,
      @JsonKey(name: 'working_hours') final Map<String, dynamic>? workingHours,
      @JsonKey(name: 'min_booking_hours') this.minBookingHours,
      @JsonKey(name: 'max_bookings_per_day') this.maxBookingsPerDay,
      @JsonKey(name: 'auto_confirm') this.autoConfirm,
      @JsonKey(name: 'years_of_experience') this.yearsOfExperience,
      final List<String>? languages,
      @JsonKey(name: 'is_active') this.isActive,
      @JsonKey(name: 'setup_step') this.setupStep})
      : _categoryIds = categoryIds,
        _subcategoryIds = subcategoryIds,
        _socialLinks = socialLinks,
        _workingHours = workingHours,
        _languages = languages;

  factory _$UpdateMasterProfileRequestImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$UpdateMasterProfileRequestImplFromJson(json);

  @override
  @JsonKey(name: 'business_name')
  final String? businessName;
  @override
  final String? bio;
  final List<String>? _categoryIds;
  @override
  @JsonKey(name: 'category_ids')
  List<String>? get categoryIds {
    final value = _categoryIds;
    if (value == null) return null;
    if (_categoryIds is EqualUnmodifiableListView) return _categoryIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _subcategoryIds;
  @override
  @JsonKey(name: 'subcategory_ids')
  List<String>? get subcategoryIds {
    final value = _subcategoryIds;
    if (value == null) return null;
    if (_subcategoryIds is EqualUnmodifiableListView) return _subcategoryIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'location_address')
  final String? locationAddress;
  @override
  @JsonKey(name: 'location_lat')
  final double? locationLat;
  @override
  @JsonKey(name: 'location_lng')
  final double? locationLng;
  @override
  @JsonKey(name: 'service_radius_km')
  final int? serviceRadiusKm;
  @override
  @JsonKey(name: 'is_mobile')
  final bool? isMobile;
  @override
  @JsonKey(name: 'has_location')
  final bool? hasLocation;
  @override
  @JsonKey(name: 'is_online_only')
  final bool? isOnlineOnly;
  final Map<String, String>? _socialLinks;
  @override
  @JsonKey(name: 'social_links')
  Map<String, String>? get socialLinks {
    final value = _socialLinks;
    if (value == null) return null;
    if (_socialLinks is EqualUnmodifiableMapView) return _socialLinks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _workingHours;
  @override
  @JsonKey(name: 'working_hours')
  Map<String, dynamic>? get workingHours {
    final value = _workingHours;
    if (value == null) return null;
    if (_workingHours is EqualUnmodifiableMapView) return _workingHours;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(name: 'min_booking_hours')
  final int? minBookingHours;
  @override
  @JsonKey(name: 'max_bookings_per_day')
  final int? maxBookingsPerDay;
  @override
  @JsonKey(name: 'auto_confirm')
  final bool? autoConfirm;
  @override
  @JsonKey(name: 'years_of_experience')
  final int? yearsOfExperience;
  final List<String>? _languages;
  @override
  List<String>? get languages {
    final value = _languages;
    if (value == null) return null;
    if (_languages is EqualUnmodifiableListView) return _languages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'is_active')
  final bool? isActive;
  @override
  @JsonKey(name: 'setup_step')
  final int? setupStep;

  @override
  String toString() {
    return 'UpdateMasterProfileRequest(businessName: $businessName, bio: $bio, categoryIds: $categoryIds, subcategoryIds: $subcategoryIds, locationAddress: $locationAddress, locationLat: $locationLat, locationLng: $locationLng, serviceRadiusKm: $serviceRadiusKm, isMobile: $isMobile, hasLocation: $hasLocation, isOnlineOnly: $isOnlineOnly, socialLinks: $socialLinks, workingHours: $workingHours, minBookingHours: $minBookingHours, maxBookingsPerDay: $maxBookingsPerDay, autoConfirm: $autoConfirm, yearsOfExperience: $yearsOfExperience, languages: $languages, isActive: $isActive, setupStep: $setupStep)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateMasterProfileRequestImpl &&
            (identical(other.businessName, businessName) ||
                other.businessName == businessName) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            const DeepCollectionEquality()
                .equals(other._categoryIds, _categoryIds) &&
            const DeepCollectionEquality()
                .equals(other._subcategoryIds, _subcategoryIds) &&
            (identical(other.locationAddress, locationAddress) ||
                other.locationAddress == locationAddress) &&
            (identical(other.locationLat, locationLat) ||
                other.locationLat == locationLat) &&
            (identical(other.locationLng, locationLng) ||
                other.locationLng == locationLng) &&
            (identical(other.serviceRadiusKm, serviceRadiusKm) ||
                other.serviceRadiusKm == serviceRadiusKm) &&
            (identical(other.isMobile, isMobile) ||
                other.isMobile == isMobile) &&
            (identical(other.hasLocation, hasLocation) ||
                other.hasLocation == hasLocation) &&
            (identical(other.isOnlineOnly, isOnlineOnly) ||
                other.isOnlineOnly == isOnlineOnly) &&
            const DeepCollectionEquality()
                .equals(other._socialLinks, _socialLinks) &&
            const DeepCollectionEquality()
                .equals(other._workingHours, _workingHours) &&
            (identical(other.minBookingHours, minBookingHours) ||
                other.minBookingHours == minBookingHours) &&
            (identical(other.maxBookingsPerDay, maxBookingsPerDay) ||
                other.maxBookingsPerDay == maxBookingsPerDay) &&
            (identical(other.autoConfirm, autoConfirm) ||
                other.autoConfirm == autoConfirm) &&
            (identical(other.yearsOfExperience, yearsOfExperience) ||
                other.yearsOfExperience == yearsOfExperience) &&
            const DeepCollectionEquality()
                .equals(other._languages, _languages) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.setupStep, setupStep) ||
                other.setupStep == setupStep));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        businessName,
        bio,
        const DeepCollectionEquality().hash(_categoryIds),
        const DeepCollectionEquality().hash(_subcategoryIds),
        locationAddress,
        locationLat,
        locationLng,
        serviceRadiusKm,
        isMobile,
        hasLocation,
        isOnlineOnly,
        const DeepCollectionEquality().hash(_socialLinks),
        const DeepCollectionEquality().hash(_workingHours),
        minBookingHours,
        maxBookingsPerDay,
        autoConfirm,
        yearsOfExperience,
        const DeepCollectionEquality().hash(_languages),
        isActive,
        setupStep
      ]);

  /// Create a copy of UpdateMasterProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateMasterProfileRequestImplCopyWith<_$UpdateMasterProfileRequestImpl>
      get copyWith => __$$UpdateMasterProfileRequestImplCopyWithImpl<
          _$UpdateMasterProfileRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateMasterProfileRequestImplToJson(
      this,
    );
  }
}

abstract class _UpdateMasterProfileRequest
    implements UpdateMasterProfileRequest {
  const factory _UpdateMasterProfileRequest(
      {@JsonKey(name: 'business_name') final String? businessName,
      final String? bio,
      @JsonKey(name: 'category_ids') final List<String>? categoryIds,
      @JsonKey(name: 'subcategory_ids') final List<String>? subcategoryIds,
      @JsonKey(name: 'location_address') final String? locationAddress,
      @JsonKey(name: 'location_lat') final double? locationLat,
      @JsonKey(name: 'location_lng') final double? locationLng,
      @JsonKey(name: 'service_radius_km') final int? serviceRadiusKm,
      @JsonKey(name: 'is_mobile') final bool? isMobile,
      @JsonKey(name: 'has_location') final bool? hasLocation,
      @JsonKey(name: 'is_online_only') final bool? isOnlineOnly,
      @JsonKey(name: 'social_links') final Map<String, String>? socialLinks,
      @JsonKey(name: 'working_hours') final Map<String, dynamic>? workingHours,
      @JsonKey(name: 'min_booking_hours') final int? minBookingHours,
      @JsonKey(name: 'max_bookings_per_day') final int? maxBookingsPerDay,
      @JsonKey(name: 'auto_confirm') final bool? autoConfirm,
      @JsonKey(name: 'years_of_experience') final int? yearsOfExperience,
      final List<String>? languages,
      @JsonKey(name: 'is_active') final bool? isActive,
      @JsonKey(name: 'setup_step')
      final int? setupStep}) = _$UpdateMasterProfileRequestImpl;

  factory _UpdateMasterProfileRequest.fromJson(Map<String, dynamic> json) =
      _$UpdateMasterProfileRequestImpl.fromJson;

  @override
  @JsonKey(name: 'business_name')
  String? get businessName;
  @override
  String? get bio;
  @override
  @JsonKey(name: 'category_ids')
  List<String>? get categoryIds;
  @override
  @JsonKey(name: 'subcategory_ids')
  List<String>? get subcategoryIds;
  @override
  @JsonKey(name: 'location_address')
  String? get locationAddress;
  @override
  @JsonKey(name: 'location_lat')
  double? get locationLat;
  @override
  @JsonKey(name: 'location_lng')
  double? get locationLng;
  @override
  @JsonKey(name: 'service_radius_km')
  int? get serviceRadiusKm;
  @override
  @JsonKey(name: 'is_mobile')
  bool? get isMobile;
  @override
  @JsonKey(name: 'has_location')
  bool? get hasLocation;
  @override
  @JsonKey(name: 'is_online_only')
  bool? get isOnlineOnly;
  @override
  @JsonKey(name: 'social_links')
  Map<String, String>? get socialLinks;
  @override
  @JsonKey(name: 'working_hours')
  Map<String, dynamic>? get workingHours;
  @override
  @JsonKey(name: 'min_booking_hours')
  int? get minBookingHours;
  @override
  @JsonKey(name: 'max_bookings_per_day')
  int? get maxBookingsPerDay;
  @override
  @JsonKey(name: 'auto_confirm')
  bool? get autoConfirm;
  @override
  @JsonKey(name: 'years_of_experience')
  int? get yearsOfExperience;
  @override
  List<String>? get languages;
  @override
  @JsonKey(name: 'is_active')
  bool? get isActive;
  @override
  @JsonKey(name: 'setup_step')
  int? get setupStep;

  /// Create a copy of UpdateMasterProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateMasterProfileRequestImplCopyWith<_$UpdateMasterProfileRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
