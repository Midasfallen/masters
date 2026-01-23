// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChatModel _$ChatModelFromJson(Map<String, dynamic> json) {
  return _ChatModel.fromJson(json);
}

/// @nodoc
mixin _$ChatModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user1_id')
  String get user1Id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user2_id')
  String get user2Id => throw _privateConstructorUsedError;
  UserModel? get user1 => throw _privateConstructorUsedError;
  UserModel? get user2 => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_message')
  MessageModel? get lastMessage => throw _privateConstructorUsedError;
  @JsonKey(name: 'unread_count')
  int get unreadCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'my_participant')
  ChatParticipantModel? get myParticipant => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ChatModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatModelCopyWith<ChatModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatModelCopyWith<$Res> {
  factory $ChatModelCopyWith(ChatModel value, $Res Function(ChatModel) then) =
      _$ChatModelCopyWithImpl<$Res, ChatModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user1_id') String user1Id,
      @JsonKey(name: 'user2_id') String user2Id,
      UserModel? user1,
      UserModel? user2,
      @JsonKey(name: 'last_message') MessageModel? lastMessage,
      @JsonKey(name: 'unread_count') int unreadCount,
      @JsonKey(name: 'my_participant') ChatParticipantModel? myParticipant,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});

  $UserModelCopyWith<$Res>? get user1;
  $UserModelCopyWith<$Res>? get user2;
  $MessageModelCopyWith<$Res>? get lastMessage;
  $ChatParticipantModelCopyWith<$Res>? get myParticipant;
}

/// @nodoc
class _$ChatModelCopyWithImpl<$Res, $Val extends ChatModel>
    implements $ChatModelCopyWith<$Res> {
  _$ChatModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? user1Id = null,
    Object? user2Id = null,
    Object? user1 = freezed,
    Object? user2 = freezed,
    Object? lastMessage = freezed,
    Object? unreadCount = null,
    Object? myParticipant = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      user1Id: null == user1Id
          ? _value.user1Id
          : user1Id // ignore: cast_nullable_to_non_nullable
              as String,
      user2Id: null == user2Id
          ? _value.user2Id
          : user2Id // ignore: cast_nullable_to_non_nullable
              as String,
      user1: freezed == user1
          ? _value.user1
          : user1 // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      user2: freezed == user2
          ? _value.user2
          : user2 // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      lastMessage: freezed == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as MessageModel?,
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
      myParticipant: freezed == myParticipant
          ? _value.myParticipant
          : myParticipant // ignore: cast_nullable_to_non_nullable
              as ChatParticipantModel?,
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

  /// Create a copy of ChatModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res>? get user1 {
    if (_value.user1 == null) {
      return null;
    }

    return $UserModelCopyWith<$Res>(_value.user1!, (value) {
      return _then(_value.copyWith(user1: value) as $Val);
    });
  }

  /// Create a copy of ChatModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res>? get user2 {
    if (_value.user2 == null) {
      return null;
    }

    return $UserModelCopyWith<$Res>(_value.user2!, (value) {
      return _then(_value.copyWith(user2: value) as $Val);
    });
  }

  /// Create a copy of ChatModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MessageModelCopyWith<$Res>? get lastMessage {
    if (_value.lastMessage == null) {
      return null;
    }

    return $MessageModelCopyWith<$Res>(_value.lastMessage!, (value) {
      return _then(_value.copyWith(lastMessage: value) as $Val);
    });
  }

  /// Create a copy of ChatModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChatParticipantModelCopyWith<$Res>? get myParticipant {
    if (_value.myParticipant == null) {
      return null;
    }

    return $ChatParticipantModelCopyWith<$Res>(_value.myParticipant!, (value) {
      return _then(_value.copyWith(myParticipant: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ChatModelImplCopyWith<$Res>
    implements $ChatModelCopyWith<$Res> {
  factory _$$ChatModelImplCopyWith(
          _$ChatModelImpl value, $Res Function(_$ChatModelImpl) then) =
      __$$ChatModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user1_id') String user1Id,
      @JsonKey(name: 'user2_id') String user2Id,
      UserModel? user1,
      UserModel? user2,
      @JsonKey(name: 'last_message') MessageModel? lastMessage,
      @JsonKey(name: 'unread_count') int unreadCount,
      @JsonKey(name: 'my_participant') ChatParticipantModel? myParticipant,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});

  @override
  $UserModelCopyWith<$Res>? get user1;
  @override
  $UserModelCopyWith<$Res>? get user2;
  @override
  $MessageModelCopyWith<$Res>? get lastMessage;
  @override
  $ChatParticipantModelCopyWith<$Res>? get myParticipant;
}

/// @nodoc
class __$$ChatModelImplCopyWithImpl<$Res>
    extends _$ChatModelCopyWithImpl<$Res, _$ChatModelImpl>
    implements _$$ChatModelImplCopyWith<$Res> {
  __$$ChatModelImplCopyWithImpl(
      _$ChatModelImpl _value, $Res Function(_$ChatModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChatModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? user1Id = null,
    Object? user2Id = null,
    Object? user1 = freezed,
    Object? user2 = freezed,
    Object? lastMessage = freezed,
    Object? unreadCount = null,
    Object? myParticipant = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$ChatModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      user1Id: null == user1Id
          ? _value.user1Id
          : user1Id // ignore: cast_nullable_to_non_nullable
              as String,
      user2Id: null == user2Id
          ? _value.user2Id
          : user2Id // ignore: cast_nullable_to_non_nullable
              as String,
      user1: freezed == user1
          ? _value.user1
          : user1 // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      user2: freezed == user2
          ? _value.user2
          : user2 // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      lastMessage: freezed == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as MessageModel?,
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
      myParticipant: freezed == myParticipant
          ? _value.myParticipant
          : myParticipant // ignore: cast_nullable_to_non_nullable
              as ChatParticipantModel?,
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
class _$ChatModelImpl implements _ChatModel {
  const _$ChatModelImpl(
      {required this.id,
      @JsonKey(name: 'user1_id') required this.user1Id,
      @JsonKey(name: 'user2_id') required this.user2Id,
      this.user1,
      this.user2,
      @JsonKey(name: 'last_message') this.lastMessage,
      @JsonKey(name: 'unread_count') required this.unreadCount,
      @JsonKey(name: 'my_participant') this.myParticipant,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt});

  factory _$ChatModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user1_id')
  final String user1Id;
  @override
  @JsonKey(name: 'user2_id')
  final String user2Id;
  @override
  final UserModel? user1;
  @override
  final UserModel? user2;
  @override
  @JsonKey(name: 'last_message')
  final MessageModel? lastMessage;
  @override
  @JsonKey(name: 'unread_count')
  final int unreadCount;
  @override
  @JsonKey(name: 'my_participant')
  final ChatParticipantModel? myParticipant;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'ChatModel(id: $id, user1Id: $user1Id, user2Id: $user2Id, user1: $user1, user2: $user2, lastMessage: $lastMessage, unreadCount: $unreadCount, myParticipant: $myParticipant, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.user1Id, user1Id) || other.user1Id == user1Id) &&
            (identical(other.user2Id, user2Id) || other.user2Id == user2Id) &&
            (identical(other.user1, user1) || other.user1 == user1) &&
            (identical(other.user2, user2) || other.user2 == user2) &&
            (identical(other.lastMessage, lastMessage) ||
                other.lastMessage == lastMessage) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount) &&
            (identical(other.myParticipant, myParticipant) ||
                other.myParticipant == myParticipant) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, user1Id, user2Id, user1,
      user2, lastMessage, unreadCount, myParticipant, createdAt, updatedAt);

  /// Create a copy of ChatModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatModelImplCopyWith<_$ChatModelImpl> get copyWith =>
      __$$ChatModelImplCopyWithImpl<_$ChatModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatModelImplToJson(
      this,
    );
  }
}

abstract class _ChatModel implements ChatModel {
  const factory _ChatModel(
          {required final String id,
          @JsonKey(name: 'user1_id') required final String user1Id,
          @JsonKey(name: 'user2_id') required final String user2Id,
          final UserModel? user1,
          final UserModel? user2,
          @JsonKey(name: 'last_message') final MessageModel? lastMessage,
          @JsonKey(name: 'unread_count') required final int unreadCount,
          @JsonKey(name: 'my_participant')
          final ChatParticipantModel? myParticipant,
          @JsonKey(name: 'created_at') required final DateTime createdAt,
          @JsonKey(name: 'updated_at') required final DateTime updatedAt}) =
      _$ChatModelImpl;

  factory _ChatModel.fromJson(Map<String, dynamic> json) =
      _$ChatModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user1_id')
  String get user1Id;
  @override
  @JsonKey(name: 'user2_id')
  String get user2Id;
  @override
  UserModel? get user1;
  @override
  UserModel? get user2;
  @override
  @JsonKey(name: 'last_message')
  MessageModel? get lastMessage;
  @override
  @JsonKey(name: 'unread_count')
  int get unreadCount;
  @override
  @JsonKey(name: 'my_participant')
  ChatParticipantModel? get myParticipant;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of ChatModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatModelImplCopyWith<_$ChatModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChatParticipantModel _$ChatParticipantModelFromJson(Map<String, dynamic> json) {
  return _ChatParticipantModel.fromJson(json);
}

/// @nodoc
mixin _$ChatParticipantModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'chat_id')
  String get chatId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_pinned')
  bool get isPinned => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_archived')
  bool get isArchived => throw _privateConstructorUsedError;
  @JsonKey(name: 'unread_count')
  int get unreadCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_read_message_id')
  String? get lastReadMessageId => throw _privateConstructorUsedError;

  /// Serializes this ChatParticipantModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatParticipantModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatParticipantModelCopyWith<ChatParticipantModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatParticipantModelCopyWith<$Res> {
  factory $ChatParticipantModelCopyWith(ChatParticipantModel value,
          $Res Function(ChatParticipantModel) then) =
      _$ChatParticipantModelCopyWithImpl<$Res, ChatParticipantModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'chat_id') String chatId,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'is_pinned') bool isPinned,
      @JsonKey(name: 'is_archived') bool isArchived,
      @JsonKey(name: 'unread_count') int unreadCount,
      @JsonKey(name: 'last_read_message_id') String? lastReadMessageId});
}

/// @nodoc
class _$ChatParticipantModelCopyWithImpl<$Res,
        $Val extends ChatParticipantModel>
    implements $ChatParticipantModelCopyWith<$Res> {
  _$ChatParticipantModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatParticipantModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? chatId = null,
    Object? userId = null,
    Object? isPinned = null,
    Object? isArchived = null,
    Object? unreadCount = null,
    Object? lastReadMessageId = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      chatId: null == chatId
          ? _value.chatId
          : chatId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      isPinned: null == isPinned
          ? _value.isPinned
          : isPinned // ignore: cast_nullable_to_non_nullable
              as bool,
      isArchived: null == isArchived
          ? _value.isArchived
          : isArchived // ignore: cast_nullable_to_non_nullable
              as bool,
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastReadMessageId: freezed == lastReadMessageId
          ? _value.lastReadMessageId
          : lastReadMessageId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChatParticipantModelImplCopyWith<$Res>
    implements $ChatParticipantModelCopyWith<$Res> {
  factory _$$ChatParticipantModelImplCopyWith(_$ChatParticipantModelImpl value,
          $Res Function(_$ChatParticipantModelImpl) then) =
      __$$ChatParticipantModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'chat_id') String chatId,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'is_pinned') bool isPinned,
      @JsonKey(name: 'is_archived') bool isArchived,
      @JsonKey(name: 'unread_count') int unreadCount,
      @JsonKey(name: 'last_read_message_id') String? lastReadMessageId});
}

/// @nodoc
class __$$ChatParticipantModelImplCopyWithImpl<$Res>
    extends _$ChatParticipantModelCopyWithImpl<$Res, _$ChatParticipantModelImpl>
    implements _$$ChatParticipantModelImplCopyWith<$Res> {
  __$$ChatParticipantModelImplCopyWithImpl(_$ChatParticipantModelImpl _value,
      $Res Function(_$ChatParticipantModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChatParticipantModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? chatId = null,
    Object? userId = null,
    Object? isPinned = null,
    Object? isArchived = null,
    Object? unreadCount = null,
    Object? lastReadMessageId = freezed,
  }) {
    return _then(_$ChatParticipantModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      chatId: null == chatId
          ? _value.chatId
          : chatId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      isPinned: null == isPinned
          ? _value.isPinned
          : isPinned // ignore: cast_nullable_to_non_nullable
              as bool,
      isArchived: null == isArchived
          ? _value.isArchived
          : isArchived // ignore: cast_nullable_to_non_nullable
              as bool,
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastReadMessageId: freezed == lastReadMessageId
          ? _value.lastReadMessageId
          : lastReadMessageId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatParticipantModelImpl implements _ChatParticipantModel {
  const _$ChatParticipantModelImpl(
      {required this.id,
      @JsonKey(name: 'chat_id') required this.chatId,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'is_pinned') required this.isPinned,
      @JsonKey(name: 'is_archived') required this.isArchived,
      @JsonKey(name: 'unread_count') required this.unreadCount,
      @JsonKey(name: 'last_read_message_id') this.lastReadMessageId});

  factory _$ChatParticipantModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatParticipantModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'chat_id')
  final String chatId;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'is_pinned')
  final bool isPinned;
  @override
  @JsonKey(name: 'is_archived')
  final bool isArchived;
  @override
  @JsonKey(name: 'unread_count')
  final int unreadCount;
  @override
  @JsonKey(name: 'last_read_message_id')
  final String? lastReadMessageId;

  @override
  String toString() {
    return 'ChatParticipantModel(id: $id, chatId: $chatId, userId: $userId, isPinned: $isPinned, isArchived: $isArchived, unreadCount: $unreadCount, lastReadMessageId: $lastReadMessageId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatParticipantModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.chatId, chatId) || other.chatId == chatId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.isPinned, isPinned) ||
                other.isPinned == isPinned) &&
            (identical(other.isArchived, isArchived) ||
                other.isArchived == isArchived) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount) &&
            (identical(other.lastReadMessageId, lastReadMessageId) ||
                other.lastReadMessageId == lastReadMessageId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, chatId, userId, isPinned,
      isArchived, unreadCount, lastReadMessageId);

  /// Create a copy of ChatParticipantModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatParticipantModelImplCopyWith<_$ChatParticipantModelImpl>
      get copyWith =>
          __$$ChatParticipantModelImplCopyWithImpl<_$ChatParticipantModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatParticipantModelImplToJson(
      this,
    );
  }
}

abstract class _ChatParticipantModel implements ChatParticipantModel {
  const factory _ChatParticipantModel(
      {required final String id,
      @JsonKey(name: 'chat_id') required final String chatId,
      @JsonKey(name: 'user_id') required final String userId,
      @JsonKey(name: 'is_pinned') required final bool isPinned,
      @JsonKey(name: 'is_archived') required final bool isArchived,
      @JsonKey(name: 'unread_count') required final int unreadCount,
      @JsonKey(name: 'last_read_message_id')
      final String? lastReadMessageId}) = _$ChatParticipantModelImpl;

  factory _ChatParticipantModel.fromJson(Map<String, dynamic> json) =
      _$ChatParticipantModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'chat_id')
  String get chatId;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'is_pinned')
  bool get isPinned;
  @override
  @JsonKey(name: 'is_archived')
  bool get isArchived;
  @override
  @JsonKey(name: 'unread_count')
  int get unreadCount;
  @override
  @JsonKey(name: 'last_read_message_id')
  String? get lastReadMessageId;

  /// Create a copy of ChatParticipantModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatParticipantModelImplCopyWith<_$ChatParticipantModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) {
  return _MessageModel.fromJson(json);
}

/// @nodoc
mixin _$MessageModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'chat_id')
  String get chatId => throw _privateConstructorUsedError;
  @JsonKey(name: 'sender_id')
  String get senderId => throw _privateConstructorUsedError;
  @JsonKey(name: 'receiver_id')
  String get receiverId => throw _privateConstructorUsedError;
  UserModel? get sender => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  MessageType get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'media_url')
  String? get mediaUrl => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_read')
  bool get isRead => throw _privateConstructorUsedError;
  @JsonKey(name: 'read_at')
  DateTime? get readAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this MessageModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MessageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MessageModelCopyWith<MessageModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageModelCopyWith<$Res> {
  factory $MessageModelCopyWith(
          MessageModel value, $Res Function(MessageModel) then) =
      _$MessageModelCopyWithImpl<$Res, MessageModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'chat_id') String chatId,
      @JsonKey(name: 'sender_id') String senderId,
      @JsonKey(name: 'receiver_id') String receiverId,
      UserModel? sender,
      String content,
      MessageType type,
      @JsonKey(name: 'media_url') String? mediaUrl,
      Map<String, dynamic>? metadata,
      @JsonKey(name: 'is_read') bool isRead,
      @JsonKey(name: 'read_at') DateTime? readAt,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});

  $UserModelCopyWith<$Res>? get sender;
}

/// @nodoc
class _$MessageModelCopyWithImpl<$Res, $Val extends MessageModel>
    implements $MessageModelCopyWith<$Res> {
  _$MessageModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MessageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? chatId = null,
    Object? senderId = null,
    Object? receiverId = null,
    Object? sender = freezed,
    Object? content = null,
    Object? type = null,
    Object? mediaUrl = freezed,
    Object? metadata = freezed,
    Object? isRead = null,
    Object? readAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      chatId: null == chatId
          ? _value.chatId
          : chatId // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      receiverId: null == receiverId
          ? _value.receiverId
          : receiverId // ignore: cast_nullable_to_non_nullable
              as String,
      sender: freezed == sender
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MessageType,
      mediaUrl: freezed == mediaUrl
          ? _value.mediaUrl
          : mediaUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      readAt: freezed == readAt
          ? _value.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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

  /// Create a copy of MessageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res>? get sender {
    if (_value.sender == null) {
      return null;
    }

    return $UserModelCopyWith<$Res>(_value.sender!, (value) {
      return _then(_value.copyWith(sender: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MessageModelImplCopyWith<$Res>
    implements $MessageModelCopyWith<$Res> {
  factory _$$MessageModelImplCopyWith(
          _$MessageModelImpl value, $Res Function(_$MessageModelImpl) then) =
      __$$MessageModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'chat_id') String chatId,
      @JsonKey(name: 'sender_id') String senderId,
      @JsonKey(name: 'receiver_id') String receiverId,
      UserModel? sender,
      String content,
      MessageType type,
      @JsonKey(name: 'media_url') String? mediaUrl,
      Map<String, dynamic>? metadata,
      @JsonKey(name: 'is_read') bool isRead,
      @JsonKey(name: 'read_at') DateTime? readAt,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});

  @override
  $UserModelCopyWith<$Res>? get sender;
}

/// @nodoc
class __$$MessageModelImplCopyWithImpl<$Res>
    extends _$MessageModelCopyWithImpl<$Res, _$MessageModelImpl>
    implements _$$MessageModelImplCopyWith<$Res> {
  __$$MessageModelImplCopyWithImpl(
      _$MessageModelImpl _value, $Res Function(_$MessageModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of MessageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? chatId = null,
    Object? senderId = null,
    Object? receiverId = null,
    Object? sender = freezed,
    Object? content = null,
    Object? type = null,
    Object? mediaUrl = freezed,
    Object? metadata = freezed,
    Object? isRead = null,
    Object? readAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$MessageModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      chatId: null == chatId
          ? _value.chatId
          : chatId // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      receiverId: null == receiverId
          ? _value.receiverId
          : receiverId // ignore: cast_nullable_to_non_nullable
              as String,
      sender: freezed == sender
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MessageType,
      mediaUrl: freezed == mediaUrl
          ? _value.mediaUrl
          : mediaUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      readAt: freezed == readAt
          ? _value.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
class _$MessageModelImpl implements _MessageModel {
  const _$MessageModelImpl(
      {required this.id,
      @JsonKey(name: 'chat_id') required this.chatId,
      @JsonKey(name: 'sender_id') required this.senderId,
      @JsonKey(name: 'receiver_id') required this.receiverId,
      this.sender,
      required this.content,
      required this.type,
      @JsonKey(name: 'media_url') this.mediaUrl,
      final Map<String, dynamic>? metadata,
      @JsonKey(name: 'is_read') required this.isRead,
      @JsonKey(name: 'read_at') this.readAt,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt})
      : _metadata = metadata;

  factory _$MessageModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'chat_id')
  final String chatId;
  @override
  @JsonKey(name: 'sender_id')
  final String senderId;
  @override
  @JsonKey(name: 'receiver_id')
  final String receiverId;
  @override
  final UserModel? sender;
  @override
  final String content;
  @override
  final MessageType type;
  @override
  @JsonKey(name: 'media_url')
  final String? mediaUrl;
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
  @JsonKey(name: 'is_read')
  final bool isRead;
  @override
  @JsonKey(name: 'read_at')
  final DateTime? readAt;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'MessageModel(id: $id, chatId: $chatId, senderId: $senderId, receiverId: $receiverId, sender: $sender, content: $content, type: $type, mediaUrl: $mediaUrl, metadata: $metadata, isRead: $isRead, readAt: $readAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.chatId, chatId) || other.chatId == chatId) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.receiverId, receiverId) ||
                other.receiverId == receiverId) &&
            (identical(other.sender, sender) || other.sender == sender) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.mediaUrl, mediaUrl) ||
                other.mediaUrl == mediaUrl) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.readAt, readAt) || other.readAt == readAt) &&
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
      chatId,
      senderId,
      receiverId,
      sender,
      content,
      type,
      mediaUrl,
      const DeepCollectionEquality().hash(_metadata),
      isRead,
      readAt,
      createdAt,
      updatedAt);

  /// Create a copy of MessageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageModelImplCopyWith<_$MessageModelImpl> get copyWith =>
      __$$MessageModelImplCopyWithImpl<_$MessageModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageModelImplToJson(
      this,
    );
  }
}

abstract class _MessageModel implements MessageModel {
  const factory _MessageModel(
          {required final String id,
          @JsonKey(name: 'chat_id') required final String chatId,
          @JsonKey(name: 'sender_id') required final String senderId,
          @JsonKey(name: 'receiver_id') required final String receiverId,
          final UserModel? sender,
          required final String content,
          required final MessageType type,
          @JsonKey(name: 'media_url') final String? mediaUrl,
          final Map<String, dynamic>? metadata,
          @JsonKey(name: 'is_read') required final bool isRead,
          @JsonKey(name: 'read_at') final DateTime? readAt,
          @JsonKey(name: 'created_at') required final DateTime createdAt,
          @JsonKey(name: 'updated_at') required final DateTime updatedAt}) =
      _$MessageModelImpl;

  factory _MessageModel.fromJson(Map<String, dynamic> json) =
      _$MessageModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'chat_id')
  String get chatId;
  @override
  @JsonKey(name: 'sender_id')
  String get senderId;
  @override
  @JsonKey(name: 'receiver_id')
  String get receiverId;
  @override
  UserModel? get sender;
  @override
  String get content;
  @override
  MessageType get type;
  @override
  @JsonKey(name: 'media_url')
  String? get mediaUrl;
  @override
  Map<String, dynamic>? get metadata;
  @override
  @JsonKey(name: 'is_read')
  bool get isRead;
  @override
  @JsonKey(name: 'read_at')
  DateTime? get readAt;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of MessageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessageModelImplCopyWith<_$MessageModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateChatRequest _$CreateChatRequestFromJson(Map<String, dynamic> json) {
  return _CreateChatRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateChatRequest {
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;

  /// Serializes this CreateChatRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateChatRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateChatRequestCopyWith<CreateChatRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateChatRequestCopyWith<$Res> {
  factory $CreateChatRequestCopyWith(
          CreateChatRequest value, $Res Function(CreateChatRequest) then) =
      _$CreateChatRequestCopyWithImpl<$Res, CreateChatRequest>;
  @useResult
  $Res call({@JsonKey(name: 'user_id') String userId});
}

/// @nodoc
class _$CreateChatRequestCopyWithImpl<$Res, $Val extends CreateChatRequest>
    implements $CreateChatRequestCopyWith<$Res> {
  _$CreateChatRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateChatRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateChatRequestImplCopyWith<$Res>
    implements $CreateChatRequestCopyWith<$Res> {
  factory _$$CreateChatRequestImplCopyWith(_$CreateChatRequestImpl value,
          $Res Function(_$CreateChatRequestImpl) then) =
      __$$CreateChatRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'user_id') String userId});
}

/// @nodoc
class __$$CreateChatRequestImplCopyWithImpl<$Res>
    extends _$CreateChatRequestCopyWithImpl<$Res, _$CreateChatRequestImpl>
    implements _$$CreateChatRequestImplCopyWith<$Res> {
  __$$CreateChatRequestImplCopyWithImpl(_$CreateChatRequestImpl _value,
      $Res Function(_$CreateChatRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateChatRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
  }) {
    return _then(_$CreateChatRequestImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateChatRequestImpl implements _CreateChatRequest {
  const _$CreateChatRequestImpl(
      {@JsonKey(name: 'user_id') required this.userId});

  factory _$CreateChatRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateChatRequestImplFromJson(json);

  @override
  @JsonKey(name: 'user_id')
  final String userId;

  @override
  String toString() {
    return 'CreateChatRequest(userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateChatRequestImpl &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId);

  /// Create a copy of CreateChatRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateChatRequestImplCopyWith<_$CreateChatRequestImpl> get copyWith =>
      __$$CreateChatRequestImplCopyWithImpl<_$CreateChatRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateChatRequestImplToJson(
      this,
    );
  }
}

abstract class _CreateChatRequest implements CreateChatRequest {
  const factory _CreateChatRequest(
          {@JsonKey(name: 'user_id') required final String userId}) =
      _$CreateChatRequestImpl;

  factory _CreateChatRequest.fromJson(Map<String, dynamic> json) =
      _$CreateChatRequestImpl.fromJson;

  @override
  @JsonKey(name: 'user_id')
  String get userId;

  /// Create a copy of CreateChatRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateChatRequestImplCopyWith<_$CreateChatRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SendMessageRequest _$SendMessageRequestFromJson(Map<String, dynamic> json) {
  return _SendMessageRequest.fromJson(json);
}

/// @nodoc
mixin _$SendMessageRequest {
  String get content => throw _privateConstructorUsedError;
  MessageType? get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'media_url')
  String? get mediaUrl => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this SendMessageRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SendMessageRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SendMessageRequestCopyWith<SendMessageRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SendMessageRequestCopyWith<$Res> {
  factory $SendMessageRequestCopyWith(
          SendMessageRequest value, $Res Function(SendMessageRequest) then) =
      _$SendMessageRequestCopyWithImpl<$Res, SendMessageRequest>;
  @useResult
  $Res call(
      {String content,
      MessageType? type,
      @JsonKey(name: 'media_url') String? mediaUrl,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$SendMessageRequestCopyWithImpl<$Res, $Val extends SendMessageRequest>
    implements $SendMessageRequestCopyWith<$Res> {
  _$SendMessageRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SendMessageRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? type = freezed,
    Object? mediaUrl = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MessageType?,
      mediaUrl: freezed == mediaUrl
          ? _value.mediaUrl
          : mediaUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SendMessageRequestImplCopyWith<$Res>
    implements $SendMessageRequestCopyWith<$Res> {
  factory _$$SendMessageRequestImplCopyWith(_$SendMessageRequestImpl value,
          $Res Function(_$SendMessageRequestImpl) then) =
      __$$SendMessageRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String content,
      MessageType? type,
      @JsonKey(name: 'media_url') String? mediaUrl,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$SendMessageRequestImplCopyWithImpl<$Res>
    extends _$SendMessageRequestCopyWithImpl<$Res, _$SendMessageRequestImpl>
    implements _$$SendMessageRequestImplCopyWith<$Res> {
  __$$SendMessageRequestImplCopyWithImpl(_$SendMessageRequestImpl _value,
      $Res Function(_$SendMessageRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of SendMessageRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? type = freezed,
    Object? mediaUrl = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$SendMessageRequestImpl(
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MessageType?,
      mediaUrl: freezed == mediaUrl
          ? _value.mediaUrl
          : mediaUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SendMessageRequestImpl implements _SendMessageRequest {
  const _$SendMessageRequestImpl(
      {required this.content,
      this.type,
      @JsonKey(name: 'media_url') this.mediaUrl,
      final Map<String, dynamic>? metadata})
      : _metadata = metadata;

  factory _$SendMessageRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$SendMessageRequestImplFromJson(json);

  @override
  final String content;
  @override
  final MessageType? type;
  @override
  @JsonKey(name: 'media_url')
  final String? mediaUrl;
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
  String toString() {
    return 'SendMessageRequest(content: $content, type: $type, mediaUrl: $mediaUrl, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SendMessageRequestImpl &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.mediaUrl, mediaUrl) ||
                other.mediaUrl == mediaUrl) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, content, type, mediaUrl,
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of SendMessageRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SendMessageRequestImplCopyWith<_$SendMessageRequestImpl> get copyWith =>
      __$$SendMessageRequestImplCopyWithImpl<_$SendMessageRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SendMessageRequestImplToJson(
      this,
    );
  }
}

abstract class _SendMessageRequest implements SendMessageRequest {
  const factory _SendMessageRequest(
      {required final String content,
      final MessageType? type,
      @JsonKey(name: 'media_url') final String? mediaUrl,
      final Map<String, dynamic>? metadata}) = _$SendMessageRequestImpl;

  factory _SendMessageRequest.fromJson(Map<String, dynamic> json) =
      _$SendMessageRequestImpl.fromJson;

  @override
  String get content;
  @override
  MessageType? get type;
  @override
  @JsonKey(name: 'media_url')
  String? get mediaUrl;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of SendMessageRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SendMessageRequestImplCopyWith<_$SendMessageRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
