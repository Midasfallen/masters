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
    required String userId,
    required SubscriptionTier tier,
    required SubscriptionStatus status,
    required BillingPeriod billingPeriod,
    required double priceAmount,
    @Default('RUB') String currencyCode,
    required DateTime startedAt,
    DateTime? expiresAt,
    DateTime? cancelledAt,
    @Default(true) bool autoRenew,
    String? paymentMethod,
    required DateTime createdAt,
    required DateTime updatedAt,
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
    required double monthlyPrice,
    required double yearlyPrice,
    @Default(0) int yearlyDiscountPercent,
    @Default(false) bool isPopular,
    @Default(true) bool isActive,
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
