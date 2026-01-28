// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) {
  return _NotificationModel.fromJson(json);
}

/// @nodoc
mixin _$NotificationModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  bool get isRead => throw _privateConstructorUsedError;
  String? get relatedId => throw _privateConstructorUsedError;
  String? get relatedType => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  String? get actionUrl => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this NotificationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationModelCopyWith<NotificationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationModelCopyWith<$Res> {
  factory $NotificationModelCopyWith(
          NotificationModel value, $Res Function(NotificationModel) then) =
      _$NotificationModelCopyWithImpl<$Res, NotificationModel>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String type,
      String title,
      String message,
      bool isRead,
      String? relatedId,
      String? relatedType,
      Map<String, dynamic>? metadata,
      String? actionUrl,
      DateTime createdAt});
}

/// @nodoc
class _$NotificationModelCopyWithImpl<$Res, $Val extends NotificationModel>
    implements $NotificationModelCopyWith<$Res> {
  _$NotificationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? title = null,
    Object? message = null,
    Object? isRead = null,
    Object? relatedId = freezed,
    Object? relatedType = freezed,
    Object? metadata = freezed,
    Object? actionUrl = freezed,
    Object? createdAt = null,
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
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      relatedId: freezed == relatedId
          ? _value.relatedId
          : relatedId // ignore: cast_nullable_to_non_nullable
              as String?,
      relatedType: freezed == relatedType
          ? _value.relatedType
          : relatedType // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      actionUrl: freezed == actionUrl
          ? _value.actionUrl
          : actionUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationModelImplCopyWith<$Res>
    implements $NotificationModelCopyWith<$Res> {
  factory _$$NotificationModelImplCopyWith(_$NotificationModelImpl value,
          $Res Function(_$NotificationModelImpl) then) =
      __$$NotificationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String type,
      String title,
      String message,
      bool isRead,
      String? relatedId,
      String? relatedType,
      Map<String, dynamic>? metadata,
      String? actionUrl,
      DateTime createdAt});
}

/// @nodoc
class __$$NotificationModelImplCopyWithImpl<$Res>
    extends _$NotificationModelCopyWithImpl<$Res, _$NotificationModelImpl>
    implements _$$NotificationModelImplCopyWith<$Res> {
  __$$NotificationModelImplCopyWithImpl(_$NotificationModelImpl _value,
      $Res Function(_$NotificationModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? title = null,
    Object? message = null,
    Object? isRead = null,
    Object? relatedId = freezed,
    Object? relatedType = freezed,
    Object? metadata = freezed,
    Object? actionUrl = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$NotificationModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      relatedId: freezed == relatedId
          ? _value.relatedId
          : relatedId // ignore: cast_nullable_to_non_nullable
              as String?,
      relatedType: freezed == relatedType
          ? _value.relatedType
          : relatedType // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      actionUrl: freezed == actionUrl
          ? _value.actionUrl
          : actionUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationModelImpl implements _NotificationModel {
  const _$NotificationModelImpl(
      {required this.id,
      required this.userId,
      required this.type,
      required this.title,
      required this.message,
      this.isRead = false,
      this.relatedId,
      this.relatedType,
      final Map<String, dynamic>? metadata,
      this.actionUrl,
      required this.createdAt})
      : _metadata = metadata;

  factory _$NotificationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String type;
  @override
  final String title;
  @override
  final String message;
  @override
  @JsonKey()
  final bool isRead;
  @override
  final String? relatedId;
  @override
  final String? relatedType;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? actionUrl;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'NotificationModel(id: $id, userId: $userId, type: $type, title: $title, message: $message, isRead: $isRead, relatedId: $relatedId, relatedType: $relatedType, metadata: $metadata, actionUrl: $actionUrl, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.relatedId, relatedId) ||
                other.relatedId == relatedId) &&
            (identical(other.relatedType, relatedType) ||
                other.relatedType == relatedType) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.actionUrl, actionUrl) ||
                other.actionUrl == actionUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      type,
      title,
      message,
      isRead,
      relatedId,
      relatedType,
      const DeepCollectionEquality().hash(_metadata),
      actionUrl,
      createdAt);

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationModelImplCopyWith<_$NotificationModelImpl> get copyWith =>
      __$$NotificationModelImplCopyWithImpl<_$NotificationModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationModelImplToJson(
      this,
    );
  }
}

abstract class _NotificationModel implements NotificationModel {
  const factory _NotificationModel(
      {required final String id,
      required final String userId,
      required final String type,
      required final String title,
      required final String message,
      final bool isRead,
      final String? relatedId,
      final String? relatedType,
      final Map<String, dynamic>? metadata,
      final String? actionUrl,
      required final DateTime createdAt}) = _$NotificationModelImpl;

  factory _NotificationModel.fromJson(Map<String, dynamic> json) =
      _$NotificationModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get type;
  @override
  String get title;
  @override
  String get message;
  @override
  bool get isRead;
  @override
  String? get relatedId;
  @override
  String? get relatedType;
  @override
  Map<String, dynamic>? get metadata;
  @override
  String? get actionUrl;
  @override
  DateTime get createdAt;

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationModelImplCopyWith<_$NotificationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MarkNotificationReadRequest _$MarkNotificationReadRequestFromJson(
    Map<String, dynamic> json) {
  return _MarkNotificationReadRequest.fromJson(json);
}

/// @nodoc
mixin _$MarkNotificationReadRequest {
  @JsonKey(name: 'notification_id')
  String get notificationId => throw _privateConstructorUsedError;

  /// Serializes this MarkNotificationReadRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MarkNotificationReadRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MarkNotificationReadRequestCopyWith<MarkNotificationReadRequest>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MarkNotificationReadRequestCopyWith<$Res> {
  factory $MarkNotificationReadRequestCopyWith(
          MarkNotificationReadRequest value,
          $Res Function(MarkNotificationReadRequest) then) =
      _$MarkNotificationReadRequestCopyWithImpl<$Res,
          MarkNotificationReadRequest>;
  @useResult
  $Res call({@JsonKey(name: 'notification_id') String notificationId});
}

/// @nodoc
class _$MarkNotificationReadRequestCopyWithImpl<$Res,
        $Val extends MarkNotificationReadRequest>
    implements $MarkNotificationReadRequestCopyWith<$Res> {
  _$MarkNotificationReadRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MarkNotificationReadRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notificationId = null,
  }) {
    return _then(_value.copyWith(
      notificationId: null == notificationId
          ? _value.notificationId
          : notificationId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MarkNotificationReadRequestImplCopyWith<$Res>
    implements $MarkNotificationReadRequestCopyWith<$Res> {
  factory _$$MarkNotificationReadRequestImplCopyWith(
          _$MarkNotificationReadRequestImpl value,
          $Res Function(_$MarkNotificationReadRequestImpl) then) =
      __$$MarkNotificationReadRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'notification_id') String notificationId});
}

/// @nodoc
class __$$MarkNotificationReadRequestImplCopyWithImpl<$Res>
    extends _$MarkNotificationReadRequestCopyWithImpl<$Res,
        _$MarkNotificationReadRequestImpl>
    implements _$$MarkNotificationReadRequestImplCopyWith<$Res> {
  __$$MarkNotificationReadRequestImplCopyWithImpl(
      _$MarkNotificationReadRequestImpl _value,
      $Res Function(_$MarkNotificationReadRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of MarkNotificationReadRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notificationId = null,
  }) {
    return _then(_$MarkNotificationReadRequestImpl(
      notificationId: null == notificationId
          ? _value.notificationId
          : notificationId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MarkNotificationReadRequestImpl
    implements _MarkNotificationReadRequest {
  const _$MarkNotificationReadRequestImpl(
      {@JsonKey(name: 'notification_id') required this.notificationId});

  factory _$MarkNotificationReadRequestImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$MarkNotificationReadRequestImplFromJson(json);

  @override
  @JsonKey(name: 'notification_id')
  final String notificationId;

  @override
  String toString() {
    return 'MarkNotificationReadRequest(notificationId: $notificationId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MarkNotificationReadRequestImpl &&
            (identical(other.notificationId, notificationId) ||
                other.notificationId == notificationId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, notificationId);

  /// Create a copy of MarkNotificationReadRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MarkNotificationReadRequestImplCopyWith<_$MarkNotificationReadRequestImpl>
      get copyWith => __$$MarkNotificationReadRequestImplCopyWithImpl<
          _$MarkNotificationReadRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MarkNotificationReadRequestImplToJson(
      this,
    );
  }
}

abstract class _MarkNotificationReadRequest
    implements MarkNotificationReadRequest {
  const factory _MarkNotificationReadRequest(
          {@JsonKey(name: 'notification_id')
          required final String notificationId}) =
      _$MarkNotificationReadRequestImpl;

  factory _MarkNotificationReadRequest.fromJson(Map<String, dynamic> json) =
      _$MarkNotificationReadRequestImpl.fromJson;

  @override
  @JsonKey(name: 'notification_id')
  String get notificationId;

  /// Create a copy of MarkNotificationReadRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MarkNotificationReadRequestImplCopyWith<_$MarkNotificationReadRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
