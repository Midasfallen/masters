// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'favorite.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Favorite _$FavoriteFromJson(Map<String, dynamic> json) {
  return _Favorite.fromJson(json);
}

/// @nodoc
mixin _$Favorite {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'entity_type')
  FavoriteEntityType get entityType => throw _privateConstructorUsedError;
  @JsonKey(name: 'entity_id')
  String get entityId => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  dynamic get entity => throw _privateConstructorUsedError;

  /// Serializes this Favorite to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Favorite
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FavoriteCopyWith<Favorite> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FavoriteCopyWith<$Res> {
  factory $FavoriteCopyWith(Favorite value, $Res Function(Favorite) then) =
      _$FavoriteCopyWithImpl<$Res, Favorite>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'entity_type') FavoriteEntityType entityType,
      @JsonKey(name: 'entity_id') String entityId,
      @JsonKey(name: 'created_at') DateTime createdAt,
      dynamic entity});
}

/// @nodoc
class _$FavoriteCopyWithImpl<$Res, $Val extends Favorite>
    implements $FavoriteCopyWith<$Res> {
  _$FavoriteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Favorite
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? entityType = null,
    Object? entityId = null,
    Object? createdAt = null,
    Object? entity = freezed,
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
      entityType: null == entityType
          ? _value.entityType
          : entityType // ignore: cast_nullable_to_non_nullable
              as FavoriteEntityType,
      entityId: null == entityId
          ? _value.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      entity: freezed == entity
          ? _value.entity
          : entity // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FavoriteImplCopyWith<$Res>
    implements $FavoriteCopyWith<$Res> {
  factory _$$FavoriteImplCopyWith(
          _$FavoriteImpl value, $Res Function(_$FavoriteImpl) then) =
      __$$FavoriteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'entity_type') FavoriteEntityType entityType,
      @JsonKey(name: 'entity_id') String entityId,
      @JsonKey(name: 'created_at') DateTime createdAt,
      dynamic entity});
}

/// @nodoc
class __$$FavoriteImplCopyWithImpl<$Res>
    extends _$FavoriteCopyWithImpl<$Res, _$FavoriteImpl>
    implements _$$FavoriteImplCopyWith<$Res> {
  __$$FavoriteImplCopyWithImpl(
      _$FavoriteImpl _value, $Res Function(_$FavoriteImpl) _then)
      : super(_value, _then);

  /// Create a copy of Favorite
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? entityType = null,
    Object? entityId = null,
    Object? createdAt = null,
    Object? entity = freezed,
  }) {
    return _then(_$FavoriteImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      entityType: null == entityType
          ? _value.entityType
          : entityType // ignore: cast_nullable_to_non_nullable
              as FavoriteEntityType,
      entityId: null == entityId
          ? _value.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      entity: freezed == entity
          ? _value.entity
          : entity // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FavoriteImpl implements _Favorite {
  const _$FavoriteImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'entity_type') required this.entityType,
      @JsonKey(name: 'entity_id') required this.entityId,
      @JsonKey(name: 'created_at') required this.createdAt,
      this.entity});

  factory _$FavoriteImpl.fromJson(Map<String, dynamic> json) =>
      _$$FavoriteImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'entity_type')
  final FavoriteEntityType entityType;
  @override
  @JsonKey(name: 'entity_id')
  final String entityId;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  final dynamic entity;

  @override
  String toString() {
    return 'Favorite(id: $id, userId: $userId, entityType: $entityType, entityId: $entityId, createdAt: $createdAt, entity: $entity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FavoriteImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.entityType, entityType) ||
                other.entityType == entityType) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.entity, entity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, entityType, entityId,
      createdAt, const DeepCollectionEquality().hash(entity));

  /// Create a copy of Favorite
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FavoriteImplCopyWith<_$FavoriteImpl> get copyWith =>
      __$$FavoriteImplCopyWithImpl<_$FavoriteImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FavoriteImplToJson(
      this,
    );
  }
}

abstract class _Favorite implements Favorite {
  const factory _Favorite(
      {required final String id,
      @JsonKey(name: 'user_id') required final String userId,
      @JsonKey(name: 'entity_type')
      required final FavoriteEntityType entityType,
      @JsonKey(name: 'entity_id') required final String entityId,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      final dynamic entity}) = _$FavoriteImpl;

  factory _Favorite.fromJson(Map<String, dynamic> json) =
      _$FavoriteImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'entity_type')
  FavoriteEntityType get entityType;
  @override
  @JsonKey(name: 'entity_id')
  String get entityId;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  dynamic get entity;

  /// Create a copy of Favorite
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FavoriteImplCopyWith<_$FavoriteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AddFavoriteRequest _$AddFavoriteRequestFromJson(Map<String, dynamic> json) {
  return _AddFavoriteRequest.fromJson(json);
}

/// @nodoc
mixin _$AddFavoriteRequest {
  @JsonKey(name: 'entity_type')
  FavoriteEntityType get entityType => throw _privateConstructorUsedError;
  @JsonKey(name: 'entity_id')
  String get entityId => throw _privateConstructorUsedError;

  /// Serializes this AddFavoriteRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AddFavoriteRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AddFavoriteRequestCopyWith<AddFavoriteRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddFavoriteRequestCopyWith<$Res> {
  factory $AddFavoriteRequestCopyWith(
          AddFavoriteRequest value, $Res Function(AddFavoriteRequest) then) =
      _$AddFavoriteRequestCopyWithImpl<$Res, AddFavoriteRequest>;
  @useResult
  $Res call(
      {@JsonKey(name: 'entity_type') FavoriteEntityType entityType,
      @JsonKey(name: 'entity_id') String entityId});
}

/// @nodoc
class _$AddFavoriteRequestCopyWithImpl<$Res, $Val extends AddFavoriteRequest>
    implements $AddFavoriteRequestCopyWith<$Res> {
  _$AddFavoriteRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AddFavoriteRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entityType = null,
    Object? entityId = null,
  }) {
    return _then(_value.copyWith(
      entityType: null == entityType
          ? _value.entityType
          : entityType // ignore: cast_nullable_to_non_nullable
              as FavoriteEntityType,
      entityId: null == entityId
          ? _value.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AddFavoriteRequestImplCopyWith<$Res>
    implements $AddFavoriteRequestCopyWith<$Res> {
  factory _$$AddFavoriteRequestImplCopyWith(_$AddFavoriteRequestImpl value,
          $Res Function(_$AddFavoriteRequestImpl) then) =
      __$$AddFavoriteRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'entity_type') FavoriteEntityType entityType,
      @JsonKey(name: 'entity_id') String entityId});
}

/// @nodoc
class __$$AddFavoriteRequestImplCopyWithImpl<$Res>
    extends _$AddFavoriteRequestCopyWithImpl<$Res, _$AddFavoriteRequestImpl>
    implements _$$AddFavoriteRequestImplCopyWith<$Res> {
  __$$AddFavoriteRequestImplCopyWithImpl(_$AddFavoriteRequestImpl _value,
      $Res Function(_$AddFavoriteRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of AddFavoriteRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entityType = null,
    Object? entityId = null,
  }) {
    return _then(_$AddFavoriteRequestImpl(
      entityType: null == entityType
          ? _value.entityType
          : entityType // ignore: cast_nullable_to_non_nullable
              as FavoriteEntityType,
      entityId: null == entityId
          ? _value.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AddFavoriteRequestImpl implements _AddFavoriteRequest {
  const _$AddFavoriteRequestImpl(
      {@JsonKey(name: 'entity_type') required this.entityType,
      @JsonKey(name: 'entity_id') required this.entityId});

  factory _$AddFavoriteRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$AddFavoriteRequestImplFromJson(json);

  @override
  @JsonKey(name: 'entity_type')
  final FavoriteEntityType entityType;
  @override
  @JsonKey(name: 'entity_id')
  final String entityId;

  @override
  String toString() {
    return 'AddFavoriteRequest(entityType: $entityType, entityId: $entityId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddFavoriteRequestImpl &&
            (identical(other.entityType, entityType) ||
                other.entityType == entityType) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, entityType, entityId);

  /// Create a copy of AddFavoriteRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddFavoriteRequestImplCopyWith<_$AddFavoriteRequestImpl> get copyWith =>
      __$$AddFavoriteRequestImplCopyWithImpl<_$AddFavoriteRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AddFavoriteRequestImplToJson(
      this,
    );
  }
}

abstract class _AddFavoriteRequest implements AddFavoriteRequest {
  const factory _AddFavoriteRequest(
          {@JsonKey(name: 'entity_type')
          required final FavoriteEntityType entityType,
          @JsonKey(name: 'entity_id') required final String entityId}) =
      _$AddFavoriteRequestImpl;

  factory _AddFavoriteRequest.fromJson(Map<String, dynamic> json) =
      _$AddFavoriteRequestImpl.fromJson;

  @override
  @JsonKey(name: 'entity_type')
  FavoriteEntityType get entityType;
  @override
  @JsonKey(name: 'entity_id')
  String get entityId;

  /// Create a copy of AddFavoriteRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddFavoriteRequestImplCopyWith<_$AddFavoriteRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
