// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categories_tree_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$categoriesTreeHash() => r'12820a9b431940fb441b03ae1769834b42c59098';

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

/// Categories Tree Provider
/// Получает дерево категорий из API
///
/// Copied from [categoriesTree].
@ProviderFor(categoriesTree)
const categoriesTreeProvider = CategoriesTreeFamily();

/// Categories Tree Provider
/// Получает дерево категорий из API
///
/// Copied from [categoriesTree].
class CategoriesTreeFamily extends Family<AsyncValue<List<CategoryTreeModel>>> {
  /// Categories Tree Provider
  /// Получает дерево категорий из API
  ///
  /// Copied from [categoriesTree].
  const CategoriesTreeFamily();

  /// Categories Tree Provider
  /// Получает дерево категорий из API
  ///
  /// Copied from [categoriesTree].
  CategoriesTreeProvider call({
    String? language,
  }) {
    return CategoriesTreeProvider(
      language: language,
    );
  }

  @override
  CategoriesTreeProvider getProviderOverride(
    covariant CategoriesTreeProvider provider,
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
  String? get name => r'categoriesTreeProvider';
}

/// Categories Tree Provider
/// Получает дерево категорий из API
///
/// Copied from [categoriesTree].
class CategoriesTreeProvider
    extends AutoDisposeFutureProvider<List<CategoryTreeModel>> {
  /// Categories Tree Provider
  /// Получает дерево категорий из API
  ///
  /// Copied from [categoriesTree].
  CategoriesTreeProvider({
    String? language,
  }) : this._internal(
          (ref) => categoriesTree(
            ref as CategoriesTreeRef,
            language: language,
          ),
          from: categoriesTreeProvider,
          name: r'categoriesTreeProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$categoriesTreeHash,
          dependencies: CategoriesTreeFamily._dependencies,
          allTransitiveDependencies:
              CategoriesTreeFamily._allTransitiveDependencies,
          language: language,
        );

  CategoriesTreeProvider._internal(
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
    FutureOr<List<CategoryTreeModel>> Function(CategoriesTreeRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CategoriesTreeProvider._internal(
        (ref) => create(ref as CategoriesTreeRef),
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
  AutoDisposeFutureProviderElement<List<CategoryTreeModel>> createElement() {
    return _CategoriesTreeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CategoriesTreeProvider && other.language == language;
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
mixin CategoriesTreeRef
    on AutoDisposeFutureProviderRef<List<CategoryTreeModel>> {
  /// The parameter `language` of this provider.
  String? get language;
}

class _CategoriesTreeProviderElement
    extends AutoDisposeFutureProviderElement<List<CategoryTreeModel>>
    with CategoriesTreeRef {
  _CategoriesTreeProviderElement(super.provider);

  @override
  String? get language => (origin as CategoriesTreeProvider).language;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
