// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'services_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$servicesByCategoryIdsHash() =>
    r'f5ba88db874e251aa5ba71b2056691e7f78e72d0';

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

/// Services by Category IDs Provider
/// Получает услуги, отфильтрованные по категориям
///
/// Copied from [servicesByCategoryIds].
@ProviderFor(servicesByCategoryIds)
const servicesByCategoryIdsProvider = ServicesByCategoryIdsFamily();

/// Services by Category IDs Provider
/// Получает услуги, отфильтрованные по категориям
///
/// Copied from [servicesByCategoryIds].
class ServicesByCategoryIdsFamily
    extends Family<AsyncValue<List<ServiceModel>>> {
  /// Services by Category IDs Provider
  /// Получает услуги, отфильтрованные по категориям
  ///
  /// Copied from [servicesByCategoryIds].
  const ServicesByCategoryIdsFamily();

  /// Services by Category IDs Provider
  /// Получает услуги, отфильтрованные по категориям
  ///
  /// Copied from [servicesByCategoryIds].
  ServicesByCategoryIdsProvider call(
    List<String> categoryIds,
  ) {
    return ServicesByCategoryIdsProvider(
      categoryIds,
    );
  }

  @override
  ServicesByCategoryIdsProvider getProviderOverride(
    covariant ServicesByCategoryIdsProvider provider,
  ) {
    return call(
      provider.categoryIds,
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
  String? get name => r'servicesByCategoryIdsProvider';
}

/// Services by Category IDs Provider
/// Получает услуги, отфильтрованные по категориям
///
/// Copied from [servicesByCategoryIds].
class ServicesByCategoryIdsProvider
    extends AutoDisposeFutureProvider<List<ServiceModel>> {
  /// Services by Category IDs Provider
  /// Получает услуги, отфильтрованные по категориям
  ///
  /// Copied from [servicesByCategoryIds].
  ServicesByCategoryIdsProvider(
    List<String> categoryIds,
  ) : this._internal(
          (ref) => servicesByCategoryIds(
            ref as ServicesByCategoryIdsRef,
            categoryIds,
          ),
          from: servicesByCategoryIdsProvider,
          name: r'servicesByCategoryIdsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$servicesByCategoryIdsHash,
          dependencies: ServicesByCategoryIdsFamily._dependencies,
          allTransitiveDependencies:
              ServicesByCategoryIdsFamily._allTransitiveDependencies,
          categoryIds: categoryIds,
        );

  ServicesByCategoryIdsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.categoryIds,
  }) : super.internal();

  final List<String> categoryIds;

  @override
  Override overrideWith(
    FutureOr<List<ServiceModel>> Function(ServicesByCategoryIdsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ServicesByCategoryIdsProvider._internal(
        (ref) => create(ref as ServicesByCategoryIdsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        categoryIds: categoryIds,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ServiceModel>> createElement() {
    return _ServicesByCategoryIdsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ServicesByCategoryIdsProvider &&
        other.categoryIds == categoryIds;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, categoryIds.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ServicesByCategoryIdsRef
    on AutoDisposeFutureProviderRef<List<ServiceModel>> {
  /// The parameter `categoryIds` of this provider.
  List<String> get categoryIds;
}

class _ServicesByCategoryIdsProviderElement
    extends AutoDisposeFutureProviderElement<List<ServiceModel>>
    with ServicesByCategoryIdsRef {
  _ServicesByCategoryIdsProviderElement(super.provider);

  @override
  List<String> get categoryIds =>
      (origin as ServicesByCategoryIdsProvider).categoryIds;
}

String _$serviceByIdHash() => r'85abd2f32b3dd0af6a6e7de500986c1c681a4e8a';

/// Service by ID Provider
/// Получает услугу по ID
///
/// Copied from [serviceById].
@ProviderFor(serviceById)
const serviceByIdProvider = ServiceByIdFamily();

/// Service by ID Provider
/// Получает услугу по ID
///
/// Copied from [serviceById].
class ServiceByIdFamily extends Family<AsyncValue<ServiceModel>> {
  /// Service by ID Provider
  /// Получает услугу по ID
  ///
  /// Copied from [serviceById].
  const ServiceByIdFamily();

  /// Service by ID Provider
  /// Получает услугу по ID
  ///
  /// Copied from [serviceById].
  ServiceByIdProvider call(
    String serviceId,
  ) {
    return ServiceByIdProvider(
      serviceId,
    );
  }

  @override
  ServiceByIdProvider getProviderOverride(
    covariant ServiceByIdProvider provider,
  ) {
    return call(
      provider.serviceId,
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
  String? get name => r'serviceByIdProvider';
}

/// Service by ID Provider
/// Получает услугу по ID
///
/// Copied from [serviceById].
class ServiceByIdProvider extends AutoDisposeFutureProvider<ServiceModel> {
  /// Service by ID Provider
  /// Получает услугу по ID
  ///
  /// Copied from [serviceById].
  ServiceByIdProvider(
    String serviceId,
  ) : this._internal(
          (ref) => serviceById(
            ref as ServiceByIdRef,
            serviceId,
          ),
          from: serviceByIdProvider,
          name: r'serviceByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$serviceByIdHash,
          dependencies: ServiceByIdFamily._dependencies,
          allTransitiveDependencies:
              ServiceByIdFamily._allTransitiveDependencies,
          serviceId: serviceId,
        );

  ServiceByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.serviceId,
  }) : super.internal();

  final String serviceId;

  @override
  Override overrideWith(
    FutureOr<ServiceModel> Function(ServiceByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ServiceByIdProvider._internal(
        (ref) => create(ref as ServiceByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        serviceId: serviceId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ServiceModel> createElement() {
    return _ServiceByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ServiceByIdProvider && other.serviceId == serviceId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, serviceId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ServiceByIdRef on AutoDisposeFutureProviderRef<ServiceModel> {
  /// The parameter `serviceId` of this provider.
  String get serviceId;
}

class _ServiceByIdProviderElement
    extends AutoDisposeFutureProviderElement<ServiceModel> with ServiceByIdRef {
  _ServiceByIdProviderElement(super.provider);

  @override
  String get serviceId => (origin as ServiceByIdProvider).serviceId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
