// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userByIdHash() => r'4e73952922a0bd829357d5895e011221931ea4e3';

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

/// User by ID Provider
///
/// Copied from [userById].
@ProviderFor(userById)
const userByIdProvider = UserByIdFamily();

/// User by ID Provider
///
/// Copied from [userById].
class UserByIdFamily extends Family<AsyncValue<UserModel>> {
  /// User by ID Provider
  ///
  /// Copied from [userById].
  const UserByIdFamily();

  /// User by ID Provider
  ///
  /// Copied from [userById].
  UserByIdProvider call(
    String userId,
  ) {
    return UserByIdProvider(
      userId,
    );
  }

  @override
  UserByIdProvider getProviderOverride(
    covariant UserByIdProvider provider,
  ) {
    return call(
      provider.userId,
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
  String? get name => r'userByIdProvider';
}

/// User by ID Provider
///
/// Copied from [userById].
class UserByIdProvider extends AutoDisposeFutureProvider<UserModel> {
  /// User by ID Provider
  ///
  /// Copied from [userById].
  UserByIdProvider(
    String userId,
  ) : this._internal(
          (ref) => userById(
            ref as UserByIdRef,
            userId,
          ),
          from: userByIdProvider,
          name: r'userByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userByIdHash,
          dependencies: UserByIdFamily._dependencies,
          allTransitiveDependencies: UserByIdFamily._allTransitiveDependencies,
          userId: userId,
        );

  UserByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    FutureOr<UserModel> Function(UserByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserByIdProvider._internal(
        (ref) => create(ref as UserByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<UserModel> createElement() {
    return _UserByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserByIdProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserByIdRef on AutoDisposeFutureProviderRef<UserModel> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserByIdProviderElement
    extends AutoDisposeFutureProviderElement<UserModel> with UserByIdRef {
  _UserByIdProviderElement(super.provider);

  @override
  String get userId => (origin as UserByIdProvider).userId;
}

String _$currentUserProfileHash() =>
    r'c4602482557e0b3cb89970d920480d00f1afffdc';

/// Current User Profile Provider
///
/// Copied from [currentUserProfile].
@ProviderFor(currentUserProfile)
final currentUserProfileProvider =
    AutoDisposeFutureProvider<UserModel>.internal(
  currentUserProfile,
  name: r'currentUserProfileProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentUserProfileHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentUserProfileRef = AutoDisposeFutureProviderRef<UserModel>;
String _$userListHash() => r'2ae6c65c98a4958b9570d5b9de3b00e8fb49c7c9';

/// User List Provider
///
/// Copied from [userList].
@ProviderFor(userList)
const userListProvider = UserListFamily();

/// User List Provider
///
/// Copied from [userList].
class UserListFamily extends Family<AsyncValue<List<UserModel>>> {
  /// User List Provider
  ///
  /// Copied from [userList].
  const UserListFamily();

  /// User List Provider
  ///
  /// Copied from [userList].
  UserListProvider call({
    int page = 1,
    int limit = 20,
    String? search,
  }) {
    return UserListProvider(
      page: page,
      limit: limit,
      search: search,
    );
  }

  @override
  UserListProvider getProviderOverride(
    covariant UserListProvider provider,
  ) {
    return call(
      page: provider.page,
      limit: provider.limit,
      search: provider.search,
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
  String? get name => r'userListProvider';
}

/// User List Provider
///
/// Copied from [userList].
class UserListProvider extends AutoDisposeFutureProvider<List<UserModel>> {
  /// User List Provider
  ///
  /// Copied from [userList].
  UserListProvider({
    int page = 1,
    int limit = 20,
    String? search,
  }) : this._internal(
          (ref) => userList(
            ref as UserListRef,
            page: page,
            limit: limit,
            search: search,
          ),
          from: userListProvider,
          name: r'userListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userListHash,
          dependencies: UserListFamily._dependencies,
          allTransitiveDependencies: UserListFamily._allTransitiveDependencies,
          page: page,
          limit: limit,
          search: search,
        );

  UserListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.page,
    required this.limit,
    required this.search,
  }) : super.internal();

  final int page;
  final int limit;
  final String? search;

  @override
  Override overrideWith(
    FutureOr<List<UserModel>> Function(UserListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserListProvider._internal(
        (ref) => create(ref as UserListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        page: page,
        limit: limit,
        search: search,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<UserModel>> createElement() {
    return _UserListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserListProvider &&
        other.page == page &&
        other.limit == limit &&
        other.search == search;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);
    hash = _SystemHash.combine(hash, search.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserListRef on AutoDisposeFutureProviderRef<List<UserModel>> {
  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `limit` of this provider.
  int get limit;

  /// The parameter `search` of this provider.
  String? get search;
}

class _UserListProviderElement
    extends AutoDisposeFutureProviderElement<List<UserModel>> with UserListRef {
  _UserListProviderElement(super.provider);

  @override
  int get page => (origin as UserListProvider).page;
  @override
  int get limit => (origin as UserListProvider).limit;
  @override
  String? get search => (origin as UserListProvider).search;
}

String _$userNotifierHash() => r'3fdaad89b3d685f3a1f1b0628985cc78ff93b87c';

/// User Notifier for mutations
///
/// Copied from [UserNotifier].
@ProviderFor(UserNotifier)
final userNotifierProvider =
    AutoDisposeAsyncNotifierProvider<UserNotifier, UserModel?>.internal(
  UserNotifier.new,
  name: r'userNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UserNotifier = AutoDisposeAsyncNotifier<UserModel?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
