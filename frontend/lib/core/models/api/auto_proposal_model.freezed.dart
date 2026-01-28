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

MatchReasonsModel _$MatchReasonsModelFromJson(Map<String, dynamic> json) {
  return _MatchReasonsModel.fromJson(json);
}

/// @nodoc
mixin _$MatchReasonsModel {
  double? get locationScore => throw _privateConstructorUsedError;
  double? get ratingScore => throw _privateConstructorUsedError;
  double? get priceScore => throw _privateConstructorUsedError;
  double? get availabilityScore => throw _privateConstructorUsedError;
  double? get historyScore => throw _privateConstructorUsedError;
  List<String> get reasons => throw _privateConstructorUsedError;

  /// Serializes this MatchReasonsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MatchReasonsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MatchReasonsModelCopyWith<MatchReasonsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MatchReasonsModelCopyWith<$Res> {
  factory $MatchReasonsModelCopyWith(
          MatchReasonsModel value, $Res Function(MatchReasonsModel) then) =
      _$MatchReasonsModelCopyWithImpl<$Res, MatchReasonsModel>;
  @useResult
  $Res call(
      {double? locationScore,
      double? ratingScore,
      double? priceScore,
      double? availabilityScore,
      double? historyScore,
      List<String> reasons});
}

/// @nodoc
class _$MatchReasonsModelCopyWithImpl<$Res, $Val extends MatchReasonsModel>
    implements $MatchReasonsModelCopyWith<$Res> {
  _$MatchReasonsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MatchReasonsModel
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
abstract class _$$MatchReasonsModelImplCopyWith<$Res>
    implements $MatchReasonsModelCopyWith<$Res> {
  factory _$$MatchReasonsModelImplCopyWith(_$MatchReasonsModelImpl value,
          $Res Function(_$MatchReasonsModelImpl) then) =
      __$$MatchReasonsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double? locationScore,
      double? ratingScore,
      double? priceScore,
      double? availabilityScore,
      double? historyScore,
      List<String> reasons});
}

/// @nodoc
class __$$MatchReasonsModelImplCopyWithImpl<$Res>
    extends _$MatchReasonsModelCopyWithImpl<$Res, _$MatchReasonsModelImpl>
    implements _$$MatchReasonsModelImplCopyWith<$Res> {
  __$$MatchReasonsModelImplCopyWithImpl(_$MatchReasonsModelImpl _value,
      $Res Function(_$MatchReasonsModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of MatchReasonsModel
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
    return _then(_$MatchReasonsModelImpl(
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
class _$MatchReasonsModelImpl implements _MatchReasonsModel {
  const _$MatchReasonsModelImpl(
      {this.locationScore,
      this.ratingScore,
      this.priceScore,
      this.availabilityScore,
      this.historyScore,
      final List<String> reasons = const []})
      : _reasons = reasons;

  factory _$MatchReasonsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MatchReasonsModelImplFromJson(json);

  @override
  final double? locationScore;
  @override
  final double? ratingScore;
  @override
  final double? priceScore;
  @override
  final double? availabilityScore;
  @override
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
    return 'MatchReasonsModel(locationScore: $locationScore, ratingScore: $ratingScore, priceScore: $priceScore, availabilityScore: $availabilityScore, historyScore: $historyScore, reasons: $reasons)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MatchReasonsModelImpl &&
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

  /// Create a copy of MatchReasonsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MatchReasonsModelImplCopyWith<_$MatchReasonsModelImpl> get copyWith =>
      __$$MatchReasonsModelImplCopyWithImpl<_$MatchReasonsModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MatchReasonsModelImplToJson(
      this,
    );
  }
}

abstract class _MatchReasonsModel implements MatchReasonsModel {
  const factory _MatchReasonsModel(
      {final double? locationScore,
      final double? ratingScore,
      final double? priceScore,
      final double? availabilityScore,
      final double? historyScore,
      final List<String> reasons}) = _$MatchReasonsModelImpl;

  factory _MatchReasonsModel.fromJson(Map<String, dynamic> json) =
      _$MatchReasonsModelImpl.fromJson;

  @override
  double? get locationScore;
  @override
  double? get ratingScore;
  @override
  double? get priceScore;
  @override
  double? get availabilityScore;
  @override
  double? get historyScore;
  @override
  List<String> get reasons;

  /// Create a copy of MatchReasonsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MatchReasonsModelImplCopyWith<_$MatchReasonsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProposalMasterModel _$ProposalMasterModelFromJson(Map<String, dynamic> json) {
  return _ProposalMasterModel.fromJson(json);
}

/// @nodoc
mixin _$ProposalMasterModel {
  String get id => throw _privateConstructorUsedError;
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;
  double? get rating => throw _privateConstructorUsedError;

  /// Serializes this ProposalMasterModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProposalMasterModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProposalMasterModelCopyWith<ProposalMasterModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProposalMasterModelCopyWith<$Res> {
  factory $ProposalMasterModelCopyWith(
          ProposalMasterModel value, $Res Function(ProposalMasterModel) then) =
      _$ProposalMasterModelCopyWithImpl<$Res, ProposalMasterModel>;
  @useResult
  $Res call(
      {String id,
      String firstName,
      String lastName,
      String? avatarUrl,
      double? rating});
}

/// @nodoc
class _$ProposalMasterModelCopyWithImpl<$Res, $Val extends ProposalMasterModel>
    implements $ProposalMasterModelCopyWith<$Res> {
  _$ProposalMasterModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProposalMasterModel
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
abstract class _$$ProposalMasterModelImplCopyWith<$Res>
    implements $ProposalMasterModelCopyWith<$Res> {
  factory _$$ProposalMasterModelImplCopyWith(_$ProposalMasterModelImpl value,
          $Res Function(_$ProposalMasterModelImpl) then) =
      __$$ProposalMasterModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String firstName,
      String lastName,
      String? avatarUrl,
      double? rating});
}

/// @nodoc
class __$$ProposalMasterModelImplCopyWithImpl<$Res>
    extends _$ProposalMasterModelCopyWithImpl<$Res, _$ProposalMasterModelImpl>
    implements _$$ProposalMasterModelImplCopyWith<$Res> {
  __$$ProposalMasterModelImplCopyWithImpl(_$ProposalMasterModelImpl _value,
      $Res Function(_$ProposalMasterModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProposalMasterModel
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
    return _then(_$ProposalMasterModelImpl(
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
class _$ProposalMasterModelImpl implements _ProposalMasterModel {
  const _$ProposalMasterModelImpl(
      {required this.id,
      required this.firstName,
      required this.lastName,
      this.avatarUrl,
      this.rating});

  factory _$ProposalMasterModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProposalMasterModelImplFromJson(json);

  @override
  final String id;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String? avatarUrl;
  @override
  final double? rating;

  @override
  String toString() {
    return 'ProposalMasterModel(id: $id, firstName: $firstName, lastName: $lastName, avatarUrl: $avatarUrl, rating: $rating)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProposalMasterModelImpl &&
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

  /// Create a copy of ProposalMasterModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProposalMasterModelImplCopyWith<_$ProposalMasterModelImpl> get copyWith =>
      __$$ProposalMasterModelImplCopyWithImpl<_$ProposalMasterModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProposalMasterModelImplToJson(
      this,
    );
  }
}

abstract class _ProposalMasterModel implements ProposalMasterModel {
  const factory _ProposalMasterModel(
      {required final String id,
      required final String firstName,
      required final String lastName,
      final String? avatarUrl,
      final double? rating}) = _$ProposalMasterModelImpl;

  factory _ProposalMasterModel.fromJson(Map<String, dynamic> json) =
      _$ProposalMasterModelImpl.fromJson;

  @override
  String get id;
  @override
  String get firstName;
  @override
  String get lastName;
  @override
  String? get avatarUrl;
  @override
  double? get rating;

  /// Create a copy of ProposalMasterModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProposalMasterModelImplCopyWith<_$ProposalMasterModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProposalServiceModel _$ProposalServiceModelFromJson(Map<String, dynamic> json) {
  return _ProposalServiceModel.fromJson(json);
}

/// @nodoc
mixin _$ProposalServiceModel {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  int get durationMinutes => throw _privateConstructorUsedError;

  /// Serializes this ProposalServiceModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProposalServiceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProposalServiceModelCopyWith<ProposalServiceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProposalServiceModelCopyWith<$Res> {
  factory $ProposalServiceModelCopyWith(ProposalServiceModel value,
          $Res Function(ProposalServiceModel) then) =
      _$ProposalServiceModelCopyWithImpl<$Res, ProposalServiceModel>;
  @useResult
  $Res call({String id, String title, double price, int durationMinutes});
}

/// @nodoc
class _$ProposalServiceModelCopyWithImpl<$Res,
        $Val extends ProposalServiceModel>
    implements $ProposalServiceModelCopyWith<$Res> {
  _$ProposalServiceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProposalServiceModel
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
abstract class _$$ProposalServiceModelImplCopyWith<$Res>
    implements $ProposalServiceModelCopyWith<$Res> {
  factory _$$ProposalServiceModelImplCopyWith(_$ProposalServiceModelImpl value,
          $Res Function(_$ProposalServiceModelImpl) then) =
      __$$ProposalServiceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String title, double price, int durationMinutes});
}

/// @nodoc
class __$$ProposalServiceModelImplCopyWithImpl<$Res>
    extends _$ProposalServiceModelCopyWithImpl<$Res, _$ProposalServiceModelImpl>
    implements _$$ProposalServiceModelImplCopyWith<$Res> {
  __$$ProposalServiceModelImplCopyWithImpl(_$ProposalServiceModelImpl _value,
      $Res Function(_$ProposalServiceModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProposalServiceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? price = null,
    Object? durationMinutes = null,
  }) {
    return _then(_$ProposalServiceModelImpl(
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
class _$ProposalServiceModelImpl implements _ProposalServiceModel {
  const _$ProposalServiceModelImpl(
      {required this.id,
      required this.title,
      required this.price,
      required this.durationMinutes});

  factory _$ProposalServiceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProposalServiceModelImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final double price;
  @override
  final int durationMinutes;

  @override
  String toString() {
    return 'ProposalServiceModel(id: $id, title: $title, price: $price, durationMinutes: $durationMinutes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProposalServiceModelImpl &&
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

  /// Create a copy of ProposalServiceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProposalServiceModelImplCopyWith<_$ProposalServiceModelImpl>
      get copyWith =>
          __$$ProposalServiceModelImplCopyWithImpl<_$ProposalServiceModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProposalServiceModelImplToJson(
      this,
    );
  }
}

abstract class _ProposalServiceModel implements ProposalServiceModel {
  const factory _ProposalServiceModel(
      {required final String id,
      required final String title,
      required final double price,
      required final int durationMinutes}) = _$ProposalServiceModelImpl;

  factory _ProposalServiceModel.fromJson(Map<String, dynamic> json) =
      _$ProposalServiceModelImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  double get price;
  @override
  int get durationMinutes;

  /// Create a copy of ProposalServiceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProposalServiceModelImplCopyWith<_$ProposalServiceModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

TimeSlotModel _$TimeSlotModelFromJson(Map<String, dynamic> json) {
  return _TimeSlotModel.fromJson(json);
}

/// @nodoc
mixin _$TimeSlotModel {
  int get dayOfWeek => throw _privateConstructorUsedError;
  int get startHour => throw _privateConstructorUsedError;
  int get endHour => throw _privateConstructorUsedError;

  /// Serializes this TimeSlotModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TimeSlotModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TimeSlotModelCopyWith<TimeSlotModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimeSlotModelCopyWith<$Res> {
  factory $TimeSlotModelCopyWith(
          TimeSlotModel value, $Res Function(TimeSlotModel) then) =
      _$TimeSlotModelCopyWithImpl<$Res, TimeSlotModel>;
  @useResult
  $Res call({int dayOfWeek, int startHour, int endHour});
}

/// @nodoc
class _$TimeSlotModelCopyWithImpl<$Res, $Val extends TimeSlotModel>
    implements $TimeSlotModelCopyWith<$Res> {
  _$TimeSlotModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TimeSlotModel
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
abstract class _$$TimeSlotModelImplCopyWith<$Res>
    implements $TimeSlotModelCopyWith<$Res> {
  factory _$$TimeSlotModelImplCopyWith(
          _$TimeSlotModelImpl value, $Res Function(_$TimeSlotModelImpl) then) =
      __$$TimeSlotModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int dayOfWeek, int startHour, int endHour});
}

/// @nodoc
class __$$TimeSlotModelImplCopyWithImpl<$Res>
    extends _$TimeSlotModelCopyWithImpl<$Res, _$TimeSlotModelImpl>
    implements _$$TimeSlotModelImplCopyWith<$Res> {
  __$$TimeSlotModelImplCopyWithImpl(
      _$TimeSlotModelImpl _value, $Res Function(_$TimeSlotModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of TimeSlotModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dayOfWeek = null,
    Object? startHour = null,
    Object? endHour = null,
  }) {
    return _then(_$TimeSlotModelImpl(
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
class _$TimeSlotModelImpl implements _TimeSlotModel {
  const _$TimeSlotModelImpl(
      {required this.dayOfWeek,
      required this.startHour,
      required this.endHour});

  factory _$TimeSlotModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimeSlotModelImplFromJson(json);

  @override
  final int dayOfWeek;
  @override
  final int startHour;
  @override
  final int endHour;

  @override
  String toString() {
    return 'TimeSlotModel(dayOfWeek: $dayOfWeek, startHour: $startHour, endHour: $endHour)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimeSlotModelImpl &&
            (identical(other.dayOfWeek, dayOfWeek) ||
                other.dayOfWeek == dayOfWeek) &&
            (identical(other.startHour, startHour) ||
                other.startHour == startHour) &&
            (identical(other.endHour, endHour) || other.endHour == endHour));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, dayOfWeek, startHour, endHour);

  /// Create a copy of TimeSlotModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimeSlotModelImplCopyWith<_$TimeSlotModelImpl> get copyWith =>
      __$$TimeSlotModelImplCopyWithImpl<_$TimeSlotModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TimeSlotModelImplToJson(
      this,
    );
  }
}

abstract class _TimeSlotModel implements TimeSlotModel {
  const factory _TimeSlotModel(
      {required final int dayOfWeek,
      required final int startHour,
      required final int endHour}) = _$TimeSlotModelImpl;

  factory _TimeSlotModel.fromJson(Map<String, dynamic> json) =
      _$TimeSlotModelImpl.fromJson;

  @override
  int get dayOfWeek;
  @override
  int get startHour;
  @override
  int get endHour;

  /// Create a copy of TimeSlotModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimeSlotModelImplCopyWith<_$TimeSlotModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AutoProposalSettingsModel _$AutoProposalSettingsModelFromJson(
    Map<String, dynamic> json) {
  return _AutoProposalSettingsModel.fromJson(json);
}

/// @nodoc
mixin _$AutoProposalSettingsModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  bool get isEnabled => throw _privateConstructorUsedError;
  int get intervalDays => throw _privateConstructorUsedError;
  List<String> get preferredCategories => throw _privateConstructorUsedError;
  double? get maxPrice => throw _privateConstructorUsedError;
  int get maxDistanceKm => throw _privateConstructorUsedError;
  double get minRating => throw _privateConstructorUsedError;
  List<TimeSlotModel> get preferredTimeSlots =>
      throw _privateConstructorUsedError;
  DateTime? get lastProposalAt => throw _privateConstructorUsedError;
  DateTime? get nextProposalAt => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
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
      String userId,
      bool isEnabled,
      int intervalDays,
      List<String> preferredCategories,
      double? maxPrice,
      int maxDistanceKm,
      double minRating,
      List<TimeSlotModel> preferredTimeSlots,
      DateTime? lastProposalAt,
      DateTime? nextProposalAt,
      DateTime createdAt,
      DateTime updatedAt});
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
    Object? preferredCategories = null,
    Object? maxPrice = freezed,
    Object? maxDistanceKm = null,
    Object? minRating = null,
    Object? preferredTimeSlots = null,
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
              as int,
      preferredCategories: null == preferredCategories
          ? _value.preferredCategories
          : preferredCategories // ignore: cast_nullable_to_non_nullable
              as List<String>,
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
      preferredTimeSlots: null == preferredTimeSlots
          ? _value.preferredTimeSlots
          : preferredTimeSlots // ignore: cast_nullable_to_non_nullable
              as List<TimeSlotModel>,
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
      String userId,
      bool isEnabled,
      int intervalDays,
      List<String> preferredCategories,
      double? maxPrice,
      int maxDistanceKm,
      double minRating,
      List<TimeSlotModel> preferredTimeSlots,
      DateTime? lastProposalAt,
      DateTime? nextProposalAt,
      DateTime createdAt,
      DateTime updatedAt});
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
    Object? preferredCategories = null,
    Object? maxPrice = freezed,
    Object? maxDistanceKm = null,
    Object? minRating = null,
    Object? preferredTimeSlots = null,
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
              as int,
      preferredCategories: null == preferredCategories
          ? _value._preferredCategories
          : preferredCategories // ignore: cast_nullable_to_non_nullable
              as List<String>,
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
      preferredTimeSlots: null == preferredTimeSlots
          ? _value._preferredTimeSlots
          : preferredTimeSlots // ignore: cast_nullable_to_non_nullable
              as List<TimeSlotModel>,
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
      required this.userId,
      required this.isEnabled,
      required this.intervalDays,
      final List<String> preferredCategories = const [],
      this.maxPrice,
      required this.maxDistanceKm,
      required this.minRating,
      final List<TimeSlotModel> preferredTimeSlots = const [],
      this.lastProposalAt,
      this.nextProposalAt,
      required this.createdAt,
      required this.updatedAt})
      : _preferredCategories = preferredCategories,
        _preferredTimeSlots = preferredTimeSlots;

  factory _$AutoProposalSettingsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AutoProposalSettingsModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final bool isEnabled;
  @override
  final int intervalDays;
  final List<String> _preferredCategories;
  @override
  @JsonKey()
  List<String> get preferredCategories {
    if (_preferredCategories is EqualUnmodifiableListView)
      return _preferredCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_preferredCategories);
  }

  @override
  final double? maxPrice;
  @override
  final int maxDistanceKm;
  @override
  final double minRating;
  final List<TimeSlotModel> _preferredTimeSlots;
  @override
  @JsonKey()
  List<TimeSlotModel> get preferredTimeSlots {
    if (_preferredTimeSlots is EqualUnmodifiableListView)
      return _preferredTimeSlots;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_preferredTimeSlots);
  }

  @override
  final DateTime? lastProposalAt;
  @override
  final DateTime? nextProposalAt;
  @override
  final DateTime createdAt;
  @override
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
      required final String userId,
      required final bool isEnabled,
      required final int intervalDays,
      final List<String> preferredCategories,
      final double? maxPrice,
      required final int maxDistanceKm,
      required final double minRating,
      final List<TimeSlotModel> preferredTimeSlots,
      final DateTime? lastProposalAt,
      final DateTime? nextProposalAt,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$AutoProposalSettingsModelImpl;

  factory _AutoProposalSettingsModel.fromJson(Map<String, dynamic> json) =
      _$AutoProposalSettingsModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  bool get isEnabled;
  @override
  int get intervalDays;
  @override
  List<String> get preferredCategories;
  @override
  double? get maxPrice;
  @override
  int get maxDistanceKm;
  @override
  double get minRating;
  @override
  List<TimeSlotModel> get preferredTimeSlots;
  @override
  DateTime? get lastProposalAt;
  @override
  DateTime? get nextProposalAt;
  @override
  DateTime get createdAt;
  @override
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
  bool? get isEnabled => throw _privateConstructorUsedError;
  int? get intervalDays => throw _privateConstructorUsedError;
  List<String>? get preferredCategories => throw _privateConstructorUsedError;
  double? get maxPrice => throw _privateConstructorUsedError;
  int? get maxDistanceKm => throw _privateConstructorUsedError;
  double? get minRating => throw _privateConstructorUsedError;
  List<TimeSlotModel>? get preferredTimeSlots =>
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
      {bool? isEnabled,
      int? intervalDays,
      List<String>? preferredCategories,
      double? maxPrice,
      int? maxDistanceKm,
      double? minRating,
      List<TimeSlotModel>? preferredTimeSlots});
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
              as int?,
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
              as List<TimeSlotModel>?,
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
      {bool? isEnabled,
      int? intervalDays,
      List<String>? preferredCategories,
      double? maxPrice,
      int? maxDistanceKm,
      double? minRating,
      List<TimeSlotModel>? preferredTimeSlots});
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
              as int?,
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
              as List<TimeSlotModel>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateAutoProposalSettingsDtoImpl
    implements _UpdateAutoProposalSettingsDto {
  const _$UpdateAutoProposalSettingsDtoImpl(
      {this.isEnabled,
      this.intervalDays,
      final List<String>? preferredCategories,
      this.maxPrice,
      this.maxDistanceKm,
      this.minRating,
      final List<TimeSlotModel>? preferredTimeSlots})
      : _preferredCategories = preferredCategories,
        _preferredTimeSlots = preferredTimeSlots;

  factory _$UpdateAutoProposalSettingsDtoImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$UpdateAutoProposalSettingsDtoImplFromJson(json);

  @override
  final bool? isEnabled;
  @override
  final int? intervalDays;
  final List<String>? _preferredCategories;
  @override
  List<String>? get preferredCategories {
    final value = _preferredCategories;
    if (value == null) return null;
    if (_preferredCategories is EqualUnmodifiableListView)
      return _preferredCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final double? maxPrice;
  @override
  final int? maxDistanceKm;
  @override
  final double? minRating;
  final List<TimeSlotModel>? _preferredTimeSlots;
  @override
  List<TimeSlotModel>? get preferredTimeSlots {
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
          {final bool? isEnabled,
          final int? intervalDays,
          final List<String>? preferredCategories,
          final double? maxPrice,
          final int? maxDistanceKm,
          final double? minRating,
          final List<TimeSlotModel>? preferredTimeSlots}) =
      _$UpdateAutoProposalSettingsDtoImpl;

  factory _UpdateAutoProposalSettingsDto.fromJson(Map<String, dynamic> json) =
      _$UpdateAutoProposalSettingsDtoImpl.fromJson;

  @override
  bool? get isEnabled;
  @override
  int? get intervalDays;
  @override
  List<String>? get preferredCategories;
  @override
  double? get maxPrice;
  @override
  int? get maxDistanceKm;
  @override
  double? get minRating;
  @override
  List<TimeSlotModel>? get preferredTimeSlots;

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
  @JsonKey(name: 'preferred_datetime')
  String? get preferredDatetime => throw _privateConstructorUsedError;
  String? get comment => throw _privateConstructorUsedError;

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
      {@JsonKey(name: 'preferred_datetime') String? preferredDatetime,
      String? comment});
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
    Object? preferredDatetime = freezed,
    Object? comment = freezed,
  }) {
    return _then(_value.copyWith(
      preferredDatetime: freezed == preferredDatetime
          ? _value.preferredDatetime
          : preferredDatetime // ignore: cast_nullable_to_non_nullable
              as String?,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
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
      {@JsonKey(name: 'preferred_datetime') String? preferredDatetime,
      String? comment});
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
    Object? preferredDatetime = freezed,
    Object? comment = freezed,
  }) {
    return _then(_$AcceptProposalDtoImpl(
      preferredDatetime: freezed == preferredDatetime
          ? _value.preferredDatetime
          : preferredDatetime // ignore: cast_nullable_to_non_nullable
              as String?,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AcceptProposalDtoImpl implements _AcceptProposalDto {
  const _$AcceptProposalDtoImpl(
      {@JsonKey(name: 'preferred_datetime') this.preferredDatetime,
      this.comment});

  factory _$AcceptProposalDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AcceptProposalDtoImplFromJson(json);

  @override
  @JsonKey(name: 'preferred_datetime')
  final String? preferredDatetime;
  @override
  final String? comment;

  @override
  String toString() {
    return 'AcceptProposalDto(preferredDatetime: $preferredDatetime, comment: $comment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AcceptProposalDtoImpl &&
            (identical(other.preferredDatetime, preferredDatetime) ||
                other.preferredDatetime == preferredDatetime) &&
            (identical(other.comment, comment) || other.comment == comment));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, preferredDatetime, comment);

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
      {@JsonKey(name: 'preferred_datetime') final String? preferredDatetime,
      final String? comment}) = _$AcceptProposalDtoImpl;

  factory _AcceptProposalDto.fromJson(Map<String, dynamic> json) =
      _$AcceptProposalDtoImpl.fromJson;

  @override
  @JsonKey(name: 'preferred_datetime')
  String? get preferredDatetime;
  @override
  String? get comment;

  /// Create a copy of AcceptProposalDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AcceptProposalDtoImplCopyWith<_$AcceptProposalDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AutoProposalModel _$AutoProposalModelFromJson(Map<String, dynamic> json) {
  return _AutoProposalModel.fromJson(json);
}

/// @nodoc
mixin _$AutoProposalModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get masterId => throw _privateConstructorUsedError;
  String get serviceId => throw _privateConstructorUsedError;
  String get categoryId => throw _privateConstructorUsedError;
  ProposalStatus get status => throw _privateConstructorUsedError;
  int get matchScore => throw _privateConstructorUsedError;
  MatchReasonsModel get matchReasons => throw _privateConstructorUsedError;
  DateTime? get proposedDatetime => throw _privateConstructorUsedError;
  DateTime get expiresAt => throw _privateConstructorUsedError;
  String? get bookingId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  ProposalMasterModel? get master => throw _privateConstructorUsedError;
  ProposalServiceModel? get service => throw _privateConstructorUsedError;

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
      String userId,
      String masterId,
      String serviceId,
      String categoryId,
      ProposalStatus status,
      int matchScore,
      MatchReasonsModel matchReasons,
      DateTime? proposedDatetime,
      DateTime expiresAt,
      String? bookingId,
      DateTime createdAt,
      ProposalMasterModel? master,
      ProposalServiceModel? service});

  $MatchReasonsModelCopyWith<$Res> get matchReasons;
  $ProposalMasterModelCopyWith<$Res>? get master;
  $ProposalServiceModelCopyWith<$Res>? get service;
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
              as MatchReasonsModel,
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
              as ProposalMasterModel?,
      service: freezed == service
          ? _value.service
          : service // ignore: cast_nullable_to_non_nullable
              as ProposalServiceModel?,
    ) as $Val);
  }

  /// Create a copy of AutoProposalModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MatchReasonsModelCopyWith<$Res> get matchReasons {
    return $MatchReasonsModelCopyWith<$Res>(_value.matchReasons, (value) {
      return _then(_value.copyWith(matchReasons: value) as $Val);
    });
  }

  /// Create a copy of AutoProposalModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProposalMasterModelCopyWith<$Res>? get master {
    if (_value.master == null) {
      return null;
    }

    return $ProposalMasterModelCopyWith<$Res>(_value.master!, (value) {
      return _then(_value.copyWith(master: value) as $Val);
    });
  }

  /// Create a copy of AutoProposalModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProposalServiceModelCopyWith<$Res>? get service {
    if (_value.service == null) {
      return null;
    }

    return $ProposalServiceModelCopyWith<$Res>(_value.service!, (value) {
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
      String userId,
      String masterId,
      String serviceId,
      String categoryId,
      ProposalStatus status,
      int matchScore,
      MatchReasonsModel matchReasons,
      DateTime? proposedDatetime,
      DateTime expiresAt,
      String? bookingId,
      DateTime createdAt,
      ProposalMasterModel? master,
      ProposalServiceModel? service});

  @override
  $MatchReasonsModelCopyWith<$Res> get matchReasons;
  @override
  $ProposalMasterModelCopyWith<$Res>? get master;
  @override
  $ProposalServiceModelCopyWith<$Res>? get service;
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
              as MatchReasonsModel,
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
              as ProposalMasterModel?,
      service: freezed == service
          ? _value.service
          : service // ignore: cast_nullable_to_non_nullable
              as ProposalServiceModel?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AutoProposalModelImpl implements _AutoProposalModel {
  const _$AutoProposalModelImpl(
      {required this.id,
      required this.userId,
      required this.masterId,
      required this.serviceId,
      required this.categoryId,
      required this.status,
      required this.matchScore,
      required this.matchReasons,
      this.proposedDatetime,
      required this.expiresAt,
      this.bookingId,
      required this.createdAt,
      this.master,
      this.service});

  factory _$AutoProposalModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AutoProposalModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String masterId;
  @override
  final String serviceId;
  @override
  final String categoryId;
  @override
  final ProposalStatus status;
  @override
  final int matchScore;
  @override
  final MatchReasonsModel matchReasons;
  @override
  final DateTime? proposedDatetime;
  @override
  final DateTime expiresAt;
  @override
  final String? bookingId;
  @override
  final DateTime createdAt;
  @override
  final ProposalMasterModel? master;
  @override
  final ProposalServiceModel? service;

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
      required final String userId,
      required final String masterId,
      required final String serviceId,
      required final String categoryId,
      required final ProposalStatus status,
      required final int matchScore,
      required final MatchReasonsModel matchReasons,
      final DateTime? proposedDatetime,
      required final DateTime expiresAt,
      final String? bookingId,
      required final DateTime createdAt,
      final ProposalMasterModel? master,
      final ProposalServiceModel? service}) = _$AutoProposalModelImpl;

  factory _AutoProposalModel.fromJson(Map<String, dynamic> json) =
      _$AutoProposalModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get masterId;
  @override
  String get serviceId;
  @override
  String get categoryId;
  @override
  ProposalStatus get status;
  @override
  int get matchScore;
  @override
  MatchReasonsModel get matchReasons;
  @override
  DateTime? get proposedDatetime;
  @override
  DateTime get expiresAt;
  @override
  String? get bookingId;
  @override
  DateTime get createdAt;
  @override
  ProposalMasterModel? get master;
  @override
  ProposalServiceModel? get service;

  /// Create a copy of AutoProposalModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AutoProposalModelImplCopyWith<_$AutoProposalModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
