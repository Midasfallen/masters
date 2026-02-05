// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_templates_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$serviceTemplatesByCategoryIdHash() =>
    r'7f8c2852388273385537ef2d8c375de1af8260db';

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

/// Service Templates by Category ID Provider
/// Получает шаблоны услуг для категории level 1
///
/// Copied from [serviceTemplatesByCategoryId].
@ProviderFor(serviceTemplatesByCategoryId)
const serviceTemplatesByCategoryIdProvider =
    ServiceTemplatesByCategoryIdFamily();

/// Service Templates by Category ID Provider
/// Получает шаблоны услуг для категории level 1
///
/// Copied from [serviceTemplatesByCategoryId].
class ServiceTemplatesByCategoryIdFamily
    extends Family<AsyncValue<ServiceTemplateListResponse>> {
  /// Service Templates by Category ID Provider
  /// Получает шаблоны услуг для категории level 1
  ///
  /// Copied from [serviceTemplatesByCategoryId].
  const ServiceTemplatesByCategoryIdFamily();

  /// Service Templates by Category ID Provider
  /// Получает шаблоны услуг для категории level 1
  ///
  /// Copied from [serviceTemplatesByCategoryId].
  ServiceTemplatesByCategoryIdProvider call(
    String categoryId, {
    String? language,
  }) {
    return ServiceTemplatesByCategoryIdProvider(
      categoryId,
      language: language,
    );
  }

  @override
  ServiceTemplatesByCategoryIdProvider getProviderOverride(
    covariant ServiceTemplatesByCategoryIdProvider provider,
  ) {
    return call(
      provider.categoryId,
      language: provider.language,
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
  String? get name => r'serviceTemplatesByCategoryIdProvider';
}

/// Service Templates by Category ID Provider
/// Получает шаблоны услуг для категории level 1
///
/// Copied from [serviceTemplatesByCategoryId].
class ServiceTemplatesByCategoryIdProvider
    extends AutoDisposeFutureProvider<ServiceTemplateListResponse> {
  /// Service Templates by Category ID Provider
  /// Получает шаблоны услуг для категории level 1
  ///
  /// Copied from [serviceTemplatesByCategoryId].
  ServiceTemplatesByCategoryIdProvider(
    String categoryId, {
    String? language,
  }) : this._internal(
          (ref) => serviceTemplatesByCategoryId(
            ref as ServiceTemplatesByCategoryIdRef,
            categoryId,
            language: language,
          ),
          from: serviceTemplatesByCategoryIdProvider,
          name: r'serviceTemplatesByCategoryIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$serviceTemplatesByCategoryIdHash,
          dependencies: ServiceTemplatesByCategoryIdFamily._dependencies,
          allTransitiveDependencies:
              ServiceTemplatesByCategoryIdFamily._allTransitiveDependencies,
          categoryId: categoryId,
          language: language,
        );

  ServiceTemplatesByCategoryIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.categoryId,
    required this.language,
  }) : super.internal();

  final String categoryId;
  final String? language;

  @override
  Override overrideWith(
    FutureOr<ServiceTemplateListResponse> Function(
            ServiceTemplatesByCategoryIdRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ServiceTemplatesByCategoryIdProvider._internal(
        (ref) => create(ref as ServiceTemplatesByCategoryIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        categoryId: categoryId,
        language: language,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ServiceTemplateListResponse>
      createElement() {
    return _ServiceTemplatesByCategoryIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ServiceTemplatesByCategoryIdProvider &&
        other.categoryId == categoryId &&
        other.language == language;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);
    hash = _SystemHash.combine(hash, language.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ServiceTemplatesByCategoryIdRef
    on AutoDisposeFutureProviderRef<ServiceTemplateListResponse> {
  /// The parameter `categoryId` of this provider.
  String get categoryId;

  /// The parameter `language` of this provider.
  String? get language;
}

class _ServiceTemplatesByCategoryIdProviderElement
    extends AutoDisposeFutureProviderElement<ServiceTemplateListResponse>
    with ServiceTemplatesByCategoryIdRef {
  _ServiceTemplatesByCategoryIdProviderElement(super.provider);

  @override
  String get categoryId =>
      (origin as ServiceTemplatesByCategoryIdProvider).categoryId;
  @override
  String? get language =>
      (origin as ServiceTemplatesByCategoryIdProvider).language;
}

String _$serviceTemplateBySlugHash() =>
    r'f2ba4302c3f4057f7b665054a756101fc6a3d9fc';

/// Service Template by Slug Provider
/// Получает шаблон услуги по slug
///
/// Copied from [serviceTemplateBySlug].
@ProviderFor(serviceTemplateBySlug)
const serviceTemplateBySlugProvider = ServiceTemplateBySlugFamily();

/// Service Template by Slug Provider
/// Получает шаблон услуги по slug
///
/// Copied from [serviceTemplateBySlug].
class ServiceTemplateBySlugFamily
    extends Family<AsyncValue<ServiceTemplateModel>> {
  /// Service Template by Slug Provider
  /// Получает шаблон услуги по slug
  ///
  /// Copied from [serviceTemplateBySlug].
  const ServiceTemplateBySlugFamily();

  /// Service Template by Slug Provider
  /// Получает шаблон услуги по slug
  ///
  /// Copied from [serviceTemplateBySlug].
  ServiceTemplateBySlugProvider call(
    String slug, {
    String? language,
  }) {
    return ServiceTemplateBySlugProvider(
      slug,
      language: language,
    );
  }

  @override
  ServiceTemplateBySlugProvider getProviderOverride(
    covariant ServiceTemplateBySlugProvider provider,
  ) {
    return call(
      provider.slug,
      language: provider.language,
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
  String? get name => r'serviceTemplateBySlugProvider';
}

/// Service Template by Slug Provider
/// Получает шаблон услуги по slug
///
/// Copied from [serviceTemplateBySlug].
class ServiceTemplateBySlugProvider
    extends AutoDisposeFutureProvider<ServiceTemplateModel> {
  /// Service Template by Slug Provider
  /// Получает шаблон услуги по slug
  ///
  /// Copied from [serviceTemplateBySlug].
  ServiceTemplateBySlugProvider(
    String slug, {
    String? language,
  }) : this._internal(
          (ref) => serviceTemplateBySlug(
            ref as ServiceTemplateBySlugRef,
            slug,
            language: language,
          ),
          from: serviceTemplateBySlugProvider,
          name: r'serviceTemplateBySlugProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$serviceTemplateBySlugHash,
          dependencies: ServiceTemplateBySlugFamily._dependencies,
          allTransitiveDependencies:
              ServiceTemplateBySlugFamily._allTransitiveDependencies,
          slug: slug,
          language: language,
        );

  ServiceTemplateBySlugProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.slug,
    required this.language,
  }) : super.internal();

  final String slug;
  final String? language;

  @override
  Override overrideWith(
    FutureOr<ServiceTemplateModel> Function(ServiceTemplateBySlugRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ServiceTemplateBySlugProvider._internal(
        (ref) => create(ref as ServiceTemplateBySlugRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        slug: slug,
        language: language,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ServiceTemplateModel> createElement() {
    return _ServiceTemplateBySlugProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ServiceTemplateBySlugProvider &&
        other.slug == slug &&
        other.language == language;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, slug.hashCode);
    hash = _SystemHash.combine(hash, language.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ServiceTemplateBySlugRef
    on AutoDisposeFutureProviderRef<ServiceTemplateModel> {
  /// The parameter `slug` of this provider.
  String get slug;

  /// The parameter `language` of this provider.
  String? get language;
}

class _ServiceTemplateBySlugProviderElement
    extends AutoDisposeFutureProviderElement<ServiceTemplateModel>
    with ServiceTemplateBySlugRef {
  _ServiceTemplateBySlugProviderElement(super.provider);

  @override
  String get slug => (origin as ServiceTemplateBySlugProvider).slug;
  @override
  String? get language => (origin as ServiceTemplateBySlugProvider).language;
}

String _$serviceTemplateByIdHash() =>
    r'9fe7bd2656809758927ceb707102dec66383af6b';

/// Service Template by ID Provider
/// Получает шаблон услуги по ID
///
/// Copied from [serviceTemplateById].
@ProviderFor(serviceTemplateById)
const serviceTemplateByIdProvider = ServiceTemplateByIdFamily();

/// Service Template by ID Provider
/// Получает шаблон услуги по ID
///
/// Copied from [serviceTemplateById].
class ServiceTemplateByIdFamily
    extends Family<AsyncValue<ServiceTemplateModel>> {
  /// Service Template by ID Provider
  /// Получает шаблон услуги по ID
  ///
  /// Copied from [serviceTemplateById].
  const ServiceTemplateByIdFamily();

  /// Service Template by ID Provider
  /// Получает шаблон услуги по ID
  ///
  /// Copied from [serviceTemplateById].
  ServiceTemplateByIdProvider call(
    String templateId, {
    String? language,
  }) {
    return ServiceTemplateByIdProvider(
      templateId,
      language: language,
    );
  }

  @override
  ServiceTemplateByIdProvider getProviderOverride(
    covariant ServiceTemplateByIdProvider provider,
  ) {
    return call(
      provider.templateId,
      language: provider.language,
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
  String? get name => r'serviceTemplateByIdProvider';
}

/// Service Template by ID Provider
/// Получает шаблон услуги по ID
///
/// Copied from [serviceTemplateById].
class ServiceTemplateByIdProvider
    extends AutoDisposeFutureProvider<ServiceTemplateModel> {
  /// Service Template by ID Provider
  /// Получает шаблон услуги по ID
  ///
  /// Copied from [serviceTemplateById].
  ServiceTemplateByIdProvider(
    String templateId, {
    String? language,
  }) : this._internal(
          (ref) => serviceTemplateById(
            ref as ServiceTemplateByIdRef,
            templateId,
            language: language,
          ),
          from: serviceTemplateByIdProvider,
          name: r'serviceTemplateByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$serviceTemplateByIdHash,
          dependencies: ServiceTemplateByIdFamily._dependencies,
          allTransitiveDependencies:
              ServiceTemplateByIdFamily._allTransitiveDependencies,
          templateId: templateId,
          language: language,
        );

  ServiceTemplateByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.templateId,
    required this.language,
  }) : super.internal();

  final String templateId;
  final String? language;

  @override
  Override overrideWith(
    FutureOr<ServiceTemplateModel> Function(ServiceTemplateByIdRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ServiceTemplateByIdProvider._internal(
        (ref) => create(ref as ServiceTemplateByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        templateId: templateId,
        language: language,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ServiceTemplateModel> createElement() {
    return _ServiceTemplateByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ServiceTemplateByIdProvider &&
        other.templateId == templateId &&
        other.language == language;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, templateId.hashCode);
    hash = _SystemHash.combine(hash, language.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ServiceTemplateByIdRef
    on AutoDisposeFutureProviderRef<ServiceTemplateModel> {
  /// The parameter `templateId` of this provider.
  String get templateId;

  /// The parameter `language` of this provider.
  String? get language;
}

class _ServiceTemplateByIdProviderElement
    extends AutoDisposeFutureProviderElement<ServiceTemplateModel>
    with ServiceTemplateByIdRef {
  _ServiceTemplateByIdProviderElement(super.provider);

  @override
  String get templateId => (origin as ServiceTemplateByIdProvider).templateId;
  @override
  String? get language => (origin as ServiceTemplateByIdProvider).language;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
