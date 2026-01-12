import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_platform/core/models/api/premium_subscription_model.dart';
import 'package:service_platform/core/providers/api/premium_subscription_provider.dart';
import 'package:service_platform/core/theme/app_colors.dart';
import 'package:service_platform/core/theme/app_sizes.dart';
import 'package:intl/intl.dart';

class PremiumSubscriptionScreen extends ConsumerWidget {
  const PremiumSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSubscriptionAsync = ref.watch(currentSubscriptionProvider);
    final plansAsync = ref.watch(subscriptionPlansProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Премиум подписка'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(currentSubscriptionProvider);
          ref.invalidate(subscriptionPlansProvider);
        },
        child: currentSubscriptionAsync.when(
          data: (subscription) => plansAsync.when(
            data: (plans) => _buildContent(context, ref, subscription, plans),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => _buildError(error, () {
              ref.invalidate(subscriptionPlansProvider);
            }),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => _buildError(error, () {
            ref.invalidate(currentSubscriptionProvider);
          }),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    PremiumSubscriptionModel? subscription,
    List<SubscriptionPlanModel> plans,
  ) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current Subscription Status
          if (subscription != null) _buildCurrentSubscription(context, ref, subscription),

          const SizedBox(height: AppSizes.paddingLg),

          // Subscription Plans
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMd),
            child: Text(
              subscription == null ? 'Выберите план' : 'Сменить план',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
          ),

          const SizedBox(height: AppSizes.paddingMd),

          // Plans List
          ...plans.map((plan) => _buildPlanCard(context, ref, plan, subscription)),

          const SizedBox(height: AppSizes.paddingXl),

          // Features Comparison
          _buildFeaturesComparison(plans),

          const SizedBox(height: AppSizes.paddingXl),
        ],
      ),
    );
  }

  Widget _buildCurrentSubscription(
    BuildContext context,
    WidgetRef ref,
    PremiumSubscriptionModel subscription,
  ) {
    final isActive = subscription.status == SubscriptionStatus.active;
    final isCancelled = subscription.status == SubscriptionStatus.cancelled;

    return Container(
      margin: const EdgeInsets.all(AppSizes.paddingMd),
      padding: const EdgeInsets.all(AppSizes.paddingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isActive
              ? [AppColors.primary, AppColors.secondary]
              : [Colors.grey.shade300, Colors.grey.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                _getTierName(subscription.tier),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingSm,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: Text(
                  _getStatusText(subscription.status),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSizes.paddingSm),

          Text(
            '${subscription.priceAmount.toStringAsFixed(0)} ${subscription.currencyCode}/${subscription.billingPeriod == BillingPeriod.monthly ? "мес" : "год"}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),

          if (subscription.expiresAt != null) ...[
            const SizedBox(height: AppSizes.paddingSm),
            Text(
              isCancelled
                  ? 'Действует до: ${DateFormat('dd.MM.yyyy').format(subscription.expiresAt!)}'
                  : 'Продлится: ${DateFormat('dd.MM.yyyy').format(subscription.expiresAt!)}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],

          if (isActive) ...[
            const SizedBox(height: AppSizes.paddingMd),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: isCancelled
                        ? () => _resumeSubscription(context, ref)
                        : () => _cancelSubscription(context, ref),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                    ),
                    child: Text(isCancelled ? 'Возобновить' : 'Отменить'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPlanCard(
    BuildContext context,
    WidgetRef ref,
    SubscriptionPlanModel plan,
    PremiumSubscriptionModel? currentSubscription,
  ) {
    final isCurrent = currentSubscription?.tier == plan.tier;
    final billingPeriod = BillingPeriod.monthly; // Default selection

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMd,
        vertical: AppSizes.paddingSm,
      ),
      child: Card(
        elevation: plan.isPopular ? AppSizes.elevation4 : AppSizes.elevation2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          side: plan.isPopular
              ? BorderSide(color: AppColors.primary, width: 2)
              : BorderSide.none,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Plan Header
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plan.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          plan.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (plan.isPopular)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingSm,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      ),
                      child: const Text(
                        'Популярный',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: AppSizes.paddingMd),

              // Pricing
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${plan.monthlyPrice.toStringAsFixed(0)} ₽',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 6),
                    child: Text(
                      '/месяц',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),

              if (plan.yearlyDiscountPercent > 0) ...[
                const SizedBox(height: 4),
                Text(
                  'или ${plan.yearlyPrice.toStringAsFixed(0)} ₽/год (скидка ${plan.yearlyDiscountPercent}%)',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.green[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],

              const SizedBox(height: AppSizes.paddingMd),

              // Features
              ...plan.features.map((feature) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, size: 20, color: AppColors.primary),
                    const SizedBox(width: AppSizes.paddingSm),
                    Expanded(
                      child: Text(
                        feature,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              )),

              const SizedBox(height: AppSizes.paddingMd),

              // Subscribe Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isCurrent
                      ? null
                      : () => _subscribe(context, ref, plan.tier, billingPeriod),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isCurrent ? Colors.grey : AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingMd),
                  ),
                  child: Text(
                    isCurrent ? 'Текущий план' : 'Выбрать план',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturesComparison(List<SubscriptionPlanModel> plans) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Сравнение планов',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSizes.paddingMd),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.paddingMd),
              child: Column(
                children: [
                  _buildComparisonRow('Автопредложения мастеров', [false, true, true, true]),
                  _buildComparisonRow('Приоритет в поиске', [false, false, true, true]),
                  _buildComparisonRow('Расширенная аналитика', [false, false, true, true]),
                  _buildComparisonRow('Безлимитные бронирования', [false, false, false, true]),
                  _buildComparisonRow('Приоритетная поддержка', [false, false, false, true]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonRow(String feature, List<bool> tiers) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingSm),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(feature, style: const TextStyle(fontSize: 14)),
          ),
          ...tiers.map((available) => Expanded(
            child: Icon(
              available ? Icons.check : Icons.close,
              size: 18,
              color: available ? Colors.green : Colors.grey,
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildError(Object error, VoidCallback onRetry) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: AppSizes.paddingMd),
          Text('Ошибка: $error'),
          const SizedBox(height: AppSizes.paddingMd),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Повторить'),
          ),
        ],
      ),
    );
  }

  String _getTierName(SubscriptionTier tier) {
    switch (tier) {
      case SubscriptionTier.free:
        return 'Free';
      case SubscriptionTier.basic:
        return 'Basic';
      case SubscriptionTier.premium:
        return 'Premium';
      case SubscriptionTier.pro:
        return 'Pro';
    }
  }

  String _getStatusText(SubscriptionStatus status) {
    switch (status) {
      case SubscriptionStatus.active:
        return 'Активна';
      case SubscriptionStatus.cancelled:
        return 'Отменена';
      case SubscriptionStatus.expired:
        return 'Истекла';
      case SubscriptionStatus.trial:
        return 'Пробный период';
    }
  }

  Future<void> _subscribe(
    BuildContext context,
    WidgetRef ref,
    SubscriptionTier tier,
    BillingPeriod billingPeriod,
  ) async {
    try {
      await ref.read(premiumSubscriptionNotifierProvider.notifier).subscribe(
            tier: tier,
            billingPeriod: billingPeriod,
          );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Подписка успешно оформлена!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _cancelSubscription(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Отменить подписку?'),
        content: const Text(
          'Подписка будет действовать до конца оплаченного периода, после чего автопродление будет отключено.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Назад'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Отменить подписку'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await ref.read(premiumSubscriptionNotifierProvider.notifier).cancel();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Подписка отменена'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _resumeSubscription(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(premiumSubscriptionNotifierProvider.notifier).resume();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Подписка возобновлена!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
