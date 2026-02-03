import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_platform/core/models/api/friend_model.dart';
import 'package:service_platform/core/models/api/user_model.dart';
import 'package:service_platform/core/repositories/subscription_repository.dart';

part 'subscriptions_provider.g.dart';

/// My Subscriptions List Provider
@riverpod
Future<List<UserModel>> mySubscriptionsList(
  MySubscriptionsListRef ref, {
  int page = 1,
  int limit = 50,
}) async {
  final repository = ref.watch(subscriptionRepositoryProvider);
  return await repository.getMySubscriptions(page: page, limit: limit);
}

/// My Subscribers List Provider
@riverpod
Future<List<UserModel>> mySubscribersList(
  MySubscribersListRef ref, {
  int page = 1,
  int limit = 50,
}) async {
  final repository = ref.watch(subscriptionRepositoryProvider);
  return await repository.getMySubscribers(page: page, limit: limit);
}

/// Subscription by ID Provider
@riverpod
Future<SubscriptionModel> subscriptionById(
  SubscriptionByIdRef ref,
  String subscriptionId,
) async {
  final repository = ref.watch(subscriptionRepositoryProvider);
  return await repository.getSubscriptionById(subscriptionId);
}

/// Check if following user Provider
/// [userId] - ID пользователя, на которого проверяем подписку (targetId)
@riverpod
Future<bool> isFollowing(IsFollowingRef ref, String userId) async {
  final repository = ref.watch(subscriptionRepositoryProvider);
  return await repository.checkSubscription(userId);
}

/// Subscription Notifier for mutations
@riverpod
class SubscriptionNotifier extends _$SubscriptionNotifier {
  @override
  FutureOr<SubscriptionModel?> build() async {
    return null;
  }

  /// Subscribe to user
  Future<SubscriptionModel> subscribe(String userId) async {
    state = const AsyncValue.loading();

    return await AsyncValue.guard(() async {
      final repository = ref.read(subscriptionRepositoryProvider);
      final subscription = await repository.subscribe(userId);

      // КРИТИЧНО: Инвалидировать ПОСЛЕ await для избежания race conditions
      ref.invalidate(mySubscriptionsListProvider);
      ref.invalidate(isFollowingProvider(userId));

      return subscription;
    }).then((asyncValue) {
      state = asyncValue;
      return asyncValue.requireValue;
    });
  }

  /// Unsubscribe from user
  Future<void> unsubscribe(String userId) async {
    state = const AsyncValue.loading();

    await AsyncValue.guard(() async {
      final repository = ref.read(subscriptionRepositoryProvider);
      await repository.unsubscribe(userId);

      // КРИТИЧНО: Инвалидировать ПОСЛЕ await для избежания race conditions
      ref.invalidate(mySubscriptionsListProvider);
      ref.invalidate(isFollowingProvider(userId));
    }).then((asyncValue) {
      state = asyncValue as AsyncValue<SubscriptionModel?>;
    });
  }

  /// Toggle subscription notifications
  Future<SubscriptionModel> toggleNotifications(String subscriptionId, bool enabled) async {
    state = const AsyncValue.loading();

    return await AsyncValue.guard(() async {
      final repository = ref.read(subscriptionRepositoryProvider);
      final subscription = await repository.toggleNotifications(subscriptionId, enabled);

      // Invalidate subscriptions list
      ref.invalidate(mySubscriptionsListProvider);

      return subscription;
    }).then((asyncValue) {
      state = asyncValue;
      return asyncValue.requireValue;
    });
  }
}
