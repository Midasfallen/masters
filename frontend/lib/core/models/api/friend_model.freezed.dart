// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'friend_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FriendshipModel _$FriendshipModelFromJson(Map<String, dynamic> json) {
  return _FriendshipModel.fromJson(json);
}

/// @nodoc
mixin _$FriendshipModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'requester_id')
  String get requesterId => throw _privateConstructorUsedError;
  @JsonKey(name: 'addressee_id')
  String get addresseeId => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // pending, accepted, declined, blocked
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt =>
      throw _privateConstructorUsedError; // Relations (optional, если backend их возвращает)
  UserModel? get requester => throw _privateConstructorUsedError;
  UserModel? get addressee => throw _privateConstructorUsedError;

  /// Serializes this FriendshipModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FriendshipModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FriendshipModelCopyWith<FriendshipModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FriendshipModelCopyWith<$Res> {
  factory $FriendshipModelCopyWith(
          FriendshipModel value, $Res Function(FriendshipModel) then) =
      _$FriendshipModelCopyWithImpl<$Res, FriendshipModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'requester_id') String requesterId,
      @JsonKey(name: 'addressee_id') String addresseeId,
      String status,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      UserModel? requester,
      UserModel? addressee});

  $UserModelCopyWith<$Res>? get requester;
  $UserModelCopyWith<$Res>? get addressee;
}

/// @nodoc
class _$FriendshipModelCopyWithImpl<$Res, $Val extends FriendshipModel>
    implements $FriendshipModelCopyWith<$Res> {
  _$FriendshipModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FriendshipModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? requesterId = null,
    Object? addresseeId = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? requester = freezed,
    Object? addressee = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      requesterId: null == requesterId
          ? _value.requesterId
          : requesterId // ignore: cast_nullable_to_non_nullable
              as String,
      addresseeId: null == addresseeId
          ? _value.addresseeId
          : addresseeId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      requester: freezed == requester
          ? _value.requester
          : requester // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      addressee: freezed == addressee
          ? _value.addressee
          : addressee // ignore: cast_nullable_to_non_nullable
              as UserModel?,
    ) as $Val);
  }

  /// Create a copy of FriendshipModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res>? get requester {
    if (_value.requester == null) {
      return null;
    }

    return $UserModelCopyWith<$Res>(_value.requester!, (value) {
      return _then(_value.copyWith(requester: value) as $Val);
    });
  }

  /// Create a copy of FriendshipModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res>? get addressee {
    if (_value.addressee == null) {
      return null;
    }

    return $UserModelCopyWith<$Res>(_value.addressee!, (value) {
      return _then(_value.copyWith(addressee: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FriendshipModelImplCopyWith<$Res>
    implements $FriendshipModelCopyWith<$Res> {
  factory _$$FriendshipModelImplCopyWith(_$FriendshipModelImpl value,
          $Res Function(_$FriendshipModelImpl) then) =
      __$$FriendshipModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'requester_id') String requesterId,
      @JsonKey(name: 'addressee_id') String addresseeId,
      String status,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      UserModel? requester,
      UserModel? addressee});

  @override
  $UserModelCopyWith<$Res>? get requester;
  @override
  $UserModelCopyWith<$Res>? get addressee;
}

/// @nodoc
class __$$FriendshipModelImplCopyWithImpl<$Res>
    extends _$FriendshipModelCopyWithImpl<$Res, _$FriendshipModelImpl>
    implements _$$FriendshipModelImplCopyWith<$Res> {
  __$$FriendshipModelImplCopyWithImpl(
      _$FriendshipModelImpl _value, $Res Function(_$FriendshipModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of FriendshipModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? requesterId = null,
    Object? addresseeId = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? requester = freezed,
    Object? addressee = freezed,
  }) {
    return _then(_$FriendshipModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      requesterId: null == requesterId
          ? _value.requesterId
          : requesterId // ignore: cast_nullable_to_non_nullable
              as String,
      addresseeId: null == addresseeId
          ? _value.addresseeId
          : addresseeId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      requester: freezed == requester
          ? _value.requester
          : requester // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      addressee: freezed == addressee
          ? _value.addressee
          : addressee // ignore: cast_nullable_to_non_nullable
              as UserModel?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FriendshipModelImpl implements _FriendshipModel {
  const _$FriendshipModelImpl(
      {required this.id,
      @JsonKey(name: 'requester_id') required this.requesterId,
      @JsonKey(name: 'addressee_id') required this.addresseeId,
      required this.status,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt,
      this.requester,
      this.addressee});

  factory _$FriendshipModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FriendshipModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'requester_id')
  final String requesterId;
  @override
  @JsonKey(name: 'addressee_id')
  final String addresseeId;
  @override
  final String status;
// pending, accepted, declined, blocked
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
// Relations (optional, если backend их возвращает)
  @override
  final UserModel? requester;
  @override
  final UserModel? addressee;

  @override
  String toString() {
    return 'FriendshipModel(id: $id, requesterId: $requesterId, addresseeId: $addresseeId, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, requester: $requester, addressee: $addressee)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FriendshipModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.requesterId, requesterId) ||
                other.requesterId == requesterId) &&
            (identical(other.addresseeId, addresseeId) ||
                other.addresseeId == addresseeId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.requester, requester) ||
                other.requester == requester) &&
            (identical(other.addressee, addressee) ||
                other.addressee == addressee));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, requesterId, addresseeId,
      status, createdAt, updatedAt, requester, addressee);

  /// Create a copy of FriendshipModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FriendshipModelImplCopyWith<_$FriendshipModelImpl> get copyWith =>
      __$$FriendshipModelImplCopyWithImpl<_$FriendshipModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FriendshipModelImplToJson(
      this,
    );
  }
}

abstract class _FriendshipModel implements FriendshipModel {
  const factory _FriendshipModel(
      {required final String id,
      @JsonKey(name: 'requester_id') required final String requesterId,
      @JsonKey(name: 'addressee_id') required final String addresseeId,
      required final String status,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'updated_at') required final DateTime updatedAt,
      final UserModel? requester,
      final UserModel? addressee}) = _$FriendshipModelImpl;

  factory _FriendshipModel.fromJson(Map<String, dynamic> json) =
      _$FriendshipModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'requester_id')
  String get requesterId;
  @override
  @JsonKey(name: 'addressee_id')
  String get addresseeId;
  @override
  String get status; // pending, accepted, declined, blocked
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt; // Relations (optional, если backend их возвращает)
  @override
  UserModel? get requester;
  @override
  UserModel? get addressee;

  /// Create a copy of FriendshipModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FriendshipModelImplCopyWith<_$FriendshipModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FriendModel _$FriendModelFromJson(Map<String, dynamic> json) {
  return _FriendModel.fromJson(json);
}

/// @nodoc
mixin _$FriendModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'friendship_id')
  String get friendshipId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'first_name')
  String get firstName => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_name')
  String get lastName => throw _privateConstructorUsedError;
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_master')
  bool get isMaster => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  @JsonKey(name: 'mutual_friends_count')
  int get mutualFriendsCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this FriendModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FriendModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FriendModelCopyWith<FriendModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FriendModelCopyWith<$Res> {
  factory $FriendModelCopyWith(
          FriendModel value, $Res Function(FriendModel) then) =
      _$FriendModelCopyWithImpl<$Res, FriendModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'friendship_id') String friendshipId,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'first_name') String firstName,
      @JsonKey(name: 'last_name') String lastName,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      @JsonKey(name: 'is_master') bool isMaster,
      String? bio,
      @JsonKey(name: 'mutual_friends_count') int mutualFriendsCount,
      @JsonKey(name: 'created_at') DateTime createdAt});
}

/// @nodoc
class _$FriendModelCopyWithImpl<$Res, $Val extends FriendModel>
    implements $FriendModelCopyWith<$Res> {
  _$FriendModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FriendModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? friendshipId = null,
    Object? userId = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? avatarUrl = freezed,
    Object? isMaster = null,
    Object? bio = freezed,
    Object? mutualFriendsCount = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      friendshipId: null == friendshipId
          ? _value.friendshipId
          : friendshipId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isMaster: null == isMaster
          ? _value.isMaster
          : isMaster // ignore: cast_nullable_to_non_nullable
              as bool,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      mutualFriendsCount: null == mutualFriendsCount
          ? _value.mutualFriendsCount
          : mutualFriendsCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FriendModelImplCopyWith<$Res>
    implements $FriendModelCopyWith<$Res> {
  factory _$$FriendModelImplCopyWith(
          _$FriendModelImpl value, $Res Function(_$FriendModelImpl) then) =
      __$$FriendModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'friendship_id') String friendshipId,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'first_name') String firstName,
      @JsonKey(name: 'last_name') String lastName,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      @JsonKey(name: 'is_master') bool isMaster,
      String? bio,
      @JsonKey(name: 'mutual_friends_count') int mutualFriendsCount,
      @JsonKey(name: 'created_at') DateTime createdAt});
}

/// @nodoc
class __$$FriendModelImplCopyWithImpl<$Res>
    extends _$FriendModelCopyWithImpl<$Res, _$FriendModelImpl>
    implements _$$FriendModelImplCopyWith<$Res> {
  __$$FriendModelImplCopyWithImpl(
      _$FriendModelImpl _value, $Res Function(_$FriendModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of FriendModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? friendshipId = null,
    Object? userId = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? avatarUrl = freezed,
    Object? isMaster = null,
    Object? bio = freezed,
    Object? mutualFriendsCount = null,
    Object? createdAt = null,
  }) {
    return _then(_$FriendModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      friendshipId: null == friendshipId
          ? _value.friendshipId
          : friendshipId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isMaster: null == isMaster
          ? _value.isMaster
          : isMaster // ignore: cast_nullable_to_non_nullable
              as bool,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      mutualFriendsCount: null == mutualFriendsCount
          ? _value.mutualFriendsCount
          : mutualFriendsCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FriendModelImpl implements _FriendModel {
  const _$FriendModelImpl(
      {required this.id,
      @JsonKey(name: 'friendship_id') required this.friendshipId,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'first_name') required this.firstName,
      @JsonKey(name: 'last_name') required this.lastName,
      @JsonKey(name: 'avatar_url') this.avatarUrl,
      @JsonKey(name: 'is_master') this.isMaster = false,
      this.bio,
      @JsonKey(name: 'mutual_friends_count') this.mutualFriendsCount = 0,
      @JsonKey(name: 'created_at') required this.createdAt});

  factory _$FriendModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FriendModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'friendship_id')
  final String friendshipId;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'first_name')
  final String firstName;
  @override
  @JsonKey(name: 'last_name')
  final String lastName;
  @override
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  @override
  @JsonKey(name: 'is_master')
  final bool isMaster;
  @override
  final String? bio;
  @override
  @JsonKey(name: 'mutual_friends_count')
  final int mutualFriendsCount;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @override
  String toString() {
    return 'FriendModel(id: $id, friendshipId: $friendshipId, userId: $userId, firstName: $firstName, lastName: $lastName, avatarUrl: $avatarUrl, isMaster: $isMaster, bio: $bio, mutualFriendsCount: $mutualFriendsCount, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FriendModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.friendshipId, friendshipId) ||
                other.friendshipId == friendshipId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.isMaster, isMaster) ||
                other.isMaster == isMaster) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.mutualFriendsCount, mutualFriendsCount) ||
                other.mutualFriendsCount == mutualFriendsCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      friendshipId,
      userId,
      firstName,
      lastName,
      avatarUrl,
      isMaster,
      bio,
      mutualFriendsCount,
      createdAt);

  /// Create a copy of FriendModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FriendModelImplCopyWith<_$FriendModelImpl> get copyWith =>
      __$$FriendModelImplCopyWithImpl<_$FriendModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FriendModelImplToJson(
      this,
    );
  }
}

abstract class _FriendModel implements FriendModel {
  const factory _FriendModel(
          {required final String id,
          @JsonKey(name: 'friendship_id') required final String friendshipId,
          @JsonKey(name: 'user_id') required final String userId,
          @JsonKey(name: 'first_name') required final String firstName,
          @JsonKey(name: 'last_name') required final String lastName,
          @JsonKey(name: 'avatar_url') final String? avatarUrl,
          @JsonKey(name: 'is_master') final bool isMaster,
          final String? bio,
          @JsonKey(name: 'mutual_friends_count') final int mutualFriendsCount,
          @JsonKey(name: 'created_at') required final DateTime createdAt}) =
      _$FriendModelImpl;

  factory _FriendModel.fromJson(Map<String, dynamic> json) =
      _$FriendModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'friendship_id')
  String get friendshipId;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'first_name')
  String get firstName;
  @override
  @JsonKey(name: 'last_name')
  String get lastName;
  @override
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl;
  @override
  @JsonKey(name: 'is_master')
  bool get isMaster;
  @override
  String? get bio;
  @override
  @JsonKey(name: 'mutual_friends_count')
  int get mutualFriendsCount;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;

  /// Create a copy of FriendModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FriendModelImplCopyWith<_$FriendModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SubscriptionModel _$SubscriptionModelFromJson(Map<String, dynamic> json) {
  return _SubscriptionModel.fromJson(json);
}

/// @nodoc
mixin _$SubscriptionModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'subscriber_id')
  String get subscriberId => throw _privateConstructorUsedError;
  @JsonKey(name: 'target_id')
  String get targetId => throw _privateConstructorUsedError;
  @JsonKey(name: 'notifications_enabled')
  bool get notificationsEnabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt =>
      throw _privateConstructorUsedError; // Relations (optional)
  UserModel? get subscriber => throw _privateConstructorUsedError;
  UserModel? get target => throw _privateConstructorUsedError;

  /// Serializes this SubscriptionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SubscriptionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubscriptionModelCopyWith<SubscriptionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubscriptionModelCopyWith<$Res> {
  factory $SubscriptionModelCopyWith(
          SubscriptionModel value, $Res Function(SubscriptionModel) then) =
      _$SubscriptionModelCopyWithImpl<$Res, SubscriptionModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'subscriber_id') String subscriberId,
      @JsonKey(name: 'target_id') String targetId,
      @JsonKey(name: 'notifications_enabled') bool notificationsEnabled,
      @JsonKey(name: 'created_at') DateTime createdAt,
      UserModel? subscriber,
      UserModel? target});

  $UserModelCopyWith<$Res>? get subscriber;
  $UserModelCopyWith<$Res>? get target;
}

/// @nodoc
class _$SubscriptionModelCopyWithImpl<$Res, $Val extends SubscriptionModel>
    implements $SubscriptionModelCopyWith<$Res> {
  _$SubscriptionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubscriptionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? subscriberId = null,
    Object? targetId = null,
    Object? notificationsEnabled = null,
    Object? createdAt = null,
    Object? subscriber = freezed,
    Object? target = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      subscriberId: null == subscriberId
          ? _value.subscriberId
          : subscriberId // ignore: cast_nullable_to_non_nullable
              as String,
      targetId: null == targetId
          ? _value.targetId
          : targetId // ignore: cast_nullable_to_non_nullable
              as String,
      notificationsEnabled: null == notificationsEnabled
          ? _value.notificationsEnabled
          : notificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      subscriber: freezed == subscriber
          ? _value.subscriber
          : subscriber // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      target: freezed == target
          ? _value.target
          : target // ignore: cast_nullable_to_non_nullable
              as UserModel?,
    ) as $Val);
  }

  /// Create a copy of SubscriptionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res>? get subscriber {
    if (_value.subscriber == null) {
      return null;
    }

    return $UserModelCopyWith<$Res>(_value.subscriber!, (value) {
      return _then(_value.copyWith(subscriber: value) as $Val);
    });
  }

  /// Create a copy of SubscriptionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res>? get target {
    if (_value.target == null) {
      return null;
    }

    return $UserModelCopyWith<$Res>(_value.target!, (value) {
      return _then(_value.copyWith(target: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SubscriptionModelImplCopyWith<$Res>
    implements $SubscriptionModelCopyWith<$Res> {
  factory _$$SubscriptionModelImplCopyWith(_$SubscriptionModelImpl value,
          $Res Function(_$SubscriptionModelImpl) then) =
      __$$SubscriptionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'subscriber_id') String subscriberId,
      @JsonKey(name: 'target_id') String targetId,
      @JsonKey(name: 'notifications_enabled') bool notificationsEnabled,
      @JsonKey(name: 'created_at') DateTime createdAt,
      UserModel? subscriber,
      UserModel? target});

  @override
  $UserModelCopyWith<$Res>? get subscriber;
  @override
  $UserModelCopyWith<$Res>? get target;
}

/// @nodoc
class __$$SubscriptionModelImplCopyWithImpl<$Res>
    extends _$SubscriptionModelCopyWithImpl<$Res, _$SubscriptionModelImpl>
    implements _$$SubscriptionModelImplCopyWith<$Res> {
  __$$SubscriptionModelImplCopyWithImpl(_$SubscriptionModelImpl _value,
      $Res Function(_$SubscriptionModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SubscriptionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? subscriberId = null,
    Object? targetId = null,
    Object? notificationsEnabled = null,
    Object? createdAt = null,
    Object? subscriber = freezed,
    Object? target = freezed,
  }) {
    return _then(_$SubscriptionModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      subscriberId: null == subscriberId
          ? _value.subscriberId
          : subscriberId // ignore: cast_nullable_to_non_nullable
              as String,
      targetId: null == targetId
          ? _value.targetId
          : targetId // ignore: cast_nullable_to_non_nullable
              as String,
      notificationsEnabled: null == notificationsEnabled
          ? _value.notificationsEnabled
          : notificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      subscriber: freezed == subscriber
          ? _value.subscriber
          : subscriber // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      target: freezed == target
          ? _value.target
          : target // ignore: cast_nullable_to_non_nullable
              as UserModel?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SubscriptionModelImpl implements _SubscriptionModel {
  const _$SubscriptionModelImpl(
      {required this.id,
      @JsonKey(name: 'subscriber_id') required this.subscriberId,
      @JsonKey(name: 'target_id') required this.targetId,
      @JsonKey(name: 'notifications_enabled') this.notificationsEnabled = true,
      @JsonKey(name: 'created_at') required this.createdAt,
      this.subscriber,
      this.target});

  factory _$SubscriptionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubscriptionModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'subscriber_id')
  final String subscriberId;
  @override
  @JsonKey(name: 'target_id')
  final String targetId;
  @override
  @JsonKey(name: 'notifications_enabled')
  final bool notificationsEnabled;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
// Relations (optional)
  @override
  final UserModel? subscriber;
  @override
  final UserModel? target;

  @override
  String toString() {
    return 'SubscriptionModel(id: $id, subscriberId: $subscriberId, targetId: $targetId, notificationsEnabled: $notificationsEnabled, createdAt: $createdAt, subscriber: $subscriber, target: $target)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubscriptionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.subscriberId, subscriberId) ||
                other.subscriberId == subscriberId) &&
            (identical(other.targetId, targetId) ||
                other.targetId == targetId) &&
            (identical(other.notificationsEnabled, notificationsEnabled) ||
                other.notificationsEnabled == notificationsEnabled) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.subscriber, subscriber) ||
                other.subscriber == subscriber) &&
            (identical(other.target, target) || other.target == target));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, subscriberId, targetId,
      notificationsEnabled, createdAt, subscriber, target);

  /// Create a copy of SubscriptionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubscriptionModelImplCopyWith<_$SubscriptionModelImpl> get copyWith =>
      __$$SubscriptionModelImplCopyWithImpl<_$SubscriptionModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubscriptionModelImplToJson(
      this,
    );
  }
}

abstract class _SubscriptionModel implements SubscriptionModel {
  const factory _SubscriptionModel(
      {required final String id,
      @JsonKey(name: 'subscriber_id') required final String subscriberId,
      @JsonKey(name: 'target_id') required final String targetId,
      @JsonKey(name: 'notifications_enabled') final bool notificationsEnabled,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      final UserModel? subscriber,
      final UserModel? target}) = _$SubscriptionModelImpl;

  factory _SubscriptionModel.fromJson(Map<String, dynamic> json) =
      _$SubscriptionModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'subscriber_id')
  String get subscriberId;
  @override
  @JsonKey(name: 'target_id')
  String get targetId;
  @override
  @JsonKey(name: 'notifications_enabled')
  bool get notificationsEnabled;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt; // Relations (optional)
  @override
  UserModel? get subscriber;
  @override
  UserModel? get target;

  /// Create a copy of SubscriptionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubscriptionModelImplCopyWith<_$SubscriptionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
