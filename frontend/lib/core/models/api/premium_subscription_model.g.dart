// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'premium_subscription_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PremiumSubscriptionModelImpl _$$PremiumSubscriptionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PremiumSubscriptionModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      tier: $enumDecode(_$SubscriptionTierEnumMap, json['tier']),
      status: $enumDecode(_$SubscriptionStatusEnumMap, json['status']),
      billingPeriod: $enumDecode(_$BillingPeriodEnumMap, json['billingPeriod']),
      priceAmount: (json['priceAmount'] as num).toDouble(),
      currencyCode: json['currencyCode'] as String? ?? 'RUB',
      startedAt: DateTime.parse(json['startedAt'] as String),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      cancelledAt: json['cancelledAt'] == null
          ? null
          : DateTime.parse(json['cancelledAt'] as String),
      autoRenew: json['autoRenew'] as bool? ?? true,
      paymentMethod: json['paymentMethod'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$PremiumSubscriptionModelImplToJson(
        _$PremiumSubscriptionModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'tier': _$SubscriptionTierEnumMap[instance.tier]!,
      'status': _$SubscriptionStatusEnumMap[instance.status]!,
      'billingPeriod': _$BillingPeriodEnumMap[instance.billingPeriod]!,
      'priceAmount': instance.priceAmount,
      'currencyCode': instance.currencyCode,
      'startedAt': instance.startedAt.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'cancelledAt': instance.cancelledAt?.toIso8601String(),
      'autoRenew': instance.autoRenew,
      'paymentMethod': instance.paymentMethod,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
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
      monthlyPrice: (json['monthlyPrice'] as num).toDouble(),
      yearlyPrice: (json['yearlyPrice'] as num).toDouble(),
      yearlyDiscountPercent:
          (json['yearlyDiscountPercent'] as num?)?.toInt() ?? 0,
      isPopular: json['isPopular'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$$SubscriptionPlanModelImplToJson(
        _$SubscriptionPlanModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tier': _$SubscriptionTierEnumMap[instance.tier]!,
      'name': instance.name,
      'description': instance.description,
      'features': instance.features,
      'monthlyPrice': instance.monthlyPrice,
      'yearlyPrice': instance.yearlyPrice,
      'yearlyDiscountPercent': instance.yearlyDiscountPercent,
      'isPopular': instance.isPopular,
      'isActive': instance.isActive,
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
