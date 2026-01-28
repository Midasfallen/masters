// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ServiceModel _$ServiceModelFromJson(Map<String, dynamic> json) {
  return _ServiceModel.fromJson(json);
}

/// @nodoc
mixin _$ServiceModel {
  String get id => throw _privateConstructorUsedError;
  String get masterId => throw _privateConstructorUsedError;
  String get categoryId => throw _privateConstructorUsedError;
  String? get subcategoryId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  double? get priceFrom => throw _privateConstructorUsedError;
  double? get priceTo => throw _privateConstructorUsedError;
  int get durationMinutes => throw _privateConstructorUsedError;
  bool get isBookableOnline => throw _privateConstructorUsedError;
  bool get isMobile => throw _privateConstructorUsedError;
  bool get isInSalon => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  List<String> get photoUrls => throw _privateConstructorUsedError;
  int get bookingsCount => throw _privateConstructorUsedError;
  double get averageRating => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  int get displayOrder => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ServiceModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ServiceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ServiceModelCopyWith<ServiceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServiceModelCopyWith<$Res> {
  factory $ServiceModelCopyWith(
          ServiceModel value, $Res Function(ServiceModel) then) =
      _$ServiceModelCopyWithImpl<$Res, ServiceModel>;
  @useResult
  $Res call(
      {String id,
      String masterId,
      String categoryId,
      String? subcategoryId,
      String name,
      String? description,
      double price,
      String currency,
      double? priceFrom,
      double? priceTo,
      int durationMinutes,
      bool isBookableOnline,
      bool isMobile,
      bool isInSalon,
      List<String> tags,
      List<String> photoUrls,
      int bookingsCount,
      double averageRating,
      bool isActive,
      int displayOrder,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$ServiceModelCopyWithImpl<$Res, $Val extends ServiceModel>
    implements $ServiceModelCopyWith<$Res> {
  _$ServiceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ServiceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? masterId = null,
    Object? categoryId = null,
    Object? subcategoryId = freezed,
    Object? name = null,
    Object? description = freezed,
    Object? price = null,
    Object? currency = null,
    Object? priceFrom = freezed,
    Object? priceTo = freezed,
    Object? durationMinutes = null,
    Object? isBookableOnline = null,
    Object? isMobile = null,
    Object? isInSalon = null,
    Object? tags = null,
    Object? photoUrls = null,
    Object? bookingsCount = null,
    Object? averageRating = null,
    Object? isActive = null,
    Object? displayOrder = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      masterId: null == masterId
          ? _value.masterId
          : masterId // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      subcategoryId: freezed == subcategoryId
          ? _value.subcategoryId
          : subcategoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      priceFrom: freezed == priceFrom
          ? _value.priceFrom
          : priceFrom // ignore: cast_nullable_to_non_nullable
              as double?,
      priceTo: freezed == priceTo
          ? _value.priceTo
          : priceTo // ignore: cast_nullable_to_non_nullable
              as double?,
      durationMinutes: null == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      isBookableOnline: null == isBookableOnline
          ? _value.isBookableOnline
          : isBookableOnline // ignore: cast_nullable_to_non_nullable
              as bool,
      isMobile: null == isMobile
          ? _value.isMobile
          : isMobile // ignore: cast_nullable_to_non_nullable
              as bool,
      isInSalon: null == isInSalon
          ? _value.isInSalon
          : isInSalon // ignore: cast_nullable_to_non_nullable
              as bool,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      photoUrls: null == photoUrls
          ? _value.photoUrls
          : photoUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      bookingsCount: null == bookingsCount
          ? _value.bookingsCount
          : bookingsCount // ignore: cast_nullable_to_non_nullable
              as int,
      averageRating: null == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      displayOrder: null == displayOrder
          ? _value.displayOrder
          : displayOrder // ignore: cast_nullable_to_non_nullable
              as int,
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
}

/// @nodoc
abstract class _$$ServiceModelImplCopyWith<$Res>
    implements $ServiceModelCopyWith<$Res> {
  factory _$$ServiceModelImplCopyWith(
          _$ServiceModelImpl value, $Res Function(_$ServiceModelImpl) then) =
      __$$ServiceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String masterId,
      String categoryId,
      String? subcategoryId,
      String name,
      String? description,
      double price,
      String currency,
      double? priceFrom,
      double? priceTo,
      int durationMinutes,
      bool isBookableOnline,
      bool isMobile,
      bool isInSalon,
      List<String> tags,
      List<String> photoUrls,
      int bookingsCount,
      double averageRating,
      bool isActive,
      int displayOrder,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$ServiceModelImplCopyWithImpl<$Res>
    extends _$ServiceModelCopyWithImpl<$Res, _$ServiceModelImpl>
    implements _$$ServiceModelImplCopyWith<$Res> {
  __$$ServiceModelImplCopyWithImpl(
      _$ServiceModelImpl _value, $Res Function(_$ServiceModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ServiceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? masterId = null,
    Object? categoryId = null,
    Object? subcategoryId = freezed,
    Object? name = null,
    Object? description = freezed,
    Object? price = null,
    Object? currency = null,
    Object? priceFrom = freezed,
    Object? priceTo = freezed,
    Object? durationMinutes = null,
    Object? isBookableOnline = null,
    Object? isMobile = null,
    Object? isInSalon = null,
    Object? tags = null,
    Object? photoUrls = null,
    Object? bookingsCount = null,
    Object? averageRating = null,
    Object? isActive = null,
    Object? displayOrder = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$ServiceModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      masterId: null == masterId
          ? _value.masterId
          : masterId // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      subcategoryId: freezed == subcategoryId
          ? _value.subcategoryId
          : subcategoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      priceFrom: freezed == priceFrom
          ? _value.priceFrom
          : priceFrom // ignore: cast_nullable_to_non_nullable
              as double?,
      priceTo: freezed == priceTo
          ? _value.priceTo
          : priceTo // ignore: cast_nullable_to_non_nullable
              as double?,
      durationMinutes: null == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      isBookableOnline: null == isBookableOnline
          ? _value.isBookableOnline
          : isBookableOnline // ignore: cast_nullable_to_non_nullable
              as bool,
      isMobile: null == isMobile
          ? _value.isMobile
          : isMobile // ignore: cast_nullable_to_non_nullable
              as bool,
      isInSalon: null == isInSalon
          ? _value.isInSalon
          : isInSalon // ignore: cast_nullable_to_non_nullable
              as bool,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      photoUrls: null == photoUrls
          ? _value._photoUrls
          : photoUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      bookingsCount: null == bookingsCount
          ? _value.bookingsCount
          : bookingsCount // ignore: cast_nullable_to_non_nullable
              as int,
      averageRating: null == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      displayOrder: null == displayOrder
          ? _value.displayOrder
          : displayOrder // ignore: cast_nullable_to_non_nullable
              as int,
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
class _$ServiceModelImpl implements _ServiceModel {
  const _$ServiceModelImpl(
      {required this.id,
      required this.masterId,
      required this.categoryId,
      this.subcategoryId,
      required this.name,
      this.description,
      required this.price,
      required this.currency,
      this.priceFrom,
      this.priceTo,
      required this.durationMinutes,
      required this.isBookableOnline,
      required this.isMobile,
      required this.isInSalon,
      required final List<String> tags,
      required final List<String> photoUrls,
      required this.bookingsCount,
      required this.averageRating,
      required this.isActive,
      required this.displayOrder,
      required this.createdAt,
      required this.updatedAt})
      : _tags = tags,
        _photoUrls = photoUrls;

  factory _$ServiceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServiceModelImplFromJson(json);

  @override
  final String id;
  @override
  final String masterId;
  @override
  final String categoryId;
  @override
  final String? subcategoryId;
  @override
  final String name;
  @override
  final String? description;
  @override
  final double price;
  @override
  final String currency;
  @override
  final double? priceFrom;
  @override
  final double? priceTo;
  @override
  final int durationMinutes;
  @override
  final bool isBookableOnline;
  @override
  final bool isMobile;
  @override
  final bool isInSalon;
  final List<String> _tags;
  @override
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  final List<String> _photoUrls;
  @override
  List<String> get photoUrls {
    if (_photoUrls is EqualUnmodifiableListView) return _photoUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_photoUrls);
  }

  @override
  final int bookingsCount;
  @override
  final double averageRating;
  @override
  final bool isActive;
  @override
  final int displayOrder;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'ServiceModel(id: $id, masterId: $masterId, categoryId: $categoryId, subcategoryId: $subcategoryId, name: $name, description: $description, price: $price, currency: $currency, priceFrom: $priceFrom, priceTo: $priceTo, durationMinutes: $durationMinutes, isBookableOnline: $isBookableOnline, isMobile: $isMobile, isInSalon: $isInSalon, tags: $tags, photoUrls: $photoUrls, bookingsCount: $bookingsCount, averageRating: $averageRating, isActive: $isActive, displayOrder: $displayOrder, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServiceModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.masterId, masterId) ||
                other.masterId == masterId) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.subcategoryId, subcategoryId) ||
                other.subcategoryId == subcategoryId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.priceFrom, priceFrom) ||
                other.priceFrom == priceFrom) &&
            (identical(other.priceTo, priceTo) || other.priceTo == priceTo) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            (identical(other.isBookableOnline, isBookableOnline) ||
                other.isBookableOnline == isBookableOnline) &&
            (identical(other.isMobile, isMobile) ||
                other.isMobile == isMobile) &&
            (identical(other.isInSalon, isInSalon) ||
                other.isInSalon == isInSalon) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality()
                .equals(other._photoUrls, _photoUrls) &&
            (identical(other.bookingsCount, bookingsCount) ||
                other.bookingsCount == bookingsCount) &&
            (identical(other.averageRating, averageRating) ||
                other.averageRating == averageRating) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.displayOrder, displayOrder) ||
                other.displayOrder == displayOrder) &&
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
        masterId,
        categoryId,
        subcategoryId,
        name,
        description,
        price,
        currency,
        priceFrom,
        priceTo,
        durationMinutes,
        isBookableOnline,
        isMobile,
        isInSalon,
        const DeepCollectionEquality().hash(_tags),
        const DeepCollectionEquality().hash(_photoUrls),
        bookingsCount,
        averageRating,
        isActive,
        displayOrder,
        createdAt,
        updatedAt
      ]);

  /// Create a copy of ServiceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServiceModelImplCopyWith<_$ServiceModelImpl> get copyWith =>
      __$$ServiceModelImplCopyWithImpl<_$ServiceModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ServiceModelImplToJson(
      this,
    );
  }
}

abstract class _ServiceModel implements ServiceModel {
  const factory _ServiceModel(
      {required final String id,
      required final String masterId,
      required final String categoryId,
      final String? subcategoryId,
      required final String name,
      final String? description,
      required final double price,
      required final String currency,
      final double? priceFrom,
      final double? priceTo,
      required final int durationMinutes,
      required final bool isBookableOnline,
      required final bool isMobile,
      required final bool isInSalon,
      required final List<String> tags,
      required final List<String> photoUrls,
      required final int bookingsCount,
      required final double averageRating,
      required final bool isActive,
      required final int displayOrder,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$ServiceModelImpl;

  factory _ServiceModel.fromJson(Map<String, dynamic> json) =
      _$ServiceModelImpl.fromJson;

  @override
  String get id;
  @override
  String get masterId;
  @override
  String get categoryId;
  @override
  String? get subcategoryId;
  @override
  String get name;
  @override
  String? get description;
  @override
  double get price;
  @override
  String get currency;
  @override
  double? get priceFrom;
  @override
  double? get priceTo;
  @override
  int get durationMinutes;
  @override
  bool get isBookableOnline;
  @override
  bool get isMobile;
  @override
  bool get isInSalon;
  @override
  List<String> get tags;
  @override
  List<String> get photoUrls;
  @override
  int get bookingsCount;
  @override
  double get averageRating;
  @override
  bool get isActive;
  @override
  int get displayOrder;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of ServiceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServiceModelImplCopyWith<_$ServiceModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateServiceRequest _$CreateServiceRequestFromJson(Map<String, dynamic> json) {
  return _CreateServiceRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateServiceRequest {
  @JsonKey(name: 'category_id')
  String get categoryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'subcategory_id')
  String? get subcategoryId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  String? get currency => throw _privateConstructorUsedError;
  @JsonKey(name: 'price_from')
  double? get priceFrom => throw _privateConstructorUsedError;
  @JsonKey(name: 'price_to')
  double? get priceTo => throw _privateConstructorUsedError;
  @JsonKey(name: 'duration_minutes')
  int get durationMinutes => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_bookable_online')
  bool? get isBookableOnline => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_mobile')
  bool? get isMobile => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_in_salon')
  bool? get isInSalon => throw _privateConstructorUsedError;
  List<String>? get tags => throw _privateConstructorUsedError;

  /// Serializes this CreateServiceRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateServiceRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateServiceRequestCopyWith<CreateServiceRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateServiceRequestCopyWith<$Res> {
  factory $CreateServiceRequestCopyWith(CreateServiceRequest value,
          $Res Function(CreateServiceRequest) then) =
      _$CreateServiceRequestCopyWithImpl<$Res, CreateServiceRequest>;
  @useResult
  $Res call(
      {@JsonKey(name: 'category_id') String categoryId,
      @JsonKey(name: 'subcategory_id') String? subcategoryId,
      String name,
      String? description,
      double price,
      String? currency,
      @JsonKey(name: 'price_from') double? priceFrom,
      @JsonKey(name: 'price_to') double? priceTo,
      @JsonKey(name: 'duration_minutes') int durationMinutes,
      @JsonKey(name: 'is_bookable_online') bool? isBookableOnline,
      @JsonKey(name: 'is_mobile') bool? isMobile,
      @JsonKey(name: 'is_in_salon') bool? isInSalon,
      List<String>? tags});
}

/// @nodoc
class _$CreateServiceRequestCopyWithImpl<$Res,
        $Val extends CreateServiceRequest>
    implements $CreateServiceRequestCopyWith<$Res> {
  _$CreateServiceRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateServiceRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryId = null,
    Object? subcategoryId = freezed,
    Object? name = null,
    Object? description = freezed,
    Object? price = null,
    Object? currency = freezed,
    Object? priceFrom = freezed,
    Object? priceTo = freezed,
    Object? durationMinutes = null,
    Object? isBookableOnline = freezed,
    Object? isMobile = freezed,
    Object? isInSalon = freezed,
    Object? tags = freezed,
  }) {
    return _then(_value.copyWith(
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      subcategoryId: freezed == subcategoryId
          ? _value.subcategoryId
          : subcategoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      priceFrom: freezed == priceFrom
          ? _value.priceFrom
          : priceFrom // ignore: cast_nullable_to_non_nullable
              as double?,
      priceTo: freezed == priceTo
          ? _value.priceTo
          : priceTo // ignore: cast_nullable_to_non_nullable
              as double?,
      durationMinutes: null == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      isBookableOnline: freezed == isBookableOnline
          ? _value.isBookableOnline
          : isBookableOnline // ignore: cast_nullable_to_non_nullable
              as bool?,
      isMobile: freezed == isMobile
          ? _value.isMobile
          : isMobile // ignore: cast_nullable_to_non_nullable
              as bool?,
      isInSalon: freezed == isInSalon
          ? _value.isInSalon
          : isInSalon // ignore: cast_nullable_to_non_nullable
              as bool?,
      tags: freezed == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateServiceRequestImplCopyWith<$Res>
    implements $CreateServiceRequestCopyWith<$Res> {
  factory _$$CreateServiceRequestImplCopyWith(_$CreateServiceRequestImpl value,
          $Res Function(_$CreateServiceRequestImpl) then) =
      __$$CreateServiceRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'category_id') String categoryId,
      @JsonKey(name: 'subcategory_id') String? subcategoryId,
      String name,
      String? description,
      double price,
      String? currency,
      @JsonKey(name: 'price_from') double? priceFrom,
      @JsonKey(name: 'price_to') double? priceTo,
      @JsonKey(name: 'duration_minutes') int durationMinutes,
      @JsonKey(name: 'is_bookable_online') bool? isBookableOnline,
      @JsonKey(name: 'is_mobile') bool? isMobile,
      @JsonKey(name: 'is_in_salon') bool? isInSalon,
      List<String>? tags});
}

/// @nodoc
class __$$CreateServiceRequestImplCopyWithImpl<$Res>
    extends _$CreateServiceRequestCopyWithImpl<$Res, _$CreateServiceRequestImpl>
    implements _$$CreateServiceRequestImplCopyWith<$Res> {
  __$$CreateServiceRequestImplCopyWithImpl(_$CreateServiceRequestImpl _value,
      $Res Function(_$CreateServiceRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateServiceRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryId = null,
    Object? subcategoryId = freezed,
    Object? name = null,
    Object? description = freezed,
    Object? price = null,
    Object? currency = freezed,
    Object? priceFrom = freezed,
    Object? priceTo = freezed,
    Object? durationMinutes = null,
    Object? isBookableOnline = freezed,
    Object? isMobile = freezed,
    Object? isInSalon = freezed,
    Object? tags = freezed,
  }) {
    return _then(_$CreateServiceRequestImpl(
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      subcategoryId: freezed == subcategoryId
          ? _value.subcategoryId
          : subcategoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      priceFrom: freezed == priceFrom
          ? _value.priceFrom
          : priceFrom // ignore: cast_nullable_to_non_nullable
              as double?,
      priceTo: freezed == priceTo
          ? _value.priceTo
          : priceTo // ignore: cast_nullable_to_non_nullable
              as double?,
      durationMinutes: null == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      isBookableOnline: freezed == isBookableOnline
          ? _value.isBookableOnline
          : isBookableOnline // ignore: cast_nullable_to_non_nullable
              as bool?,
      isMobile: freezed == isMobile
          ? _value.isMobile
          : isMobile // ignore: cast_nullable_to_non_nullable
              as bool?,
      isInSalon: freezed == isInSalon
          ? _value.isInSalon
          : isInSalon // ignore: cast_nullable_to_non_nullable
              as bool?,
      tags: freezed == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateServiceRequestImpl implements _CreateServiceRequest {
  const _$CreateServiceRequestImpl(
      {@JsonKey(name: 'category_id') required this.categoryId,
      @JsonKey(name: 'subcategory_id') this.subcategoryId,
      required this.name,
      this.description,
      required this.price,
      this.currency,
      @JsonKey(name: 'price_from') this.priceFrom,
      @JsonKey(name: 'price_to') this.priceTo,
      @JsonKey(name: 'duration_minutes') required this.durationMinutes,
      @JsonKey(name: 'is_bookable_online') this.isBookableOnline,
      @JsonKey(name: 'is_mobile') this.isMobile,
      @JsonKey(name: 'is_in_salon') this.isInSalon,
      final List<String>? tags})
      : _tags = tags;

  factory _$CreateServiceRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateServiceRequestImplFromJson(json);

  @override
  @JsonKey(name: 'category_id')
  final String categoryId;
  @override
  @JsonKey(name: 'subcategory_id')
  final String? subcategoryId;
  @override
  final String name;
  @override
  final String? description;
  @override
  final double price;
  @override
  final String? currency;
  @override
  @JsonKey(name: 'price_from')
  final double? priceFrom;
  @override
  @JsonKey(name: 'price_to')
  final double? priceTo;
  @override
  @JsonKey(name: 'duration_minutes')
  final int durationMinutes;
  @override
  @JsonKey(name: 'is_bookable_online')
  final bool? isBookableOnline;
  @override
  @JsonKey(name: 'is_mobile')
  final bool? isMobile;
  @override
  @JsonKey(name: 'is_in_salon')
  final bool? isInSalon;
  final List<String>? _tags;
  @override
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'CreateServiceRequest(categoryId: $categoryId, subcategoryId: $subcategoryId, name: $name, description: $description, price: $price, currency: $currency, priceFrom: $priceFrom, priceTo: $priceTo, durationMinutes: $durationMinutes, isBookableOnline: $isBookableOnline, isMobile: $isMobile, isInSalon: $isInSalon, tags: $tags)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateServiceRequestImpl &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.subcategoryId, subcategoryId) ||
                other.subcategoryId == subcategoryId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.priceFrom, priceFrom) ||
                other.priceFrom == priceFrom) &&
            (identical(other.priceTo, priceTo) || other.priceTo == priceTo) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            (identical(other.isBookableOnline, isBookableOnline) ||
                other.isBookableOnline == isBookableOnline) &&
            (identical(other.isMobile, isMobile) ||
                other.isMobile == isMobile) &&
            (identical(other.isInSalon, isInSalon) ||
                other.isInSalon == isInSalon) &&
            const DeepCollectionEquality().equals(other._tags, _tags));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      categoryId,
      subcategoryId,
      name,
      description,
      price,
      currency,
      priceFrom,
      priceTo,
      durationMinutes,
      isBookableOnline,
      isMobile,
      isInSalon,
      const DeepCollectionEquality().hash(_tags));

  /// Create a copy of CreateServiceRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateServiceRequestImplCopyWith<_$CreateServiceRequestImpl>
      get copyWith =>
          __$$CreateServiceRequestImplCopyWithImpl<_$CreateServiceRequestImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateServiceRequestImplToJson(
      this,
    );
  }
}

abstract class _CreateServiceRequest implements CreateServiceRequest {
  const factory _CreateServiceRequest(
      {@JsonKey(name: 'category_id') required final String categoryId,
      @JsonKey(name: 'subcategory_id') final String? subcategoryId,
      required final String name,
      final String? description,
      required final double price,
      final String? currency,
      @JsonKey(name: 'price_from') final double? priceFrom,
      @JsonKey(name: 'price_to') final double? priceTo,
      @JsonKey(name: 'duration_minutes') required final int durationMinutes,
      @JsonKey(name: 'is_bookable_online') final bool? isBookableOnline,
      @JsonKey(name: 'is_mobile') final bool? isMobile,
      @JsonKey(name: 'is_in_salon') final bool? isInSalon,
      final List<String>? tags}) = _$CreateServiceRequestImpl;

  factory _CreateServiceRequest.fromJson(Map<String, dynamic> json) =
      _$CreateServiceRequestImpl.fromJson;

  @override
  @JsonKey(name: 'category_id')
  String get categoryId;
  @override
  @JsonKey(name: 'subcategory_id')
  String? get subcategoryId;
  @override
  String get name;
  @override
  String? get description;
  @override
  double get price;
  @override
  String? get currency;
  @override
  @JsonKey(name: 'price_from')
  double? get priceFrom;
  @override
  @JsonKey(name: 'price_to')
  double? get priceTo;
  @override
  @JsonKey(name: 'duration_minutes')
  int get durationMinutes;
  @override
  @JsonKey(name: 'is_bookable_online')
  bool? get isBookableOnline;
  @override
  @JsonKey(name: 'is_mobile')
  bool? get isMobile;
  @override
  @JsonKey(name: 'is_in_salon')
  bool? get isInSalon;
  @override
  List<String>? get tags;

  /// Create a copy of CreateServiceRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateServiceRequestImplCopyWith<_$CreateServiceRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

UpdateServiceRequest _$UpdateServiceRequestFromJson(Map<String, dynamic> json) {
  return _UpdateServiceRequest.fromJson(json);
}

/// @nodoc
mixin _$UpdateServiceRequest {
  String? get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  double? get price => throw _privateConstructorUsedError;
  @JsonKey(name: 'price_from')
  double? get priceFrom => throw _privateConstructorUsedError;
  @JsonKey(name: 'price_to')
  double? get priceTo => throw _privateConstructorUsedError;
  @JsonKey(name: 'duration_minutes')
  int? get durationMinutes => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_bookable_online')
  bool? get isBookableOnline => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_mobile')
  bool? get isMobile => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_in_salon')
  bool? get isInSalon => throw _privateConstructorUsedError;
  List<String>? get tags => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool? get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'display_order')
  int? get displayOrder => throw _privateConstructorUsedError;

  /// Serializes this UpdateServiceRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateServiceRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateServiceRequestCopyWith<UpdateServiceRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateServiceRequestCopyWith<$Res> {
  factory $UpdateServiceRequestCopyWith(UpdateServiceRequest value,
          $Res Function(UpdateServiceRequest) then) =
      _$UpdateServiceRequestCopyWithImpl<$Res, UpdateServiceRequest>;
  @useResult
  $Res call(
      {String? name,
      String? description,
      double? price,
      @JsonKey(name: 'price_from') double? priceFrom,
      @JsonKey(name: 'price_to') double? priceTo,
      @JsonKey(name: 'duration_minutes') int? durationMinutes,
      @JsonKey(name: 'is_bookable_online') bool? isBookableOnline,
      @JsonKey(name: 'is_mobile') bool? isMobile,
      @JsonKey(name: 'is_in_salon') bool? isInSalon,
      List<String>? tags,
      @JsonKey(name: 'is_active') bool? isActive,
      @JsonKey(name: 'display_order') int? displayOrder});
}

/// @nodoc
class _$UpdateServiceRequestCopyWithImpl<$Res,
        $Val extends UpdateServiceRequest>
    implements $UpdateServiceRequestCopyWith<$Res> {
  _$UpdateServiceRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateServiceRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? description = freezed,
    Object? price = freezed,
    Object? priceFrom = freezed,
    Object? priceTo = freezed,
    Object? durationMinutes = freezed,
    Object? isBookableOnline = freezed,
    Object? isMobile = freezed,
    Object? isInSalon = freezed,
    Object? tags = freezed,
    Object? isActive = freezed,
    Object? displayOrder = freezed,
  }) {
    return _then(_value.copyWith(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double?,
      priceFrom: freezed == priceFrom
          ? _value.priceFrom
          : priceFrom // ignore: cast_nullable_to_non_nullable
              as double?,
      priceTo: freezed == priceTo
          ? _value.priceTo
          : priceTo // ignore: cast_nullable_to_non_nullable
              as double?,
      durationMinutes: freezed == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      isBookableOnline: freezed == isBookableOnline
          ? _value.isBookableOnline
          : isBookableOnline // ignore: cast_nullable_to_non_nullable
              as bool?,
      isMobile: freezed == isMobile
          ? _value.isMobile
          : isMobile // ignore: cast_nullable_to_non_nullable
              as bool?,
      isInSalon: freezed == isInSalon
          ? _value.isInSalon
          : isInSalon // ignore: cast_nullable_to_non_nullable
              as bool?,
      tags: freezed == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
      displayOrder: freezed == displayOrder
          ? _value.displayOrder
          : displayOrder // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateServiceRequestImplCopyWith<$Res>
    implements $UpdateServiceRequestCopyWith<$Res> {
  factory _$$UpdateServiceRequestImplCopyWith(_$UpdateServiceRequestImpl value,
          $Res Function(_$UpdateServiceRequestImpl) then) =
      __$$UpdateServiceRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? name,
      String? description,
      double? price,
      @JsonKey(name: 'price_from') double? priceFrom,
      @JsonKey(name: 'price_to') double? priceTo,
      @JsonKey(name: 'duration_minutes') int? durationMinutes,
      @JsonKey(name: 'is_bookable_online') bool? isBookableOnline,
      @JsonKey(name: 'is_mobile') bool? isMobile,
      @JsonKey(name: 'is_in_salon') bool? isInSalon,
      List<String>? tags,
      @JsonKey(name: 'is_active') bool? isActive,
      @JsonKey(name: 'display_order') int? displayOrder});
}

/// @nodoc
class __$$UpdateServiceRequestImplCopyWithImpl<$Res>
    extends _$UpdateServiceRequestCopyWithImpl<$Res, _$UpdateServiceRequestImpl>
    implements _$$UpdateServiceRequestImplCopyWith<$Res> {
  __$$UpdateServiceRequestImplCopyWithImpl(_$UpdateServiceRequestImpl _value,
      $Res Function(_$UpdateServiceRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateServiceRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? description = freezed,
    Object? price = freezed,
    Object? priceFrom = freezed,
    Object? priceTo = freezed,
    Object? durationMinutes = freezed,
    Object? isBookableOnline = freezed,
    Object? isMobile = freezed,
    Object? isInSalon = freezed,
    Object? tags = freezed,
    Object? isActive = freezed,
    Object? displayOrder = freezed,
  }) {
    return _then(_$UpdateServiceRequestImpl(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double?,
      priceFrom: freezed == priceFrom
          ? _value.priceFrom
          : priceFrom // ignore: cast_nullable_to_non_nullable
              as double?,
      priceTo: freezed == priceTo
          ? _value.priceTo
          : priceTo // ignore: cast_nullable_to_non_nullable
              as double?,
      durationMinutes: freezed == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      isBookableOnline: freezed == isBookableOnline
          ? _value.isBookableOnline
          : isBookableOnline // ignore: cast_nullable_to_non_nullable
              as bool?,
      isMobile: freezed == isMobile
          ? _value.isMobile
          : isMobile // ignore: cast_nullable_to_non_nullable
              as bool?,
      isInSalon: freezed == isInSalon
          ? _value.isInSalon
          : isInSalon // ignore: cast_nullable_to_non_nullable
              as bool?,
      tags: freezed == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
      displayOrder: freezed == displayOrder
          ? _value.displayOrder
          : displayOrder // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateServiceRequestImpl implements _UpdateServiceRequest {
  const _$UpdateServiceRequestImpl(
      {this.name,
      this.description,
      this.price,
      @JsonKey(name: 'price_from') this.priceFrom,
      @JsonKey(name: 'price_to') this.priceTo,
      @JsonKey(name: 'duration_minutes') this.durationMinutes,
      @JsonKey(name: 'is_bookable_online') this.isBookableOnline,
      @JsonKey(name: 'is_mobile') this.isMobile,
      @JsonKey(name: 'is_in_salon') this.isInSalon,
      final List<String>? tags,
      @JsonKey(name: 'is_active') this.isActive,
      @JsonKey(name: 'display_order') this.displayOrder})
      : _tags = tags;

  factory _$UpdateServiceRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateServiceRequestImplFromJson(json);

  @override
  final String? name;
  @override
  final String? description;
  @override
  final double? price;
  @override
  @JsonKey(name: 'price_from')
  final double? priceFrom;
  @override
  @JsonKey(name: 'price_to')
  final double? priceTo;
  @override
  @JsonKey(name: 'duration_minutes')
  final int? durationMinutes;
  @override
  @JsonKey(name: 'is_bookable_online')
  final bool? isBookableOnline;
  @override
  @JsonKey(name: 'is_mobile')
  final bool? isMobile;
  @override
  @JsonKey(name: 'is_in_salon')
  final bool? isInSalon;
  final List<String>? _tags;
  @override
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'is_active')
  final bool? isActive;
  @override
  @JsonKey(name: 'display_order')
  final int? displayOrder;

  @override
  String toString() {
    return 'UpdateServiceRequest(name: $name, description: $description, price: $price, priceFrom: $priceFrom, priceTo: $priceTo, durationMinutes: $durationMinutes, isBookableOnline: $isBookableOnline, isMobile: $isMobile, isInSalon: $isInSalon, tags: $tags, isActive: $isActive, displayOrder: $displayOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateServiceRequestImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.priceFrom, priceFrom) ||
                other.priceFrom == priceFrom) &&
            (identical(other.priceTo, priceTo) || other.priceTo == priceTo) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            (identical(other.isBookableOnline, isBookableOnline) ||
                other.isBookableOnline == isBookableOnline) &&
            (identical(other.isMobile, isMobile) ||
                other.isMobile == isMobile) &&
            (identical(other.isInSalon, isInSalon) ||
                other.isInSalon == isInSalon) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.displayOrder, displayOrder) ||
                other.displayOrder == displayOrder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      description,
      price,
      priceFrom,
      priceTo,
      durationMinutes,
      isBookableOnline,
      isMobile,
      isInSalon,
      const DeepCollectionEquality().hash(_tags),
      isActive,
      displayOrder);

  /// Create a copy of UpdateServiceRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateServiceRequestImplCopyWith<_$UpdateServiceRequestImpl>
      get copyWith =>
          __$$UpdateServiceRequestImplCopyWithImpl<_$UpdateServiceRequestImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateServiceRequestImplToJson(
      this,
    );
  }
}

abstract class _UpdateServiceRequest implements UpdateServiceRequest {
  const factory _UpdateServiceRequest(
          {final String? name,
          final String? description,
          final double? price,
          @JsonKey(name: 'price_from') final double? priceFrom,
          @JsonKey(name: 'price_to') final double? priceTo,
          @JsonKey(name: 'duration_minutes') final int? durationMinutes,
          @JsonKey(name: 'is_bookable_online') final bool? isBookableOnline,
          @JsonKey(name: 'is_mobile') final bool? isMobile,
          @JsonKey(name: 'is_in_salon') final bool? isInSalon,
          final List<String>? tags,
          @JsonKey(name: 'is_active') final bool? isActive,
          @JsonKey(name: 'display_order') final int? displayOrder}) =
      _$UpdateServiceRequestImpl;

  factory _UpdateServiceRequest.fromJson(Map<String, dynamic> json) =
      _$UpdateServiceRequestImpl.fromJson;

  @override
  String? get name;
  @override
  String? get description;
  @override
  double? get price;
  @override
  @JsonKey(name: 'price_from')
  double? get priceFrom;
  @override
  @JsonKey(name: 'price_to')
  double? get priceTo;
  @override
  @JsonKey(name: 'duration_minutes')
  int? get durationMinutes;
  @override
  @JsonKey(name: 'is_bookable_online')
  bool? get isBookableOnline;
  @override
  @JsonKey(name: 'is_mobile')
  bool? get isMobile;
  @override
  @JsonKey(name: 'is_in_salon')
  bool? get isInSalon;
  @override
  List<String>? get tags;
  @override
  @JsonKey(name: 'is_active')
  bool? get isActive;
  @override
  @JsonKey(name: 'display_order')
  int? get displayOrder;

  /// Create a copy of UpdateServiceRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateServiceRequestImplCopyWith<_$UpdateServiceRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
