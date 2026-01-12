// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friends_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$friendsListHash() => r'35f7fa22f9cae575f6c840f36d4fba5fcc10e54d';

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

/// Friends List Provider
///
/// Copied from [friendsList].
@ProviderFor(friendsList)
const friendsListProvider = FriendsListFamily();

/// Friends List Provider
///
/// Copied from [friendsList].
class FriendsListFamily extends Family<AsyncValue<List<FriendModel>>> {
  /// Friends List Provider
  ///
  /// Copied from [friendsList].
  const FriendsListFamily();

  /// Friends List Provider
  ///
  /// Copied from [friendsList].
  FriendsListProvider call({
    int page = 1,
    int limit = 50,
  }) {
    return FriendsListProvider(
      page: page,
      limit: limit,
    );
  }

  @override
  FriendsListProvider getProviderOverride(
    covariant FriendsListProvider provider,
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
  String? get name => r'friendsListProvider';
}

/// Friends List Provider
///
/// Copied from [friendsList].
class FriendsListProvider extends AutoDisposeFutureProvider<List<FriendModel>> {
  /// Friends List Provider
  ///
  /// Copied from [friendsList].
  FriendsListProvider({
    int page = 1,
    int limit = 50,
  }) : this._internal(
          (ref) => friendsList(
            ref as FriendsListRef,
            page: page,
            limit: limit,
          ),
          from: friendsListProvider,
          name: r'friendsListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$friendsListHash,
          dependencies: FriendsListFamily._dependencies,
          allTransitiveDependencies:
              FriendsListFamily._allTransitiveDependencies,
          page: page,
          limit: limit,
        );

  FriendsListProvider._internal(
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
    FutureOr<List<FriendModel>> Function(FriendsListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FriendsListProvider._internal(
        (ref) => create(ref as FriendsListRef),
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
  AutoDisposeFutureProviderElement<List<FriendModel>> createElement() {
    return _FriendsListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FriendsListProvider &&
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
mixin FriendsListRef on AutoDisposeFutureProviderRef<List<FriendModel>> {
  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _FriendsListProviderElement
    extends AutoDisposeFutureProviderElement<List<FriendModel>>
    with FriendsListRef {
  _FriendsListProviderElement(super.provider);

  @override
  int get page => (origin as FriendsListProvider).page;
  @override
  int get limit => (origin as FriendsListProvider).limit;
}

String _$incomingFriendRequestsHash() =>
    r'43b20345c51ee8f4192a31f775525475839baf42';

/// Incoming Friend Requests Provider
///
/// Copied from [incomingFriendRequests].
@ProviderFor(incomingFriendRequests)
const incomingFriendRequestsProvider = IncomingFriendRequestsFamily();

/// Incoming Friend Requests Provider
///
/// Copied from [incomingFriendRequests].
class IncomingFriendRequestsFamily
    extends Family<AsyncValue<List<FriendshipModel>>> {
  /// Incoming Friend Requests Provider
  ///
  /// Copied from [incomingFriendRequests].
  const IncomingFriendRequestsFamily();

  /// Incoming Friend Requests Provider
  ///
  /// Copied from [incomingFriendRequests].
  IncomingFriendRequestsProvider call({
    int page = 1,
    int limit = 50,
  }) {
    return IncomingFriendRequestsProvider(
      page: page,
      limit: limit,
    );
  }

  @override
  IncomingFriendRequestsProvider getProviderOverride(
    covariant IncomingFriendRequestsProvider provider,
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
  String? get name => r'incomingFriendRequestsProvider';
}

/// Incoming Friend Requests Provider
///
/// Copied from [incomingFriendRequests].
class IncomingFriendRequestsProvider
    extends AutoDisposeFutureProvider<List<FriendshipModel>> {
  /// Incoming Friend Requests Provider
  ///
  /// Copied from [incomingFriendRequests].
  IncomingFriendRequestsProvider({
    int page = 1,
    int limit = 50,
  }) : this._internal(
          (ref) => incomingFriendRequests(
            ref as IncomingFriendRequestsRef,
            page: page,
            limit: limit,
          ),
          from: incomingFriendRequestsProvider,
          name: r'incomingFriendRequestsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$incomingFriendRequestsHash,
          dependencies: IncomingFriendRequestsFamily._dependencies,
          allTransitiveDependencies:
              IncomingFriendRequestsFamily._allTransitiveDependencies,
          page: page,
          limit: limit,
        );

  IncomingFriendRequestsProvider._internal(
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
    FutureOr<List<FriendshipModel>> Function(IncomingFriendRequestsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IncomingFriendRequestsProvider._internal(
        (ref) => create(ref as IncomingFriendRequestsRef),
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
  AutoDisposeFutureProviderElement<List<FriendshipModel>> createElement() {
    return _IncomingFriendRequestsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IncomingFriendRequestsProvider &&
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
mixin IncomingFriendRequestsRef
    on AutoDisposeFutureProviderRef<List<FriendshipModel>> {
  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _IncomingFriendRequestsProviderElement
    extends AutoDisposeFutureProviderElement<List<FriendshipModel>>
    with IncomingFriendRequestsRef {
  _IncomingFriendRequestsProviderElement(super.provider);

  @override
  int get page => (origin as IncomingFriendRequestsProvider).page;
  @override
  int get limit => (origin as IncomingFriendRequestsProvider).limit;
}

String _$outgoingFriendRequestsHash() =>
    r'6349c9b7195207f8ec1ef40de8302fd55854e5dc';

/// Outgoing Friend Requests Provider
///
/// Copied from [outgoingFriendRequests].
@ProviderFor(outgoingFriendRequests)
const outgoingFriendRequestsProvider = OutgoingFriendRequestsFamily();

/// Outgoing Friend Requests Provider
///
/// Copied from [outgoingFriendRequests].
class OutgoingFriendRequestsFamily
    extends Family<AsyncValue<List<FriendshipModel>>> {
  /// Outgoing Friend Requests Provider
  ///
  /// Copied from [outgoingFriendRequests].
  const OutgoingFriendRequestsFamily();

  /// Outgoing Friend Requests Provider
  ///
  /// Copied from [outgoingFriendRequests].
  OutgoingFriendRequestsProvider call({
    int page = 1,
    int limit = 50,
  }) {
    return OutgoingFriendRequestsProvider(
      page: page,
      limit: limit,
    );
  }

  @override
  OutgoingFriendRequestsProvider getProviderOverride(
    covariant OutgoingFriendRequestsProvider provider,
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
  String? get name => r'outgoingFriendRequestsProvider';
}

/// Outgoing Friend Requests Provider
///
/// Copied from [outgoingFriendRequests].
class OutgoingFriendRequestsProvider
    extends AutoDisposeFutureProvider<List<FriendshipModel>> {
  /// Outgoing Friend Requests Provider
  ///
  /// Copied from [outgoingFriendRequests].
  OutgoingFriendRequestsProvider({
    int page = 1,
    int limit = 50,
  }) : this._internal(
          (ref) => outgoingFriendRequests(
            ref as OutgoingFriendRequestsRef,
            page: page,
            limit: limit,
          ),
          from: outgoingFriendRequestsProvider,
          name: r'outgoingFriendRequestsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$outgoingFriendRequestsHash,
          dependencies: OutgoingFriendRequestsFamily._dependencies,
          allTransitiveDependencies:
              OutgoingFriendRequestsFamily._allTransitiveDependencies,
          page: page,
          limit: limit,
        );

  OutgoingFriendRequestsProvider._internal(
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
    FutureOr<List<FriendshipModel>> Function(OutgoingFriendRequestsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: OutgoingFriendRequestsProvider._internal(
        (ref) => create(ref as OutgoingFriendRequestsRef),
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
  AutoDisposeFutureProviderElement<List<FriendshipModel>> createElement() {
    return _OutgoingFriendRequestsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OutgoingFriendRequestsProvider &&
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
mixin OutgoingFriendRequestsRef
    on AutoDisposeFutureProviderRef<List<FriendshipModel>> {
  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _OutgoingFriendRequestsProviderElement
    extends AutoDisposeFutureProviderElement<List<FriendshipModel>>
    with OutgoingFriendRequestsRef {
  _OutgoingFriendRequestsProviderElement(super.provider);

  @override
  int get page => (origin as OutgoingFriendRequestsProvider).page;
  @override
  int get limit => (origin as OutgoingFriendRequestsProvider).limit;
}

String _$friendshipByIdHash() => r'ea90459858682f4c93d85fccf0de596e1e37c374';

/// Friendship by ID Provider
///
/// Copied from [friendshipById].
@ProviderFor(friendshipById)
const friendshipByIdProvider = FriendshipByIdFamily();

/// Friendship by ID Provider
///
/// Copied from [friendshipById].
class FriendshipByIdFamily extends Family<AsyncValue<FriendshipModel>> {
  /// Friendship by ID Provider
  ///
  /// Copied from [friendshipById].
  const FriendshipByIdFamily();

  /// Friendship by ID Provider
  ///
  /// Copied from [friendshipById].
  FriendshipByIdProvider call(
    String friendshipId,
  ) {
    return FriendshipByIdProvider(
      friendshipId,
    );
  }

  @override
  FriendshipByIdProvider getProviderOverride(
    covariant FriendshipByIdProvider provider,
  ) {
    return call(
      provider.friendshipId,
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
  String? get name => r'friendshipByIdProvider';
}

/// Friendship by ID Provider
///
/// Copied from [friendshipById].
class FriendshipByIdProvider
    extends AutoDisposeFutureProvider<FriendshipModel> {
  /// Friendship by ID Provider
  ///
  /// Copied from [friendshipById].
  FriendshipByIdProvider(
    String friendshipId,
  ) : this._internal(
          (ref) => friendshipById(
            ref as FriendshipByIdRef,
            friendshipId,
          ),
          from: friendshipByIdProvider,
          name: r'friendshipByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$friendshipByIdHash,
          dependencies: FriendshipByIdFamily._dependencies,
          allTransitiveDependencies:
              FriendshipByIdFamily._allTransitiveDependencies,
          friendshipId: friendshipId,
        );

  FriendshipByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.friendshipId,
  }) : super.internal();

  final String friendshipId;

  @override
  Override overrideWith(
    FutureOr<FriendshipModel> Function(FriendshipByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FriendshipByIdProvider._internal(
        (ref) => create(ref as FriendshipByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        friendshipId: friendshipId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<FriendshipModel> createElement() {
    return _FriendshipByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FriendshipByIdProvider &&
        other.friendshipId == friendshipId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, friendshipId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FriendshipByIdRef on AutoDisposeFutureProviderRef<FriendshipModel> {
  /// The parameter `friendshipId` of this provider.
  String get friendshipId;
}

class _FriendshipByIdProviderElement
    extends AutoDisposeFutureProviderElement<FriendshipModel>
    with FriendshipByIdRef {
  _FriendshipByIdProviderElement(super.provider);

  @override
  String get friendshipId => (origin as FriendshipByIdProvider).friendshipId;
}

String _$friendNotifierHash() => r'5a3242965ad97f5c3a46ec7e6b55ac0b34f3ad40';

/// Friend Notifier for mutations
///
/// Copied from [FriendNotifier].
@ProviderFor(FriendNotifier)
final friendNotifierProvider =
    AutoDisposeAsyncNotifierProvider<FriendNotifier, FriendshipModel?>.internal(
  FriendNotifier.new,
  name: r'friendNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$friendNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FriendNotifier = AutoDisposeAsyncNotifier<FriendshipModel?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
