// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorites_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$favoritesListHash() => r'594f8ac89cf19b66ef41653265ed26fafeb722dd';

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

/// Получить список избранного
///
/// Copied from [favoritesList].
@ProviderFor(favoritesList)
const favoritesListProvider = FavoritesListFamily();

/// Получить список избранного
///
/// Copied from [favoritesList].
class FavoritesListFamily extends Family<AsyncValue<List<Favorite>>> {
  /// Получить список избранного
  ///
  /// Copied from [favoritesList].
  const FavoritesListFamily();

  /// Получить список избранного
  ///
  /// Copied from [favoritesList].
  FavoritesListProvider call({
    FavoriteEntityType? entityType,
  }) {
    return FavoritesListProvider(
      entityType: entityType,
    );
  }

  @override
  FavoritesListProvider getProviderOverride(
    covariant FavoritesListProvider provider,
  ) {
    return call(
      entityType: provider.entityType,
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
  String? get name => r'favoritesListProvider';
}

/// Получить список избранного
///
/// Copied from [favoritesList].
class FavoritesListProvider extends AutoDisposeFutureProvider<List<Favorite>> {
  /// Получить список избранного
  ///
  /// Copied from [favoritesList].
  FavoritesListProvider({
    FavoriteEntityType? entityType,
  }) : this._internal(
          (ref) => favoritesList(
            ref as FavoritesListRef,
            entityType: entityType,
          ),
          from: favoritesListProvider,
          name: r'favoritesListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$favoritesListHash,
          dependencies: FavoritesListFamily._dependencies,
          allTransitiveDependencies:
              FavoritesListFamily._allTransitiveDependencies,
          entityType: entityType,
        );

  FavoritesListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.entityType,
  }) : super.internal();

  final FavoriteEntityType? entityType;

  @override
  Override overrideWith(
    FutureOr<List<Favorite>> Function(FavoritesListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FavoritesListProvider._internal(
        (ref) => create(ref as FavoritesListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        entityType: entityType,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Favorite>> createElement() {
    return _FavoritesListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FavoritesListProvider && other.entityType == entityType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, entityType.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FavoritesListRef on AutoDisposeFutureProviderRef<List<Favorite>> {
  /// The parameter `entityType` of this provider.
  FavoriteEntityType? get entityType;
}

class _FavoritesListProviderElement
    extends AutoDisposeFutureProviderElement<List<Favorite>>
    with FavoritesListRef {
  _FavoritesListProviderElement(super.provider);

  @override
  FavoriteEntityType? get entityType =>
      (origin as FavoritesListProvider).entityType;
}

String _$favoritesCountHash() => r'6dbce1b04a5d34c0f304e4076e6f059db708227c';

/// Получить количество избранного
///
/// Copied from [favoritesCount].
@ProviderFor(favoritesCount)
const favoritesCountProvider = FavoritesCountFamily();

/// Получить количество избранного
///
/// Copied from [favoritesCount].
class FavoritesCountFamily extends Family<AsyncValue<int>> {
  /// Получить количество избранного
  ///
  /// Copied from [favoritesCount].
  const FavoritesCountFamily();

  /// Получить количество избранного
  ///
  /// Copied from [favoritesCount].
  FavoritesCountProvider call({
    FavoriteEntityType? entityType,
  }) {
    return FavoritesCountProvider(
      entityType: entityType,
    );
  }

  @override
  FavoritesCountProvider getProviderOverride(
    covariant FavoritesCountProvider provider,
  ) {
    return call(
      entityType: provider.entityType,
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
  String? get name => r'favoritesCountProvider';
}

/// Получить количество избранного
///
/// Copied from [favoritesCount].
class FavoritesCountProvider extends AutoDisposeFutureProvider<int> {
  /// Получить количество избранного
  ///
  /// Copied from [favoritesCount].
  FavoritesCountProvider({
    FavoriteEntityType? entityType,
  }) : this._internal(
          (ref) => favoritesCount(
            ref as FavoritesCountRef,
            entityType: entityType,
          ),
          from: favoritesCountProvider,
          name: r'favoritesCountProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$favoritesCountHash,
          dependencies: FavoritesCountFamily._dependencies,
          allTransitiveDependencies:
              FavoritesCountFamily._allTransitiveDependencies,
          entityType: entityType,
        );

  FavoritesCountProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.entityType,
  }) : super.internal();

  final FavoriteEntityType? entityType;

  @override
  Override overrideWith(
    FutureOr<int> Function(FavoritesCountRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FavoritesCountProvider._internal(
        (ref) => create(ref as FavoritesCountRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        entityType: entityType,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<int> createElement() {
    return _FavoritesCountProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FavoritesCountProvider && other.entityType == entityType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, entityType.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FavoritesCountRef on AutoDisposeFutureProviderRef<int> {
  /// The parameter `entityType` of this provider.
  FavoriteEntityType? get entityType;
}

class _FavoritesCountProviderElement
    extends AutoDisposeFutureProviderElement<int> with FavoritesCountRef {
  _FavoritesCountProviderElement(super.provider);

  @override
  FavoriteEntityType? get entityType =>
      (origin as FavoritesCountProvider).entityType;
}

String _$isFavoriteHash() => r'a11926c4342c4691804279b87e4724f28c2d17b1';

/// Проверить статус избранного для конкретной сущности
///
/// Copied from [isFavorite].
@ProviderFor(isFavorite)
const isFavoriteProvider = IsFavoriteFamily();

/// Проверить статус избранного для конкретной сущности
///
/// Copied from [isFavorite].
class IsFavoriteFamily extends Family<AsyncValue<bool>> {
  /// Проверить статус избранного для конкретной сущности
  ///
  /// Copied from [isFavorite].
  const IsFavoriteFamily();

  /// Проверить статус избранного для конкретной сущности
  ///
  /// Copied from [isFavorite].
  IsFavoriteProvider call(
    FavoriteEntityType entityType,
    String entityId,
  ) {
    return IsFavoriteProvider(
      entityType,
      entityId,
    );
  }

  @override
  IsFavoriteProvider getProviderOverride(
    covariant IsFavoriteProvider provider,
  ) {
    return call(
      provider.entityType,
      provider.entityId,
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
  String? get name => r'isFavoriteProvider';
}

/// Проверить статус избранного для конкретной сущности
///
/// Copied from [isFavorite].
class IsFavoriteProvider extends AutoDisposeFutureProvider<bool> {
  /// Проверить статус избранного для конкретной сущности
  ///
  /// Copied from [isFavorite].
  IsFavoriteProvider(
    FavoriteEntityType entityType,
    String entityId,
  ) : this._internal(
          (ref) => isFavorite(
            ref as IsFavoriteRef,
            entityType,
            entityId,
          ),
          from: isFavoriteProvider,
          name: r'isFavoriteProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$isFavoriteHash,
          dependencies: IsFavoriteFamily._dependencies,
          allTransitiveDependencies:
              IsFavoriteFamily._allTransitiveDependencies,
          entityType: entityType,
          entityId: entityId,
        );

  IsFavoriteProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.entityType,
    required this.entityId,
  }) : super.internal();

  final FavoriteEntityType entityType;
  final String entityId;

  @override
  Override overrideWith(
    FutureOr<bool> Function(IsFavoriteRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IsFavoriteProvider._internal(
        (ref) => create(ref as IsFavoriteRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        entityType: entityType,
        entityId: entityId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _IsFavoriteProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IsFavoriteProvider &&
        other.entityType == entityType &&
        other.entityId == entityId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, entityType.hashCode);
    hash = _SystemHash.combine(hash, entityId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin IsFavoriteRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `entityType` of this provider.
  FavoriteEntityType get entityType;

  /// The parameter `entityId` of this provider.
  String get entityId;
}

class _IsFavoriteProviderElement extends AutoDisposeFutureProviderElement<bool>
    with IsFavoriteRef {
  _IsFavoriteProviderElement(super.provider);

  @override
  FavoriteEntityType get entityType =>
      (origin as IsFavoriteProvider).entityType;
  @override
  String get entityId => (origin as IsFavoriteProvider).entityId;
}

String _$favoritesNotifierHash() => r'7559c1cbc28cf7ee6d479d34bfcaa42e369e235f';

/// Notifier для управления избранным
///
/// Copied from [FavoritesNotifier].
@ProviderFor(FavoritesNotifier)
final favoritesNotifierProvider =
    AutoDisposeAsyncNotifierProvider<FavoritesNotifier, Favorite?>.internal(
  FavoritesNotifier.new,
  name: r'favoritesNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$favoritesNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FavoritesNotifier = AutoDisposeAsyncNotifier<Favorite?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
