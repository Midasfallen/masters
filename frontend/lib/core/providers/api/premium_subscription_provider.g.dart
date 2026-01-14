// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'premium_subscription_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentSubscriptionHash() =>
    r'083affabcb17ecf404ad05da61dafcabdc852ad0';

/// Текущая подписка пользователя
///
/// Copied from [currentSubscription].
@ProviderFor(currentSubscription)
final currentSubscriptionProvider =
    AutoDisposeFutureProvider<PremiumSubscriptionModel?>.internal(
  currentSubscription,
  name: r'currentSubscriptionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentSubscriptionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentSubscriptionRef
    = AutoDisposeFutureProviderRef<PremiumSubscriptionModel?>;
String _$subscriptionPlansHash() => r'acc9fb5a236429b6d883f940b9ce577cda28da53';

/// Доступные планы подписок
///
/// Copied from [subscriptionPlans].
@ProviderFor(subscriptionPlans)
final subscriptionPlansProvider =
    AutoDisposeFutureProvider<List<SubscriptionPlanModel>>.internal(
  subscriptionPlans,
  name: r'subscriptionPlansProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$subscriptionPlansHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SubscriptionPlansRef
    = AutoDisposeFutureProviderRef<List<SubscriptionPlanModel>>;
String _$hasFeatureAccessHash() => r'f47396ddf62bb4375dbd2ef387bae5f3c62c0922';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Проверка доступа к премиум-функции
///
/// Copied from [hasFeatureAccess].
@ProviderFor(hasFeatureAccess)
const hasFeatureAccessProvider = HasFeatureAccessFamily();

/// Проверка доступа к премиум-функции
///
/// Copied from [hasFeatureAccess].
class HasFeatureAccessFamily extends Family<AsyncValue<bool>> {
  /// Проверка доступа к премиум-функции
  ///
  /// Copied from [hasFeatureAccess].
  const HasFeatureAccessFamily();

  /// Проверка доступа к премиум-функции
  ///
  /// Copied from [hasFeatureAccess].
  HasFeatureAccessProvider call(
    String featureCode,
  ) {
    return HasFeatureAccessProvider(
      featureCode,
    );
  }

  @override
  HasFeatureAccessProvider getProviderOverride(
    covariant HasFeatureAccessProvider provider,
  ) {
    return call(
      provider.featureCode,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'hasFeatureAccessProvider';
}

/// Проверка доступа к премиум-функции
///
/// Copied from [hasFeatureAccess].
class HasFeatureAccessProvider extends AutoDisposeFutureProvider<bool> {
  /// Проверка доступа к премиум-функции
  ///
  /// Copied from [hasFeatureAccess].
  HasFeatureAccessProvider(
    String featureCode,
  ) : this._internal(
          (ref) => hasFeatureAccess(
            ref as HasFeatureAccessRef,
            featureCode,
          ),
          from: hasFeatureAccessProvider,
          name: r'hasFeatureAccessProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$hasFeatureAccessHash,
          dependencies: HasFeatureAccessFamily._dependencies,
          allTransitiveDependencies:
              HasFeatureAccessFamily._allTransitiveDependencies,
          featureCode: featureCode,
        );

  HasFeatureAccessProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.featureCode,
  }) : super.internal();

  final String featureCode;

  @override
  Override overrideWith(
    FutureOr<bool> Function(HasFeatureAccessRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HasFeatureAccessProvider._internal(
        (ref) => create(ref as HasFeatureAccessRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        featureCode: featureCode,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _HasFeatureAccessProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HasFeatureAccessProvider &&
        other.featureCode == featureCode;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, featureCode.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin HasFeatureAccessRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `featureCode` of this provider.
  String get featureCode;
}

class _HasFeatureAccessProviderElement
    extends AutoDisposeFutureProviderElement<bool> with HasFeatureAccessRef {
  _HasFeatureAccessProviderElement(super.provider);

  @override
  String get featureCode => (origin as HasFeatureAccessProvider).featureCode;
}

String _$isPremiumActiveHash() => r'fc38d64925e0c8428589b95a714c0e9f4336b273';

/// Проверка, активна ли премиум-подписка
///
/// Copied from [isPremiumActive].
@ProviderFor(isPremiumActive)
final isPremiumActiveProvider = AutoDisposeFutureProvider<bool>.internal(
  isPremiumActive,
  name: r'isPremiumActiveProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isPremiumActiveHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsPremiumActiveRef = AutoDisposeFutureProviderRef<bool>;
String _$currentTierHash() => r'd94aa5dbd7a27d0adb8b6fbbe2bd93e38ea5fa05';

/// Получить текущий tier
///
/// Copied from [currentTier].
@ProviderFor(currentTier)
final currentTierProvider =
    AutoDisposeFutureProvider<SubscriptionTier>.internal(
  currentTier,
  name: r'currentTierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$currentTierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentTierRef = AutoDisposeFutureProviderRef<SubscriptionTier>;
String _$premiumSubscriptionNotifierHash() =>
    r'60bb291792ba92180724dc512a35b7a1ec73ea0b';

/// Notifier для мутаций подписки
///
/// Copied from [PremiumSubscriptionNotifier].
@ProviderFor(PremiumSubscriptionNotifier)
final premiumSubscriptionNotifierProvider = AutoDisposeAsyncNotifierProvider<
    PremiumSubscriptionNotifier, PremiumSubscriptionModel?>.internal(
  PremiumSubscriptionNotifier.new,
  name: r'premiumSubscriptionNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$premiumSubscriptionNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PremiumSubscriptionNotifier
    = AutoDisposeAsyncNotifier<PremiumSubscriptionModel?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
