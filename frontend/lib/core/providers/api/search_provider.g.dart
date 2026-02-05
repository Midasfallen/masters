// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$searchMastersHash() => r'8705268f03af98d2c6f3429ae17f63d85584cbeb';

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

/// Search Masters Provider
///
/// Copied from [searchMasters].
@ProviderFor(searchMasters)
const searchMastersProvider = SearchMastersFamily();

/// Search Masters Provider
///
/// Copied from [searchMasters].
class SearchMastersFamily extends Family<AsyncValue<List<MasterProfileModel>>> {
  /// Search Masters Provider
  ///
  /// Copied from [searchMasters].
  const SearchMastersFamily();

  /// Search Masters Provider
  ///
  /// Copied from [searchMasters].
  SearchMastersProvider call({
    String query = '',
    int page = 1,
    int limit = 20,
    String? categoryId,
    List<String>? categoryIds,
    double? lat,
    double? lng,
    int? radius,
    double? minRating,
    int? maxPrice,
  }) {
    return SearchMastersProvider(
      query: query,
      page: page,
      limit: limit,
      categoryId: categoryId,
      categoryIds: categoryIds,
      lat: lat,
      lng: lng,
      radius: radius,
      minRating: minRating,
      maxPrice: maxPrice,
    );
  }

  @override
  SearchMastersProvider getProviderOverride(
    covariant SearchMastersProvider provider,
  ) {
    return call(
      query: provider.query,
      page: provider.page,
      limit: provider.limit,
      categoryId: provider.categoryId,
      categoryIds: provider.categoryIds,
      lat: provider.lat,
      lng: provider.lng,
      radius: provider.radius,
      minRating: provider.minRating,
      maxPrice: provider.maxPrice,
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
  String? get name => r'searchMastersProvider';
}

/// Search Masters Provider
///
/// Copied from [searchMasters].
class SearchMastersProvider
    extends AutoDisposeFutureProvider<List<MasterProfileModel>> {
  /// Search Masters Provider
  ///
  /// Copied from [searchMasters].
  SearchMastersProvider({
    String query = '',
    int page = 1,
    int limit = 20,
    String? categoryId,
    List<String>? categoryIds,
    double? lat,
    double? lng,
    int? radius,
    double? minRating,
    int? maxPrice,
  }) : this._internal(
          (ref) => searchMasters(
            ref as SearchMastersRef,
            query: query,
            page: page,
            limit: limit,
            categoryId: categoryId,
            categoryIds: categoryIds,
            lat: lat,
            lng: lng,
            radius: radius,
            minRating: minRating,
            maxPrice: maxPrice,
          ),
          from: searchMastersProvider,
          name: r'searchMastersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchMastersHash,
          dependencies: SearchMastersFamily._dependencies,
          allTransitiveDependencies:
              SearchMastersFamily._allTransitiveDependencies,
          query: query,
          page: page,
          limit: limit,
          categoryId: categoryId,
          categoryIds: categoryIds,
          lat: lat,
          lng: lng,
          radius: radius,
          minRating: minRating,
          maxPrice: maxPrice,
        );

  SearchMastersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
    required this.page,
    required this.limit,
    required this.categoryId,
    required this.categoryIds,
    required this.lat,
    required this.lng,
    required this.radius,
    required this.minRating,
    required this.maxPrice,
  }) : super.internal();

  final String query;
  final int page;
  final int limit;
  final String? categoryId;
  final List<String>? categoryIds;
  final double? lat;
  final double? lng;
  final int? radius;
  final double? minRating;
  final int? maxPrice;

  @override
  Override overrideWith(
    FutureOr<List<MasterProfileModel>> Function(SearchMastersRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchMastersProvider._internal(
        (ref) => create(ref as SearchMastersRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
        page: page,
        limit: limit,
        categoryId: categoryId,
        categoryIds: categoryIds,
        lat: lat,
        lng: lng,
        radius: radius,
        minRating: minRating,
        maxPrice: maxPrice,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<MasterProfileModel>> createElement() {
    return _SearchMastersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchMastersProvider &&
        other.query == query &&
        other.page == page &&
        other.limit == limit &&
        other.categoryId == categoryId &&
        other.categoryIds == categoryIds &&
        other.lat == lat &&
        other.lng == lng &&
        other.radius == radius &&
        other.minRating == minRating &&
        other.maxPrice == maxPrice;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);
    hash = _SystemHash.combine(hash, categoryIds.hashCode);
    hash = _SystemHash.combine(hash, lat.hashCode);
    hash = _SystemHash.combine(hash, lng.hashCode);
    hash = _SystemHash.combine(hash, radius.hashCode);
    hash = _SystemHash.combine(hash, minRating.hashCode);
    hash = _SystemHash.combine(hash, maxPrice.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchMastersRef
    on AutoDisposeFutureProviderRef<List<MasterProfileModel>> {
  /// The parameter `query` of this provider.
  String get query;

  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `limit` of this provider.
  int get limit;

  /// The parameter `categoryId` of this provider.
  String? get categoryId;

  /// The parameter `categoryIds` of this provider.
  List<String>? get categoryIds;

  /// The parameter `lat` of this provider.
  double? get lat;

  /// The parameter `lng` of this provider.
  double? get lng;

  /// The parameter `radius` of this provider.
  int? get radius;

  /// The parameter `minRating` of this provider.
  double? get minRating;

  /// The parameter `maxPrice` of this provider.
  int? get maxPrice;
}

class _SearchMastersProviderElement
    extends AutoDisposeFutureProviderElement<List<MasterProfileModel>>
    with SearchMastersRef {
  _SearchMastersProviderElement(super.provider);

  @override
  String get query => (origin as SearchMastersProvider).query;
  @override
  int get page => (origin as SearchMastersProvider).page;
  @override
  int get limit => (origin as SearchMastersProvider).limit;
  @override
  String? get categoryId => (origin as SearchMastersProvider).categoryId;
  @override
  List<String>? get categoryIds =>
      (origin as SearchMastersProvider).categoryIds;
  @override
  double? get lat => (origin as SearchMastersProvider).lat;
  @override
  double? get lng => (origin as SearchMastersProvider).lng;
  @override
  int? get radius => (origin as SearchMastersProvider).radius;
  @override
  double? get minRating => (origin as SearchMastersProvider).minRating;
  @override
  int? get maxPrice => (origin as SearchMastersProvider).maxPrice;
}

String _$searchServicesHash() => r'a0b7a08aa7fda62edcd074b59a81ea28b37ee7b1';

/// Search Services Provider
///
/// Copied from [searchServices].
@ProviderFor(searchServices)
const searchServicesProvider = SearchServicesFamily();

/// Search Services Provider
///
/// Copied from [searchServices].
class SearchServicesFamily extends Family<AsyncValue<List<ServiceModel>>> {
  /// Search Services Provider
  ///
  /// Copied from [searchServices].
  const SearchServicesFamily();

  /// Search Services Provider
  ///
  /// Copied from [searchServices].
  SearchServicesProvider call({
    String query = '',
    int page = 1,
    int limit = 20,
    String? categoryId,
    List<String>? categoryIds,
    double? minPrice,
    double? maxPrice,
  }) {
    return SearchServicesProvider(
      query: query,
      page: page,
      limit: limit,
      categoryId: categoryId,
      categoryIds: categoryIds,
      minPrice: minPrice,
      maxPrice: maxPrice,
    );
  }

  @override
  SearchServicesProvider getProviderOverride(
    covariant SearchServicesProvider provider,
  ) {
    return call(
      query: provider.query,
      page: provider.page,
      limit: provider.limit,
      categoryId: provider.categoryId,
      categoryIds: provider.categoryIds,
      minPrice: provider.minPrice,
      maxPrice: provider.maxPrice,
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
  String? get name => r'searchServicesProvider';
}

/// Search Services Provider
///
/// Copied from [searchServices].
class SearchServicesProvider
    extends AutoDisposeFutureProvider<List<ServiceModel>> {
  /// Search Services Provider
  ///
  /// Copied from [searchServices].
  SearchServicesProvider({
    String query = '',
    int page = 1,
    int limit = 20,
    String? categoryId,
    List<String>? categoryIds,
    double? minPrice,
    double? maxPrice,
  }) : this._internal(
          (ref) => searchServices(
            ref as SearchServicesRef,
            query: query,
            page: page,
            limit: limit,
            categoryId: categoryId,
            categoryIds: categoryIds,
            minPrice: minPrice,
            maxPrice: maxPrice,
          ),
          from: searchServicesProvider,
          name: r'searchServicesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchServicesHash,
          dependencies: SearchServicesFamily._dependencies,
          allTransitiveDependencies:
              SearchServicesFamily._allTransitiveDependencies,
          query: query,
          page: page,
          limit: limit,
          categoryId: categoryId,
          categoryIds: categoryIds,
          minPrice: minPrice,
          maxPrice: maxPrice,
        );

  SearchServicesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
    required this.page,
    required this.limit,
    required this.categoryId,
    required this.categoryIds,
    required this.minPrice,
    required this.maxPrice,
  }) : super.internal();

  final String query;
  final int page;
  final int limit;
  final String? categoryId;
  final List<String>? categoryIds;
  final double? minPrice;
  final double? maxPrice;

  @override
  Override overrideWith(
    FutureOr<List<ServiceModel>> Function(SearchServicesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchServicesProvider._internal(
        (ref) => create(ref as SearchServicesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
        page: page,
        limit: limit,
        categoryId: categoryId,
        categoryIds: categoryIds,
        minPrice: minPrice,
        maxPrice: maxPrice,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ServiceModel>> createElement() {
    return _SearchServicesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchServicesProvider &&
        other.query == query &&
        other.page == page &&
        other.limit == limit &&
        other.categoryId == categoryId &&
        other.categoryIds == categoryIds &&
        other.minPrice == minPrice &&
        other.maxPrice == maxPrice;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);
    hash = _SystemHash.combine(hash, categoryIds.hashCode);
    hash = _SystemHash.combine(hash, minPrice.hashCode);
    hash = _SystemHash.combine(hash, maxPrice.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchServicesRef on AutoDisposeFutureProviderRef<List<ServiceModel>> {
  /// The parameter `query` of this provider.
  String get query;

  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `limit` of this provider.
  int get limit;

  /// The parameter `categoryId` of this provider.
  String? get categoryId;

  /// The parameter `categoryIds` of this provider.
  List<String>? get categoryIds;

  /// The parameter `minPrice` of this provider.
  double? get minPrice;

  /// The parameter `maxPrice` of this provider.
  double? get maxPrice;
}

class _SearchServicesProviderElement
    extends AutoDisposeFutureProviderElement<List<ServiceModel>>
    with SearchServicesRef {
  _SearchServicesProviderElement(super.provider);

  @override
  String get query => (origin as SearchServicesProvider).query;
  @override
  int get page => (origin as SearchServicesProvider).page;
  @override
  int get limit => (origin as SearchServicesProvider).limit;
  @override
  String? get categoryId => (origin as SearchServicesProvider).categoryId;
  @override
  List<String>? get categoryIds =>
      (origin as SearchServicesProvider).categoryIds;
  @override
  double? get minPrice => (origin as SearchServicesProvider).minPrice;
  @override
  double? get maxPrice => (origin as SearchServicesProvider).maxPrice;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
