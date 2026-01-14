// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ReviewModel _$ReviewModelFromJson(Map<String, dynamic> json) {
  return _ReviewModel.fromJson(json);
}

/// @nodoc
mixin _$ReviewModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'booking_id')
  String get bookingId => throw _privateConstructorUsedError;
  @JsonKey(name: 'reviewer_id')
  String get reviewerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'reviewed_user_id')
  String get reviewedUserId => throw _privateConstructorUsedError;
  @JsonKey(name: 'reviewer_type')
  ReviewerType get reviewerType => throw _privateConstructorUsedError;
  int get rating => throw _privateConstructorUsedError;
  String? get comment => throw _privateConstructorUsedError;
  @JsonKey(name: 'photo_urls')
  List<String> get photoUrls => throw _privateConstructorUsedError;
  String? get response => throw _privateConstructorUsedError;
  @JsonKey(name: 'response_at')
  DateTime? get responseAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_visible')
  bool get isVisible => throw _privateConstructorUsedError;
  @JsonKey(name: 'reports_count')
  int get reportsCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_approved')
  bool get isApproved => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ReviewModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReviewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReviewModelCopyWith<ReviewModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReviewModelCopyWith<$Res> {
  factory $ReviewModelCopyWith(
          ReviewModel value, $Res Function(ReviewModel) then) =
      _$ReviewModelCopyWithImpl<$Res, ReviewModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'booking_id') String bookingId,
      @JsonKey(name: 'reviewer_id') String reviewerId,
      @JsonKey(name: 'reviewed_user_id') String reviewedUserId,
      @JsonKey(name: 'reviewer_type') ReviewerType reviewerType,
      int rating,
      String? comment,
      @JsonKey(name: 'photo_urls') List<String> photoUrls,
      String? response,
      @JsonKey(name: 'response_at') DateTime? responseAt,
      @JsonKey(name: 'is_visible') bool isVisible,
      @JsonKey(name: 'reports_count') int reportsCount,
      @JsonKey(name: 'is_approved') bool isApproved,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class _$ReviewModelCopyWithImpl<$Res, $Val extends ReviewModel>
    implements $ReviewModelCopyWith<$Res> {
  _$ReviewModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReviewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bookingId = null,
    Object? reviewerId = null,
    Object? reviewedUserId = null,
    Object? reviewerType = null,
    Object? rating = null,
    Object? comment = freezed,
    Object? photoUrls = null,
    Object? response = freezed,
    Object? responseAt = freezed,
    Object? isVisible = null,
    Object? reportsCount = null,
    Object? isApproved = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      bookingId: null == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String,
      reviewerId: null == reviewerId
          ? _value.reviewerId
          : reviewerId // ignore: cast_nullable_to_non_nullable
              as String,
      reviewedUserId: null == reviewedUserId
          ? _value.reviewedUserId
          : reviewedUserId // ignore: cast_nullable_to_non_nullable
              as String,
      reviewerType: null == reviewerType
          ? _value.reviewerType
          : reviewerType // ignore: cast_nullable_to_non_nullable
              as ReviewerType,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as int,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrls: null == photoUrls
          ? _value.photoUrls
          : photoUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      response: freezed == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as String?,
      responseAt: freezed == responseAt
          ? _value.responseAt
          : responseAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isVisible: null == isVisible
          ? _value.isVisible
          : isVisible // ignore: cast_nullable_to_non_nullable
              as bool,
      reportsCount: null == reportsCount
          ? _value.reportsCount
          : reportsCount // ignore: cast_nullable_to_non_nullable
              as int,
      isApproved: null == isApproved
          ? _value.isApproved
          : isApproved // ignore: cast_nullable_to_non_nullable
              as bool,
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
abstract class _$$ReviewModelImplCopyWith<$Res>
    implements $ReviewModelCopyWith<$Res> {
  factory _$$ReviewModelImplCopyWith(
          _$ReviewModelImpl value, $Res Function(_$ReviewModelImpl) then) =
      __$$ReviewModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'booking_id') String bookingId,
      @JsonKey(name: 'reviewer_id') String reviewerId,
      @JsonKey(name: 'reviewed_user_id') String reviewedUserId,
      @JsonKey(name: 'reviewer_type') ReviewerType reviewerType,
      int rating,
      String? comment,
      @JsonKey(name: 'photo_urls') List<String> photoUrls,
      String? response,
      @JsonKey(name: 'response_at') DateTime? responseAt,
      @JsonKey(name: 'is_visible') bool isVisible,
      @JsonKey(name: 'reports_count') int reportsCount,
      @JsonKey(name: 'is_approved') bool isApproved,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class __$$ReviewModelImplCopyWithImpl<$Res>
    extends _$ReviewModelCopyWithImpl<$Res, _$ReviewModelImpl>
    implements _$$ReviewModelImplCopyWith<$Res> {
  __$$ReviewModelImplCopyWithImpl(
      _$ReviewModelImpl _value, $Res Function(_$ReviewModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReviewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bookingId = null,
    Object? reviewerId = null,
    Object? reviewedUserId = null,
    Object? reviewerType = null,
    Object? rating = null,
    Object? comment = freezed,
    Object? photoUrls = null,
    Object? response = freezed,
    Object? responseAt = freezed,
    Object? isVisible = null,
    Object? reportsCount = null,
    Object? isApproved = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$ReviewModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      bookingId: null == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String,
      reviewerId: null == reviewerId
          ? _value.reviewerId
          : reviewerId // ignore: cast_nullable_to_non_nullable
              as String,
      reviewedUserId: null == reviewedUserId
          ? _value.reviewedUserId
          : reviewedUserId // ignore: cast_nullable_to_non_nullable
              as String,
      reviewerType: null == reviewerType
          ? _value.reviewerType
          : reviewerType // ignore: cast_nullable_to_non_nullable
              as ReviewerType,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as int,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrls: null == photoUrls
          ? _value._photoUrls
          : photoUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      response: freezed == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as String?,
      responseAt: freezed == responseAt
          ? _value.responseAt
          : responseAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isVisible: null == isVisible
          ? _value.isVisible
          : isVisible // ignore: cast_nullable_to_non_nullable
              as bool,
      reportsCount: null == reportsCount
          ? _value.reportsCount
          : reportsCount // ignore: cast_nullable_to_non_nullable
              as int,
      isApproved: null == isApproved
          ? _value.isApproved
          : isApproved // ignore: cast_nullable_to_non_nullable
              as bool,
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
class _$ReviewModelImpl implements _ReviewModel {
  const _$ReviewModelImpl(
      {required this.id,
      @JsonKey(name: 'booking_id') required this.bookingId,
      @JsonKey(name: 'reviewer_id') required this.reviewerId,
      @JsonKey(name: 'reviewed_user_id') required this.reviewedUserId,
      @JsonKey(name: 'reviewer_type') required this.reviewerType,
      required this.rating,
      this.comment,
      @JsonKey(name: 'photo_urls') required final List<String> photoUrls,
      this.response,
      @JsonKey(name: 'response_at') this.responseAt,
      @JsonKey(name: 'is_visible') required this.isVisible,
      @JsonKey(name: 'reports_count') required this.reportsCount,
      @JsonKey(name: 'is_approved') required this.isApproved,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt})
      : _photoUrls = photoUrls;

  factory _$ReviewModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReviewModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'booking_id')
  final String bookingId;
  @override
  @JsonKey(name: 'reviewer_id')
  final String reviewerId;
  @override
  @JsonKey(name: 'reviewed_user_id')
  final String reviewedUserId;
  @override
  @JsonKey(name: 'reviewer_type')
  final ReviewerType reviewerType;
  @override
  final int rating;
  @override
  final String? comment;
  final List<String> _photoUrls;
  @override
  @JsonKey(name: 'photo_urls')
  List<String> get photoUrls {
    if (_photoUrls is EqualUnmodifiableListView) return _photoUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_photoUrls);
  }

  @override
  final String? response;
  @override
  @JsonKey(name: 'response_at')
  final DateTime? responseAt;
  @override
  @JsonKey(name: 'is_visible')
  final bool isVisible;
  @override
  @JsonKey(name: 'reports_count')
  final int reportsCount;
  @override
  @JsonKey(name: 'is_approved')
  final bool isApproved;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'ReviewModel(id: $id, bookingId: $bookingId, reviewerId: $reviewerId, reviewedUserId: $reviewedUserId, reviewerType: $reviewerType, rating: $rating, comment: $comment, photoUrls: $photoUrls, response: $response, responseAt: $responseAt, isVisible: $isVisible, reportsCount: $reportsCount, isApproved: $isApproved, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReviewModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.reviewerId, reviewerId) ||
                other.reviewerId == reviewerId) &&
            (identical(other.reviewedUserId, reviewedUserId) ||
                other.reviewedUserId == reviewedUserId) &&
            (identical(other.reviewerType, reviewerType) ||
                other.reviewerType == reviewerType) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            const DeepCollectionEquality()
                .equals(other._photoUrls, _photoUrls) &&
            (identical(other.response, response) ||
                other.response == response) &&
            (identical(other.responseAt, responseAt) ||
                other.responseAt == responseAt) &&
            (identical(other.isVisible, isVisible) ||
                other.isVisible == isVisible) &&
            (identical(other.reportsCount, reportsCount) ||
                other.reportsCount == reportsCount) &&
            (identical(other.isApproved, isApproved) ||
                other.isApproved == isApproved) &&
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
      bookingId,
      reviewerId,
      reviewedUserId,
      reviewerType,
      rating,
      comment,
      const DeepCollectionEquality().hash(_photoUrls),
      response,
      responseAt,
      isVisible,
      reportsCount,
      isApproved,
      createdAt,
      updatedAt);

  /// Create a copy of ReviewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReviewModelImplCopyWith<_$ReviewModelImpl> get copyWith =>
      __$$ReviewModelImplCopyWithImpl<_$ReviewModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReviewModelImplToJson(
      this,
    );
  }
}

abstract class _ReviewModel implements ReviewModel {
  const factory _ReviewModel(
      {required final String id,
      @JsonKey(name: 'booking_id') required final String bookingId,
      @JsonKey(name: 'reviewer_id') required final String reviewerId,
      @JsonKey(name: 'reviewed_user_id') required final String reviewedUserId,
      @JsonKey(name: 'reviewer_type') required final ReviewerType reviewerType,
      required final int rating,
      final String? comment,
      @JsonKey(name: 'photo_urls') required final List<String> photoUrls,
      final String? response,
      @JsonKey(name: 'response_at') final DateTime? responseAt,
      @JsonKey(name: 'is_visible') required final bool isVisible,
      @JsonKey(name: 'reports_count') required final int reportsCount,
      @JsonKey(name: 'is_approved') required final bool isApproved,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'updated_at')
      required final DateTime updatedAt}) = _$ReviewModelImpl;

  factory _ReviewModel.fromJson(Map<String, dynamic> json) =
      _$ReviewModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'booking_id')
  String get bookingId;
  @override
  @JsonKey(name: 'reviewer_id')
  String get reviewerId;
  @override
  @JsonKey(name: 'reviewed_user_id')
  String get reviewedUserId;
  @override
  @JsonKey(name: 'reviewer_type')
  ReviewerType get reviewerType;
  @override
  int get rating;
  @override
  String? get comment;
  @override
  @JsonKey(name: 'photo_urls')
  List<String> get photoUrls;
  @override
  String? get response;
  @override
  @JsonKey(name: 'response_at')
  DateTime? get responseAt;
  @override
  @JsonKey(name: 'is_visible')
  bool get isVisible;
  @override
  @JsonKey(name: 'reports_count')
  int get reportsCount;
  @override
  @JsonKey(name: 'is_approved')
  bool get isApproved;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of ReviewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReviewModelImplCopyWith<_$ReviewModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateReviewRequest _$CreateReviewRequestFromJson(Map<String, dynamic> json) {
  return _CreateReviewRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateReviewRequest {
  @JsonKey(name: 'booking_id')
  String get bookingId => throw _privateConstructorUsedError;
  int get rating => throw _privateConstructorUsedError;
  String? get comment => throw _privateConstructorUsedError;
  @JsonKey(name: 'photo_urls')
  List<String>? get photoUrls => throw _privateConstructorUsedError;

  /// Serializes this CreateReviewRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateReviewRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateReviewRequestCopyWith<CreateReviewRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateReviewRequestCopyWith<$Res> {
  factory $CreateReviewRequestCopyWith(
          CreateReviewRequest value, $Res Function(CreateReviewRequest) then) =
      _$CreateReviewRequestCopyWithImpl<$Res, CreateReviewRequest>;
  @useResult
  $Res call(
      {@JsonKey(name: 'booking_id') String bookingId,
      int rating,
      String? comment,
      @JsonKey(name: 'photo_urls') List<String>? photoUrls});
}

/// @nodoc
class _$CreateReviewRequestCopyWithImpl<$Res, $Val extends CreateReviewRequest>
    implements $CreateReviewRequestCopyWith<$Res> {
  _$CreateReviewRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateReviewRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookingId = null,
    Object? rating = null,
    Object? comment = freezed,
    Object? photoUrls = freezed,
  }) {
    return _then(_value.copyWith(
      bookingId: null == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as int,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrls: freezed == photoUrls
          ? _value.photoUrls
          : photoUrls // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateReviewRequestImplCopyWith<$Res>
    implements $CreateReviewRequestCopyWith<$Res> {
  factory _$$CreateReviewRequestImplCopyWith(_$CreateReviewRequestImpl value,
          $Res Function(_$CreateReviewRequestImpl) then) =
      __$$CreateReviewRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'booking_id') String bookingId,
      int rating,
      String? comment,
      @JsonKey(name: 'photo_urls') List<String>? photoUrls});
}

/// @nodoc
class __$$CreateReviewRequestImplCopyWithImpl<$Res>
    extends _$CreateReviewRequestCopyWithImpl<$Res, _$CreateReviewRequestImpl>
    implements _$$CreateReviewRequestImplCopyWith<$Res> {
  __$$CreateReviewRequestImplCopyWithImpl(_$CreateReviewRequestImpl _value,
      $Res Function(_$CreateReviewRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateReviewRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookingId = null,
    Object? rating = null,
    Object? comment = freezed,
    Object? photoUrls = freezed,
  }) {
    return _then(_$CreateReviewRequestImpl(
      bookingId: null == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as int,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrls: freezed == photoUrls
          ? _value._photoUrls
          : photoUrls // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateReviewRequestImpl implements _CreateReviewRequest {
  const _$CreateReviewRequestImpl(
      {@JsonKey(name: 'booking_id') required this.bookingId,
      required this.rating,
      this.comment,
      @JsonKey(name: 'photo_urls') final List<String>? photoUrls})
      : _photoUrls = photoUrls;

  factory _$CreateReviewRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateReviewRequestImplFromJson(json);

  @override
  @JsonKey(name: 'booking_id')
  final String bookingId;
  @override
  final int rating;
  @override
  final String? comment;
  final List<String>? _photoUrls;
  @override
  @JsonKey(name: 'photo_urls')
  List<String>? get photoUrls {
    final value = _photoUrls;
    if (value == null) return null;
    if (_photoUrls is EqualUnmodifiableListView) return _photoUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'CreateReviewRequest(bookingId: $bookingId, rating: $rating, comment: $comment, photoUrls: $photoUrls)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateReviewRequestImpl &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            const DeepCollectionEquality()
                .equals(other._photoUrls, _photoUrls));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, bookingId, rating, comment,
      const DeepCollectionEquality().hash(_photoUrls));

  /// Create a copy of CreateReviewRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateReviewRequestImplCopyWith<_$CreateReviewRequestImpl> get copyWith =>
      __$$CreateReviewRequestImplCopyWithImpl<_$CreateReviewRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateReviewRequestImplToJson(
      this,
    );
  }
}

abstract class _CreateReviewRequest implements CreateReviewRequest {
  const factory _CreateReviewRequest(
          {@JsonKey(name: 'booking_id') required final String bookingId,
          required final int rating,
          final String? comment,
          @JsonKey(name: 'photo_urls') final List<String>? photoUrls}) =
      _$CreateReviewRequestImpl;

  factory _CreateReviewRequest.fromJson(Map<String, dynamic> json) =
      _$CreateReviewRequestImpl.fromJson;

  @override
  @JsonKey(name: 'booking_id')
  String get bookingId;
  @override
  int get rating;
  @override
  String? get comment;
  @override
  @JsonKey(name: 'photo_urls')
  List<String>? get photoUrls;

  /// Create a copy of CreateReviewRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateReviewRequestImplCopyWith<_$CreateReviewRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UpdateReviewRequest _$UpdateReviewRequestFromJson(Map<String, dynamic> json) {
  return _UpdateReviewRequest.fromJson(json);
}

/// @nodoc
mixin _$UpdateReviewRequest {
  int? get rating => throw _privateConstructorUsedError;
  String? get comment => throw _privateConstructorUsedError;

  /// Serializes this UpdateReviewRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateReviewRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateReviewRequestCopyWith<UpdateReviewRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateReviewRequestCopyWith<$Res> {
  factory $UpdateReviewRequestCopyWith(
          UpdateReviewRequest value, $Res Function(UpdateReviewRequest) then) =
      _$UpdateReviewRequestCopyWithImpl<$Res, UpdateReviewRequest>;
  @useResult
  $Res call({int? rating, String? comment});
}

/// @nodoc
class _$UpdateReviewRequestCopyWithImpl<$Res, $Val extends UpdateReviewRequest>
    implements $UpdateReviewRequestCopyWith<$Res> {
  _$UpdateReviewRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateReviewRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rating = freezed,
    Object? comment = freezed,
  }) {
    return _then(_value.copyWith(
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as int?,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateReviewRequestImplCopyWith<$Res>
    implements $UpdateReviewRequestCopyWith<$Res> {
  factory _$$UpdateReviewRequestImplCopyWith(_$UpdateReviewRequestImpl value,
          $Res Function(_$UpdateReviewRequestImpl) then) =
      __$$UpdateReviewRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? rating, String? comment});
}

/// @nodoc
class __$$UpdateReviewRequestImplCopyWithImpl<$Res>
    extends _$UpdateReviewRequestCopyWithImpl<$Res, _$UpdateReviewRequestImpl>
    implements _$$UpdateReviewRequestImplCopyWith<$Res> {
  __$$UpdateReviewRequestImplCopyWithImpl(_$UpdateReviewRequestImpl _value,
      $Res Function(_$UpdateReviewRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateReviewRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rating = freezed,
    Object? comment = freezed,
  }) {
    return _then(_$UpdateReviewRequestImpl(
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as int?,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateReviewRequestImpl implements _UpdateReviewRequest {
  const _$UpdateReviewRequestImpl({this.rating, this.comment});

  factory _$UpdateReviewRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateReviewRequestImplFromJson(json);

  @override
  final int? rating;
  @override
  final String? comment;

  @override
  String toString() {
    return 'UpdateReviewRequest(rating: $rating, comment: $comment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateReviewRequestImpl &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.comment, comment) || other.comment == comment));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, rating, comment);

  /// Create a copy of UpdateReviewRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateReviewRequestImplCopyWith<_$UpdateReviewRequestImpl> get copyWith =>
      __$$UpdateReviewRequestImplCopyWithImpl<_$UpdateReviewRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateReviewRequestImplToJson(
      this,
    );
  }
}

abstract class _UpdateReviewRequest implements UpdateReviewRequest {
  const factory _UpdateReviewRequest(
      {final int? rating, final String? comment}) = _$UpdateReviewRequestImpl;

  factory _UpdateReviewRequest.fromJson(Map<String, dynamic> json) =
      _$UpdateReviewRequestImpl.fromJson;

  @override
  int? get rating;
  @override
  String? get comment;

  /// Create a copy of UpdateReviewRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateReviewRequestImplCopyWith<_$UpdateReviewRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReviewResponseRequest _$ReviewResponseRequestFromJson(
    Map<String, dynamic> json) {
  return _ReviewResponseRequest.fromJson(json);
}

/// @nodoc
mixin _$ReviewResponseRequest {
  String get response => throw _privateConstructorUsedError;

  /// Serializes this ReviewResponseRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReviewResponseRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReviewResponseRequestCopyWith<ReviewResponseRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReviewResponseRequestCopyWith<$Res> {
  factory $ReviewResponseRequestCopyWith(ReviewResponseRequest value,
          $Res Function(ReviewResponseRequest) then) =
      _$ReviewResponseRequestCopyWithImpl<$Res, ReviewResponseRequest>;
  @useResult
  $Res call({String response});
}

/// @nodoc
class _$ReviewResponseRequestCopyWithImpl<$Res,
        $Val extends ReviewResponseRequest>
    implements $ReviewResponseRequestCopyWith<$Res> {
  _$ReviewResponseRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReviewResponseRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? response = null,
  }) {
    return _then(_value.copyWith(
      response: null == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReviewResponseRequestImplCopyWith<$Res>
    implements $ReviewResponseRequestCopyWith<$Res> {
  factory _$$ReviewResponseRequestImplCopyWith(
          _$ReviewResponseRequestImpl value,
          $Res Function(_$ReviewResponseRequestImpl) then) =
      __$$ReviewResponseRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String response});
}

/// @nodoc
class __$$ReviewResponseRequestImplCopyWithImpl<$Res>
    extends _$ReviewResponseRequestCopyWithImpl<$Res,
        _$ReviewResponseRequestImpl>
    implements _$$ReviewResponseRequestImplCopyWith<$Res> {
  __$$ReviewResponseRequestImplCopyWithImpl(_$ReviewResponseRequestImpl _value,
      $Res Function(_$ReviewResponseRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReviewResponseRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? response = null,
  }) {
    return _then(_$ReviewResponseRequestImpl(
      response: null == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReviewResponseRequestImpl implements _ReviewResponseRequest {
  const _$ReviewResponseRequestImpl({required this.response});

  factory _$ReviewResponseRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReviewResponseRequestImplFromJson(json);

  @override
  final String response;

  @override
  String toString() {
    return 'ReviewResponseRequest(response: $response)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReviewResponseRequestImpl &&
            (identical(other.response, response) ||
                other.response == response));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, response);

  /// Create a copy of ReviewResponseRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReviewResponseRequestImplCopyWith<_$ReviewResponseRequestImpl>
      get copyWith => __$$ReviewResponseRequestImplCopyWithImpl<
          _$ReviewResponseRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReviewResponseRequestImplToJson(
      this,
    );
  }
}

abstract class _ReviewResponseRequest implements ReviewResponseRequest {
  const factory _ReviewResponseRequest({required final String response}) =
      _$ReviewResponseRequestImpl;

  factory _ReviewResponseRequest.fromJson(Map<String, dynamic> json) =
      _$ReviewResponseRequestImpl.fromJson;

  @override
  String get response;

  /// Create a copy of ReviewResponseRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReviewResponseRequestImplCopyWith<_$ReviewResponseRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
