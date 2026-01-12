import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_platform/core/api/dio_client.dart';
import 'package:service_platform/core/models/api/premium_subscription_model.dart';

part 'premium_subscription_repository.g.dart';

@riverpod
PremiumSubscriptionRepository premiumSubscriptionRepository(
  PremiumSubscriptionRepositoryRef ref,
) {
  return PremiumSubscriptionRepository(ref.read(dioClientProvider));
}

class PremiumSubscriptionRepository {
  final DioClient _client;

  PremiumSubscriptionRepository(this._client);

  // ============ SUBSCRIPTION MANAGEMENT ============

  /// Получить текущую подписку пользователя
  Future<PremiumSubscriptionModel?> getCurrentSubscription() async {
    try {
      final response = await _client.get('/premium/subscription');
      if (response.data == null) return null;
      return PremiumSubscriptionModel.fromJson(response.data);
    } catch (e) {
      // Если подписки нет - вернуть null
      return null;
    }
  }

  /// Получить доступные планы подписок
  Future<List<SubscriptionPlanModel>> getPlans() async {
    final response = await _client.get('/premium/plans');
    final List<dynamic> data = response.data is List
        ? response.data
        : response.data['data'] ?? [];
    return data.map((json) => SubscriptionPlanModel.fromJson(json)).toList();
  }

  /// Создать новую подписку (upgrade)
  Future<PremiumSubscriptionModel> createSubscription(
    CreateSubscriptionDto dto,
  ) async {
    final response = await _client.post(
      '/premium/subscription',
      data: dto.toJson(),
    );
    return PremiumSubscriptionModel.fromJson(response.data);
  }

  /// Обновить настройки подписки
  Future<PremiumSubscriptionModel> updateSubscription(
    UpdateSubscriptionDto dto,
  ) async {
    final response = await _client.patch(
      '/premium/subscription',
      data: dto.toJson(),
    );
    return PremiumSubscriptionModel.fromJson(response.data);
  }

  /// Отменить подписку (отключить auto-renew)
  Future<PremiumSubscriptionModel> cancelSubscription() async {
    final response = await _client.post('/premium/subscription/cancel');
    return PremiumSubscriptionModel.fromJson(response.data);
  }

  /// Возобновить подписку (включить auto-renew)
  Future<PremiumSubscriptionModel> resumeSubscription() async {
    final response = await _client.post('/premium/subscription/resume');
    return PremiumSubscriptionModel.fromJson(response.data);
  }

  // ============ PAYMENT ============

  /// Инициировать платеж
  Future<Map<String, dynamic>> initiatePayment({
    required SubscriptionTier tier,
    required BillingPeriod billingPeriod,
  }) async {
    final response = await _client.post(
      '/premium/payment/initiate',
      data: {
        'tier': tier.name,
        'billing_period': billingPeriod.name,
      },
    );
    return {
      'payment_url': response.data['payment_url'] as String,
      'payment_id': response.data['payment_id'] as String,
    };
  }

  /// Проверить статус платежа
  Future<Map<String, dynamic>> checkPaymentStatus(String paymentId) async {
    final response = await _client.get('/premium/payment/$paymentId/status');
    return {
      'status': response.data['status'] as String,
      'paid': response.data['paid'] as bool,
    };
  }

  // ============ FEATURES CHECK ============

  /// Проверить доступ к премиум-функции
  Future<bool> hasFeatureAccess(String featureCode) async {
    try {
      final response = await _client.get('/premium/features/$featureCode/check');
      return response.data['has_access'] as bool? ?? false;
    } catch (e) {
      return false;
    }
  }
}
