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
  String get requesterId => throw _privateConstructorUsedError;
  String get addresseeId => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // pending, accepted, declined, blocked
  DateTime get createdAt => throw _privateConstructorUsedError;
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
      String requesterId,
      String addresseeId,
      String status,
      DateTime createdAt,
      DateTime updatedAt,
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
      String requesterId,
      String addresseeId,
      String status,
      DateTime createdAt,
      DateTime updatedAt,
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
      required this.requesterId,
      required this.addresseeId,
      required this.status,
      required this.createdAt,
      required this.updatedAt,
      this.requester,
      this.addressee});

  factory _$FriendshipModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FriendshipModelImplFromJson(json);

  @override
  final String id;
  @override
  final String requesterId;
  @override
  final String addresseeId;
  @override
  final String status;
// pending, accepted, declined, blocked
  @override
  final DateTime createdAt;
  @override
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
      required final String requesterId,
      required final String addresseeId,
      required final String status,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final UserModel? requester,
      final UserModel? addressee}) = _$FriendshipModelImpl;

  factory _FriendshipModel.fromJson(Map<String, dynamic> json) =
      _$FriendshipModelImpl.fromJson;

  @override
  String get id;
  @override
  String get requesterId;
  @override
  String get addresseeId;
  @override
  String get status; // pending, accepted, declined, blocked
  @override
  DateTime get createdAt;
  @override
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
  String get friendshipId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;
  bool get isMaster => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  int get mutualFriendsCount => throw _privateConstructorUsedError;
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
      String friendshipId,
      String userId,
      String firstName,
      String lastName,
      String? avatarUrl,
      bool isMaster,
      String? bio,
      int mutualFriendsCount,
      DateTime createdAt});
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
      String friendshipId,
      String userId,
      String firstName,
      String lastName,
      String? avatarUrl,
      bool isMaster,
      String? bio,
      int mutualFriendsCount,
      DateTime createdAt});
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
      required this.friendshipId,
      required this.userId,
      required this.firstName,
      required this.lastName,
      this.avatarUrl,
      this.isMaster = false,
      this.bio,
      this.mutualFriendsCount = 0,
      required this.createdAt});

  factory _$FriendModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FriendModelImplFromJson(json);

  @override
  final String id;
  @override
  final String friendshipId;
  @override
  final String userId;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String? avatarUrl;
  @override
  @JsonKey()
  final bool isMaster;
  @override
  final String? bio;
  @override
  @JsonKey()
  final int mutualFriendsCount;
  @override
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
      required final String friendshipId,
      required final String userId,
      required final String firstName,
      required final String lastName,
      final String? avatarUrl,
      final bool isMaster,
      final String? bio,
      final int mutualFriendsCount,
      required final DateTime createdAt}) = _$FriendModelImpl;

  factory _FriendModel.fromJson(Map<String, dynamic> json) =
      _$FriendModelImpl.fromJson;

  @override
  String get id;
  @override
  String get friendshipId;
  @override
  String get userId;
  @override
  String get firstName;
  @override
  String get lastName;
  @override
  String? get avatarUrl;
  @override
  bool get isMaster;
  @override
  String? get bio;
  @override
  int get mutualFriendsCount;
  @override
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
  String get subscriberId => throw _privateConstructorUsedError;
  String get targetId => throw _privateConstructorUsedError;
  bool get notificationsEnabled => throw _privateConstructorUsedError;
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
      String subscriberId,
      String targetId,
      bool notificationsEnabled,
      DateTime createdAt,
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
      String subscriberId,
      String targetId,
      bool notificationsEnabled,
      DateTime createdAt,
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
      required this.subscriberId,
      required this.targetId,
      this.notificationsEnabled = true,
      required this.createdAt,
      this.subscriber,
      this.target});

  factory _$SubscriptionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubscriptionModelImplFromJson(json);

  @override
  final String id;
  @override
  final String subscriberId;
  @override
  final String targetId;
  @override
  @JsonKey()
  final bool notificationsEnabled;
  @override
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
      required final String subscriberId,
      required final String targetId,
      final bool notificationsEnabled,
      required final DateTime createdAt,
      final UserModel? subscriber,
      final UserModel? target}) = _$SubscriptionModelImpl;

  factory _SubscriptionModel.fromJson(Map<String, dynamic> json) =
      _$SubscriptionModelImpl.fromJson;

  @override
  String get id;
  @override
  String get subscriberId;
  @override
  String get targetId;
  @override
  bool get notificationsEnabled;
  @override
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
