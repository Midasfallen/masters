// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'masters_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mastersListHash() => r'456e82b3663ea6f8ad3e0f90e8f57e03f93e4a5b';

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

/// Masters List Provider
///
/// Copied from [mastersList].
@ProviderFor(mastersList)
const mastersListProvider = MastersListFamily();

/// Masters List Provider
///
/// Copied from [mastersList].
class MastersListFamily extends Family<AsyncValue<List<MasterProfileModel>>> {
  /// Masters List Provider
  ///
  /// Copied from [mastersList].
  const MastersListFamily();

  /// Masters List Provider
  ///
  /// Copied from [mastersList].
  MastersListProvider call({
    int page = 1,
    int limit = 20,
    String? categoryId,
    double? lat,
    double? lng,
    int? radius,
  }) {
    return MastersListProvider(
      page: page,
      limit: limit,
      categoryId: categoryId,
      lat: lat,
      lng: lng,
      radius: radius,
    );
  }

  @override
  MastersListProvider getProviderOverride(
    covariant MastersListProvider provider,
  ) {
    return call(
      page: provider.page,
      limit: provider.limit,
      categoryId: provider.categoryId,
      lat: provider.lat,
      lng: provider.lng,
      radius: provider.radius,
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
  String? get name => r'mastersListProvider';
}

/// Masters List Provider
///
/// Copied from [mastersList].
class MastersListProvider
    extends AutoDisposeFutureProvider<List<MasterProfileModel>> {
  /// Masters List Provider
  ///
  /// Copied from [mastersList].
  MastersListProvider({
    int page = 1,
    int limit = 20,
    String? categoryId,
    double? lat,
    double? lng,
    int? radius,
  }) : this._internal(
          (ref) => mastersList(
            ref as MastersListRef,
            page: page,
            limit: limit,
            categoryId: categoryId,
            lat: lat,
            lng: lng,
            radius: radius,
          ),
          from: mastersListProvider,
          name: r'mastersListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$mastersListHash,
          dependencies: MastersListFamily._dependencies,
          allTransitiveDependencies:
              MastersListFamily._allTransitiveDependencies,
          page: page,
          limit: limit,
          categoryId: categoryId,
          lat: lat,
          lng: lng,
          radius: radius,
        );

  MastersListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.page,
    required this.limit,
    required this.categoryId,
    required this.lat,
    required this.lng,
    required this.radius,
  }) : super.internal();

  final int page;
  final int limit;
  final String? categoryId;
  final double? lat;
  final double? lng;
  final int? radius;

  @override
  Override overrideWith(
    FutureOr<List<MasterProfileModel>> Function(MastersListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MastersListProvider._internal(
        (ref) => create(ref as MastersListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        page: page,
        limit: limit,
        categoryId: categoryId,
        lat: lat,
        lng: lng,
        radius: radius,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<MasterProfileModel>> createElement() {
    return _MastersListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MastersListProvider &&
        other.page == page &&
        other.limit == limit &&
        other.categoryId == categoryId &&
        other.lat == lat &&
        other.lng == lng &&
        other.radius == radius;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);
    hash = _SystemHash.combine(hash, lat.hashCode);
    hash = _SystemHash.combine(hash, lng.hashCode);
    hash = _SystemHash.combine(hash, radius.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MastersListRef on AutoDisposeFutureProviderRef<List<MasterProfileModel>> {
  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `limit` of this provider.
  int get limit;

  /// The parameter `categoryId` of this provider.
  String? get categoryId;

  /// The parameter `lat` of this provider.
  double? get lat;

  /// The parameter `lng` of this provider.
  double? get lng;

  /// The parameter `radius` of this provider.
  int? get radius;
}

class _MastersListProviderElement
    extends AutoDisposeFutureProviderElement<List<MasterProfileModel>>
    with MastersListRef {
  _MastersListProviderElement(super.provider);

  @override
  int get page => (origin as MastersListProvider).page;
  @override
  int get limit => (origin as MastersListProvider).limit;
  @override
  String? get categoryId => (origin as MastersListProvider).categoryId;
  @override
  double? get lat => (origin as MastersListProvider).lat;
  @override
  double? get lng => (origin as MastersListProvider).lng;
  @override
  int? get radius => (origin as MastersListProvider).radius;
}

String _$masterByProfileIdHash() => r'e7608d93f9a53dd9dd267b4a36b697d3790f34a1';

/// Master by Profile ID Provider
/// Gets master profile by master profile ID (not userId!)
///
/// Copied from [masterByProfileId].
@ProviderFor(masterByProfileId)
const masterByProfileIdProvider = MasterByProfileIdFamily();

/// Master by Profile ID Provider
/// Gets master profile by master profile ID (not userId!)
///
/// Copied from [masterByProfileId].
class MasterByProfileIdFamily extends Family<AsyncValue<MasterProfileModel>> {
  /// Master by Profile ID Provider
  /// Gets master profile by master profile ID (not userId!)
  ///
  /// Copied from [masterByProfileId].
  const MasterByProfileIdFamily();

  /// Master by Profile ID Provider
  /// Gets master profile by master profile ID (not userId!)
  ///
  /// Copied from [masterByProfileId].
  MasterByProfileIdProvider call(
    String masterId,
  ) {
    return MasterByProfileIdProvider(
      masterId,
    );
  }

  @override
  MasterByProfileIdProvider getProviderOverride(
    covariant MasterByProfileIdProvider provider,
  ) {
    return call(
      provider.masterId,
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
  String? get name => r'masterByProfileIdProvider';
}

/// Master by Profile ID Provider
/// Gets master profile by master profile ID (not userId!)
///
/// Copied from [masterByProfileId].
class MasterByProfileIdProvider
    extends AutoDisposeFutureProvider<MasterProfileModel> {
  /// Master by Profile ID Provider
  /// Gets master profile by master profile ID (not userId!)
  ///
  /// Copied from [masterByProfileId].
  MasterByProfileIdProvider(
    String masterId,
  ) : this._internal(
          (ref) => masterByProfileId(
            ref as MasterByProfileIdRef,
            masterId,
          ),
          from: masterByProfileIdProvider,
          name: r'masterByProfileIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$masterByProfileIdHash,
          dependencies: MasterByProfileIdFamily._dependencies,
          allTransitiveDependencies:
              MasterByProfileIdFamily._allTransitiveDependencies,
          masterId: masterId,
        );

  MasterByProfileIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.masterId,
  }) : super.internal();

  final String masterId;

  @override
  Override overrideWith(
    FutureOr<MasterProfileModel> Function(MasterByProfileIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MasterByProfileIdProvider._internal(
        (ref) => create(ref as MasterByProfileIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        masterId: masterId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<MasterProfileModel> createElement() {
    return _MasterByProfileIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MasterByProfileIdProvider && other.masterId == masterId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, masterId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MasterByProfileIdRef on AutoDisposeFutureProviderRef<MasterProfileModel> {
  /// The parameter `masterId` of this provider.
  String get masterId;
}

class _MasterByProfileIdProviderElement
    extends AutoDisposeFutureProviderElement<MasterProfileModel>
    with MasterByProfileIdRef {
  _MasterByProfileIdProviderElement(super.provider);

  @override
  String get masterId => (origin as MasterByProfileIdProvider).masterId;
}

String _$masterByUserIdHash() => r'de98625429b09eb87b36468c0b61fcbe4f6476b9';

/// Master by User ID Provider
/// Gets master profile by user ID (authorId from post)
///
/// Использует эндпоинт GET /masters/:id, который теперь поддерживает
/// поиск как по ID профиля мастера, так и по user_id.
///
/// Copied from [masterByUserId].
@ProviderFor(masterByUserId)
const masterByUserIdProvider = MasterByUserIdFamily();

/// Master by User ID Provider
/// Gets master profile by user ID (authorId from post)
///
/// Использует эндпоинт GET /masters/:id, который теперь поддерживает
/// поиск как по ID профиля мастера, так и по user_id.
///
/// Copied from [masterByUserId].
class MasterByUserIdFamily extends Family<AsyncValue<MasterProfileModel>> {
  /// Master by User ID Provider
  /// Gets master profile by user ID (authorId from post)
  ///
  /// Использует эндпоинт GET /masters/:id, который теперь поддерживает
  /// поиск как по ID профиля мастера, так и по user_id.
  ///
  /// Copied from [masterByUserId].
  const MasterByUserIdFamily();

  /// Master by User ID Provider
  /// Gets master profile by user ID (authorId from post)
  ///
  /// Использует эндпоинт GET /masters/:id, который теперь поддерживает
  /// поиск как по ID профиля мастера, так и по user_id.
  ///
  /// Copied from [masterByUserId].
  MasterByUserIdProvider call(
    String userId,
  ) {
    return MasterByUserIdProvider(
      userId,
    );
  }

  @override
  MasterByUserIdProvider getProviderOverride(
    covariant MasterByUserIdProvider provider,
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
  String? get name => r'masterByUserIdProvider';
}

/// Master by User ID Provider
/// Gets master profile by user ID (authorId from post)
///
/// Использует эндпоинт GET /masters/:id, который теперь поддерживает
/// поиск как по ID профиля мастера, так и по user_id.
///
/// Copied from [masterByUserId].
class MasterByUserIdProvider
    extends AutoDisposeFutureProvider<MasterProfileModel> {
  /// Master by User ID Provider
  /// Gets master profile by user ID (authorId from post)
  ///
  /// Использует эндпоинт GET /masters/:id, который теперь поддерживает
  /// поиск как по ID профиля мастера, так и по user_id.
  ///
  /// Copied from [masterByUserId].
  MasterByUserIdProvider(
    String userId,
  ) : this._internal(
          (ref) => masterByUserId(
            ref as MasterByUserIdRef,
            userId,
          ),
          from: masterByUserIdProvider,
          name: r'masterByUserIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$masterByUserIdHash,
          dependencies: MasterByUserIdFamily._dependencies,
          allTransitiveDependencies:
              MasterByUserIdFamily._allTransitiveDependencies,
          userId: userId,
        );

  MasterByUserIdProvider._internal(
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
    FutureOr<MasterProfileModel> Function(MasterByUserIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MasterByUserIdProvider._internal(
        (ref) => create(ref as MasterByUserIdRef),
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
  AutoDisposeFutureProviderElement<MasterProfileModel> createElement() {
    return _MasterByUserIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MasterByUserIdProvider && other.userId == userId;
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
mixin MasterByUserIdRef on AutoDisposeFutureProviderRef<MasterProfileModel> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _MasterByUserIdProviderElement
    extends AutoDisposeFutureProviderElement<MasterProfileModel>
    with MasterByUserIdRef {
  _MasterByUserIdProviderElement(super.provider);

  @override
  String get userId => (origin as MasterByUserIdProvider).userId;
}

String _$masterByIdHash() => r'af3f71aca6274ece113cd3879042f401e09841a9';

/// Master by ID Provider (deprecated - use masterByProfileId or masterByUserId)
///
/// ⚠️ DEPRECATED: Этот провайдер больше не должен использоваться.
/// Используйте masterByProfileId для поиска по ID профиля мастера
/// или masterByUserId для поиска по ID пользователя.
///
/// Copied from [masterById].
@ProviderFor(masterById)
const masterByIdProvider = MasterByIdFamily();

/// Master by ID Provider (deprecated - use masterByProfileId or masterByUserId)
///
/// ⚠️ DEPRECATED: Этот провайдер больше не должен использоваться.
/// Используйте masterByProfileId для поиска по ID профиля мастера
/// или masterByUserId для поиска по ID пользователя.
///
/// Copied from [masterById].
class MasterByIdFamily extends Family<AsyncValue<MasterProfileModel>> {
  /// Master by ID Provider (deprecated - use masterByProfileId or masterByUserId)
  ///
  /// ⚠️ DEPRECATED: Этот провайдер больше не должен использоваться.
  /// Используйте masterByProfileId для поиска по ID профиля мастера
  /// или masterByUserId для поиска по ID пользователя.
  ///
  /// Copied from [masterById].
  const MasterByIdFamily();

  /// Master by ID Provider (deprecated - use masterByProfileId or masterByUserId)
  ///
  /// ⚠️ DEPRECATED: Этот провайдер больше не должен использоваться.
  /// Используйте masterByProfileId для поиска по ID профиля мастера
  /// или masterByUserId для поиска по ID пользователя.
  ///
  /// Copied from [masterById].
  MasterByIdProvider call(
    String id,
  ) {
    return MasterByIdProvider(
      id,
    );
  }

  @override
  MasterByIdProvider getProviderOverride(
    covariant MasterByIdProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'masterByIdProvider';
}

/// Master by ID Provider (deprecated - use masterByProfileId or masterByUserId)
///
/// ⚠️ DEPRECATED: Этот провайдер больше не должен использоваться.
/// Используйте masterByProfileId для поиска по ID профиля мастера
/// или masterByUserId для поиска по ID пользователя.
///
/// Copied from [masterById].
class MasterByIdProvider extends AutoDisposeFutureProvider<MasterProfileModel> {
  /// Master by ID Provider (deprecated - use masterByProfileId or masterByUserId)
  ///
  /// ⚠️ DEPRECATED: Этот провайдер больше не должен использоваться.
  /// Используйте masterByProfileId для поиска по ID профиля мастера
  /// или masterByUserId для поиска по ID пользователя.
  ///
  /// Copied from [masterById].
  MasterByIdProvider(
    String id,
  ) : this._internal(
          (ref) => masterById(
            ref as MasterByIdRef,
            id,
          ),
          from: masterByIdProvider,
          name: r'masterByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$masterByIdHash,
          dependencies: MasterByIdFamily._dependencies,
          allTransitiveDependencies:
              MasterByIdFamily._allTransitiveDependencies,
          id: id,
        );

  MasterByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<MasterProfileModel> Function(MasterByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MasterByIdProvider._internal(
        (ref) => create(ref as MasterByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<MasterProfileModel> createElement() {
    return _MasterByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MasterByIdProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MasterByIdRef on AutoDisposeFutureProviderRef<MasterProfileModel> {
  /// The parameter `id` of this provider.
  String get id;
}

class _MasterByIdProviderElement
    extends AutoDisposeFutureProviderElement<MasterProfileModel>
    with MasterByIdRef {
  _MasterByIdProviderElement(super.provider);

  @override
  String get id => (origin as MasterByIdProvider).id;
}

String _$masterServicesHash() => r'8347dcaec55f7fb797acc249fc812a85fb62cde2';

/// Master Services Provider
///
/// Copied from [masterServices].
@ProviderFor(masterServices)
const masterServicesProvider = MasterServicesFamily();

/// Master Services Provider
///
/// Copied from [masterServices].
class MasterServicesFamily extends Family<AsyncValue<List<ServiceModel>>> {
  /// Master Services Provider
  ///
  /// Copied from [masterServices].
  const MasterServicesFamily();

  /// Master Services Provider
  ///
  /// Copied from [masterServices].
  MasterServicesProvider call(
    String masterProfileId,
  ) {
    return MasterServicesProvider(
      masterProfileId,
    );
  }

  @override
  MasterServicesProvider getProviderOverride(
    covariant MasterServicesProvider provider,
  ) {
    return call(
      provider.masterProfileId,
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
  String? get name => r'masterServicesProvider';
}

/// Master Services Provider
///
/// Copied from [masterServices].
class MasterServicesProvider
    extends AutoDisposeFutureProvider<List<ServiceModel>> {
  /// Master Services Provider
  ///
  /// Copied from [masterServices].
  MasterServicesProvider(
    String masterProfileId,
  ) : this._internal(
          (ref) => masterServices(
            ref as MasterServicesRef,
            masterProfileId,
          ),
          from: masterServicesProvider,
          name: r'masterServicesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$masterServicesHash,
          dependencies: MasterServicesFamily._dependencies,
          allTransitiveDependencies:
              MasterServicesFamily._allTransitiveDependencies,
          masterProfileId: masterProfileId,
        );

  MasterServicesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.masterProfileId,
  }) : super.internal();

  final String masterProfileId;

  @override
  Override overrideWith(
    FutureOr<List<ServiceModel>> Function(MasterServicesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MasterServicesProvider._internal(
        (ref) => create(ref as MasterServicesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        masterProfileId: masterProfileId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ServiceModel>> createElement() {
    return _MasterServicesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MasterServicesProvider &&
        other.masterProfileId == masterProfileId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, masterProfileId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MasterServicesRef on AutoDisposeFutureProviderRef<List<ServiceModel>> {
  /// The parameter `masterProfileId` of this provider.
  String get masterProfileId;
}

class _MasterServicesProviderElement
    extends AutoDisposeFutureProviderElement<List<ServiceModel>>
    with MasterServicesRef {
  _MasterServicesProviderElement(super.provider);

  @override
  String get masterProfileId =>
      (origin as MasterServicesProvider).masterProfileId;
}

String _$masterReviewsHash() => r'14da0c8087b1afae662b98a0ef89c81f4ff673b7';

/// Master Reviews Provider
///
/// Copied from [masterReviews].
@ProviderFor(masterReviews)
const masterReviewsProvider = MasterReviewsFamily();

/// Master Reviews Provider
///
/// Copied from [masterReviews].
class MasterReviewsFamily extends Family<AsyncValue<List<ReviewModel>>> {
  /// Master Reviews Provider
  ///
  /// Copied from [masterReviews].
  const MasterReviewsFamily();

  /// Master Reviews Provider
  ///
  /// Copied from [masterReviews].
  MasterReviewsProvider call(
    String userId, {
    int page = 1,
    int limit = 20,
  }) {
    return MasterReviewsProvider(
      userId,
      page: page,
      limit: limit,
    );
  }

  @override
  MasterReviewsProvider getProviderOverride(
    covariant MasterReviewsProvider provider,
  ) {
    return call(
      provider.userId,
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
  String? get name => r'masterReviewsProvider';
}

/// Master Reviews Provider
///
/// Copied from [masterReviews].
class MasterReviewsProvider
    extends AutoDisposeFutureProvider<List<ReviewModel>> {
  /// Master Reviews Provider
  ///
  /// Copied from [masterReviews].
  MasterReviewsProvider(
    String userId, {
    int page = 1,
    int limit = 20,
  }) : this._internal(
          (ref) => masterReviews(
            ref as MasterReviewsRef,
            userId,
            page: page,
            limit: limit,
          ),
          from: masterReviewsProvider,
          name: r'masterReviewsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$masterReviewsHash,
          dependencies: MasterReviewsFamily._dependencies,
          allTransitiveDependencies:
              MasterReviewsFamily._allTransitiveDependencies,
          userId: userId,
          page: page,
          limit: limit,
        );

  MasterReviewsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
    required this.page,
    required this.limit,
  }) : super.internal();

  final String userId;
  final int page;
  final int limit;

  @override
  Override overrideWith(
    FutureOr<List<ReviewModel>> Function(MasterReviewsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MasterReviewsProvider._internal(
        (ref) => create(ref as MasterReviewsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
        page: page,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ReviewModel>> createElement() {
    return _MasterReviewsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MasterReviewsProvider &&
        other.userId == userId &&
        other.page == page &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MasterReviewsRef on AutoDisposeFutureProviderRef<List<ReviewModel>> {
  /// The parameter `userId` of this provider.
  String get userId;

  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _MasterReviewsProviderElement
    extends AutoDisposeFutureProviderElement<List<ReviewModel>>
    with MasterReviewsRef {
  _MasterReviewsProviderElement(super.provider);

  @override
  String get userId => (origin as MasterReviewsProvider).userId;
  @override
  int get page => (origin as MasterReviewsProvider).page;
  @override
  int get limit => (origin as MasterReviewsProvider).limit;
}

String _$myMasterProfileHash() => r'30f43840d5d89bb1963740b88dc7265b214df07e';

/// My Master Profile Provider
///
/// Copied from [myMasterProfile].
@ProviderFor(myMasterProfile)
final myMasterProfileProvider =
    AutoDisposeFutureProvider<MasterProfileModel?>.internal(
  myMasterProfile,
  name: r'myMasterProfileProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$myMasterProfileHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MyMasterProfileRef = AutoDisposeFutureProviderRef<MasterProfileModel?>;
String _$masterNotifierHash() => r'673f20aa33207cd1ac283877520a193cc889c646';

/// Master Notifier for mutations
///
/// Copied from [MasterNotifier].
@ProviderFor(MasterNotifier)
final masterNotifierProvider = AutoDisposeAsyncNotifierProvider<MasterNotifier,
    MasterProfileModel?>.internal(
  MasterNotifier.new,
  name: r'masterNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$masterNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MasterNotifier = AutoDisposeAsyncNotifier<MasterProfileModel?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
