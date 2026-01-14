// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'premium_subscription_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PremiumSubscriptionModel _$PremiumSubscriptionModelFromJson(
    Map<String, dynamic> json) {
  return _PremiumSubscriptionModel.fromJson(json);
}

/// @nodoc
mixin _$PremiumSubscriptionModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  SubscriptionTier get tier => throw _privateConstructorUsedError;
  SubscriptionStatus get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'billing_period')
  BillingPeriod get billingPeriod => throw _privateConstructorUsedError;
  @JsonKey(name: 'price_amount')
  double get priceAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'currency_code')
  String get currencyCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'started_at')
  DateTime get startedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'expires_at')
  DateTime? get expiresAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'cancelled_at')
  DateTime? get cancelledAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'auto_renew')
  bool get autoRenew => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_method')
  String? get paymentMethod => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this PremiumSubscriptionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PremiumSubscriptionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PremiumSubscriptionModelCopyWith<PremiumSubscriptionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PremiumSubscriptionModelCopyWith<$Res> {
  factory $PremiumSubscriptionModelCopyWith(PremiumSubscriptionModel value,
          $Res Function(PremiumSubscriptionModel) then) =
      _$PremiumSubscriptionModelCopyWithImpl<$Res, PremiumSubscriptionModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      SubscriptionTier tier,
      SubscriptionStatus status,
      @JsonKey(name: 'billing_period') BillingPeriod billingPeriod,
      @JsonKey(name: 'price_amount') double priceAmount,
      @JsonKey(name: 'currency_code') String currencyCode,
      @JsonKey(name: 'started_at') DateTime startedAt,
      @JsonKey(name: 'expires_at') DateTime? expiresAt,
      @JsonKey(name: 'cancelled_at') DateTime? cancelledAt,
      @JsonKey(name: 'auto_renew') bool autoRenew,
      @JsonKey(name: 'payment_method') String? paymentMethod,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class _$PremiumSubscriptionModelCopyWithImpl<$Res,
        $Val extends PremiumSubscriptionModel>
    implements $PremiumSubscriptionModelCopyWith<$Res> {
  _$PremiumSubscriptionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PremiumSubscriptionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? tier = null,
    Object? status = null,
    Object? billingPeriod = null,
    Object? priceAmount = null,
    Object? currencyCode = null,
    Object? startedAt = null,
    Object? expiresAt = freezed,
    Object? cancelledAt = freezed,
    Object? autoRenew = null,
    Object? paymentMethod = freezed,
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
      tier: null == tier
          ? _value.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as SubscriptionTier,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as SubscriptionStatus,
      billingPeriod: null == billingPeriod
          ? _value.billingPeriod
          : billingPeriod // ignore: cast_nullable_to_non_nullable
              as BillingPeriod,
      priceAmount: null == priceAmount
          ? _value.priceAmount
          : priceAmount // ignore: cast_nullable_to_non_nullable
              as double,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      cancelledAt: freezed == cancelledAt
          ? _value.cancelledAt
          : cancelledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      autoRenew: null == autoRenew
          ? _value.autoRenew
          : autoRenew // ignore: cast_nullable_to_non_nullable
              as bool,
      paymentMethod: freezed == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String?,
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
abstract class _$$PremiumSubscriptionModelImplCopyWith<$Res>
    implements $PremiumSubscriptionModelCopyWith<$Res> {
  factory _$$PremiumSubscriptionModelImplCopyWith(
          _$PremiumSubscriptionModelImpl value,
          $Res Function(_$PremiumSubscriptionModelImpl) then) =
      __$$PremiumSubscriptionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      SubscriptionTier tier,
      SubscriptionStatus status,
      @JsonKey(name: 'billing_period') BillingPeriod billingPeriod,
      @JsonKey(name: 'price_amount') double priceAmount,
      @JsonKey(name: 'currency_code') String currencyCode,
      @JsonKey(name: 'started_at') DateTime startedAt,
      @JsonKey(name: 'expires_at') DateTime? expiresAt,
      @JsonKey(name: 'cancelled_at') DateTime? cancelledAt,
      @JsonKey(name: 'auto_renew') bool autoRenew,
      @JsonKey(name: 'payment_method') String? paymentMethod,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class __$$PremiumSubscriptionModelImplCopyWithImpl<$Res>
    extends _$PremiumSubscriptionModelCopyWithImpl<$Res,
        _$PremiumSubscriptionModelImpl>
    implements _$$PremiumSubscriptionModelImplCopyWith<$Res> {
  __$$PremiumSubscriptionModelImplCopyWithImpl(
      _$PremiumSubscriptionModelImpl _value,
      $Res Function(_$PremiumSubscriptionModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of PremiumSubscriptionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? tier = null,
    Object? status = null,
    Object? billingPeriod = null,
    Object? priceAmount = null,
    Object? currencyCode = null,
    Object? startedAt = null,
    Object? expiresAt = freezed,
    Object? cancelledAt = freezed,
    Object? autoRenew = null,
    Object? paymentMethod = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$PremiumSubscriptionModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      tier: null == tier
          ? _value.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as SubscriptionTier,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as SubscriptionStatus,
      billingPeriod: null == billingPeriod
          ? _value.billingPeriod
          : billingPeriod // ignore: cast_nullable_to_non_nullable
              as BillingPeriod,
      priceAmount: null == priceAmount
          ? _value.priceAmount
          : priceAmount // ignore: cast_nullable_to_non_nullable
              as double,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      cancelledAt: freezed == cancelledAt
          ? _value.cancelledAt
          : cancelledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      autoRenew: null == autoRenew
          ? _value.autoRenew
          : autoRenew // ignore: cast_nullable_to_non_nullable
              as bool,
      paymentMethod: freezed == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String?,
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
class _$PremiumSubscriptionModelImpl implements _PremiumSubscriptionModel {
  const _$PremiumSubscriptionModelImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      required this.tier,
      required this.status,
      @JsonKey(name: 'billing_period') required this.billingPeriod,
      @JsonKey(name: 'price_amount') required this.priceAmount,
      @JsonKey(name: 'currency_code') this.currencyCode = 'RUB',
      @JsonKey(name: 'started_at') required this.startedAt,
      @JsonKey(name: 'expires_at') this.expiresAt,
      @JsonKey(name: 'cancelled_at') this.cancelledAt,
      @JsonKey(name: 'auto_renew') this.autoRenew = true,
      @JsonKey(name: 'payment_method') this.paymentMethod,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt});

  factory _$PremiumSubscriptionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PremiumSubscriptionModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final SubscriptionTier tier;
  @override
  final SubscriptionStatus status;
  @override
  @JsonKey(name: 'billing_period')
  final BillingPeriod billingPeriod;
  @override
  @JsonKey(name: 'price_amount')
  final double priceAmount;
  @override
  @JsonKey(name: 'currency_code')
  final String currencyCode;
  @override
  @JsonKey(name: 'started_at')
  final DateTime startedAt;
  @override
  @JsonKey(name: 'expires_at')
  final DateTime? expiresAt;
  @override
  @JsonKey(name: 'cancelled_at')
  final DateTime? cancelledAt;
  @override
  @JsonKey(name: 'auto_renew')
  final bool autoRenew;
  @override
  @JsonKey(name: 'payment_method')
  final String? paymentMethod;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'PremiumSubscriptionModel(id: $id, userId: $userId, tier: $tier, status: $status, billingPeriod: $billingPeriod, priceAmount: $priceAmount, currencyCode: $currencyCode, startedAt: $startedAt, expiresAt: $expiresAt, cancelledAt: $cancelledAt, autoRenew: $autoRenew, paymentMethod: $paymentMethod, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PremiumSubscriptionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.tier, tier) || other.tier == tier) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.billingPeriod, billingPeriod) ||
                other.billingPeriod == billingPeriod) &&
            (identical(other.priceAmount, priceAmount) ||
                other.priceAmount == priceAmount) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.cancelledAt, cancelledAt) ||
                other.cancelledAt == cancelledAt) &&
            (identical(other.autoRenew, autoRenew) ||
                other.autoRenew == autoRenew) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
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
      tier,
      status,
      billingPeriod,
      priceAmount,
      currencyCode,
      startedAt,
      expiresAt,
      cancelledAt,
      autoRenew,
      paymentMethod,
      createdAt,
      updatedAt);

  /// Create a copy of PremiumSubscriptionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PremiumSubscriptionModelImplCopyWith<_$PremiumSubscriptionModelImpl>
      get copyWith => __$$PremiumSubscriptionModelImplCopyWithImpl<
          _$PremiumSubscriptionModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PremiumSubscriptionModelImplToJson(
      this,
    );
  }
}

abstract class _PremiumSubscriptionModel implements PremiumSubscriptionModel {
  const factory _PremiumSubscriptionModel(
          {required final String id,
          @JsonKey(name: 'user_id') required final String userId,
          required final SubscriptionTier tier,
          required final SubscriptionStatus status,
          @JsonKey(name: 'billing_period')
          required final BillingPeriod billingPeriod,
          @JsonKey(name: 'price_amount') required final double priceAmount,
          @JsonKey(name: 'currency_code') final String currencyCode,
          @JsonKey(name: 'started_at') required final DateTime startedAt,
          @JsonKey(name: 'expires_at') final DateTime? expiresAt,
          @JsonKey(name: 'cancelled_at') final DateTime? cancelledAt,
          @JsonKey(name: 'auto_renew') final bool autoRenew,
          @JsonKey(name: 'payment_method') final String? paymentMethod,
          @JsonKey(name: 'created_at') required final DateTime createdAt,
          @JsonKey(name: 'updated_at') required final DateTime updatedAt}) =
      _$PremiumSubscriptionModelImpl;

  factory _PremiumSubscriptionModel.fromJson(Map<String, dynamic> json) =
      _$PremiumSubscriptionModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  SubscriptionTier get tier;
  @override
  SubscriptionStatus get status;
  @override
  @JsonKey(name: 'billing_period')
  BillingPeriod get billingPeriod;
  @override
  @JsonKey(name: 'price_amount')
  double get priceAmount;
  @override
  @JsonKey(name: 'currency_code')
  String get currencyCode;
  @override
  @JsonKey(name: 'started_at')
  DateTime get startedAt;
  @override
  @JsonKey(name: 'expires_at')
  DateTime? get expiresAt;
  @override
  @JsonKey(name: 'cancelled_at')
  DateTime? get cancelledAt;
  @override
  @JsonKey(name: 'auto_renew')
  bool get autoRenew;
  @override
  @JsonKey(name: 'payment_method')
  String? get paymentMethod;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of PremiumSubscriptionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PremiumSubscriptionModelImplCopyWith<_$PremiumSubscriptionModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

SubscriptionPlanModel _$SubscriptionPlanModelFromJson(
    Map<String, dynamic> json) {
  return _SubscriptionPlanModel.fromJson(json);
}

/// @nodoc
mixin _$SubscriptionPlanModel {
  String get id => throw _privateConstructorUsedError;
  SubscriptionTier get tier => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<String> get features => throw _privateConstructorUsedError;
  @JsonKey(name: 'monthly_price')
  double get monthlyPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'yearly_price')
  double get yearlyPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'yearly_discount_percent')
  int get yearlyDiscountPercent => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_popular')
  bool get isPopular => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this SubscriptionPlanModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SubscriptionPlanModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubscriptionPlanModelCopyWith<SubscriptionPlanModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubscriptionPlanModelCopyWith<$Res> {
  factory $SubscriptionPlanModelCopyWith(SubscriptionPlanModel value,
          $Res Function(SubscriptionPlanModel) then) =
      _$SubscriptionPlanModelCopyWithImpl<$Res, SubscriptionPlanModel>;
  @useResult
  $Res call(
      {String id,
      SubscriptionTier tier,
      String name,
      String description,
      List<String> features,
      @JsonKey(name: 'monthly_price') double monthlyPrice,
      @JsonKey(name: 'yearly_price') double yearlyPrice,
      @JsonKey(name: 'yearly_discount_percent') int yearlyDiscountPercent,
      @JsonKey(name: 'is_popular') bool isPopular,
      @JsonKey(name: 'is_active') bool isActive});
}

/// @nodoc
class _$SubscriptionPlanModelCopyWithImpl<$Res,
        $Val extends SubscriptionPlanModel>
    implements $SubscriptionPlanModelCopyWith<$Res> {
  _$SubscriptionPlanModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubscriptionPlanModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tier = null,
    Object? name = null,
    Object? description = null,
    Object? features = null,
    Object? monthlyPrice = null,
    Object? yearlyPrice = null,
    Object? yearlyDiscountPercent = null,
    Object? isPopular = null,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      tier: null == tier
          ? _value.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as SubscriptionTier,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      features: null == features
          ? _value.features
          : features // ignore: cast_nullable_to_non_nullable
              as List<String>,
      monthlyPrice: null == monthlyPrice
          ? _value.monthlyPrice
          : monthlyPrice // ignore: cast_nullable_to_non_nullable
              as double,
      yearlyPrice: null == yearlyPrice
          ? _value.yearlyPrice
          : yearlyPrice // ignore: cast_nullable_to_non_nullable
              as double,
      yearlyDiscountPercent: null == yearlyDiscountPercent
          ? _value.yearlyDiscountPercent
          : yearlyDiscountPercent // ignore: cast_nullable_to_non_nullable
              as int,
      isPopular: null == isPopular
          ? _value.isPopular
          : isPopular // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SubscriptionPlanModelImplCopyWith<$Res>
    implements $SubscriptionPlanModelCopyWith<$Res> {
  factory _$$SubscriptionPlanModelImplCopyWith(
          _$SubscriptionPlanModelImpl value,
          $Res Function(_$SubscriptionPlanModelImpl) then) =
      __$$SubscriptionPlanModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      SubscriptionTier tier,
      String name,
      String description,
      List<String> features,
      @JsonKey(name: 'monthly_price') double monthlyPrice,
      @JsonKey(name: 'yearly_price') double yearlyPrice,
      @JsonKey(name: 'yearly_discount_percent') int yearlyDiscountPercent,
      @JsonKey(name: 'is_popular') bool isPopular,
      @JsonKey(name: 'is_active') bool isActive});
}

/// @nodoc
class __$$SubscriptionPlanModelImplCopyWithImpl<$Res>
    extends _$SubscriptionPlanModelCopyWithImpl<$Res,
        _$SubscriptionPlanModelImpl>
    implements _$$SubscriptionPlanModelImplCopyWith<$Res> {
  __$$SubscriptionPlanModelImplCopyWithImpl(_$SubscriptionPlanModelImpl _value,
      $Res Function(_$SubscriptionPlanModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SubscriptionPlanModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tier = null,
    Object? name = null,
    Object? description = null,
    Object? features = null,
    Object? monthlyPrice = null,
    Object? yearlyPrice = null,
    Object? yearlyDiscountPercent = null,
    Object? isPopular = null,
    Object? isActive = null,
  }) {
    return _then(_$SubscriptionPlanModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      tier: null == tier
          ? _value.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as SubscriptionTier,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      features: null == features
          ? _value._features
          : features // ignore: cast_nullable_to_non_nullable
              as List<String>,
      monthlyPrice: null == monthlyPrice
          ? _value.monthlyPrice
          : monthlyPrice // ignore: cast_nullable_to_non_nullable
              as double,
      yearlyPrice: null == yearlyPrice
          ? _value.yearlyPrice
          : yearlyPrice // ignore: cast_nullable_to_non_nullable
              as double,
      yearlyDiscountPercent: null == yearlyDiscountPercent
          ? _value.yearlyDiscountPercent
          : yearlyDiscountPercent // ignore: cast_nullable_to_non_nullable
              as int,
      isPopular: null == isPopular
          ? _value.isPopular
          : isPopular // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SubscriptionPlanModelImpl implements _SubscriptionPlanModel {
  const _$SubscriptionPlanModelImpl(
      {required this.id,
      required this.tier,
      required this.name,
      required this.description,
      required final List<String> features,
      @JsonKey(name: 'monthly_price') required this.monthlyPrice,
      @JsonKey(name: 'yearly_price') required this.yearlyPrice,
      @JsonKey(name: 'yearly_discount_percent') this.yearlyDiscountPercent = 0,
      @JsonKey(name: 'is_popular') this.isPopular = false,
      @JsonKey(name: 'is_active') this.isActive = true})
      : _features = features;

  factory _$SubscriptionPlanModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubscriptionPlanModelImplFromJson(json);

  @override
  final String id;
  @override
  final SubscriptionTier tier;
  @override
  final String name;
  @override
  final String description;
  final List<String> _features;
  @override
  List<String> get features {
    if (_features is EqualUnmodifiableListView) return _features;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_features);
  }

  @override
  @JsonKey(name: 'monthly_price')
  final double monthlyPrice;
  @override
  @JsonKey(name: 'yearly_price')
  final double yearlyPrice;
  @override
  @JsonKey(name: 'yearly_discount_percent')
  final int yearlyDiscountPercent;
  @override
  @JsonKey(name: 'is_popular')
  final bool isPopular;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;

  @override
  String toString() {
    return 'SubscriptionPlanModel(id: $id, tier: $tier, name: $name, description: $description, features: $features, monthlyPrice: $monthlyPrice, yearlyPrice: $yearlyPrice, yearlyDiscountPercent: $yearlyDiscountPercent, isPopular: $isPopular, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubscriptionPlanModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tier, tier) || other.tier == tier) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._features, _features) &&
            (identical(other.monthlyPrice, monthlyPrice) ||
                other.monthlyPrice == monthlyPrice) &&
            (identical(other.yearlyPrice, yearlyPrice) ||
                other.yearlyPrice == yearlyPrice) &&
            (identical(other.yearlyDiscountPercent, yearlyDiscountPercent) ||
                other.yearlyDiscountPercent == yearlyDiscountPercent) &&
            (identical(other.isPopular, isPopular) ||
                other.isPopular == isPopular) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      tier,
      name,
      description,
      const DeepCollectionEquality().hash(_features),
      monthlyPrice,
      yearlyPrice,
      yearlyDiscountPercent,
      isPopular,
      isActive);

  /// Create a copy of SubscriptionPlanModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubscriptionPlanModelImplCopyWith<_$SubscriptionPlanModelImpl>
      get copyWith => __$$SubscriptionPlanModelImplCopyWithImpl<
          _$SubscriptionPlanModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubscriptionPlanModelImplToJson(
      this,
    );
  }
}

abstract class _SubscriptionPlanModel implements SubscriptionPlanModel {
  const factory _SubscriptionPlanModel(
      {required final String id,
      required final SubscriptionTier tier,
      required final String name,
      required final String description,
      required final List<String> features,
      @JsonKey(name: 'monthly_price') required final double monthlyPrice,
      @JsonKey(name: 'yearly_price') required final double yearlyPrice,
      @JsonKey(name: 'yearly_discount_percent') final int yearlyDiscountPercent,
      @JsonKey(name: 'is_popular') final bool isPopular,
      @JsonKey(name: 'is_active')
      final bool isActive}) = _$SubscriptionPlanModelImpl;

  factory _SubscriptionPlanModel.fromJson(Map<String, dynamic> json) =
      _$SubscriptionPlanModelImpl.fromJson;

  @override
  String get id;
  @override
  SubscriptionTier get tier;
  @override
  String get name;
  @override
  String get description;
  @override
  List<String> get features;
  @override
  @JsonKey(name: 'monthly_price')
  double get monthlyPrice;
  @override
  @JsonKey(name: 'yearly_price')
  double get yearlyPrice;
  @override
  @JsonKey(name: 'yearly_discount_percent')
  int get yearlyDiscountPercent;
  @override
  @JsonKey(name: 'is_popular')
  bool get isPopular;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;

  /// Create a copy of SubscriptionPlanModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubscriptionPlanModelImplCopyWith<_$SubscriptionPlanModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

CreateSubscriptionDto _$CreateSubscriptionDtoFromJson(
    Map<String, dynamic> json) {
  return _CreateSubscriptionDto.fromJson(json);
}

/// @nodoc
mixin _$CreateSubscriptionDto {
  SubscriptionTier get tier => throw _privateConstructorUsedError;
  BillingPeriod get billingPeriod => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_method')
  String? get paymentMethod => throw _privateConstructorUsedError;

  /// Serializes this CreateSubscriptionDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateSubscriptionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateSubscriptionDtoCopyWith<CreateSubscriptionDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateSubscriptionDtoCopyWith<$Res> {
  factory $CreateSubscriptionDtoCopyWith(CreateSubscriptionDto value,
          $Res Function(CreateSubscriptionDto) then) =
      _$CreateSubscriptionDtoCopyWithImpl<$Res, CreateSubscriptionDto>;
  @useResult
  $Res call(
      {SubscriptionTier tier,
      BillingPeriod billingPeriod,
      @JsonKey(name: 'payment_method') String? paymentMethod});
}

/// @nodoc
class _$CreateSubscriptionDtoCopyWithImpl<$Res,
        $Val extends CreateSubscriptionDto>
    implements $CreateSubscriptionDtoCopyWith<$Res> {
  _$CreateSubscriptionDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateSubscriptionDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tier = null,
    Object? billingPeriod = null,
    Object? paymentMethod = freezed,
  }) {
    return _then(_value.copyWith(
      tier: null == tier
          ? _value.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as SubscriptionTier,
      billingPeriod: null == billingPeriod
          ? _value.billingPeriod
          : billingPeriod // ignore: cast_nullable_to_non_nullable
              as BillingPeriod,
      paymentMethod: freezed == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateSubscriptionDtoImplCopyWith<$Res>
    implements $CreateSubscriptionDtoCopyWith<$Res> {
  factory _$$CreateSubscriptionDtoImplCopyWith(
          _$CreateSubscriptionDtoImpl value,
          $Res Function(_$CreateSubscriptionDtoImpl) then) =
      __$$CreateSubscriptionDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {SubscriptionTier tier,
      BillingPeriod billingPeriod,
      @JsonKey(name: 'payment_method') String? paymentMethod});
}

/// @nodoc
class __$$CreateSubscriptionDtoImplCopyWithImpl<$Res>
    extends _$CreateSubscriptionDtoCopyWithImpl<$Res,
        _$CreateSubscriptionDtoImpl>
    implements _$$CreateSubscriptionDtoImplCopyWith<$Res> {
  __$$CreateSubscriptionDtoImplCopyWithImpl(_$CreateSubscriptionDtoImpl _value,
      $Res Function(_$CreateSubscriptionDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateSubscriptionDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tier = null,
    Object? billingPeriod = null,
    Object? paymentMethod = freezed,
  }) {
    return _then(_$CreateSubscriptionDtoImpl(
      tier: null == tier
          ? _value.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as SubscriptionTier,
      billingPeriod: null == billingPeriod
          ? _value.billingPeriod
          : billingPeriod // ignore: cast_nullable_to_non_nullable
              as BillingPeriod,
      paymentMethod: freezed == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateSubscriptionDtoImpl implements _CreateSubscriptionDto {
  const _$CreateSubscriptionDtoImpl(
      {required this.tier,
      required this.billingPeriod,
      @JsonKey(name: 'payment_method') this.paymentMethod});

  factory _$CreateSubscriptionDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateSubscriptionDtoImplFromJson(json);

  @override
  final SubscriptionTier tier;
  @override
  final BillingPeriod billingPeriod;
  @override
  @JsonKey(name: 'payment_method')
  final String? paymentMethod;

  @override
  String toString() {
    return 'CreateSubscriptionDto(tier: $tier, billingPeriod: $billingPeriod, paymentMethod: $paymentMethod)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateSubscriptionDtoImpl &&
            (identical(other.tier, tier) || other.tier == tier) &&
            (identical(other.billingPeriod, billingPeriod) ||
                other.billingPeriod == billingPeriod) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, tier, billingPeriod, paymentMethod);

  /// Create a copy of CreateSubscriptionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateSubscriptionDtoImplCopyWith<_$CreateSubscriptionDtoImpl>
      get copyWith => __$$CreateSubscriptionDtoImplCopyWithImpl<
          _$CreateSubscriptionDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateSubscriptionDtoImplToJson(
      this,
    );
  }
}

abstract class _CreateSubscriptionDto implements CreateSubscriptionDto {
  const factory _CreateSubscriptionDto(
          {required final SubscriptionTier tier,
          required final BillingPeriod billingPeriod,
          @JsonKey(name: 'payment_method') final String? paymentMethod}) =
      _$CreateSubscriptionDtoImpl;

  factory _CreateSubscriptionDto.fromJson(Map<String, dynamic> json) =
      _$CreateSubscriptionDtoImpl.fromJson;

  @override
  SubscriptionTier get tier;
  @override
  BillingPeriod get billingPeriod;
  @override
  @JsonKey(name: 'payment_method')
  String? get paymentMethod;

  /// Create a copy of CreateSubscriptionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateSubscriptionDtoImplCopyWith<_$CreateSubscriptionDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

UpdateSubscriptionDto _$UpdateSubscriptionDtoFromJson(
    Map<String, dynamic> json) {
  return _UpdateSubscriptionDto.fromJson(json);
}

/// @nodoc
mixin _$UpdateSubscriptionDto {
  @JsonKey(name: 'auto_renew')
  bool? get autoRenew => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_method')
  String? get paymentMethod => throw _privateConstructorUsedError;

  /// Serializes this UpdateSubscriptionDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateSubscriptionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateSubscriptionDtoCopyWith<UpdateSubscriptionDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateSubscriptionDtoCopyWith<$Res> {
  factory $UpdateSubscriptionDtoCopyWith(UpdateSubscriptionDto value,
          $Res Function(UpdateSubscriptionDto) then) =
      _$UpdateSubscriptionDtoCopyWithImpl<$Res, UpdateSubscriptionDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'auto_renew') bool? autoRenew,
      @JsonKey(name: 'payment_method') String? paymentMethod});
}

/// @nodoc
class _$UpdateSubscriptionDtoCopyWithImpl<$Res,
        $Val extends UpdateSubscriptionDto>
    implements $UpdateSubscriptionDtoCopyWith<$Res> {
  _$UpdateSubscriptionDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateSubscriptionDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? autoRenew = freezed,
    Object? paymentMethod = freezed,
  }) {
    return _then(_value.copyWith(
      autoRenew: freezed == autoRenew
          ? _value.autoRenew
          : autoRenew // ignore: cast_nullable_to_non_nullable
              as bool?,
      paymentMethod: freezed == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateSubscriptionDtoImplCopyWith<$Res>
    implements $UpdateSubscriptionDtoCopyWith<$Res> {
  factory _$$UpdateSubscriptionDtoImplCopyWith(
          _$UpdateSubscriptionDtoImpl value,
          $Res Function(_$UpdateSubscriptionDtoImpl) then) =
      __$$UpdateSubscriptionDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'auto_renew') bool? autoRenew,
      @JsonKey(name: 'payment_method') String? paymentMethod});
}

/// @nodoc
class __$$UpdateSubscriptionDtoImplCopyWithImpl<$Res>
    extends _$UpdateSubscriptionDtoCopyWithImpl<$Res,
        _$UpdateSubscriptionDtoImpl>
    implements _$$UpdateSubscriptionDtoImplCopyWith<$Res> {
  __$$UpdateSubscriptionDtoImplCopyWithImpl(_$UpdateSubscriptionDtoImpl _value,
      $Res Function(_$UpdateSubscriptionDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateSubscriptionDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? autoRenew = freezed,
    Object? paymentMethod = freezed,
  }) {
    return _then(_$UpdateSubscriptionDtoImpl(
      autoRenew: freezed == autoRenew
          ? _value.autoRenew
          : autoRenew // ignore: cast_nullable_to_non_nullable
              as bool?,
      paymentMethod: freezed == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateSubscriptionDtoImpl implements _UpdateSubscriptionDto {
  const _$UpdateSubscriptionDtoImpl(
      {@JsonKey(name: 'auto_renew') this.autoRenew,
      @JsonKey(name: 'payment_method') this.paymentMethod});

  factory _$UpdateSubscriptionDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateSubscriptionDtoImplFromJson(json);

  @override
  @JsonKey(name: 'auto_renew')
  final bool? autoRenew;
  @override
  @JsonKey(name: 'payment_method')
  final String? paymentMethod;

  @override
  String toString() {
    return 'UpdateSubscriptionDto(autoRenew: $autoRenew, paymentMethod: $paymentMethod)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateSubscriptionDtoImpl &&
            (identical(other.autoRenew, autoRenew) ||
                other.autoRenew == autoRenew) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, autoRenew, paymentMethod);

  /// Create a copy of UpdateSubscriptionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateSubscriptionDtoImplCopyWith<_$UpdateSubscriptionDtoImpl>
      get copyWith => __$$UpdateSubscriptionDtoImplCopyWithImpl<
          _$UpdateSubscriptionDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateSubscriptionDtoImplToJson(
      this,
    );
  }
}

abstract class _UpdateSubscriptionDto implements UpdateSubscriptionDto {
  const factory _UpdateSubscriptionDto(
          {@JsonKey(name: 'auto_renew') final bool? autoRenew,
          @JsonKey(name: 'payment_method') final String? paymentMethod}) =
      _$UpdateSubscriptionDtoImpl;

  factory _UpdateSubscriptionDto.fromJson(Map<String, dynamic> json) =
      _$UpdateSubscriptionDtoImpl.fromJson;

  @override
  @JsonKey(name: 'auto_renew')
  bool? get autoRenew;
  @override
  @JsonKey(name: 'payment_method')
  String? get paymentMethod;

  /// Create a copy of UpdateSubscriptionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateSubscriptionDtoImplCopyWith<_$UpdateSubscriptionDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
