// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auto_proposal_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AutoProposalModel _$AutoProposalModelFromJson(Map<String, dynamic> json) {
  return _AutoProposalModel.fromJson(json);
}

/// @nodoc
mixin _$AutoProposalModel {
  String get id => throw _privateConstructorUsedError;
  String get masterId => throw _privateConstructorUsedError;
  String get clientId => throw _privateConstructorUsedError;
  String get serviceId => throw _privateConstructorUsedError;
  DateTime get proposedDate => throw _privateConstructorUsedError;
  String get proposedTime => throw _privateConstructorUsedError;
  int get duration => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  ProposalStatus get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get expiresAt => throw _privateConstructorUsedError;
  String? get bookingId => throw _privateConstructorUsedError;
  dynamic get master => throw _privateConstructorUsedError;
  dynamic get client => throw _privateConstructorUsedError;
  dynamic get service => throw _privateConstructorUsedError;

  /// Serializes this AutoProposalModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AutoProposalModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AutoProposalModelCopyWith<AutoProposalModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AutoProposalModelCopyWith<$Res> {
  factory $AutoProposalModelCopyWith(
          AutoProposalModel value, $Res Function(AutoProposalModel) then) =
      _$AutoProposalModelCopyWithImpl<$Res, AutoProposalModel>;
  @useResult
  $Res call(
      {String id,
      String masterId,
      String clientId,
      String serviceId,
      DateTime proposedDate,
      String proposedTime,
      int duration,
      double price,
      String? message,
      ProposalStatus status,
      DateTime createdAt,
      DateTime expiresAt,
      String? bookingId,
      dynamic master,
      dynamic client,
      dynamic service});
}

/// @nodoc
class _$AutoProposalModelCopyWithImpl<$Res, $Val extends AutoProposalModel>
    implements $AutoProposalModelCopyWith<$Res> {
  _$AutoProposalModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AutoProposalModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? masterId = null,
    Object? clientId = null,
    Object? serviceId = null,
    Object? proposedDate = null,
    Object? proposedTime = null,
    Object? duration = null,
    Object? price = null,
    Object? message = freezed,
    Object? status = null,
    Object? createdAt = null,
    Object? expiresAt = null,
    Object? bookingId = freezed,
    Object? master = freezed,
    Object? client = freezed,
    Object? service = freezed,
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
      clientId: null == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String,
      serviceId: null == serviceId
          ? _value.serviceId
          : serviceId // ignore: cast_nullable_to_non_nullable
              as String,
      proposedDate: null == proposedDate
          ? _value.proposedDate
          : proposedDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      proposedTime: null == proposedTime
          ? _value.proposedTime
          : proposedTime // ignore: cast_nullable_to_non_nullable
              as String,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ProposalStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expiresAt: null == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      bookingId: freezed == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String?,
      master: freezed == master
          ? _value.master
          : master // ignore: cast_nullable_to_non_nullable
              as dynamic,
      client: freezed == client
          ? _value.client
          : client // ignore: cast_nullable_to_non_nullable
              as dynamic,
      service: freezed == service
          ? _value.service
          : service // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AutoProposalModelImplCopyWith<$Res>
    implements $AutoProposalModelCopyWith<$Res> {
  factory _$$AutoProposalModelImplCopyWith(_$AutoProposalModelImpl value,
          $Res Function(_$AutoProposalModelImpl) then) =
      __$$AutoProposalModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String masterId,
      String clientId,
      String serviceId,
      DateTime proposedDate,
      String proposedTime,
      int duration,
      double price,
      String? message,
      ProposalStatus status,
      DateTime createdAt,
      DateTime expiresAt,
      String? bookingId,
      dynamic master,
      dynamic client,
      dynamic service});
}

/// @nodoc
class __$$AutoProposalModelImplCopyWithImpl<$Res>
    extends _$AutoProposalModelCopyWithImpl<$Res, _$AutoProposalModelImpl>
    implements _$$AutoProposalModelImplCopyWith<$Res> {
  __$$AutoProposalModelImplCopyWithImpl(_$AutoProposalModelImpl _value,
      $Res Function(_$AutoProposalModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of AutoProposalModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? masterId = null,
    Object? clientId = null,
    Object? serviceId = null,
    Object? proposedDate = null,
    Object? proposedTime = null,
    Object? duration = null,
    Object? price = null,
    Object? message = freezed,
    Object? status = null,
    Object? createdAt = null,
    Object? expiresAt = null,
    Object? bookingId = freezed,
    Object? master = freezed,
    Object? client = freezed,
    Object? service = freezed,
  }) {
    return _then(_$AutoProposalModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      masterId: null == masterId
          ? _value.masterId
          : masterId // ignore: cast_nullable_to_non_nullable
              as String,
      clientId: null == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String,
      serviceId: null == serviceId
          ? _value.serviceId
          : serviceId // ignore: cast_nullable_to_non_nullable
              as String,
      proposedDate: null == proposedDate
          ? _value.proposedDate
          : proposedDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      proposedTime: null == proposedTime
          ? _value.proposedTime
          : proposedTime // ignore: cast_nullable_to_non_nullable
              as String,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ProposalStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expiresAt: null == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      bookingId: freezed == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String?,
      master: freezed == master
          ? _value.master
          : master // ignore: cast_nullable_to_non_nullable
              as dynamic,
      client: freezed == client
          ? _value.client
          : client // ignore: cast_nullable_to_non_nullable
              as dynamic,
      service: freezed == service
          ? _value.service
          : service // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AutoProposalModelImpl implements _AutoProposalModel {
  const _$AutoProposalModelImpl(
      {required this.id,
      required this.masterId,
      required this.clientId,
      required this.serviceId,
      required this.proposedDate,
      required this.proposedTime,
      required this.duration,
      required this.price,
      this.message,
      required this.status,
      required this.createdAt,
      required this.expiresAt,
      this.bookingId,
      this.master,
      this.client,
      this.service});

  factory _$AutoProposalModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AutoProposalModelImplFromJson(json);

  @override
  final String id;
  @override
  final String masterId;
  @override
  final String clientId;
  @override
  final String serviceId;
  @override
  final DateTime proposedDate;
  @override
  final String proposedTime;
  @override
  final int duration;
  @override
  final double price;
  @override
  final String? message;
  @override
  final ProposalStatus status;
  @override
  final DateTime createdAt;
  @override
  final DateTime expiresAt;
  @override
  final String? bookingId;
  @override
  final dynamic master;
  @override
  final dynamic client;
  @override
  final dynamic service;

  @override
  String toString() {
    return 'AutoProposalModel(id: $id, masterId: $masterId, clientId: $clientId, serviceId: $serviceId, proposedDate: $proposedDate, proposedTime: $proposedTime, duration: $duration, price: $price, message: $message, status: $status, createdAt: $createdAt, expiresAt: $expiresAt, bookingId: $bookingId, master: $master, client: $client, service: $service)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AutoProposalModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.masterId, masterId) ||
                other.masterId == masterId) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.serviceId, serviceId) ||
                other.serviceId == serviceId) &&
            (identical(other.proposedDate, proposedDate) ||
                other.proposedDate == proposedDate) &&
            (identical(other.proposedTime, proposedTime) ||
                other.proposedTime == proposedTime) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            const DeepCollectionEquality().equals(other.master, master) &&
            const DeepCollectionEquality().equals(other.client, client) &&
            const DeepCollectionEquality().equals(other.service, service));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      masterId,
      clientId,
      serviceId,
      proposedDate,
      proposedTime,
      duration,
      price,
      message,
      status,
      createdAt,
      expiresAt,
      bookingId,
      const DeepCollectionEquality().hash(master),
      const DeepCollectionEquality().hash(client),
      const DeepCollectionEquality().hash(service));

  /// Create a copy of AutoProposalModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AutoProposalModelImplCopyWith<_$AutoProposalModelImpl> get copyWith =>
      __$$AutoProposalModelImplCopyWithImpl<_$AutoProposalModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AutoProposalModelImplToJson(
      this,
    );
  }
}

abstract class _AutoProposalModel implements AutoProposalModel {
  const factory _AutoProposalModel(
      {required final String id,
      required final String masterId,
      required final String clientId,
      required final String serviceId,
      required final DateTime proposedDate,
      required final String proposedTime,
      required final int duration,
      required final double price,
      final String? message,
      required final ProposalStatus status,
      required final DateTime createdAt,
      required final DateTime expiresAt,
      final String? bookingId,
      final dynamic master,
      final dynamic client,
      final dynamic service}) = _$AutoProposalModelImpl;

  factory _AutoProposalModel.fromJson(Map<String, dynamic> json) =
      _$AutoProposalModelImpl.fromJson;

  @override
  String get id;
  @override
  String get masterId;
  @override
  String get clientId;
  @override
  String get serviceId;
  @override
  DateTime get proposedDate;
  @override
  String get proposedTime;
  @override
  int get duration;
  @override
  double get price;
  @override
  String? get message;
  @override
  ProposalStatus get status;
  @override
  DateTime get createdAt;
  @override
  DateTime get expiresAt;
  @override
  String? get bookingId;
  @override
  dynamic get master;
  @override
  dynamic get client;
  @override
  dynamic get service;

  /// Create a copy of AutoProposalModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AutoProposalModelImplCopyWith<_$AutoProposalModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
