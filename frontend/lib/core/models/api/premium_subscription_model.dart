import 'package:freezed_annotation/freezed_annotation.dart';

part 'premium_subscription_model.freezed.dart';
part 'premium_subscription_model.g.dart';

/// Тип премиум-подписки
enum SubscriptionTier {
  @JsonValue('free')
  free,
  @JsonValue('basic')
  basic,
  @JsonValue('premium')
  premium,
  @JsonValue('pro')
  pro,
}

/// Статус подписки
enum SubscriptionStatus {
  @JsonValue('active')
  active,
  @JsonValue('cancelled')
  cancelled,
  @JsonValue('expired')
  expired,
  @JsonValue('trial')
  trial,
}

/// Период оплаты
enum BillingPeriod {
  @JsonValue('monthly')
  monthly,
  @JsonValue('yearly')
  yearly,
}

/// Премиум-подписка пользователя
@freezed
class PremiumSubscriptionModel with _$PremiumSubscriptionModel {
  const factory PremiumSubscriptionModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required SubscriptionTier tier,
    required SubscriptionStatus status,
    @JsonKey(name: 'billing_period') required BillingPeriod billingPeriod,
    @JsonKey(name: 'price_amount') required double priceAmount,
    @JsonKey(name: 'currency_code') @Default('RUB') String currencyCode,
    @JsonKey(name: 'started_at') required DateTime startedAt,
    @JsonKey(name: 'expires_at') DateTime? expiresAt,
    @JsonKey(name: 'cancelled_at') DateTime? cancelledAt,
    @JsonKey(name: 'auto_renew') @Default(true) bool autoRenew,
    @JsonKey(name: 'payment_method') String? paymentMethod,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _PremiumSubscriptionModel;

  factory PremiumSubscriptionModel.fromJson(Map<String, dynamic> json) =>
      _$PremiumSubscriptionModelFromJson(json);
}

/// План подписки (pricing)
@freezed
class SubscriptionPlanModel with _$SubscriptionPlanModel {
  const factory SubscriptionPlanModel({
    required String id,
    required SubscriptionTier tier,
    required String name,
    required String description,
    required List<String> features,
    @JsonKey(name: 'monthly_price') required double monthlyPrice,
    @JsonKey(name: 'yearly_price') required double yearlyPrice,
    @JsonKey(name: 'yearly_discount_percent') @Default(0) int yearlyDiscountPercent,
    @JsonKey(name: 'is_popular') @Default(false) bool isPopular,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _SubscriptionPlanModel;

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionPlanModelFromJson(json);
}

/// DTO для создания подписки
@freezed
class CreateSubscriptionDto with _$CreateSubscriptionDto {
  const factory CreateSubscriptionDto({
    required SubscriptionTier tier,
    required BillingPeriod billingPeriod,
    @JsonKey(name: 'payment_method') String? paymentMethod,
  }) = _CreateSubscriptionDto;

  factory CreateSubscriptionDto.fromJson(Map<String, dynamic> json) =>
      _$CreateSubscriptionDtoFromJson(json);
}

/// DTO для обновления подписки
@freezed
class UpdateSubscriptionDto with _$UpdateSubscriptionDto {
  const factory UpdateSubscriptionDto({
    @JsonKey(name: 'auto_renew') bool? autoRenew,
    @JsonKey(name: 'payment_method') String? paymentMethod,
  }) = _UpdateSubscriptionDto;

  factory UpdateSubscriptionDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateSubscriptionDtoFromJson(json);
}
