// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'premium_subscription_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PremiumSubscriptionModelImpl _$$PremiumSubscriptionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PremiumSubscriptionModelImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      tier: $enumDecode(_$SubscriptionTierEnumMap, json['tier']),
      status: $enumDecode(_$SubscriptionStatusEnumMap, json['status']),
      billingPeriod:
          $enumDecode(_$BillingPeriodEnumMap, json['billing_period']),
      priceAmount: (json['price_amount'] as num).toDouble(),
      currencyCode: json['currency_code'] as String? ?? 'RUB',
      startedAt: DateTime.parse(json['started_at'] as String),
      expiresAt: json['expires_at'] == null
          ? null
          : DateTime.parse(json['expires_at'] as String),
      cancelledAt: json['cancelled_at'] == null
          ? null
          : DateTime.parse(json['cancelled_at'] as String),
      autoRenew: json['auto_renew'] as bool? ?? true,
      paymentMethod: json['payment_method'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$PremiumSubscriptionModelImplToJson(
        _$PremiumSubscriptionModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'tier': _$SubscriptionTierEnumMap[instance.tier]!,
      'status': _$SubscriptionStatusEnumMap[instance.status]!,
      'billing_period': _$BillingPeriodEnumMap[instance.billingPeriod]!,
      'price_amount': instance.priceAmount,
      'currency_code': instance.currencyCode,
      'started_at': instance.startedAt.toIso8601String(),
      'expires_at': instance.expiresAt?.toIso8601String(),
      'cancelled_at': instance.cancelledAt?.toIso8601String(),
      'auto_renew': instance.autoRenew,
      'payment_method': instance.paymentMethod,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$SubscriptionTierEnumMap = {
  SubscriptionTier.free: 'free',
  SubscriptionTier.basic: 'basic',
  SubscriptionTier.premium: 'premium',
  SubscriptionTier.pro: 'pro',
};

const _$SubscriptionStatusEnumMap = {
  SubscriptionStatus.active: 'active',
  SubscriptionStatus.cancelled: 'cancelled',
  SubscriptionStatus.expired: 'expired',
  SubscriptionStatus.trial: 'trial',
};

const _$BillingPeriodEnumMap = {
  BillingPeriod.monthly: 'monthly',
  BillingPeriod.yearly: 'yearly',
};

_$SubscriptionPlanModelImpl _$$SubscriptionPlanModelImplFromJson(
        Map<String, dynamic> json) =>
    _$SubscriptionPlanModelImpl(
      id: json['id'] as String,
      tier: $enumDecode(_$SubscriptionTierEnumMap, json['tier']),
      name: json['name'] as String,
      description: json['description'] as String,
      features:
          (json['features'] as List<dynamic>).map((e) => e as String).toList(),
      monthlyPrice: (json['monthly_price'] as num).toDouble(),
      yearlyPrice: (json['yearly_price'] as num).toDouble(),
      yearlyDiscountPercent:
          (json['yearly_discount_percent'] as num?)?.toInt() ?? 0,
      isPopular: json['is_popular'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
    );

Map<String, dynamic> _$$SubscriptionPlanModelImplToJson(
        _$SubscriptionPlanModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tier': _$SubscriptionTierEnumMap[instance.tier]!,
      'name': instance.name,
      'description': instance.description,
      'features': instance.features,
      'monthly_price': instance.monthlyPrice,
      'yearly_price': instance.yearlyPrice,
      'yearly_discount_percent': instance.yearlyDiscountPercent,
      'is_popular': instance.isPopular,
      'is_active': instance.isActive,
    };

_$CreateSubscriptionDtoImpl _$$CreateSubscriptionDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateSubscriptionDtoImpl(
      tier: $enumDecode(_$SubscriptionTierEnumMap, json['tier']),
      billingPeriod: $enumDecode(_$BillingPeriodEnumMap, json['billingPeriod']),
      paymentMethod: json['payment_method'] as String?,
    );

Map<String, dynamic> _$$CreateSubscriptionDtoImplToJson(
        _$CreateSubscriptionDtoImpl instance) =>
    <String, dynamic>{
      'tier': _$SubscriptionTierEnumMap[instance.tier]!,
      'billingPeriod': _$BillingPeriodEnumMap[instance.billingPeriod]!,
      'payment_method': instance.paymentMethod,
    };

_$UpdateSubscriptionDtoImpl _$$UpdateSubscriptionDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$UpdateSubscriptionDtoImpl(
      autoRenew: json['auto_renew'] as bool?,
      paymentMethod: json['payment_method'] as String?,
    );

Map<String, dynamic> _$$UpdateSubscriptionDtoImplToJson(
        _$UpdateSubscriptionDtoImpl instance) =>
    <String, dynamic>{
      'auto_renew': instance.autoRenew,
      'payment_method': instance.paymentMethod,
    };
