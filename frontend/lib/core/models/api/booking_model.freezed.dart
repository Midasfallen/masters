// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BookingModel _$BookingModelFromJson(Map<String, dynamic> json) {
  return _BookingModel.fromJson(json);
}

/// @nodoc
mixin _$BookingModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'client_id')
  String get clientId => throw _privateConstructorUsedError;
  @JsonKey(name: 'master_id')
  String get masterId => throw _privateConstructorUsedError;
  @JsonKey(name: 'service_id')
  String get serviceId => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_time')
  DateTime get startTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_time')
  DateTime get endTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'duration_minutes')
  int get durationMinutes => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  BookingStatus get status => throw _privateConstructorUsedError;
  String? get comment => throw _privateConstructorUsedError;
  @JsonKey(name: 'cancellation_reason')
  String? get cancellationReason => throw _privateConstructorUsedError;
  @JsonKey(name: 'cancelled_by')
  String? get cancelledBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'client_review_left')
  bool get clientReviewLeft => throw _privateConstructorUsedError;
  @JsonKey(name: 'master_review_left')
  bool get masterReviewLeft => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed_at')
  DateTime? get completedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_address')
  String? get locationAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_lat')
  double? get locationLat => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_lng')
  double? get locationLng => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_type')
  String get locationType => throw _privateConstructorUsedError;
  @JsonKey(name: 'reminder_sent')
  bool get reminderSent => throw _privateConstructorUsedError;
  @JsonKey(name: 'reminder_sent_at')
  DateTime? get reminderSentAt => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this BookingModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BookingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingModelCopyWith<BookingModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingModelCopyWith<$Res> {
  factory $BookingModelCopyWith(
          BookingModel value, $Res Function(BookingModel) then) =
      _$BookingModelCopyWithImpl<$Res, BookingModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'client_id') String clientId,
      @JsonKey(name: 'master_id') String masterId,
      @JsonKey(name: 'service_id') String serviceId,
      @JsonKey(name: 'start_time') DateTime startTime,
      @JsonKey(name: 'end_time') DateTime endTime,
      @JsonKey(name: 'duration_minutes') int durationMinutes,
      double price,
      BookingStatus status,
      String? comment,
      @JsonKey(name: 'cancellation_reason') String? cancellationReason,
      @JsonKey(name: 'cancelled_by') String? cancelledBy,
      @JsonKey(name: 'client_review_left') bool clientReviewLeft,
      @JsonKey(name: 'master_review_left') bool masterReviewLeft,
      @JsonKey(name: 'completed_at') DateTime? completedAt,
      @JsonKey(name: 'location_address') String? locationAddress,
      @JsonKey(name: 'location_lat') double? locationLat,
      @JsonKey(name: 'location_lng') double? locationLng,
      @JsonKey(name: 'location_type') String locationType,
      @JsonKey(name: 'reminder_sent') bool reminderSent,
      @JsonKey(name: 'reminder_sent_at') DateTime? reminderSentAt,
      Map<String, dynamic>? metadata,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class _$BookingModelCopyWithImpl<$Res, $Val extends BookingModel>
    implements $BookingModelCopyWith<$Res> {
  _$BookingModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clientId = null,
    Object? masterId = null,
    Object? serviceId = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? durationMinutes = null,
    Object? price = null,
    Object? status = null,
    Object? comment = freezed,
    Object? cancellationReason = freezed,
    Object? cancelledBy = freezed,
    Object? clientReviewLeft = null,
    Object? masterReviewLeft = null,
    Object? completedAt = freezed,
    Object? locationAddress = freezed,
    Object? locationLat = freezed,
    Object? locationLng = freezed,
    Object? locationType = null,
    Object? reminderSent = null,
    Object? reminderSentAt = freezed,
    Object? metadata = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      clientId: null == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String,
      masterId: null == masterId
          ? _value.masterId
          : masterId // ignore: cast_nullable_to_non_nullable
              as String,
      serviceId: null == serviceId
          ? _value.serviceId
          : serviceId // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      durationMinutes: null == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as BookingStatus,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      cancellationReason: freezed == cancellationReason
          ? _value.cancellationReason
          : cancellationReason // ignore: cast_nullable_to_non_nullable
              as String?,
      cancelledBy: freezed == cancelledBy
          ? _value.cancelledBy
          : cancelledBy // ignore: cast_nullable_to_non_nullable
              as String?,
      clientReviewLeft: null == clientReviewLeft
          ? _value.clientReviewLeft
          : clientReviewLeft // ignore: cast_nullable_to_non_nullable
              as bool,
      masterReviewLeft: null == masterReviewLeft
          ? _value.masterReviewLeft
          : masterReviewLeft // ignore: cast_nullable_to_non_nullable
              as bool,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
      locationType: null == locationType
          ? _value.locationType
          : locationType // ignore: cast_nullable_to_non_nullable
              as String,
      reminderSent: null == reminderSent
          ? _value.reminderSent
          : reminderSent // ignore: cast_nullable_to_non_nullable
              as bool,
      reminderSentAt: freezed == reminderSentAt
          ? _value.reminderSentAt
          : reminderSentAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
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
abstract class _$$BookingModelImplCopyWith<$Res>
    implements $BookingModelCopyWith<$Res> {
  factory _$$BookingModelImplCopyWith(
          _$BookingModelImpl value, $Res Function(_$BookingModelImpl) then) =
      __$$BookingModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'client_id') String clientId,
      @JsonKey(name: 'master_id') String masterId,
      @JsonKey(name: 'service_id') String serviceId,
      @JsonKey(name: 'start_time') DateTime startTime,
      @JsonKey(name: 'end_time') DateTime endTime,
      @JsonKey(name: 'duration_minutes') int durationMinutes,
      double price,
      BookingStatus status,
      String? comment,
      @JsonKey(name: 'cancellation_reason') String? cancellationReason,
      @JsonKey(name: 'cancelled_by') String? cancelledBy,
      @JsonKey(name: 'client_review_left') bool clientReviewLeft,
      @JsonKey(name: 'master_review_left') bool masterReviewLeft,
      @JsonKey(name: 'completed_at') DateTime? completedAt,
      @JsonKey(name: 'location_address') String? locationAddress,
      @JsonKey(name: 'location_lat') double? locationLat,
      @JsonKey(name: 'location_lng') double? locationLng,
      @JsonKey(name: 'location_type') String locationType,
      @JsonKey(name: 'reminder_sent') bool reminderSent,
      @JsonKey(name: 'reminder_sent_at') DateTime? reminderSentAt,
      Map<String, dynamic>? metadata,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class __$$BookingModelImplCopyWithImpl<$Res>
    extends _$BookingModelCopyWithImpl<$Res, _$BookingModelImpl>
    implements _$$BookingModelImplCopyWith<$Res> {
  __$$BookingModelImplCopyWithImpl(
      _$BookingModelImpl _value, $Res Function(_$BookingModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of BookingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clientId = null,
    Object? masterId = null,
    Object? serviceId = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? durationMinutes = null,
    Object? price = null,
    Object? status = null,
    Object? comment = freezed,
    Object? cancellationReason = freezed,
    Object? cancelledBy = freezed,
    Object? clientReviewLeft = null,
    Object? masterReviewLeft = null,
    Object? completedAt = freezed,
    Object? locationAddress = freezed,
    Object? locationLat = freezed,
    Object? locationLng = freezed,
    Object? locationType = null,
    Object? reminderSent = null,
    Object? reminderSentAt = freezed,
    Object? metadata = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$BookingModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      clientId: null == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String,
      masterId: null == masterId
          ? _value.masterId
          : masterId // ignore: cast_nullable_to_non_nullable
              as String,
      serviceId: null == serviceId
          ? _value.serviceId
          : serviceId // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      durationMinutes: null == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as BookingStatus,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      cancellationReason: freezed == cancellationReason
          ? _value.cancellationReason
          : cancellationReason // ignore: cast_nullable_to_non_nullable
              as String?,
      cancelledBy: freezed == cancelledBy
          ? _value.cancelledBy
          : cancelledBy // ignore: cast_nullable_to_non_nullable
              as String?,
      clientReviewLeft: null == clientReviewLeft
          ? _value.clientReviewLeft
          : clientReviewLeft // ignore: cast_nullable_to_non_nullable
              as bool,
      masterReviewLeft: null == masterReviewLeft
          ? _value.masterReviewLeft
          : masterReviewLeft // ignore: cast_nullable_to_non_nullable
              as bool,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
      locationType: null == locationType
          ? _value.locationType
          : locationType // ignore: cast_nullable_to_non_nullable
              as String,
      reminderSent: null == reminderSent
          ? _value.reminderSent
          : reminderSent // ignore: cast_nullable_to_non_nullable
              as bool,
      reminderSentAt: freezed == reminderSentAt
          ? _value.reminderSentAt
          : reminderSentAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
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
class _$BookingModelImpl implements _BookingModel {
  const _$BookingModelImpl(
      {required this.id,
      @JsonKey(name: 'client_id') required this.clientId,
      @JsonKey(name: 'master_id') required this.masterId,
      @JsonKey(name: 'service_id') required this.serviceId,
      @JsonKey(name: 'start_time') required this.startTime,
      @JsonKey(name: 'end_time') required this.endTime,
      @JsonKey(name: 'duration_minutes') required this.durationMinutes,
      required this.price,
      required this.status,
      this.comment,
      @JsonKey(name: 'cancellation_reason') this.cancellationReason,
      @JsonKey(name: 'cancelled_by') this.cancelledBy,
      @JsonKey(name: 'client_review_left') required this.clientReviewLeft,
      @JsonKey(name: 'master_review_left') required this.masterReviewLeft,
      @JsonKey(name: 'completed_at') this.completedAt,
      @JsonKey(name: 'location_address') this.locationAddress,
      @JsonKey(name: 'location_lat') this.locationLat,
      @JsonKey(name: 'location_lng') this.locationLng,
      @JsonKey(name: 'location_type') required this.locationType,
      @JsonKey(name: 'reminder_sent') required this.reminderSent,
      @JsonKey(name: 'reminder_sent_at') this.reminderSentAt,
      final Map<String, dynamic>? metadata,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt})
      : _metadata = metadata;

  factory _$BookingModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'client_id')
  final String clientId;
  @override
  @JsonKey(name: 'master_id')
  final String masterId;
  @override
  @JsonKey(name: 'service_id')
  final String serviceId;
  @override
  @JsonKey(name: 'start_time')
  final DateTime startTime;
  @override
  @JsonKey(name: 'end_time')
  final DateTime endTime;
  @override
  @JsonKey(name: 'duration_minutes')
  final int durationMinutes;
  @override
  final double price;
  @override
  final BookingStatus status;
  @override
  final String? comment;
  @override
  @JsonKey(name: 'cancellation_reason')
  final String? cancellationReason;
  @override
  @JsonKey(name: 'cancelled_by')
  final String? cancelledBy;
  @override
  @JsonKey(name: 'client_review_left')
  final bool clientReviewLeft;
  @override
  @JsonKey(name: 'master_review_left')
  final bool masterReviewLeft;
  @override
  @JsonKey(name: 'completed_at')
  final DateTime? completedAt;
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
  @JsonKey(name: 'location_type')
  final String locationType;
  @override
  @JsonKey(name: 'reminder_sent')
  final bool reminderSent;
  @override
  @JsonKey(name: 'reminder_sent_at')
  final DateTime? reminderSentAt;
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
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'BookingModel(id: $id, clientId: $clientId, masterId: $masterId, serviceId: $serviceId, startTime: $startTime, endTime: $endTime, durationMinutes: $durationMinutes, price: $price, status: $status, comment: $comment, cancellationReason: $cancellationReason, cancelledBy: $cancelledBy, clientReviewLeft: $clientReviewLeft, masterReviewLeft: $masterReviewLeft, completedAt: $completedAt, locationAddress: $locationAddress, locationLat: $locationLat, locationLng: $locationLng, locationType: $locationType, reminderSent: $reminderSent, reminderSentAt: $reminderSentAt, metadata: $metadata, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.masterId, masterId) ||
                other.masterId == masterId) &&
            (identical(other.serviceId, serviceId) ||
                other.serviceId == serviceId) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.cancellationReason, cancellationReason) ||
                other.cancellationReason == cancellationReason) &&
            (identical(other.cancelledBy, cancelledBy) ||
                other.cancelledBy == cancelledBy) &&
            (identical(other.clientReviewLeft, clientReviewLeft) ||
                other.clientReviewLeft == clientReviewLeft) &&
            (identical(other.masterReviewLeft, masterReviewLeft) ||
                other.masterReviewLeft == masterReviewLeft) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.locationAddress, locationAddress) ||
                other.locationAddress == locationAddress) &&
            (identical(other.locationLat, locationLat) ||
                other.locationLat == locationLat) &&
            (identical(other.locationLng, locationLng) ||
                other.locationLng == locationLng) &&
            (identical(other.locationType, locationType) ||
                other.locationType == locationType) &&
            (identical(other.reminderSent, reminderSent) ||
                other.reminderSent == reminderSent) &&
            (identical(other.reminderSentAt, reminderSentAt) ||
                other.reminderSentAt == reminderSentAt) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
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
        clientId,
        masterId,
        serviceId,
        startTime,
        endTime,
        durationMinutes,
        price,
        status,
        comment,
        cancellationReason,
        cancelledBy,
        clientReviewLeft,
        masterReviewLeft,
        completedAt,
        locationAddress,
        locationLat,
        locationLng,
        locationType,
        reminderSent,
        reminderSentAt,
        const DeepCollectionEquality().hash(_metadata),
        createdAt,
        updatedAt
      ]);

  /// Create a copy of BookingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingModelImplCopyWith<_$BookingModelImpl> get copyWith =>
      __$$BookingModelImplCopyWithImpl<_$BookingModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingModelImplToJson(
      this,
    );
  }
}

abstract class _BookingModel implements BookingModel {
  const factory _BookingModel(
      {required final String id,
      @JsonKey(name: 'client_id') required final String clientId,
      @JsonKey(name: 'master_id') required final String masterId,
      @JsonKey(name: 'service_id') required final String serviceId,
      @JsonKey(name: 'start_time') required final DateTime startTime,
      @JsonKey(name: 'end_time') required final DateTime endTime,
      @JsonKey(name: 'duration_minutes') required final int durationMinutes,
      required final double price,
      required final BookingStatus status,
      final String? comment,
      @JsonKey(name: 'cancellation_reason') final String? cancellationReason,
      @JsonKey(name: 'cancelled_by') final String? cancelledBy,
      @JsonKey(name: 'client_review_left') required final bool clientReviewLeft,
      @JsonKey(name: 'master_review_left') required final bool masterReviewLeft,
      @JsonKey(name: 'completed_at') final DateTime? completedAt,
      @JsonKey(name: 'location_address') final String? locationAddress,
      @JsonKey(name: 'location_lat') final double? locationLat,
      @JsonKey(name: 'location_lng') final double? locationLng,
      @JsonKey(name: 'location_type') required final String locationType,
      @JsonKey(name: 'reminder_sent') required final bool reminderSent,
      @JsonKey(name: 'reminder_sent_at') final DateTime? reminderSentAt,
      final Map<String, dynamic>? metadata,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'updated_at')
      required final DateTime updatedAt}) = _$BookingModelImpl;

  factory _BookingModel.fromJson(Map<String, dynamic> json) =
      _$BookingModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'client_id')
  String get clientId;
  @override
  @JsonKey(name: 'master_id')
  String get masterId;
  @override
  @JsonKey(name: 'service_id')
  String get serviceId;
  @override
  @JsonKey(name: 'start_time')
  DateTime get startTime;
  @override
  @JsonKey(name: 'end_time')
  DateTime get endTime;
  @override
  @JsonKey(name: 'duration_minutes')
  int get durationMinutes;
  @override
  double get price;
  @override
  BookingStatus get status;
  @override
  String? get comment;
  @override
  @JsonKey(name: 'cancellation_reason')
  String? get cancellationReason;
  @override
  @JsonKey(name: 'cancelled_by')
  String? get cancelledBy;
  @override
  @JsonKey(name: 'client_review_left')
  bool get clientReviewLeft;
  @override
  @JsonKey(name: 'master_review_left')
  bool get masterReviewLeft;
  @override
  @JsonKey(name: 'completed_at')
  DateTime? get completedAt;
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
  @JsonKey(name: 'location_type')
  String get locationType;
  @override
  @JsonKey(name: 'reminder_sent')
  bool get reminderSent;
  @override
  @JsonKey(name: 'reminder_sent_at')
  DateTime? get reminderSentAt;
  @override
  Map<String, dynamic>? get metadata;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of BookingModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingModelImplCopyWith<_$BookingModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateBookingRequest _$CreateBookingRequestFromJson(Map<String, dynamic> json) {
  return _CreateBookingRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateBookingRequest {
  @JsonKey(name: 'master_id')
  String get masterId => throw _privateConstructorUsedError;
  @JsonKey(name: 'service_id')
  String get serviceId => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_time')
  DateTime get startTime => throw _privateConstructorUsedError;
  String? get comment => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_address')
  String? get locationAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_lat')
  double? get locationLat => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_lng')
  double? get locationLng => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_type')
  String? get locationType => throw _privateConstructorUsedError;

  /// Serializes this CreateBookingRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateBookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateBookingRequestCopyWith<CreateBookingRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateBookingRequestCopyWith<$Res> {
  factory $CreateBookingRequestCopyWith(CreateBookingRequest value,
          $Res Function(CreateBookingRequest) then) =
      _$CreateBookingRequestCopyWithImpl<$Res, CreateBookingRequest>;
  @useResult
  $Res call(
      {@JsonKey(name: 'master_id') String masterId,
      @JsonKey(name: 'service_id') String serviceId,
      @JsonKey(name: 'start_time') DateTime startTime,
      String? comment,
      @JsonKey(name: 'location_address') String? locationAddress,
      @JsonKey(name: 'location_lat') double? locationLat,
      @JsonKey(name: 'location_lng') double? locationLng,
      @JsonKey(name: 'location_type') String? locationType});
}

/// @nodoc
class _$CreateBookingRequestCopyWithImpl<$Res,
        $Val extends CreateBookingRequest>
    implements $CreateBookingRequestCopyWith<$Res> {
  _$CreateBookingRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateBookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? masterId = null,
    Object? serviceId = null,
    Object? startTime = null,
    Object? comment = freezed,
    Object? locationAddress = freezed,
    Object? locationLat = freezed,
    Object? locationLng = freezed,
    Object? locationType = freezed,
  }) {
    return _then(_value.copyWith(
      masterId: null == masterId
          ? _value.masterId
          : masterId // ignore: cast_nullable_to_non_nullable
              as String,
      serviceId: null == serviceId
          ? _value.serviceId
          : serviceId // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
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
      locationType: freezed == locationType
          ? _value.locationType
          : locationType // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateBookingRequestImplCopyWith<$Res>
    implements $CreateBookingRequestCopyWith<$Res> {
  factory _$$CreateBookingRequestImplCopyWith(_$CreateBookingRequestImpl value,
          $Res Function(_$CreateBookingRequestImpl) then) =
      __$$CreateBookingRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'master_id') String masterId,
      @JsonKey(name: 'service_id') String serviceId,
      @JsonKey(name: 'start_time') DateTime startTime,
      String? comment,
      @JsonKey(name: 'location_address') String? locationAddress,
      @JsonKey(name: 'location_lat') double? locationLat,
      @JsonKey(name: 'location_lng') double? locationLng,
      @JsonKey(name: 'location_type') String? locationType});
}

/// @nodoc
class __$$CreateBookingRequestImplCopyWithImpl<$Res>
    extends _$CreateBookingRequestCopyWithImpl<$Res, _$CreateBookingRequestImpl>
    implements _$$CreateBookingRequestImplCopyWith<$Res> {
  __$$CreateBookingRequestImplCopyWithImpl(_$CreateBookingRequestImpl _value,
      $Res Function(_$CreateBookingRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateBookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? masterId = null,
    Object? serviceId = null,
    Object? startTime = null,
    Object? comment = freezed,
    Object? locationAddress = freezed,
    Object? locationLat = freezed,
    Object? locationLng = freezed,
    Object? locationType = freezed,
  }) {
    return _then(_$CreateBookingRequestImpl(
      masterId: null == masterId
          ? _value.masterId
          : masterId // ignore: cast_nullable_to_non_nullable
              as String,
      serviceId: null == serviceId
          ? _value.serviceId
          : serviceId // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
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
      locationType: freezed == locationType
          ? _value.locationType
          : locationType // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateBookingRequestImpl implements _CreateBookingRequest {
  const _$CreateBookingRequestImpl(
      {@JsonKey(name: 'master_id') required this.masterId,
      @JsonKey(name: 'service_id') required this.serviceId,
      @JsonKey(name: 'start_time') required this.startTime,
      this.comment,
      @JsonKey(name: 'location_address') this.locationAddress,
      @JsonKey(name: 'location_lat') this.locationLat,
      @JsonKey(name: 'location_lng') this.locationLng,
      @JsonKey(name: 'location_type') this.locationType});

  factory _$CreateBookingRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateBookingRequestImplFromJson(json);

  @override
  @JsonKey(name: 'master_id')
  final String masterId;
  @override
  @JsonKey(name: 'service_id')
  final String serviceId;
  @override
  @JsonKey(name: 'start_time')
  final DateTime startTime;
  @override
  final String? comment;
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
  @JsonKey(name: 'location_type')
  final String? locationType;

  @override
  String toString() {
    return 'CreateBookingRequest(masterId: $masterId, serviceId: $serviceId, startTime: $startTime, comment: $comment, locationAddress: $locationAddress, locationLat: $locationLat, locationLng: $locationLng, locationType: $locationType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateBookingRequestImpl &&
            (identical(other.masterId, masterId) ||
                other.masterId == masterId) &&
            (identical(other.serviceId, serviceId) ||
                other.serviceId == serviceId) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.locationAddress, locationAddress) ||
                other.locationAddress == locationAddress) &&
            (identical(other.locationLat, locationLat) ||
                other.locationLat == locationLat) &&
            (identical(other.locationLng, locationLng) ||
                other.locationLng == locationLng) &&
            (identical(other.locationType, locationType) ||
                other.locationType == locationType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, masterId, serviceId, startTime,
      comment, locationAddress, locationLat, locationLng, locationType);

  /// Create a copy of CreateBookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateBookingRequestImplCopyWith<_$CreateBookingRequestImpl>
      get copyWith =>
          __$$CreateBookingRequestImplCopyWithImpl<_$CreateBookingRequestImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateBookingRequestImplToJson(
      this,
    );
  }
}

abstract class _CreateBookingRequest implements CreateBookingRequest {
  const factory _CreateBookingRequest(
          {@JsonKey(name: 'master_id') required final String masterId,
          @JsonKey(name: 'service_id') required final String serviceId,
          @JsonKey(name: 'start_time') required final DateTime startTime,
          final String? comment,
          @JsonKey(name: 'location_address') final String? locationAddress,
          @JsonKey(name: 'location_lat') final double? locationLat,
          @JsonKey(name: 'location_lng') final double? locationLng,
          @JsonKey(name: 'location_type') final String? locationType}) =
      _$CreateBookingRequestImpl;

  factory _CreateBookingRequest.fromJson(Map<String, dynamic> json) =
      _$CreateBookingRequestImpl.fromJson;

  @override
  @JsonKey(name: 'master_id')
  String get masterId;
  @override
  @JsonKey(name: 'service_id')
  String get serviceId;
  @override
  @JsonKey(name: 'start_time')
  DateTime get startTime;
  @override
  String? get comment;
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
  @JsonKey(name: 'location_type')
  String? get locationType;

  /// Create a copy of CreateBookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateBookingRequestImplCopyWith<_$CreateBookingRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

UpdateBookingStatusRequest _$UpdateBookingStatusRequestFromJson(
    Map<String, dynamic> json) {
  return _UpdateBookingStatusRequest.fromJson(json);
}

/// @nodoc
mixin _$UpdateBookingStatusRequest {
  BookingStatus get status => throw _privateConstructorUsedError;

  /// Serializes this UpdateBookingStatusRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateBookingStatusRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateBookingStatusRequestCopyWith<UpdateBookingStatusRequest>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateBookingStatusRequestCopyWith<$Res> {
  factory $UpdateBookingStatusRequestCopyWith(UpdateBookingStatusRequest value,
          $Res Function(UpdateBookingStatusRequest) then) =
      _$UpdateBookingStatusRequestCopyWithImpl<$Res,
          UpdateBookingStatusRequest>;
  @useResult
  $Res call({BookingStatus status});
}

/// @nodoc
class _$UpdateBookingStatusRequestCopyWithImpl<$Res,
        $Val extends UpdateBookingStatusRequest>
    implements $UpdateBookingStatusRequestCopyWith<$Res> {
  _$UpdateBookingStatusRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateBookingStatusRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as BookingStatus,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateBookingStatusRequestImplCopyWith<$Res>
    implements $UpdateBookingStatusRequestCopyWith<$Res> {
  factory _$$UpdateBookingStatusRequestImplCopyWith(
          _$UpdateBookingStatusRequestImpl value,
          $Res Function(_$UpdateBookingStatusRequestImpl) then) =
      __$$UpdateBookingStatusRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({BookingStatus status});
}

/// @nodoc
class __$$UpdateBookingStatusRequestImplCopyWithImpl<$Res>
    extends _$UpdateBookingStatusRequestCopyWithImpl<$Res,
        _$UpdateBookingStatusRequestImpl>
    implements _$$UpdateBookingStatusRequestImplCopyWith<$Res> {
  __$$UpdateBookingStatusRequestImplCopyWithImpl(
      _$UpdateBookingStatusRequestImpl _value,
      $Res Function(_$UpdateBookingStatusRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateBookingStatusRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
  }) {
    return _then(_$UpdateBookingStatusRequestImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as BookingStatus,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateBookingStatusRequestImpl implements _UpdateBookingStatusRequest {
  const _$UpdateBookingStatusRequestImpl({required this.status});

  factory _$UpdateBookingStatusRequestImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$UpdateBookingStatusRequestImplFromJson(json);

  @override
  final BookingStatus status;

  @override
  String toString() {
    return 'UpdateBookingStatusRequest(status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateBookingStatusRequestImpl &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, status);

  /// Create a copy of UpdateBookingStatusRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateBookingStatusRequestImplCopyWith<_$UpdateBookingStatusRequestImpl>
      get copyWith => __$$UpdateBookingStatusRequestImplCopyWithImpl<
          _$UpdateBookingStatusRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateBookingStatusRequestImplToJson(
      this,
    );
  }
}

abstract class _UpdateBookingStatusRequest
    implements UpdateBookingStatusRequest {
  const factory _UpdateBookingStatusRequest(
      {required final BookingStatus status}) = _$UpdateBookingStatusRequestImpl;

  factory _UpdateBookingStatusRequest.fromJson(Map<String, dynamic> json) =
      _$UpdateBookingStatusRequestImpl.fromJson;

  @override
  BookingStatus get status;

  /// Create a copy of UpdateBookingStatusRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateBookingStatusRequestImplCopyWith<_$UpdateBookingStatusRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

CancelBookingRequest _$CancelBookingRequestFromJson(Map<String, dynamic> json) {
  return _CancelBookingRequest.fromJson(json);
}

/// @nodoc
mixin _$CancelBookingRequest {
  String get reason => throw _privateConstructorUsedError;

  /// Serializes this CancelBookingRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CancelBookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CancelBookingRequestCopyWith<CancelBookingRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CancelBookingRequestCopyWith<$Res> {
  factory $CancelBookingRequestCopyWith(CancelBookingRequest value,
          $Res Function(CancelBookingRequest) then) =
      _$CancelBookingRequestCopyWithImpl<$Res, CancelBookingRequest>;
  @useResult
  $Res call({String reason});
}

/// @nodoc
class _$CancelBookingRequestCopyWithImpl<$Res,
        $Val extends CancelBookingRequest>
    implements $CancelBookingRequestCopyWith<$Res> {
  _$CancelBookingRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CancelBookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reason = null,
  }) {
    return _then(_value.copyWith(
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CancelBookingRequestImplCopyWith<$Res>
    implements $CancelBookingRequestCopyWith<$Res> {
  factory _$$CancelBookingRequestImplCopyWith(_$CancelBookingRequestImpl value,
          $Res Function(_$CancelBookingRequestImpl) then) =
      __$$CancelBookingRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String reason});
}

/// @nodoc
class __$$CancelBookingRequestImplCopyWithImpl<$Res>
    extends _$CancelBookingRequestCopyWithImpl<$Res, _$CancelBookingRequestImpl>
    implements _$$CancelBookingRequestImplCopyWith<$Res> {
  __$$CancelBookingRequestImplCopyWithImpl(_$CancelBookingRequestImpl _value,
      $Res Function(_$CancelBookingRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of CancelBookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reason = null,
  }) {
    return _then(_$CancelBookingRequestImpl(
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CancelBookingRequestImpl implements _CancelBookingRequest {
  const _$CancelBookingRequestImpl({required this.reason});

  factory _$CancelBookingRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CancelBookingRequestImplFromJson(json);

  @override
  final String reason;

  @override
  String toString() {
    return 'CancelBookingRequest(reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CancelBookingRequestImpl &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, reason);

  /// Create a copy of CancelBookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CancelBookingRequestImplCopyWith<_$CancelBookingRequestImpl>
      get copyWith =>
          __$$CancelBookingRequestImplCopyWithImpl<_$CancelBookingRequestImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CancelBookingRequestImplToJson(
      this,
    );
  }
}

abstract class _CancelBookingRequest implements CancelBookingRequest {
  const factory _CancelBookingRequest({required final String reason}) =
      _$CancelBookingRequestImpl;

  factory _CancelBookingRequest.fromJson(Map<String, dynamic> json) =
      _$CancelBookingRequestImpl.fromJson;

  @override
  String get reason;

  /// Create a copy of CancelBookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CancelBookingRequestImplCopyWith<_$CancelBookingRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
