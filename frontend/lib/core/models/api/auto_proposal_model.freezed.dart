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

MatchReasons _$MatchReasonsFromJson(Map<String, dynamic> json) {
  return _MatchReasons.fromJson(json);
}

/// @nodoc
mixin _$MatchReasons {
  @JsonKey(name: 'location_score')
  double? get locationScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'rating_score')
  double? get ratingScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'price_score')
  double? get priceScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'availability_score')
  double? get availabilityScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'history_score')
  double? get historyScore => throw _privateConstructorUsedError;
  List<String> get reasons => throw _privateConstructorUsedError;

  /// Serializes this MatchReasons to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MatchReasons
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MatchReasonsCopyWith<MatchReasons> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MatchReasonsCopyWith<$Res> {
  factory $MatchReasonsCopyWith(
          MatchReasons value, $Res Function(MatchReasons) then) =
      _$MatchReasonsCopyWithImpl<$Res, MatchReasons>;
  @useResult
  $Res call(
      {@JsonKey(name: 'location_score') double? locationScore,
      @JsonKey(name: 'rating_score') double? ratingScore,
      @JsonKey(name: 'price_score') double? priceScore,
      @JsonKey(name: 'availability_score') double? availabilityScore,
      @JsonKey(name: 'history_score') double? historyScore,
      List<String> reasons});
}

/// @nodoc
class _$MatchReasonsCopyWithImpl<$Res, $Val extends MatchReasons>
    implements $MatchReasonsCopyWith<$Res> {
  _$MatchReasonsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MatchReasons
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? locationScore = freezed,
    Object? ratingScore = freezed,
    Object? priceScore = freezed,
    Object? availabilityScore = freezed,
    Object? historyScore = freezed,
    Object? reasons = null,
  }) {
    return _then(_value.copyWith(
      locationScore: freezed == locationScore
          ? _value.locationScore
          : locationScore // ignore: cast_nullable_to_non_nullable
              as double?,
      ratingScore: freezed == ratingScore
          ? _value.ratingScore
          : ratingScore // ignore: cast_nullable_to_non_nullable
              as double?,
      priceScore: freezed == priceScore
          ? _value.priceScore
          : priceScore // ignore: cast_nullable_to_non_nullable
              as double?,
      availabilityScore: freezed == availabilityScore
          ? _value.availabilityScore
          : availabilityScore // ignore: cast_nullable_to_non_nullable
              as double?,
      historyScore: freezed == historyScore
          ? _value.historyScore
          : historyScore // ignore: cast_nullable_to_non_nullable
              as double?,
      reasons: null == reasons
          ? _value.reasons
          : reasons // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MatchReasonsImplCopyWith<$Res>
    implements $MatchReasonsCopyWith<$Res> {
  factory _$$MatchReasonsImplCopyWith(
          _$MatchReasonsImpl value, $Res Function(_$MatchReasonsImpl) then) =
      __$$MatchReasonsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'location_score') double? locationScore,
      @JsonKey(name: 'rating_score') double? ratingScore,
      @JsonKey(name: 'price_score') double? priceScore,
      @JsonKey(name: 'availability_score') double? availabilityScore,
      @JsonKey(name: 'history_score') double? historyScore,
      List<String> reasons});
}

/// @nodoc
class __$$MatchReasonsImplCopyWithImpl<$Res>
    extends _$MatchReasonsCopyWithImpl<$Res, _$MatchReasonsImpl>
    implements _$$MatchReasonsImplCopyWith<$Res> {
  __$$MatchReasonsImplCopyWithImpl(
      _$MatchReasonsImpl _value, $Res Function(_$MatchReasonsImpl) _then)
      : super(_value, _then);

  /// Create a copy of MatchReasons
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? locationScore = freezed,
    Object? ratingScore = freezed,
    Object? priceScore = freezed,
    Object? availabilityScore = freezed,
    Object? historyScore = freezed,
    Object? reasons = null,
  }) {
    return _then(_$MatchReasonsImpl(
      locationScore: freezed == locationScore
          ? _value.locationScore
          : locationScore // ignore: cast_nullable_to_non_nullable
              as double?,
      ratingScore: freezed == ratingScore
          ? _value.ratingScore
          : ratingScore // ignore: cast_nullable_to_non_nullable
              as double?,
      priceScore: freezed == priceScore
          ? _value.priceScore
          : priceScore // ignore: cast_nullable_to_non_nullable
              as double?,
      availabilityScore: freezed == availabilityScore
          ? _value.availabilityScore
          : availabilityScore // ignore: cast_nullable_to_non_nullable
              as double?,
      historyScore: freezed == historyScore
          ? _value.historyScore
          : historyScore // ignore: cast_nullable_to_non_nullable
              as double?,
      reasons: null == reasons
          ? _value._reasons
          : reasons // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MatchReasonsImpl implements _MatchReasons {
  const _$MatchReasonsImpl(
      {@JsonKey(name: 'location_score') this.locationScore,
      @JsonKey(name: 'rating_score') this.ratingScore,
      @JsonKey(name: 'price_score') this.priceScore,
      @JsonKey(name: 'availability_score') this.availabilityScore,
      @JsonKey(name: 'history_score') this.historyScore,
      final List<String> reasons = const []})
      : _reasons = reasons;

  factory _$MatchReasonsImpl.fromJson(Map<String, dynamic> json) =>
      _$$MatchReasonsImplFromJson(json);

  @override
  @JsonKey(name: 'location_score')
  final double? locationScore;
  @override
  @JsonKey(name: 'rating_score')
  final double? ratingScore;
  @override
  @JsonKey(name: 'price_score')
  final double? priceScore;
  @override
  @JsonKey(name: 'availability_score')
  final double? availabilityScore;
  @override
  @JsonKey(name: 'history_score')
  final double? historyScore;
  final List<String> _reasons;
  @override
  @JsonKey()
  List<String> get reasons {
    if (_reasons is EqualUnmodifiableListView) return _reasons;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reasons);
  }

  @override
  String toString() {
    return 'MatchReasons(locationScore: $locationScore, ratingScore: $ratingScore, priceScore: $priceScore, availabilityScore: $availabilityScore, historyScore: $historyScore, reasons: $reasons)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MatchReasonsImpl &&
            (identical(other.locationScore, locationScore) ||
                other.locationScore == locationScore) &&
            (identical(other.ratingScore, ratingScore) ||
                other.ratingScore == ratingScore) &&
            (identical(other.priceScore, priceScore) ||
                other.priceScore == priceScore) &&
            (identical(other.availabilityScore, availabilityScore) ||
                other.availabilityScore == availabilityScore) &&
            (identical(other.historyScore, historyScore) ||
                other.historyScore == historyScore) &&
            const DeepCollectionEquality().equals(other._reasons, _reasons));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      locationScore,
      ratingScore,
      priceScore,
      availabilityScore,
      historyScore,
      const DeepCollectionEquality().hash(_reasons));

  /// Create a copy of MatchReasons
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MatchReasonsImplCopyWith<_$MatchReasonsImpl> get copyWith =>
      __$$MatchReasonsImplCopyWithImpl<_$MatchReasonsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MatchReasonsImplToJson(
      this,
    );
  }
}

abstract class _MatchReasons implements MatchReasons {
  const factory _MatchReasons(
      {@JsonKey(name: 'location_score') final double? locationScore,
      @JsonKey(name: 'rating_score') final double? ratingScore,
      @JsonKey(name: 'price_score') final double? priceScore,
      @JsonKey(name: 'availability_score') final double? availabilityScore,
      @JsonKey(name: 'history_score') final double? historyScore,
      final List<String> reasons}) = _$MatchReasonsImpl;

  factory _MatchReasons.fromJson(Map<String, dynamic> json) =
      _$MatchReasonsImpl.fromJson;

  @override
  @JsonKey(name: 'location_score')
  double? get locationScore;
  @override
  @JsonKey(name: 'rating_score')
  double? get ratingScore;
  @override
  @JsonKey(name: 'price_score')
  double? get priceScore;
  @override
  @JsonKey(name: 'availability_score')
  double? get availabilityScore;
  @override
  @JsonKey(name: 'history_score')
  double? get historyScore;
  @override
  List<String> get reasons;

  /// Create a copy of MatchReasons
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MatchReasonsImplCopyWith<_$MatchReasonsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProposalMaster _$ProposalMasterFromJson(Map<String, dynamic> json) {
  return _ProposalMaster.fromJson(json);
}

/// @nodoc
mixin _$ProposalMaster {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'first_name')
  String get firstName => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_name')
  String get lastName => throw _privateConstructorUsedError;
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl => throw _privateConstructorUsedError;
  double? get rating => throw _privateConstructorUsedError;

  /// Serializes this ProposalMaster to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProposalMaster
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProposalMasterCopyWith<ProposalMaster> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProposalMasterCopyWith<$Res> {
  factory $ProposalMasterCopyWith(
          ProposalMaster value, $Res Function(ProposalMaster) then) =
      _$ProposalMasterCopyWithImpl<$Res, ProposalMaster>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'first_name') String firstName,
      @JsonKey(name: 'last_name') String lastName,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      double? rating});
}

/// @nodoc
class _$ProposalMasterCopyWithImpl<$Res, $Val extends ProposalMaster>
    implements $ProposalMasterCopyWith<$Res> {
  _$ProposalMasterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProposalMaster
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? avatarUrl = freezed,
    Object? rating = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
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
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProposalMasterImplCopyWith<$Res>
    implements $ProposalMasterCopyWith<$Res> {
  factory _$$ProposalMasterImplCopyWith(_$ProposalMasterImpl value,
          $Res Function(_$ProposalMasterImpl) then) =
      __$$ProposalMasterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'first_name') String firstName,
      @JsonKey(name: 'last_name') String lastName,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      double? rating});
}

/// @nodoc
class __$$ProposalMasterImplCopyWithImpl<$Res>
    extends _$ProposalMasterCopyWithImpl<$Res, _$ProposalMasterImpl>
    implements _$$ProposalMasterImplCopyWith<$Res> {
  __$$ProposalMasterImplCopyWithImpl(
      _$ProposalMasterImpl _value, $Res Function(_$ProposalMasterImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProposalMaster
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? avatarUrl = freezed,
    Object? rating = freezed,
  }) {
    return _then(_$ProposalMasterImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
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
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProposalMasterImpl implements _ProposalMaster {
  const _$ProposalMasterImpl(
      {required this.id,
      @JsonKey(name: 'first_name') required this.firstName,
      @JsonKey(name: 'last_name') required this.lastName,
      @JsonKey(name: 'avatar_url') this.avatarUrl,
      this.rating});

  factory _$ProposalMasterImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProposalMasterImplFromJson(json);

  @override
  final String id;
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
  final double? rating;

  @override
  String toString() {
    return 'ProposalMaster(id: $id, firstName: $firstName, lastName: $lastName, avatarUrl: $avatarUrl, rating: $rating)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProposalMasterImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.rating, rating) || other.rating == rating));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, firstName, lastName, avatarUrl, rating);

  /// Create a copy of ProposalMaster
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProposalMasterImplCopyWith<_$ProposalMasterImpl> get copyWith =>
      __$$ProposalMasterImplCopyWithImpl<_$ProposalMasterImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProposalMasterImplToJson(
      this,
    );
  }
}

abstract class _ProposalMaster implements ProposalMaster {
  const factory _ProposalMaster(
      {required final String id,
      @JsonKey(name: 'first_name') required final String firstName,
      @JsonKey(name: 'last_name') required final String lastName,
      @JsonKey(name: 'avatar_url') final String? avatarUrl,
      final double? rating}) = _$ProposalMasterImpl;

  factory _ProposalMaster.fromJson(Map<String, dynamic> json) =
      _$ProposalMasterImpl.fromJson;

  @override
  String get id;
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
  double? get rating;

  /// Create a copy of ProposalMaster
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProposalMasterImplCopyWith<_$ProposalMasterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProposalService _$ProposalServiceFromJson(Map<String, dynamic> json) {
  return _ProposalService.fromJson(json);
}

/// @nodoc
mixin _$ProposalService {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  @JsonKey(name: 'duration_minutes')
  int get durationMinutes => throw _privateConstructorUsedError;

  /// Serializes this ProposalService to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProposalService
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProposalServiceCopyWith<ProposalService> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProposalServiceCopyWith<$Res> {
  factory $ProposalServiceCopyWith(
          ProposalService value, $Res Function(ProposalService) then) =
      _$ProposalServiceCopyWithImpl<$Res, ProposalService>;
  @useResult
  $Res call(
      {String id,
      String title,
      double price,
      @JsonKey(name: 'duration_minutes') int durationMinutes});
}

/// @nodoc
class _$ProposalServiceCopyWithImpl<$Res, $Val extends ProposalService>
    implements $ProposalServiceCopyWith<$Res> {
  _$ProposalServiceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProposalService
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? price = null,
    Object? durationMinutes = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      durationMinutes: null == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProposalServiceImplCopyWith<$Res>
    implements $ProposalServiceCopyWith<$Res> {
  factory _$$ProposalServiceImplCopyWith(_$ProposalServiceImpl value,
          $Res Function(_$ProposalServiceImpl) then) =
      __$$ProposalServiceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      double price,
      @JsonKey(name: 'duration_minutes') int durationMinutes});
}

/// @nodoc
class __$$ProposalServiceImplCopyWithImpl<$Res>
    extends _$ProposalServiceCopyWithImpl<$Res, _$ProposalServiceImpl>
    implements _$$ProposalServiceImplCopyWith<$Res> {
  __$$ProposalServiceImplCopyWithImpl(
      _$ProposalServiceImpl _value, $Res Function(_$ProposalServiceImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProposalService
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? price = null,
    Object? durationMinutes = null,
  }) {
    return _then(_$ProposalServiceImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      durationMinutes: null == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProposalServiceImpl implements _ProposalService {
  const _$ProposalServiceImpl(
      {required this.id,
      required this.title,
      required this.price,
      @JsonKey(name: 'duration_minutes') required this.durationMinutes});

  factory _$ProposalServiceImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProposalServiceImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final double price;
  @override
  @JsonKey(name: 'duration_minutes')
  final int durationMinutes;

  @override
  String toString() {
    return 'ProposalService(id: $id, title: $title, price: $price, durationMinutes: $durationMinutes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProposalServiceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, title, price, durationMinutes);

  /// Create a copy of ProposalService
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProposalServiceImplCopyWith<_$ProposalServiceImpl> get copyWith =>
      __$$ProposalServiceImplCopyWithImpl<_$ProposalServiceImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProposalServiceImplToJson(
      this,
    );
  }
}

abstract class _ProposalService implements ProposalService {
  const factory _ProposalService(
      {required final String id,
      required final String title,
      required final double price,
      @JsonKey(name: 'duration_minutes')
      required final int durationMinutes}) = _$ProposalServiceImpl;

  factory _ProposalService.fromJson(Map<String, dynamic> json) =
      _$ProposalServiceImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  double get price;
  @override
  @JsonKey(name: 'duration_minutes')
  int get durationMinutes;

  /// Create a copy of ProposalService
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProposalServiceImplCopyWith<_$ProposalServiceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AutoProposalModel _$AutoProposalModelFromJson(Map<String, dynamic> json) {
  return _AutoProposalModel.fromJson(json);
}

/// @nodoc
mixin _$AutoProposalModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'master_id')
  String get masterId => throw _privateConstructorUsedError;
  @JsonKey(name: 'service_id')
  String get serviceId => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_id')
  String get categoryId => throw _privateConstructorUsedError;
  ProposalStatus get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'match_score')
  int get matchScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'match_reasons')
  MatchReasons get matchReasons => throw _privateConstructorUsedError;
  @JsonKey(name: 'proposed_datetime')
  DateTime? get proposedDatetime => throw _privateConstructorUsedError;
  @JsonKey(name: 'expires_at')
  DateTime get expiresAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'booking_id')
  String? get bookingId => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  ProposalMaster? get master => throw _privateConstructorUsedError;
  ProposalService? get service => throw _privateConstructorUsedError;

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
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'master_id') String masterId,
      @JsonKey(name: 'service_id') String serviceId,
      @JsonKey(name: 'category_id') String categoryId,
      ProposalStatus status,
      @JsonKey(name: 'match_score') int matchScore,
      @JsonKey(name: 'match_reasons') MatchReasons matchReasons,
      @JsonKey(name: 'proposed_datetime') DateTime? proposedDatetime,
      @JsonKey(name: 'expires_at') DateTime expiresAt,
      @JsonKey(name: 'booking_id') String? bookingId,
      @JsonKey(name: 'created_at') DateTime createdAt,
      ProposalMaster? master,
      ProposalService? service});

  $MatchReasonsCopyWith<$Res> get matchReasons;
  $ProposalMasterCopyWith<$Res>? get master;
  $ProposalServiceCopyWith<$Res>? get service;
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
    Object? userId = null,
    Object? masterId = null,
    Object? serviceId = null,
    Object? categoryId = null,
    Object? status = null,
    Object? matchScore = null,
    Object? matchReasons = null,
    Object? proposedDatetime = freezed,
    Object? expiresAt = null,
    Object? bookingId = freezed,
    Object? createdAt = null,
    Object? master = freezed,
    Object? service = freezed,
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
      masterId: null == masterId
          ? _value.masterId
          : masterId // ignore: cast_nullable_to_non_nullable
              as String,
      serviceId: null == serviceId
          ? _value.serviceId
          : serviceId // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ProposalStatus,
      matchScore: null == matchScore
          ? _value.matchScore
          : matchScore // ignore: cast_nullable_to_non_nullable
              as int,
      matchReasons: null == matchReasons
          ? _value.matchReasons
          : matchReasons // ignore: cast_nullable_to_non_nullable
              as MatchReasons,
      proposedDatetime: freezed == proposedDatetime
          ? _value.proposedDatetime
          : proposedDatetime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiresAt: null == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      bookingId: freezed == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      master: freezed == master
          ? _value.master
          : master // ignore: cast_nullable_to_non_nullable
              as ProposalMaster?,
      service: freezed == service
          ? _value.service
          : service // ignore: cast_nullable_to_non_nullable
              as ProposalService?,
    ) as $Val);
  }

  /// Create a copy of AutoProposalModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MatchReasonsCopyWith<$Res> get matchReasons {
    return $MatchReasonsCopyWith<$Res>(_value.matchReasons, (value) {
      return _then(_value.copyWith(matchReasons: value) as $Val);
    });
  }

  /// Create a copy of AutoProposalModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProposalMasterCopyWith<$Res>? get master {
    if (_value.master == null) {
      return null;
    }

    return $ProposalMasterCopyWith<$Res>(_value.master!, (value) {
      return _then(_value.copyWith(master: value) as $Val);
    });
  }

  /// Create a copy of AutoProposalModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProposalServiceCopyWith<$Res>? get service {
    if (_value.service == null) {
      return null;
    }

    return $ProposalServiceCopyWith<$Res>(_value.service!, (value) {
      return _then(_value.copyWith(service: value) as $Val);
    });
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
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'master_id') String masterId,
      @JsonKey(name: 'service_id') String serviceId,
      @JsonKey(name: 'category_id') String categoryId,
      ProposalStatus status,
      @JsonKey(name: 'match_score') int matchScore,
      @JsonKey(name: 'match_reasons') MatchReasons matchReasons,
      @JsonKey(name: 'proposed_datetime') DateTime? proposedDatetime,
      @JsonKey(name: 'expires_at') DateTime expiresAt,
      @JsonKey(name: 'booking_id') String? bookingId,
      @JsonKey(name: 'created_at') DateTime createdAt,
      ProposalMaster? master,
      ProposalService? service});

  @override
  $MatchReasonsCopyWith<$Res> get matchReasons;
  @override
  $ProposalMasterCopyWith<$Res>? get master;
  @override
  $ProposalServiceCopyWith<$Res>? get service;
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
    Object? userId = null,
    Object? masterId = null,
    Object? serviceId = null,
    Object? categoryId = null,
    Object? status = null,
    Object? matchScore = null,
    Object? matchReasons = null,
    Object? proposedDatetime = freezed,
    Object? expiresAt = null,
    Object? bookingId = freezed,
    Object? createdAt = null,
    Object? master = freezed,
    Object? service = freezed,
  }) {
    return _then(_$AutoProposalModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      masterId: null == masterId
          ? _value.masterId
          : masterId // ignore: cast_nullable_to_non_nullable
              as String,
      serviceId: null == serviceId
          ? _value.serviceId
          : serviceId // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ProposalStatus,
      matchScore: null == matchScore
          ? _value.matchScore
          : matchScore // ignore: cast_nullable_to_non_nullable
              as int,
      matchReasons: null == matchReasons
          ? _value.matchReasons
          : matchReasons // ignore: cast_nullable_to_non_nullable
              as MatchReasons,
      proposedDatetime: freezed == proposedDatetime
          ? _value.proposedDatetime
          : proposedDatetime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiresAt: null == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      bookingId: freezed == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      master: freezed == master
          ? _value.master
          : master // ignore: cast_nullable_to_non_nullable
              as ProposalMaster?,
      service: freezed == service
          ? _value.service
          : service // ignore: cast_nullable_to_non_nullable
              as ProposalService?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AutoProposalModelImpl implements _AutoProposalModel {
  const _$AutoProposalModelImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'master_id') required this.masterId,
      @JsonKey(name: 'service_id') required this.serviceId,
      @JsonKey(name: 'category_id') required this.categoryId,
      required this.status,
      @JsonKey(name: 'match_score') this.matchScore = 0,
      @JsonKey(name: 'match_reasons') required this.matchReasons,
      @JsonKey(name: 'proposed_datetime') this.proposedDatetime,
      @JsonKey(name: 'expires_at') required this.expiresAt,
      @JsonKey(name: 'booking_id') this.bookingId,
      @JsonKey(name: 'created_at') required this.createdAt,
      this.master,
      this.service});

  factory _$AutoProposalModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AutoProposalModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'master_id')
  final String masterId;
  @override
  @JsonKey(name: 'service_id')
  final String serviceId;
  @override
  @JsonKey(name: 'category_id')
  final String categoryId;
  @override
  final ProposalStatus status;
  @override
  @JsonKey(name: 'match_score')
  final int matchScore;
  @override
  @JsonKey(name: 'match_reasons')
  final MatchReasons matchReasons;
  @override
  @JsonKey(name: 'proposed_datetime')
  final DateTime? proposedDatetime;
  @override
  @JsonKey(name: 'expires_at')
  final DateTime expiresAt;
  @override
  @JsonKey(name: 'booking_id')
  final String? bookingId;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  final ProposalMaster? master;
  @override
  final ProposalService? service;

  @override
  String toString() {
    return 'AutoProposalModel(id: $id, userId: $userId, masterId: $masterId, serviceId: $serviceId, categoryId: $categoryId, status: $status, matchScore: $matchScore, matchReasons: $matchReasons, proposedDatetime: $proposedDatetime, expiresAt: $expiresAt, bookingId: $bookingId, createdAt: $createdAt, master: $master, service: $service)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AutoProposalModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.masterId, masterId) ||
                other.masterId == masterId) &&
            (identical(other.serviceId, serviceId) ||
                other.serviceId == serviceId) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.matchScore, matchScore) ||
                other.matchScore == matchScore) &&
            (identical(other.matchReasons, matchReasons) ||
                other.matchReasons == matchReasons) &&
            (identical(other.proposedDatetime, proposedDatetime) ||
                other.proposedDatetime == proposedDatetime) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.master, master) || other.master == master) &&
            (identical(other.service, service) || other.service == service));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      masterId,
      serviceId,
      categoryId,
      status,
      matchScore,
      matchReasons,
      proposedDatetime,
      expiresAt,
      bookingId,
      createdAt,
      master,
      service);

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
      @JsonKey(name: 'user_id') required final String userId,
      @JsonKey(name: 'master_id') required final String masterId,
      @JsonKey(name: 'service_id') required final String serviceId,
      @JsonKey(name: 'category_id') required final String categoryId,
      required final ProposalStatus status,
      @JsonKey(name: 'match_score') final int matchScore,
      @JsonKey(name: 'match_reasons') required final MatchReasons matchReasons,
      @JsonKey(name: 'proposed_datetime') final DateTime? proposedDatetime,
      @JsonKey(name: 'expires_at') required final DateTime expiresAt,
      @JsonKey(name: 'booking_id') final String? bookingId,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      final ProposalMaster? master,
      final ProposalService? service}) = _$AutoProposalModelImpl;

  factory _AutoProposalModel.fromJson(Map<String, dynamic> json) =
      _$AutoProposalModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'master_id')
  String get masterId;
  @override
  @JsonKey(name: 'service_id')
  String get serviceId;
  @override
  @JsonKey(name: 'category_id')
  String get categoryId;
  @override
  ProposalStatus get status;
  @override
  @JsonKey(name: 'match_score')
  int get matchScore;
  @override
  @JsonKey(name: 'match_reasons')
  MatchReasons get matchReasons;
  @override
  @JsonKey(name: 'proposed_datetime')
  DateTime? get proposedDatetime;
  @override
  @JsonKey(name: 'expires_at')
  DateTime get expiresAt;
  @override
  @JsonKey(name: 'booking_id')
  String? get bookingId;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  ProposalMaster? get master;
  @override
  ProposalService? get service;

  /// Create a copy of AutoProposalModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AutoProposalModelImplCopyWith<_$AutoProposalModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PreferredTimeSlot _$PreferredTimeSlotFromJson(Map<String, dynamic> json) {
  return _PreferredTimeSlot.fromJson(json);
}

/// @nodoc
mixin _$PreferredTimeSlot {
  @JsonKey(name: 'day_of_week')
  int get dayOfWeek =>
      throw _privateConstructorUsedError; // 0 = Sunday, 6 = Saturday
  @JsonKey(name: 'start_hour')
  int get startHour => throw _privateConstructorUsedError; // 0-23
  @JsonKey(name: 'end_hour')
  int get endHour => throw _privateConstructorUsedError;

  /// Serializes this PreferredTimeSlot to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PreferredTimeSlot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PreferredTimeSlotCopyWith<PreferredTimeSlot> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PreferredTimeSlotCopyWith<$Res> {
  factory $PreferredTimeSlotCopyWith(
          PreferredTimeSlot value, $Res Function(PreferredTimeSlot) then) =
      _$PreferredTimeSlotCopyWithImpl<$Res, PreferredTimeSlot>;
  @useResult
  $Res call(
      {@JsonKey(name: 'day_of_week') int dayOfWeek,
      @JsonKey(name: 'start_hour') int startHour,
      @JsonKey(name: 'end_hour') int endHour});
}

/// @nodoc
class _$PreferredTimeSlotCopyWithImpl<$Res, $Val extends PreferredTimeSlot>
    implements $PreferredTimeSlotCopyWith<$Res> {
  _$PreferredTimeSlotCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PreferredTimeSlot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dayOfWeek = null,
    Object? startHour = null,
    Object? endHour = null,
  }) {
    return _then(_value.copyWith(
      dayOfWeek: null == dayOfWeek
          ? _value.dayOfWeek
          : dayOfWeek // ignore: cast_nullable_to_non_nullable
              as int,
      startHour: null == startHour
          ? _value.startHour
          : startHour // ignore: cast_nullable_to_non_nullable
              as int,
      endHour: null == endHour
          ? _value.endHour
          : endHour // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PreferredTimeSlotImplCopyWith<$Res>
    implements $PreferredTimeSlotCopyWith<$Res> {
  factory _$$PreferredTimeSlotImplCopyWith(_$PreferredTimeSlotImpl value,
          $Res Function(_$PreferredTimeSlotImpl) then) =
      __$$PreferredTimeSlotImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'day_of_week') int dayOfWeek,
      @JsonKey(name: 'start_hour') int startHour,
      @JsonKey(name: 'end_hour') int endHour});
}

/// @nodoc
class __$$PreferredTimeSlotImplCopyWithImpl<$Res>
    extends _$PreferredTimeSlotCopyWithImpl<$Res, _$PreferredTimeSlotImpl>
    implements _$$PreferredTimeSlotImplCopyWith<$Res> {
  __$$PreferredTimeSlotImplCopyWithImpl(_$PreferredTimeSlotImpl _value,
      $Res Function(_$PreferredTimeSlotImpl) _then)
      : super(_value, _then);

  /// Create a copy of PreferredTimeSlot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dayOfWeek = null,
    Object? startHour = null,
    Object? endHour = null,
  }) {
    return _then(_$PreferredTimeSlotImpl(
      dayOfWeek: null == dayOfWeek
          ? _value.dayOfWeek
          : dayOfWeek // ignore: cast_nullable_to_non_nullable
              as int,
      startHour: null == startHour
          ? _value.startHour
          : startHour // ignore: cast_nullable_to_non_nullable
              as int,
      endHour: null == endHour
          ? _value.endHour
          : endHour // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PreferredTimeSlotImpl implements _PreferredTimeSlot {
  const _$PreferredTimeSlotImpl(
      {@JsonKey(name: 'day_of_week') required this.dayOfWeek,
      @JsonKey(name: 'start_hour') required this.startHour,
      @JsonKey(name: 'end_hour') required this.endHour});

  factory _$PreferredTimeSlotImpl.fromJson(Map<String, dynamic> json) =>
      _$$PreferredTimeSlotImplFromJson(json);

  @override
  @JsonKey(name: 'day_of_week')
  final int dayOfWeek;
// 0 = Sunday, 6 = Saturday
  @override
  @JsonKey(name: 'start_hour')
  final int startHour;
// 0-23
  @override
  @JsonKey(name: 'end_hour')
  final int endHour;

  @override
  String toString() {
    return 'PreferredTimeSlot(dayOfWeek: $dayOfWeek, startHour: $startHour, endHour: $endHour)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PreferredTimeSlotImpl &&
            (identical(other.dayOfWeek, dayOfWeek) ||
                other.dayOfWeek == dayOfWeek) &&
            (identical(other.startHour, startHour) ||
                other.startHour == startHour) &&
            (identical(other.endHour, endHour) || other.endHour == endHour));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, dayOfWeek, startHour, endHour);

  /// Create a copy of PreferredTimeSlot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PreferredTimeSlotImplCopyWith<_$PreferredTimeSlotImpl> get copyWith =>
      __$$PreferredTimeSlotImplCopyWithImpl<_$PreferredTimeSlotImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PreferredTimeSlotImplToJson(
      this,
    );
  }
}

abstract class _PreferredTimeSlot implements PreferredTimeSlot {
  const factory _PreferredTimeSlot(
          {@JsonKey(name: 'day_of_week') required final int dayOfWeek,
          @JsonKey(name: 'start_hour') required final int startHour,
          @JsonKey(name: 'end_hour') required final int endHour}) =
      _$PreferredTimeSlotImpl;

  factory _PreferredTimeSlot.fromJson(Map<String, dynamic> json) =
      _$PreferredTimeSlotImpl.fromJson;

  @override
  @JsonKey(name: 'day_of_week')
  int get dayOfWeek; // 0 = Sunday, 6 = Saturday
  @override
  @JsonKey(name: 'start_hour')
  int get startHour; // 0-23
  @override
  @JsonKey(name: 'end_hour')
  int get endHour;

  /// Create a copy of PreferredTimeSlot
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PreferredTimeSlotImplCopyWith<_$PreferredTimeSlotImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AutoProposalSettingsModel _$AutoProposalSettingsModelFromJson(
    Map<String, dynamic> json) {
  return _AutoProposalSettingsModel.fromJson(json);
}

/// @nodoc
mixin _$AutoProposalSettingsModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_enabled')
  bool get isEnabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'interval_days')
  ProposalInterval get intervalDays => throw _privateConstructorUsedError;
  @JsonKey(name: 'preferred_categories')
  List<String>? get preferredCategories => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_price')
  double? get maxPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_distance_km')
  int get maxDistanceKm => throw _privateConstructorUsedError;
  @JsonKey(name: 'min_rating')
  double get minRating => throw _privateConstructorUsedError;
  @JsonKey(name: 'preferred_time_slots')
  List<PreferredTimeSlot>? get preferredTimeSlots =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'last_proposal_at')
  DateTime? get lastProposalAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'next_proposal_at')
  DateTime? get nextProposalAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this AutoProposalSettingsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AutoProposalSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AutoProposalSettingsModelCopyWith<AutoProposalSettingsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AutoProposalSettingsModelCopyWith<$Res> {
  factory $AutoProposalSettingsModelCopyWith(AutoProposalSettingsModel value,
          $Res Function(AutoProposalSettingsModel) then) =
      _$AutoProposalSettingsModelCopyWithImpl<$Res, AutoProposalSettingsModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'is_enabled') bool isEnabled,
      @JsonKey(name: 'interval_days') ProposalInterval intervalDays,
      @JsonKey(name: 'preferred_categories') List<String>? preferredCategories,
      @JsonKey(name: 'max_price') double? maxPrice,
      @JsonKey(name: 'max_distance_km') int maxDistanceKm,
      @JsonKey(name: 'min_rating') double minRating,
      @JsonKey(name: 'preferred_time_slots')
      List<PreferredTimeSlot>? preferredTimeSlots,
      @JsonKey(name: 'last_proposal_at') DateTime? lastProposalAt,
      @JsonKey(name: 'next_proposal_at') DateTime? nextProposalAt,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class _$AutoProposalSettingsModelCopyWithImpl<$Res,
        $Val extends AutoProposalSettingsModel>
    implements $AutoProposalSettingsModelCopyWith<$Res> {
  _$AutoProposalSettingsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AutoProposalSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? isEnabled = null,
    Object? intervalDays = null,
    Object? preferredCategories = freezed,
    Object? maxPrice = freezed,
    Object? maxDistanceKm = null,
    Object? minRating = null,
    Object? preferredTimeSlots = freezed,
    Object? lastProposalAt = freezed,
    Object? nextProposalAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
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
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      intervalDays: null == intervalDays
          ? _value.intervalDays
          : intervalDays // ignore: cast_nullable_to_non_nullable
              as ProposalInterval,
      preferredCategories: freezed == preferredCategories
          ? _value.preferredCategories
          : preferredCategories // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      maxPrice: freezed == maxPrice
          ? _value.maxPrice
          : maxPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      maxDistanceKm: null == maxDistanceKm
          ? _value.maxDistanceKm
          : maxDistanceKm // ignore: cast_nullable_to_non_nullable
              as int,
      minRating: null == minRating
          ? _value.minRating
          : minRating // ignore: cast_nullable_to_non_nullable
              as double,
      preferredTimeSlots: freezed == preferredTimeSlots
          ? _value.preferredTimeSlots
          : preferredTimeSlots // ignore: cast_nullable_to_non_nullable
              as List<PreferredTimeSlot>?,
      lastProposalAt: freezed == lastProposalAt
          ? _value.lastProposalAt
          : lastProposalAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      nextProposalAt: freezed == nextProposalAt
          ? _value.nextProposalAt
          : nextProposalAt // ignore: cast_nullable_to_non_nullable
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
}

/// @nodoc
abstract class _$$AutoProposalSettingsModelImplCopyWith<$Res>
    implements $AutoProposalSettingsModelCopyWith<$Res> {
  factory _$$AutoProposalSettingsModelImplCopyWith(
          _$AutoProposalSettingsModelImpl value,
          $Res Function(_$AutoProposalSettingsModelImpl) then) =
      __$$AutoProposalSettingsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'is_enabled') bool isEnabled,
      @JsonKey(name: 'interval_days') ProposalInterval intervalDays,
      @JsonKey(name: 'preferred_categories') List<String>? preferredCategories,
      @JsonKey(name: 'max_price') double? maxPrice,
      @JsonKey(name: 'max_distance_km') int maxDistanceKm,
      @JsonKey(name: 'min_rating') double minRating,
      @JsonKey(name: 'preferred_time_slots')
      List<PreferredTimeSlot>? preferredTimeSlots,
      @JsonKey(name: 'last_proposal_at') DateTime? lastProposalAt,
      @JsonKey(name: 'next_proposal_at') DateTime? nextProposalAt,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class __$$AutoProposalSettingsModelImplCopyWithImpl<$Res>
    extends _$AutoProposalSettingsModelCopyWithImpl<$Res,
        _$AutoProposalSettingsModelImpl>
    implements _$$AutoProposalSettingsModelImplCopyWith<$Res> {
  __$$AutoProposalSettingsModelImplCopyWithImpl(
      _$AutoProposalSettingsModelImpl _value,
      $Res Function(_$AutoProposalSettingsModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of AutoProposalSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? isEnabled = null,
    Object? intervalDays = null,
    Object? preferredCategories = freezed,
    Object? maxPrice = freezed,
    Object? maxDistanceKm = null,
    Object? minRating = null,
    Object? preferredTimeSlots = freezed,
    Object? lastProposalAt = freezed,
    Object? nextProposalAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$AutoProposalSettingsModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      intervalDays: null == intervalDays
          ? _value.intervalDays
          : intervalDays // ignore: cast_nullable_to_non_nullable
              as ProposalInterval,
      preferredCategories: freezed == preferredCategories
          ? _value._preferredCategories
          : preferredCategories // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      maxPrice: freezed == maxPrice
          ? _value.maxPrice
          : maxPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      maxDistanceKm: null == maxDistanceKm
          ? _value.maxDistanceKm
          : maxDistanceKm // ignore: cast_nullable_to_non_nullable
              as int,
      minRating: null == minRating
          ? _value.minRating
          : minRating // ignore: cast_nullable_to_non_nullable
              as double,
      preferredTimeSlots: freezed == preferredTimeSlots
          ? _value._preferredTimeSlots
          : preferredTimeSlots // ignore: cast_nullable_to_non_nullable
              as List<PreferredTimeSlot>?,
      lastProposalAt: freezed == lastProposalAt
          ? _value.lastProposalAt
          : lastProposalAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      nextProposalAt: freezed == nextProposalAt
          ? _value.nextProposalAt
          : nextProposalAt // ignore: cast_nullable_to_non_nullable
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
class _$AutoProposalSettingsModelImpl implements _AutoProposalSettingsModel {
  const _$AutoProposalSettingsModelImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'is_enabled') this.isEnabled = true,
      @JsonKey(name: 'interval_days')
      this.intervalDays = ProposalInterval.weekly,
      @JsonKey(name: 'preferred_categories')
      final List<String>? preferredCategories,
      @JsonKey(name: 'max_price') this.maxPrice,
      @JsonKey(name: 'max_distance_km') this.maxDistanceKm = 10,
      @JsonKey(name: 'min_rating') this.minRating = 4.0,
      @JsonKey(name: 'preferred_time_slots')
      final List<PreferredTimeSlot>? preferredTimeSlots,
      @JsonKey(name: 'last_proposal_at') this.lastProposalAt,
      @JsonKey(name: 'next_proposal_at') this.nextProposalAt,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt})
      : _preferredCategories = preferredCategories,
        _preferredTimeSlots = preferredTimeSlots;

  factory _$AutoProposalSettingsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AutoProposalSettingsModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'is_enabled')
  final bool isEnabled;
  @override
  @JsonKey(name: 'interval_days')
  final ProposalInterval intervalDays;
  final List<String>? _preferredCategories;
  @override
  @JsonKey(name: 'preferred_categories')
  List<String>? get preferredCategories {
    final value = _preferredCategories;
    if (value == null) return null;
    if (_preferredCategories is EqualUnmodifiableListView)
      return _preferredCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'max_price')
  final double? maxPrice;
  @override
  @JsonKey(name: 'max_distance_km')
  final int maxDistanceKm;
  @override
  @JsonKey(name: 'min_rating')
  final double minRating;
  final List<PreferredTimeSlot>? _preferredTimeSlots;
  @override
  @JsonKey(name: 'preferred_time_slots')
  List<PreferredTimeSlot>? get preferredTimeSlots {
    final value = _preferredTimeSlots;
    if (value == null) return null;
    if (_preferredTimeSlots is EqualUnmodifiableListView)
      return _preferredTimeSlots;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'last_proposal_at')
  final DateTime? lastProposalAt;
  @override
  @JsonKey(name: 'next_proposal_at')
  final DateTime? nextProposalAt;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'AutoProposalSettingsModel(id: $id, userId: $userId, isEnabled: $isEnabled, intervalDays: $intervalDays, preferredCategories: $preferredCategories, maxPrice: $maxPrice, maxDistanceKm: $maxDistanceKm, minRating: $minRating, preferredTimeSlots: $preferredTimeSlots, lastProposalAt: $lastProposalAt, nextProposalAt: $nextProposalAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AutoProposalSettingsModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled) &&
            (identical(other.intervalDays, intervalDays) ||
                other.intervalDays == intervalDays) &&
            const DeepCollectionEquality()
                .equals(other._preferredCategories, _preferredCategories) &&
            (identical(other.maxPrice, maxPrice) ||
                other.maxPrice == maxPrice) &&
            (identical(other.maxDistanceKm, maxDistanceKm) ||
                other.maxDistanceKm == maxDistanceKm) &&
            (identical(other.minRating, minRating) ||
                other.minRating == minRating) &&
            const DeepCollectionEquality()
                .equals(other._preferredTimeSlots, _preferredTimeSlots) &&
            (identical(other.lastProposalAt, lastProposalAt) ||
                other.lastProposalAt == lastProposalAt) &&
            (identical(other.nextProposalAt, nextProposalAt) ||
                other.nextProposalAt == nextProposalAt) &&
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
      userId,
      isEnabled,
      intervalDays,
      const DeepCollectionEquality().hash(_preferredCategories),
      maxPrice,
      maxDistanceKm,
      minRating,
      const DeepCollectionEquality().hash(_preferredTimeSlots),
      lastProposalAt,
      nextProposalAt,
      createdAt,
      updatedAt);

  /// Create a copy of AutoProposalSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AutoProposalSettingsModelImplCopyWith<_$AutoProposalSettingsModelImpl>
      get copyWith => __$$AutoProposalSettingsModelImplCopyWithImpl<
          _$AutoProposalSettingsModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AutoProposalSettingsModelImplToJson(
      this,
    );
  }
}

abstract class _AutoProposalSettingsModel implements AutoProposalSettingsModel {
  const factory _AutoProposalSettingsModel(
          {required final String id,
          @JsonKey(name: 'user_id') required final String userId,
          @JsonKey(name: 'is_enabled') final bool isEnabled,
          @JsonKey(name: 'interval_days') final ProposalInterval intervalDays,
          @JsonKey(name: 'preferred_categories')
          final List<String>? preferredCategories,
          @JsonKey(name: 'max_price') final double? maxPrice,
          @JsonKey(name: 'max_distance_km') final int maxDistanceKm,
          @JsonKey(name: 'min_rating') final double minRating,
          @JsonKey(name: 'preferred_time_slots')
          final List<PreferredTimeSlot>? preferredTimeSlots,
          @JsonKey(name: 'last_proposal_at') final DateTime? lastProposalAt,
          @JsonKey(name: 'next_proposal_at') final DateTime? nextProposalAt,
          @JsonKey(name: 'created_at') required final DateTime createdAt,
          @JsonKey(name: 'updated_at') required final DateTime updatedAt}) =
      _$AutoProposalSettingsModelImpl;

  factory _AutoProposalSettingsModel.fromJson(Map<String, dynamic> json) =
      _$AutoProposalSettingsModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'is_enabled')
  bool get isEnabled;
  @override
  @JsonKey(name: 'interval_days')
  ProposalInterval get intervalDays;
  @override
  @JsonKey(name: 'preferred_categories')
  List<String>? get preferredCategories;
  @override
  @JsonKey(name: 'max_price')
  double? get maxPrice;
  @override
  @JsonKey(name: 'max_distance_km')
  int get maxDistanceKm;
  @override
  @JsonKey(name: 'min_rating')
  double get minRating;
  @override
  @JsonKey(name: 'preferred_time_slots')
  List<PreferredTimeSlot>? get preferredTimeSlots;
  @override
  @JsonKey(name: 'last_proposal_at')
  DateTime? get lastProposalAt;
  @override
  @JsonKey(name: 'next_proposal_at')
  DateTime? get nextProposalAt;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of AutoProposalSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AutoProposalSettingsModelImplCopyWith<_$AutoProposalSettingsModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

UpdateAutoProposalSettingsDto _$UpdateAutoProposalSettingsDtoFromJson(
    Map<String, dynamic> json) {
  return _UpdateAutoProposalSettingsDto.fromJson(json);
}

/// @nodoc
mixin _$UpdateAutoProposalSettingsDto {
  @JsonKey(name: 'is_enabled')
  bool? get isEnabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'interval_days')
  ProposalInterval? get intervalDays => throw _privateConstructorUsedError;
  @JsonKey(name: 'preferred_categories')
  List<String>? get preferredCategories => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_price')
  double? get maxPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_distance_km')
  int? get maxDistanceKm => throw _privateConstructorUsedError;
  @JsonKey(name: 'min_rating')
  double? get minRating => throw _privateConstructorUsedError;
  @JsonKey(name: 'preferred_time_slots')
  List<PreferredTimeSlot>? get preferredTimeSlots =>
      throw _privateConstructorUsedError;

  /// Serializes this UpdateAutoProposalSettingsDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateAutoProposalSettingsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateAutoProposalSettingsDtoCopyWith<UpdateAutoProposalSettingsDto>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateAutoProposalSettingsDtoCopyWith<$Res> {
  factory $UpdateAutoProposalSettingsDtoCopyWith(
          UpdateAutoProposalSettingsDto value,
          $Res Function(UpdateAutoProposalSettingsDto) then) =
      _$UpdateAutoProposalSettingsDtoCopyWithImpl<$Res,
          UpdateAutoProposalSettingsDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'is_enabled') bool? isEnabled,
      @JsonKey(name: 'interval_days') ProposalInterval? intervalDays,
      @JsonKey(name: 'preferred_categories') List<String>? preferredCategories,
      @JsonKey(name: 'max_price') double? maxPrice,
      @JsonKey(name: 'max_distance_km') int? maxDistanceKm,
      @JsonKey(name: 'min_rating') double? minRating,
      @JsonKey(name: 'preferred_time_slots')
      List<PreferredTimeSlot>? preferredTimeSlots});
}

/// @nodoc
class _$UpdateAutoProposalSettingsDtoCopyWithImpl<$Res,
        $Val extends UpdateAutoProposalSettingsDto>
    implements $UpdateAutoProposalSettingsDtoCopyWith<$Res> {
  _$UpdateAutoProposalSettingsDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateAutoProposalSettingsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isEnabled = freezed,
    Object? intervalDays = freezed,
    Object? preferredCategories = freezed,
    Object? maxPrice = freezed,
    Object? maxDistanceKm = freezed,
    Object? minRating = freezed,
    Object? preferredTimeSlots = freezed,
  }) {
    return _then(_value.copyWith(
      isEnabled: freezed == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool?,
      intervalDays: freezed == intervalDays
          ? _value.intervalDays
          : intervalDays // ignore: cast_nullable_to_non_nullable
              as ProposalInterval?,
      preferredCategories: freezed == preferredCategories
          ? _value.preferredCategories
          : preferredCategories // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      maxPrice: freezed == maxPrice
          ? _value.maxPrice
          : maxPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      maxDistanceKm: freezed == maxDistanceKm
          ? _value.maxDistanceKm
          : maxDistanceKm // ignore: cast_nullable_to_non_nullable
              as int?,
      minRating: freezed == minRating
          ? _value.minRating
          : minRating // ignore: cast_nullable_to_non_nullable
              as double?,
      preferredTimeSlots: freezed == preferredTimeSlots
          ? _value.preferredTimeSlots
          : preferredTimeSlots // ignore: cast_nullable_to_non_nullable
              as List<PreferredTimeSlot>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateAutoProposalSettingsDtoImplCopyWith<$Res>
    implements $UpdateAutoProposalSettingsDtoCopyWith<$Res> {
  factory _$$UpdateAutoProposalSettingsDtoImplCopyWith(
          _$UpdateAutoProposalSettingsDtoImpl value,
          $Res Function(_$UpdateAutoProposalSettingsDtoImpl) then) =
      __$$UpdateAutoProposalSettingsDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'is_enabled') bool? isEnabled,
      @JsonKey(name: 'interval_days') ProposalInterval? intervalDays,
      @JsonKey(name: 'preferred_categories') List<String>? preferredCategories,
      @JsonKey(name: 'max_price') double? maxPrice,
      @JsonKey(name: 'max_distance_km') int? maxDistanceKm,
      @JsonKey(name: 'min_rating') double? minRating,
      @JsonKey(name: 'preferred_time_slots')
      List<PreferredTimeSlot>? preferredTimeSlots});
}

/// @nodoc
class __$$UpdateAutoProposalSettingsDtoImplCopyWithImpl<$Res>
    extends _$UpdateAutoProposalSettingsDtoCopyWithImpl<$Res,
        _$UpdateAutoProposalSettingsDtoImpl>
    implements _$$UpdateAutoProposalSettingsDtoImplCopyWith<$Res> {
  __$$UpdateAutoProposalSettingsDtoImplCopyWithImpl(
      _$UpdateAutoProposalSettingsDtoImpl _value,
      $Res Function(_$UpdateAutoProposalSettingsDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateAutoProposalSettingsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isEnabled = freezed,
    Object? intervalDays = freezed,
    Object? preferredCategories = freezed,
    Object? maxPrice = freezed,
    Object? maxDistanceKm = freezed,
    Object? minRating = freezed,
    Object? preferredTimeSlots = freezed,
  }) {
    return _then(_$UpdateAutoProposalSettingsDtoImpl(
      isEnabled: freezed == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool?,
      intervalDays: freezed == intervalDays
          ? _value.intervalDays
          : intervalDays // ignore: cast_nullable_to_non_nullable
              as ProposalInterval?,
      preferredCategories: freezed == preferredCategories
          ? _value._preferredCategories
          : preferredCategories // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      maxPrice: freezed == maxPrice
          ? _value.maxPrice
          : maxPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      maxDistanceKm: freezed == maxDistanceKm
          ? _value.maxDistanceKm
          : maxDistanceKm // ignore: cast_nullable_to_non_nullable
              as int?,
      minRating: freezed == minRating
          ? _value.minRating
          : minRating // ignore: cast_nullable_to_non_nullable
              as double?,
      preferredTimeSlots: freezed == preferredTimeSlots
          ? _value._preferredTimeSlots
          : preferredTimeSlots // ignore: cast_nullable_to_non_nullable
              as List<PreferredTimeSlot>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateAutoProposalSettingsDtoImpl
    implements _UpdateAutoProposalSettingsDto {
  const _$UpdateAutoProposalSettingsDtoImpl(
      {@JsonKey(name: 'is_enabled') this.isEnabled,
      @JsonKey(name: 'interval_days') this.intervalDays,
      @JsonKey(name: 'preferred_categories')
      final List<String>? preferredCategories,
      @JsonKey(name: 'max_price') this.maxPrice,
      @JsonKey(name: 'max_distance_km') this.maxDistanceKm,
      @JsonKey(name: 'min_rating') this.minRating,
      @JsonKey(name: 'preferred_time_slots')
      final List<PreferredTimeSlot>? preferredTimeSlots})
      : _preferredCategories = preferredCategories,
        _preferredTimeSlots = preferredTimeSlots;

  factory _$UpdateAutoProposalSettingsDtoImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$UpdateAutoProposalSettingsDtoImplFromJson(json);

  @override
  @JsonKey(name: 'is_enabled')
  final bool? isEnabled;
  @override
  @JsonKey(name: 'interval_days')
  final ProposalInterval? intervalDays;
  final List<String>? _preferredCategories;
  @override
  @JsonKey(name: 'preferred_categories')
  List<String>? get preferredCategories {
    final value = _preferredCategories;
    if (value == null) return null;
    if (_preferredCategories is EqualUnmodifiableListView)
      return _preferredCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'max_price')
  final double? maxPrice;
  @override
  @JsonKey(name: 'max_distance_km')
  final int? maxDistanceKm;
  @override
  @JsonKey(name: 'min_rating')
  final double? minRating;
  final List<PreferredTimeSlot>? _preferredTimeSlots;
  @override
  @JsonKey(name: 'preferred_time_slots')
  List<PreferredTimeSlot>? get preferredTimeSlots {
    final value = _preferredTimeSlots;
    if (value == null) return null;
    if (_preferredTimeSlots is EqualUnmodifiableListView)
      return _preferredTimeSlots;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'UpdateAutoProposalSettingsDto(isEnabled: $isEnabled, intervalDays: $intervalDays, preferredCategories: $preferredCategories, maxPrice: $maxPrice, maxDistanceKm: $maxDistanceKm, minRating: $minRating, preferredTimeSlots: $preferredTimeSlots)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateAutoProposalSettingsDtoImpl &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled) &&
            (identical(other.intervalDays, intervalDays) ||
                other.intervalDays == intervalDays) &&
            const DeepCollectionEquality()
                .equals(other._preferredCategories, _preferredCategories) &&
            (identical(other.maxPrice, maxPrice) ||
                other.maxPrice == maxPrice) &&
            (identical(other.maxDistanceKm, maxDistanceKm) ||
                other.maxDistanceKm == maxDistanceKm) &&
            (identical(other.minRating, minRating) ||
                other.minRating == minRating) &&
            const DeepCollectionEquality()
                .equals(other._preferredTimeSlots, _preferredTimeSlots));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      isEnabled,
      intervalDays,
      const DeepCollectionEquality().hash(_preferredCategories),
      maxPrice,
      maxDistanceKm,
      minRating,
      const DeepCollectionEquality().hash(_preferredTimeSlots));

  /// Create a copy of UpdateAutoProposalSettingsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateAutoProposalSettingsDtoImplCopyWith<
          _$UpdateAutoProposalSettingsDtoImpl>
      get copyWith => __$$UpdateAutoProposalSettingsDtoImplCopyWithImpl<
          _$UpdateAutoProposalSettingsDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateAutoProposalSettingsDtoImplToJson(
      this,
    );
  }
}

abstract class _UpdateAutoProposalSettingsDto
    implements UpdateAutoProposalSettingsDto {
  const factory _UpdateAutoProposalSettingsDto(
          {@JsonKey(name: 'is_enabled') final bool? isEnabled,
          @JsonKey(name: 'interval_days') final ProposalInterval? intervalDays,
          @JsonKey(name: 'preferred_categories')
          final List<String>? preferredCategories,
          @JsonKey(name: 'max_price') final double? maxPrice,
          @JsonKey(name: 'max_distance_km') final int? maxDistanceKm,
          @JsonKey(name: 'min_rating') final double? minRating,
          @JsonKey(name: 'preferred_time_slots')
          final List<PreferredTimeSlot>? preferredTimeSlots}) =
      _$UpdateAutoProposalSettingsDtoImpl;

  factory _UpdateAutoProposalSettingsDto.fromJson(Map<String, dynamic> json) =
      _$UpdateAutoProposalSettingsDtoImpl.fromJson;

  @override
  @JsonKey(name: 'is_enabled')
  bool? get isEnabled;
  @override
  @JsonKey(name: 'interval_days')
  ProposalInterval? get intervalDays;
  @override
  @JsonKey(name: 'preferred_categories')
  List<String>? get preferredCategories;
  @override
  @JsonKey(name: 'max_price')
  double? get maxPrice;
  @override
  @JsonKey(name: 'max_distance_km')
  int? get maxDistanceKm;
  @override
  @JsonKey(name: 'min_rating')
  double? get minRating;
  @override
  @JsonKey(name: 'preferred_time_slots')
  List<PreferredTimeSlot>? get preferredTimeSlots;

  /// Create a copy of UpdateAutoProposalSettingsDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateAutoProposalSettingsDtoImplCopyWith<
          _$UpdateAutoProposalSettingsDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

AcceptProposalDto _$AcceptProposalDtoFromJson(Map<String, dynamic> json) {
  return _AcceptProposalDto.fromJson(json);
}

/// @nodoc
mixin _$AcceptProposalDto {
  @JsonKey(name: 'proposed_datetime')
  DateTime get proposedDatetime => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this AcceptProposalDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AcceptProposalDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AcceptProposalDtoCopyWith<AcceptProposalDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AcceptProposalDtoCopyWith<$Res> {
  factory $AcceptProposalDtoCopyWith(
          AcceptProposalDto value, $Res Function(AcceptProposalDto) then) =
      _$AcceptProposalDtoCopyWithImpl<$Res, AcceptProposalDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'proposed_datetime') DateTime proposedDatetime,
      String? notes});
}

/// @nodoc
class _$AcceptProposalDtoCopyWithImpl<$Res, $Val extends AcceptProposalDto>
    implements $AcceptProposalDtoCopyWith<$Res> {
  _$AcceptProposalDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AcceptProposalDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? proposedDatetime = null,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      proposedDatetime: null == proposedDatetime
          ? _value.proposedDatetime
          : proposedDatetime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AcceptProposalDtoImplCopyWith<$Res>
    implements $AcceptProposalDtoCopyWith<$Res> {
  factory _$$AcceptProposalDtoImplCopyWith(_$AcceptProposalDtoImpl value,
          $Res Function(_$AcceptProposalDtoImpl) then) =
      __$$AcceptProposalDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'proposed_datetime') DateTime proposedDatetime,
      String? notes});
}

/// @nodoc
class __$$AcceptProposalDtoImplCopyWithImpl<$Res>
    extends _$AcceptProposalDtoCopyWithImpl<$Res, _$AcceptProposalDtoImpl>
    implements _$$AcceptProposalDtoImplCopyWith<$Res> {
  __$$AcceptProposalDtoImplCopyWithImpl(_$AcceptProposalDtoImpl _value,
      $Res Function(_$AcceptProposalDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of AcceptProposalDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? proposedDatetime = null,
    Object? notes = freezed,
  }) {
    return _then(_$AcceptProposalDtoImpl(
      proposedDatetime: null == proposedDatetime
          ? _value.proposedDatetime
          : proposedDatetime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AcceptProposalDtoImpl implements _AcceptProposalDto {
  const _$AcceptProposalDtoImpl(
      {@JsonKey(name: 'proposed_datetime') required this.proposedDatetime,
      this.notes});

  factory _$AcceptProposalDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AcceptProposalDtoImplFromJson(json);

  @override
  @JsonKey(name: 'proposed_datetime')
  final DateTime proposedDatetime;
  @override
  final String? notes;

  @override
  String toString() {
    return 'AcceptProposalDto(proposedDatetime: $proposedDatetime, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AcceptProposalDtoImpl &&
            (identical(other.proposedDatetime, proposedDatetime) ||
                other.proposedDatetime == proposedDatetime) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, proposedDatetime, notes);

  /// Create a copy of AcceptProposalDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AcceptProposalDtoImplCopyWith<_$AcceptProposalDtoImpl> get copyWith =>
      __$$AcceptProposalDtoImplCopyWithImpl<_$AcceptProposalDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AcceptProposalDtoImplToJson(
      this,
    );
  }
}

abstract class _AcceptProposalDto implements AcceptProposalDto {
  const factory _AcceptProposalDto(
      {@JsonKey(name: 'proposed_datetime')
      required final DateTime proposedDatetime,
      final String? notes}) = _$AcceptProposalDtoImpl;

  factory _AcceptProposalDto.fromJson(Map<String, dynamic> json) =
      _$AcceptProposalDtoImpl.fromJson;

  @override
  @JsonKey(name: 'proposed_datetime')
  DateTime get proposedDatetime;
  @override
  String? get notes;

  /// Create a copy of AcceptProposalDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AcceptProposalDtoImplCopyWith<_$AcceptProposalDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
