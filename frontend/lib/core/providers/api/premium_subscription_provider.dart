import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_platform/core/models/api/premium_subscription_model.dart';
import 'package:service_platform/core/repositories/premium_subscription_repository.dart';

part 'premium_subscription_provider.g.dart';

// ============ CURRENT SUBSCRIPTION ============

/// Текущая подписка пользователя
@riverpod
Future<PremiumSubscriptionModel?> currentSubscription(
  CurrentSubscriptionRef ref,
) async {
  final repository = ref.watch(premiumSubscriptionRepositoryProvider);
  return await repository.getCurrentSubscription();
}

// ============ SUBSCRIPTION PLANS ============

/// Доступные планы подписок
@riverpod
Future<List<SubscriptionPlanModel>> subscriptionPlans(
  SubscriptionPlansRef ref,
) async {
  final repository = ref.watch(premiumSubscriptionRepositoryProvider);
  return await repository.getPlans();
}

// ============ SUBSCRIPTION NOTIFIER ============

/// Notifier для мутаций подписки
@riverpod
class PremiumSubscriptionNotifier extends _$PremiumSubscriptionNotifier {
  @override
  FutureOr<PremiumSubscriptionModel?> build() async {
    return null;
  }

  /// Создать новую подписку (upgrade)
  Future<PremiumSubscriptionModel> subscribe({
    required SubscriptionTier tier,
    required BillingPeriod billingPeriod,
    String? paymentMethod,
  }) async {
    state = const AsyncValue.loading();

    return await AsyncValue.guard(() async {
      final repository = ref.read(premiumSubscriptionRepositoryProvider);

      final subscription = await repository.createSubscription(
        CreateSubscriptionDto(
          tier: tier,
          billingPeriod: billingPeriod,
          paymentMethod: paymentMethod,
        ),
      );

      // Invalidate current subscription
      ref.invalidate(currentSubscriptionProvider);

      return subscription;
    }).then((asyncValue) {
      state = asyncValue;
      return asyncValue.requireValue;
    });
  }

  /// Отменить подписку
  Future<PremiumSubscriptionModel> cancel() async {
    state = const AsyncValue.loading();

    return await AsyncValue.guard(() async {
      final repository = ref.read(premiumSubscriptionRepositoryProvider);
      final subscription = await repository.cancelSubscription();

      // Invalidate current subscription
      ref.invalidate(currentSubscriptionProvider);

      return subscription;
    }).then((asyncValue) {
      state = asyncValue;
      return asyncValue.requireValue;
    });
  }

  /// Возобновить подписку
  Future<PremiumSubscriptionModel> resume() async {
    state = const AsyncValue.loading();

    return await AsyncValue.guard(() async {
      final repository = ref.read(premiumSubscriptionRepositoryProvider);
      final subscription = await repository.resumeSubscription();

      // Invalidate current subscription
      ref.invalidate(currentSubscriptionProvider);

      return subscription;
    }).then((asyncValue) {
      state = asyncValue;
      return asyncValue.requireValue;
    });
  }

  /// Обновить настройки подписки
  Future<PremiumSubscriptionModel> updateSettings({
    bool? autoRenew,
    String? paymentMethod,
  }) async {
    state = const AsyncValue.loading();

    return await AsyncValue.guard(() async {
      final repository = ref.read(premiumSubscriptionRepositoryProvider);

      final subscription = await repository.updateSubscription(
        UpdateSubscriptionDto(
          autoRenew: autoRenew,
          paymentMethod: paymentMethod,
        ),
      );

      // Invalidate current subscription
      ref.invalidate(currentSubscriptionProvider);

      return subscription;
    }).then((asyncValue) {
      state = asyncValue;
      return asyncValue.requireValue;
    });
  }

  /// Инициировать платеж
  Future<Map<String, dynamic>> initiatePayment({
    required SubscriptionTier tier,
    required BillingPeriod billingPeriod,
  }) async {
    final repository = ref.read(premiumSubscriptionRepositoryProvider);
    return await repository.initiatePayment(
      tier: tier,
      billingPeriod: billingPeriod,
    );
  }

  /// Проверить статус платежа
  Future<Map<String, dynamic>> checkPaymentStatus(String paymentId) async {
    final repository = ref.read(premiumSubscriptionRepositoryProvider);
    return await repository.checkPaymentStatus(paymentId);
  }
}

// ============ FEATURE ACCESS ============

/// Проверка доступа к премиум-функции
@riverpod
Future<bool> hasFeatureAccess(
  HasFeatureAccessRef ref,
  String featureCode,
) async {
  final repository = ref.watch(premiumSubscriptionRepositoryProvider);
  return await repository.hasFeatureAccess(featureCode);
}

// ============ HELPER PROVIDERS ============

/// Проверка, активна ли премиум-подписка
@riverpod
Future<bool> isPremiumActive(IsPremiumActiveRef ref) async {
  final subscription = await ref.watch(currentSubscriptionProvider.future);

  if (subscription == null) return false;

  return subscription.status == SubscriptionStatus.active &&
         (subscription.tier == SubscriptionTier.premium ||
          subscription.tier == SubscriptionTier.pro);
}

/// Получить текущий tier
@riverpod
Future<SubscriptionTier> currentTier(CurrentTierRef ref) async {
  final subscription = await ref.watch(currentSubscriptionProvider.future);
  return subscription?.tier ?? SubscriptionTier.free;
}
