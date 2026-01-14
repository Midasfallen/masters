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

String _$masterByIdHash() => r'5903348f437b4e09a6d65fd402eb5d7b0962d584';

/// Master by ID Provider
///
/// Copied from [masterById].
@ProviderFor(masterById)
const masterByIdProvider = MasterByIdFamily();

/// Master by ID Provider
///
/// Copied from [masterById].
class MasterByIdFamily extends Family<AsyncValue<MasterProfileModel>> {
  /// Master by ID Provider
  ///
  /// Copied from [masterById].
  const MasterByIdFamily();

  /// Master by ID Provider
  ///
  /// Copied from [masterById].
  MasterByIdProvider call(
    String masterId,
  ) {
    return MasterByIdProvider(
      masterId,
    );
  }

  @override
  MasterByIdProvider getProviderOverride(
    covariant MasterByIdProvider provider,
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
  String? get name => r'masterByIdProvider';
}

/// Master by ID Provider
///
/// Copied from [masterById].
class MasterByIdProvider extends AutoDisposeFutureProvider<MasterProfileModel> {
  /// Master by ID Provider
  ///
  /// Copied from [masterById].
  MasterByIdProvider(
    String masterId,
  ) : this._internal(
          (ref) => masterById(
            ref as MasterByIdRef,
            masterId,
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
          masterId: masterId,
        );

  MasterByIdProvider._internal(
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
        masterId: masterId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<MasterProfileModel> createElement() {
    return _MasterByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MasterByIdProvider && other.masterId == masterId;
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
mixin MasterByIdRef on AutoDisposeFutureProviderRef<MasterProfileModel> {
  /// The parameter `masterId` of this provider.
  String get masterId;
}

class _MasterByIdProviderElement
    extends AutoDisposeFutureProviderElement<MasterProfileModel>
    with MasterByIdRef {
  _MasterByIdProviderElement(super.provider);

  @override
  String get masterId => (origin as MasterByIdProvider).masterId;
}

String _$masterServicesHash() => r'e93653df7daf9010f1ada1783710d14fa974abfd';

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
    String masterId,
  ) {
    return MasterServicesProvider(
      masterId,
    );
  }

  @override
  MasterServicesProvider getProviderOverride(
    covariant MasterServicesProvider provider,
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
    String masterId,
  ) : this._internal(
          (ref) => masterServices(
            ref as MasterServicesRef,
            masterId,
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
          masterId: masterId,
        );

  MasterServicesProvider._internal(
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
        masterId: masterId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ServiceModel>> createElement() {
    return _MasterServicesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MasterServicesProvider && other.masterId == masterId;
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
mixin MasterServicesRef on AutoDisposeFutureProviderRef<List<ServiceModel>> {
  /// The parameter `masterId` of this provider.
  String get masterId;
}

class _MasterServicesProviderElement
    extends AutoDisposeFutureProviderElement<List<ServiceModel>>
    with MasterServicesRef {
  _MasterServicesProviderElement(super.provider);

  @override
  String get masterId => (origin as MasterServicesProvider).masterId;
}

String _$masterReviewsHash() => r'1312dd6888c4c34410ad98acfdd1bbeec1253a85';

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
    String masterId, {
    int page = 1,
    int limit = 20,
  }) {
    return MasterReviewsProvider(
      masterId,
      page: page,
      limit: limit,
    );
  }

  @override
  MasterReviewsProvider getProviderOverride(
    covariant MasterReviewsProvider provider,
  ) {
    return call(
      provider.masterId,
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
    String masterId, {
    int page = 1,
    int limit = 20,
  }) : this._internal(
          (ref) => masterReviews(
            ref as MasterReviewsRef,
            masterId,
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
          masterId: masterId,
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
    required this.masterId,
    required this.page,
    required this.limit,
  }) : super.internal();

  final String masterId;
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
        masterId: masterId,
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
        other.masterId == masterId &&
        other.page == page &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, masterId.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MasterReviewsRef on AutoDisposeFutureProviderRef<List<ReviewModel>> {
  /// The parameter `masterId` of this provider.
  String get masterId;

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
  String get masterId => (origin as MasterReviewsProvider).masterId;
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
