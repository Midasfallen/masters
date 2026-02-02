// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categories_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$categoriesHash() => r'c1bb8e3c076d58b1e91a2a928f9054fadcf18afe';

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

/// Categories Provider
/// Получает все категории плоским списком из API
///
/// Copied from [categories].
@ProviderFor(categories)
const categoriesProvider = CategoriesFamily();

/// Categories Provider
/// Получает все категории плоским списком из API
///
/// Copied from [categories].
class CategoriesFamily extends Family<AsyncValue<List<CategoryModel>>> {
  /// Categories Provider
  /// Получает все категории плоским списком из API
  ///
  /// Copied from [categories].
  const CategoriesFamily();

  /// Categories Provider
  /// Получает все категории плоским списком из API
  ///
  /// Copied from [categories].
  CategoriesProvider call({
    String? language,
  }) {
    return CategoriesProvider(
      language: language,
    );
  }

  @override
  CategoriesProvider getProviderOverride(
    covariant CategoriesProvider provider,
  ) {
    return call(
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
  String? get name => r'categoriesProvider';
}

/// Categories Provider
/// Получает все категории плоским списком из API
///
/// Copied from [categories].
class CategoriesProvider
    extends AutoDisposeFutureProvider<List<CategoryModel>> {
  /// Categories Provider
  /// Получает все категории плоским списком из API
  ///
  /// Copied from [categories].
  CategoriesProvider({
    String? language,
  }) : this._internal(
          (ref) => categories(
            ref as CategoriesRef,
            language: language,
          ),
          from: categoriesProvider,
          name: r'categoriesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$categoriesHash,
          dependencies: CategoriesFamily._dependencies,
          allTransitiveDependencies:
              CategoriesFamily._allTransitiveDependencies,
          language: language,
        );

  CategoriesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.language,
  }) : super.internal();

  final String? language;

  @override
  Override overrideWith(
    FutureOr<List<CategoryModel>> Function(CategoriesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CategoriesProvider._internal(
        (ref) => create(ref as CategoriesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        language: language,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<CategoryModel>> createElement() {
    return _CategoriesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CategoriesProvider && other.language == language;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, language.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CategoriesRef on AutoDisposeFutureProviderRef<List<CategoryModel>> {
  /// The parameter `language` of this provider.
  String? get language;
}

class _CategoriesProviderElement
    extends AutoDisposeFutureProviderElement<List<CategoryModel>>
    with CategoriesRef {
  _CategoriesProviderElement(super.provider);

  @override
  String? get language => (origin as CategoriesProvider).language;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
