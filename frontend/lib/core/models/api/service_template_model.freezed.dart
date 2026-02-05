// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_template_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ServiceTemplateModel _$ServiceTemplateModelFromJson(Map<String, dynamic> json) {
  return _ServiceTemplateModel.fromJson(json);
}

/// @nodoc
mixin _$ServiceTemplateModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'categoryId')
  String get categoryId => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'iconUrl')
  String? get iconUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'defaultDurationMinutes')
  int? get defaultDurationMinutes => throw _privateConstructorUsedError;
  @JsonKey(name: 'defaultPriceRangeMin')
  double? get defaultPriceRangeMin => throw _privateConstructorUsedError;
  @JsonKey(name: 'defaultPriceRangeMax')
  double? get defaultPriceRangeMax => throw _privateConstructorUsedError;
  @JsonKey(name: 'isActive')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'displayOrder')
  int get displayOrder => throw _privateConstructorUsedError;
  @JsonKey(name: 'createdAt')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updatedAt')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ServiceTemplateModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ServiceTemplateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ServiceTemplateModelCopyWith<ServiceTemplateModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServiceTemplateModelCopyWith<$Res> {
  factory $ServiceTemplateModelCopyWith(ServiceTemplateModel value,
          $Res Function(ServiceTemplateModel) then) =
      _$ServiceTemplateModelCopyWithImpl<$Res, ServiceTemplateModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'categoryId') String categoryId,
      String slug,
      String name,
      String? description,
      @JsonKey(name: 'iconUrl') String? iconUrl,
      @JsonKey(name: 'defaultDurationMinutes') int? defaultDurationMinutes,
      @JsonKey(name: 'defaultPriceRangeMin') double? defaultPriceRangeMin,
      @JsonKey(name: 'defaultPriceRangeMax') double? defaultPriceRangeMax,
      @JsonKey(name: 'isActive') bool isActive,
      @JsonKey(name: 'displayOrder') int displayOrder,
      @JsonKey(name: 'createdAt') DateTime createdAt,
      @JsonKey(name: 'updatedAt') DateTime updatedAt});
}

/// @nodoc
class _$ServiceTemplateModelCopyWithImpl<$Res,
        $Val extends ServiceTemplateModel>
    implements $ServiceTemplateModelCopyWith<$Res> {
  _$ServiceTemplateModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ServiceTemplateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? categoryId = null,
    Object? slug = null,
    Object? name = null,
    Object? description = freezed,
    Object? iconUrl = freezed,
    Object? defaultDurationMinutes = freezed,
    Object? defaultPriceRangeMin = freezed,
    Object? defaultPriceRangeMax = freezed,
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
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      iconUrl: freezed == iconUrl
          ? _value.iconUrl
          : iconUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      defaultDurationMinutes: freezed == defaultDurationMinutes
          ? _value.defaultDurationMinutes
          : defaultDurationMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      defaultPriceRangeMin: freezed == defaultPriceRangeMin
          ? _value.defaultPriceRangeMin
          : defaultPriceRangeMin // ignore: cast_nullable_to_non_nullable
              as double?,
      defaultPriceRangeMax: freezed == defaultPriceRangeMax
          ? _value.defaultPriceRangeMax
          : defaultPriceRangeMax // ignore: cast_nullable_to_non_nullable
              as double?,
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
abstract class _$$ServiceTemplateModelImplCopyWith<$Res>
    implements $ServiceTemplateModelCopyWith<$Res> {
  factory _$$ServiceTemplateModelImplCopyWith(_$ServiceTemplateModelImpl value,
          $Res Function(_$ServiceTemplateModelImpl) then) =
      __$$ServiceTemplateModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'categoryId') String categoryId,
      String slug,
      String name,
      String? description,
      @JsonKey(name: 'iconUrl') String? iconUrl,
      @JsonKey(name: 'defaultDurationMinutes') int? defaultDurationMinutes,
      @JsonKey(name: 'defaultPriceRangeMin') double? defaultPriceRangeMin,
      @JsonKey(name: 'defaultPriceRangeMax') double? defaultPriceRangeMax,
      @JsonKey(name: 'isActive') bool isActive,
      @JsonKey(name: 'displayOrder') int displayOrder,
      @JsonKey(name: 'createdAt') DateTime createdAt,
      @JsonKey(name: 'updatedAt') DateTime updatedAt});
}

/// @nodoc
class __$$ServiceTemplateModelImplCopyWithImpl<$Res>
    extends _$ServiceTemplateModelCopyWithImpl<$Res, _$ServiceTemplateModelImpl>
    implements _$$ServiceTemplateModelImplCopyWith<$Res> {
  __$$ServiceTemplateModelImplCopyWithImpl(_$ServiceTemplateModelImpl _value,
      $Res Function(_$ServiceTemplateModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ServiceTemplateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? categoryId = null,
    Object? slug = null,
    Object? name = null,
    Object? description = freezed,
    Object? iconUrl = freezed,
    Object? defaultDurationMinutes = freezed,
    Object? defaultPriceRangeMin = freezed,
    Object? defaultPriceRangeMax = freezed,
    Object? isActive = null,
    Object? displayOrder = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$ServiceTemplateModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      iconUrl: freezed == iconUrl
          ? _value.iconUrl
          : iconUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      defaultDurationMinutes: freezed == defaultDurationMinutes
          ? _value.defaultDurationMinutes
          : defaultDurationMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      defaultPriceRangeMin: freezed == defaultPriceRangeMin
          ? _value.defaultPriceRangeMin
          : defaultPriceRangeMin // ignore: cast_nullable_to_non_nullable
              as double?,
      defaultPriceRangeMax: freezed == defaultPriceRangeMax
          ? _value.defaultPriceRangeMax
          : defaultPriceRangeMax // ignore: cast_nullable_to_non_nullable
              as double?,
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
class _$ServiceTemplateModelImpl implements _ServiceTemplateModel {
  const _$ServiceTemplateModelImpl(
      {required this.id,
      @JsonKey(name: 'categoryId') required this.categoryId,
      required this.slug,
      required this.name,
      this.description,
      @JsonKey(name: 'iconUrl') this.iconUrl,
      @JsonKey(name: 'defaultDurationMinutes') this.defaultDurationMinutes,
      @JsonKey(name: 'defaultPriceRangeMin') this.defaultPriceRangeMin,
      @JsonKey(name: 'defaultPriceRangeMax') this.defaultPriceRangeMax,
      @JsonKey(name: 'isActive') this.isActive = true,
      @JsonKey(name: 'displayOrder') this.displayOrder = 0,
      @JsonKey(name: 'createdAt') required this.createdAt,
      @JsonKey(name: 'updatedAt') required this.updatedAt});

  factory _$ServiceTemplateModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServiceTemplateModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'categoryId')
  final String categoryId;
  @override
  final String slug;
  @override
  final String name;
  @override
  final String? description;
  @override
  @JsonKey(name: 'iconUrl')
  final String? iconUrl;
  @override
  @JsonKey(name: 'defaultDurationMinutes')
  final int? defaultDurationMinutes;
  @override
  @JsonKey(name: 'defaultPriceRangeMin')
  final double? defaultPriceRangeMin;
  @override
  @JsonKey(name: 'defaultPriceRangeMax')
  final double? defaultPriceRangeMax;
  @override
  @JsonKey(name: 'isActive')
  final bool isActive;
  @override
  @JsonKey(name: 'displayOrder')
  final int displayOrder;
  @override
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updatedAt')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'ServiceTemplateModel(id: $id, categoryId: $categoryId, slug: $slug, name: $name, description: $description, iconUrl: $iconUrl, defaultDurationMinutes: $defaultDurationMinutes, defaultPriceRangeMin: $defaultPriceRangeMin, defaultPriceRangeMax: $defaultPriceRangeMax, isActive: $isActive, displayOrder: $displayOrder, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServiceTemplateModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl) &&
            (identical(other.defaultDurationMinutes, defaultDurationMinutes) ||
                other.defaultDurationMinutes == defaultDurationMinutes) &&
            (identical(other.defaultPriceRangeMin, defaultPriceRangeMin) ||
                other.defaultPriceRangeMin == defaultPriceRangeMin) &&
            (identical(other.defaultPriceRangeMax, defaultPriceRangeMax) ||
                other.defaultPriceRangeMax == defaultPriceRangeMax) &&
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
  int get hashCode => Object.hash(
      runtimeType,
      id,
      categoryId,
      slug,
      name,
      description,
      iconUrl,
      defaultDurationMinutes,
      defaultPriceRangeMin,
      defaultPriceRangeMax,
      isActive,
      displayOrder,
      createdAt,
      updatedAt);

  /// Create a copy of ServiceTemplateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServiceTemplateModelImplCopyWith<_$ServiceTemplateModelImpl>
      get copyWith =>
          __$$ServiceTemplateModelImplCopyWithImpl<_$ServiceTemplateModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ServiceTemplateModelImplToJson(
      this,
    );
  }
}

abstract class _ServiceTemplateModel implements ServiceTemplateModel {
  const factory _ServiceTemplateModel(
      {required final String id,
      @JsonKey(name: 'categoryId') required final String categoryId,
      required final String slug,
      required final String name,
      final String? description,
      @JsonKey(name: 'iconUrl') final String? iconUrl,
      @JsonKey(name: 'defaultDurationMinutes')
      final int? defaultDurationMinutes,
      @JsonKey(name: 'defaultPriceRangeMin') final double? defaultPriceRangeMin,
      @JsonKey(name: 'defaultPriceRangeMax') final double? defaultPriceRangeMax,
      @JsonKey(name: 'isActive') final bool isActive,
      @JsonKey(name: 'displayOrder') final int displayOrder,
      @JsonKey(name: 'createdAt') required final DateTime createdAt,
      @JsonKey(name: 'updatedAt')
      required final DateTime updatedAt}) = _$ServiceTemplateModelImpl;

  factory _ServiceTemplateModel.fromJson(Map<String, dynamic> json) =
      _$ServiceTemplateModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'categoryId')
  String get categoryId;
  @override
  String get slug;
  @override
  String get name;
  @override
  String? get description;
  @override
  @JsonKey(name: 'iconUrl')
  String? get iconUrl;
  @override
  @JsonKey(name: 'defaultDurationMinutes')
  int? get defaultDurationMinutes;
  @override
  @JsonKey(name: 'defaultPriceRangeMin')
  double? get defaultPriceRangeMin;
  @override
  @JsonKey(name: 'defaultPriceRangeMax')
  double? get defaultPriceRangeMax;
  @override
  @JsonKey(name: 'isActive')
  bool get isActive;
  @override
  @JsonKey(name: 'displayOrder')
  int get displayOrder;
  @override
  @JsonKey(name: 'createdAt')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updatedAt')
  DateTime get updatedAt;

  /// Create a copy of ServiceTemplateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServiceTemplateModelImplCopyWith<_$ServiceTemplateModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ServiceTemplateListResponse _$ServiceTemplateListResponseFromJson(
    Map<String, dynamic> json) {
  return _ServiceTemplateListResponse.fromJson(json);
}

/// @nodoc
mixin _$ServiceTemplateListResponse {
  List<ServiceTemplateModel> get data => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;

  /// Serializes this ServiceTemplateListResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ServiceTemplateListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ServiceTemplateListResponseCopyWith<ServiceTemplateListResponse>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServiceTemplateListResponseCopyWith<$Res> {
  factory $ServiceTemplateListResponseCopyWith(
          ServiceTemplateListResponse value,
          $Res Function(ServiceTemplateListResponse) then) =
      _$ServiceTemplateListResponseCopyWithImpl<$Res,
          ServiceTemplateListResponse>;
  @useResult
  $Res call({List<ServiceTemplateModel> data, int total});
}

/// @nodoc
class _$ServiceTemplateListResponseCopyWithImpl<$Res,
        $Val extends ServiceTemplateListResponse>
    implements $ServiceTemplateListResponseCopyWith<$Res> {
  _$ServiceTemplateListResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ServiceTemplateListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? total = null,
  }) {
    return _then(_value.copyWith(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<ServiceTemplateModel>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ServiceTemplateListResponseImplCopyWith<$Res>
    implements $ServiceTemplateListResponseCopyWith<$Res> {
  factory _$$ServiceTemplateListResponseImplCopyWith(
          _$ServiceTemplateListResponseImpl value,
          $Res Function(_$ServiceTemplateListResponseImpl) then) =
      __$$ServiceTemplateListResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<ServiceTemplateModel> data, int total});
}

/// @nodoc
class __$$ServiceTemplateListResponseImplCopyWithImpl<$Res>
    extends _$ServiceTemplateListResponseCopyWithImpl<$Res,
        _$ServiceTemplateListResponseImpl>
    implements _$$ServiceTemplateListResponseImplCopyWith<$Res> {
  __$$ServiceTemplateListResponseImplCopyWithImpl(
      _$ServiceTemplateListResponseImpl _value,
      $Res Function(_$ServiceTemplateListResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of ServiceTemplateListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? total = null,
  }) {
    return _then(_$ServiceTemplateListResponseImpl(
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<ServiceTemplateModel>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ServiceTemplateListResponseImpl
    implements _ServiceTemplateListResponse {
  const _$ServiceTemplateListResponseImpl(
      {required final List<ServiceTemplateModel> data, required this.total})
      : _data = data;

  factory _$ServiceTemplateListResponseImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$ServiceTemplateListResponseImplFromJson(json);

  final List<ServiceTemplateModel> _data;
  @override
  List<ServiceTemplateModel> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final int total;

  @override
  String toString() {
    return 'ServiceTemplateListResponse(data: $data, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServiceTemplateListResponseImpl &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.total, total) || other.total == total));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_data), total);

  /// Create a copy of ServiceTemplateListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServiceTemplateListResponseImplCopyWith<_$ServiceTemplateListResponseImpl>
      get copyWith => __$$ServiceTemplateListResponseImplCopyWithImpl<
          _$ServiceTemplateListResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ServiceTemplateListResponseImplToJson(
      this,
    );
  }
}

abstract class _ServiceTemplateListResponse
    implements ServiceTemplateListResponse {
  const factory _ServiceTemplateListResponse(
      {required final List<ServiceTemplateModel> data,
      required final int total}) = _$ServiceTemplateListResponseImpl;

  factory _ServiceTemplateListResponse.fromJson(Map<String, dynamic> json) =
      _$ServiceTemplateListResponseImpl.fromJson;

  @override
  List<ServiceTemplateModel> get data;
  @override
  int get total;

  /// Create a copy of ServiceTemplateListResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServiceTemplateListResponseImplCopyWith<_$ServiceTemplateListResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
