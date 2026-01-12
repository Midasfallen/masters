// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscriptions_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mySubscriptionsListHash() =>
    r'4e75045e6adfe6ccd0bd13d4600eeec0202c02a2';

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

/// My Subscriptions List Provider
///
/// Copied from [mySubscriptionsList].
@ProviderFor(mySubscriptionsList)
const mySubscriptionsListProvider = MySubscriptionsListFamily();

/// My Subscriptions List Provider
///
/// Copied from [mySubscriptionsList].
class MySubscriptionsListFamily extends Family<AsyncValue<List<UserModel>>> {
  /// My Subscriptions List Provider
  ///
  /// Copied from [mySubscriptionsList].
  const MySubscriptionsListFamily();

  /// My Subscriptions List Provider
  ///
  /// Copied from [mySubscriptionsList].
  MySubscriptionsListProvider call({
    int page = 1,
    int limit = 50,
  }) {
    return MySubscriptionsListProvider(
      page: page,
      limit: limit,
    );
  }

  @override
  MySubscriptionsListProvider getProviderOverride(
    covariant MySubscriptionsListProvider provider,
  ) {
    return call(
      page: provider.page,
      limit: provider.limit,
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
  String? get name => r'mySubscriptionsListProvider';
}

/// My Subscriptions List Provider
///
/// Copied from [mySubscriptionsList].
class MySubscriptionsListProvider
    extends AutoDisposeFutureProvider<List<UserModel>> {
  /// My Subscriptions List Provider
  ///
  /// Copied from [mySubscriptionsList].
  MySubscriptionsListProvider({
    int page = 1,
    int limit = 50,
  }) : this._internal(
          (ref) => mySubscriptionsList(
            ref as MySubscriptionsListRef,
            page: page,
            limit: limit,
          ),
          from: mySubscriptionsListProvider,
          name: r'mySubscriptionsListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$mySubscriptionsListHash,
          dependencies: MySubscriptionsListFamily._dependencies,
          allTransitiveDependencies:
              MySubscriptionsListFamily._allTransitiveDependencies,
          page: page,
          limit: limit,
        );

  MySubscriptionsListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.page,
    required this.limit,
  }) : super.internal();

  final int page;
  final int limit;

  @override
  Override overrideWith(
    FutureOr<List<UserModel>> Function(MySubscriptionsListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MySubscriptionsListProvider._internal(
        (ref) => create(ref as MySubscriptionsListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        page: page,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<UserModel>> createElement() {
    return _MySubscriptionsListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MySubscriptionsListProvider &&
        other.page == page &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MySubscriptionsListRef on AutoDisposeFutureProviderRef<List<UserModel>> {
  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _MySubscriptionsListProviderElement
    extends AutoDisposeFutureProviderElement<List<UserModel>>
    with MySubscriptionsListRef {
  _MySubscriptionsListProviderElement(super.provider);

  @override
  int get page => (origin as MySubscriptionsListProvider).page;
  @override
  int get limit => (origin as MySubscriptionsListProvider).limit;
}

String _$mySubscribersListHash() => r'5b3ac8de8b7c4daa048b18f3cc7ace7ea02d573f';

/// My Subscribers List Provider
///
/// Copied from [mySubscribersList].
@ProviderFor(mySubscribersList)
const mySubscribersListProvider = MySubscribersListFamily();

/// My Subscribers List Provider
///
/// Copied from [mySubscribersList].
class MySubscribersListFamily extends Family<AsyncValue<List<UserModel>>> {
  /// My Subscribers List Provider
  ///
  /// Copied from [mySubscribersList].
  const MySubscribersListFamily();

  /// My Subscribers List Provider
  ///
  /// Copied from [mySubscribersList].
  MySubscribersListProvider call({
    int page = 1,
    int limit = 50,
  }) {
    return MySubscribersListProvider(
      page: page,
      limit: limit,
    );
  }

  @override
  MySubscribersListProvider getProviderOverride(
    covariant MySubscribersListProvider provider,
  ) {
    return call(
      page: provider.page,
      limit: provider.limit,
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
  String? get name => r'mySubscribersListProvider';
}

/// My Subscribers List Provider
///
/// Copied from [mySubscribersList].
class MySubscribersListProvider
    extends AutoDisposeFutureProvider<List<UserModel>> {
  /// My Subscribers List Provider
  ///
  /// Copied from [mySubscribersList].
  MySubscribersListProvider({
    int page = 1,
    int limit = 50,
  }) : this._internal(
          (ref) => mySubscribersList(
            ref as MySubscribersListRef,
            page: page,
            limit: limit,
          ),
          from: mySubscribersListProvider,
          name: r'mySubscribersListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$mySubscribersListHash,
          dependencies: MySubscribersListFamily._dependencies,
          allTransitiveDependencies:
              MySubscribersListFamily._allTransitiveDependencies,
          page: page,
          limit: limit,
        );

  MySubscribersListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.page,
    required this.limit,
  }) : super.internal();

  final int page;
  final int limit;

  @override
  Override overrideWith(
    FutureOr<List<UserModel>> Function(MySubscribersListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MySubscribersListProvider._internal(
        (ref) => create(ref as MySubscribersListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        page: page,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<UserModel>> createElement() {
    return _MySubscribersListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MySubscribersListProvider &&
        other.page == page &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MySubscribersListRef on AutoDisposeFutureProviderRef<List<UserModel>> {
  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _MySubscribersListProviderElement
    extends AutoDisposeFutureProviderElement<List<UserModel>>
    with MySubscribersListRef {
  _MySubscribersListProviderElement(super.provider);

  @override
  int get page => (origin as MySubscribersListProvider).page;
  @override
  int get limit => (origin as MySubscribersListProvider).limit;
}

String _$subscriptionByIdHash() => r'ed2184b18fdc657060005a1d95f7501b6277fe01';

/// Subscription by ID Provider
///
/// Copied from [subscriptionById].
@ProviderFor(subscriptionById)
const subscriptionByIdProvider = SubscriptionByIdFamily();

/// Subscription by ID Provider
///
/// Copied from [subscriptionById].
class SubscriptionByIdFamily extends Family<AsyncValue<SubscriptionModel>> {
  /// Subscription by ID Provider
  ///
  /// Copied from [subscriptionById].
  const SubscriptionByIdFamily();

  /// Subscription by ID Provider
  ///
  /// Copied from [subscriptionById].
  SubscriptionByIdProvider call(
    String subscriptionId,
  ) {
    return SubscriptionByIdProvider(
      subscriptionId,
    );
  }

  @override
  SubscriptionByIdProvider getProviderOverride(
    covariant SubscriptionByIdProvider provider,
  ) {
    return call(
      provider.subscriptionId,
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
  String? get name => r'subscriptionByIdProvider';
}

/// Subscription by ID Provider
///
/// Copied from [subscriptionById].
class SubscriptionByIdProvider
    extends AutoDisposeFutureProvider<SubscriptionModel> {
  /// Subscription by ID Provider
  ///
  /// Copied from [subscriptionById].
  SubscriptionByIdProvider(
    String subscriptionId,
  ) : this._internal(
          (ref) => subscriptionById(
            ref as SubscriptionByIdRef,
            subscriptionId,
          ),
          from: subscriptionByIdProvider,
          name: r'subscriptionByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$subscriptionByIdHash,
          dependencies: SubscriptionByIdFamily._dependencies,
          allTransitiveDependencies:
              SubscriptionByIdFamily._allTransitiveDependencies,
          subscriptionId: subscriptionId,
        );

  SubscriptionByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.subscriptionId,
  }) : super.internal();

  final String subscriptionId;

  @override
  Override overrideWith(
    FutureOr<SubscriptionModel> Function(SubscriptionByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SubscriptionByIdProvider._internal(
        (ref) => create(ref as SubscriptionByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        subscriptionId: subscriptionId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<SubscriptionModel> createElement() {
    return _SubscriptionByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SubscriptionByIdProvider &&
        other.subscriptionId == subscriptionId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, subscriptionId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SubscriptionByIdRef on AutoDisposeFutureProviderRef<SubscriptionModel> {
  /// The parameter `subscriptionId` of this provider.
  String get subscriptionId;
}

class _SubscriptionByIdProviderElement
    extends AutoDisposeFutureProviderElement<SubscriptionModel>
    with SubscriptionByIdRef {
  _SubscriptionByIdProviderElement(super.provider);

  @override
  String get subscriptionId =>
      (origin as SubscriptionByIdProvider).subscriptionId;
}

String _$subscriptionNotifierHash() =>
    r'0e2cfb6dbe201b8ca048c2c4735bf60656563ed5';

/// Subscription Notifier for mutations
///
/// Copied from [SubscriptionNotifier].
@ProviderFor(SubscriptionNotifier)
final subscriptionNotifierProvider = AutoDisposeAsyncNotifierProvider<
    SubscriptionNotifier, SubscriptionModel?>.internal(
  SubscriptionNotifier.new,
  name: r'subscriptionNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$subscriptionNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SubscriptionNotifier = AutoDisposeAsyncNotifier<SubscriptionModel?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
