// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$feedPostsHash() => r'4459bc89856040b005951b865c33368295b03631';

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

/// Feed Posts Provider
///
/// Copied from [feedPosts].
@ProviderFor(feedPosts)
const feedPostsProvider = FeedPostsFamily();

/// Feed Posts Provider
///
/// Copied from [feedPosts].
class FeedPostsFamily extends Family<AsyncValue<List<PostModel>>> {
  /// Feed Posts Provider
  ///
  /// Copied from [feedPosts].
  const FeedPostsFamily();

  /// Feed Posts Provider
  ///
  /// Copied from [feedPosts].
  FeedPostsProvider call({
    int page = 1,
    int limit = 20,
    List<String>? categoryIds,
    double? lat,
    double? lng,
  }) {
    return FeedPostsProvider(
      page: page,
      limit: limit,
      categoryIds: categoryIds,
      lat: lat,
      lng: lng,
    );
  }

  @override
  FeedPostsProvider getProviderOverride(
    covariant FeedPostsProvider provider,
  ) {
    return call(
      page: provider.page,
      limit: provider.limit,
      categoryIds: provider.categoryIds,
      lat: provider.lat,
      lng: provider.lng,
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
  String? get name => r'feedPostsProvider';
}

/// Feed Posts Provider
///
/// Copied from [feedPosts].
class FeedPostsProvider extends AutoDisposeFutureProvider<List<PostModel>> {
  /// Feed Posts Provider
  ///
  /// Copied from [feedPosts].
  FeedPostsProvider({
    int page = 1,
    int limit = 20,
    List<String>? categoryIds,
    double? lat,
    double? lng,
  }) : this._internal(
          (ref) => feedPosts(
            ref as FeedPostsRef,
            page: page,
            limit: limit,
            categoryIds: categoryIds,
            lat: lat,
            lng: lng,
          ),
          from: feedPostsProvider,
          name: r'feedPostsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$feedPostsHash,
          dependencies: FeedPostsFamily._dependencies,
          allTransitiveDependencies: FeedPostsFamily._allTransitiveDependencies,
          page: page,
          limit: limit,
          categoryIds: categoryIds,
          lat: lat,
          lng: lng,
        );

  FeedPostsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.page,
    required this.limit,
    required this.categoryIds,
    required this.lat,
    required this.lng,
  }) : super.internal();

  final int page;
  final int limit;
  final List<String>? categoryIds;
  final double? lat;
  final double? lng;

  @override
  Override overrideWith(
    FutureOr<List<PostModel>> Function(FeedPostsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FeedPostsProvider._internal(
        (ref) => create(ref as FeedPostsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        page: page,
        limit: limit,
        categoryIds: categoryIds,
        lat: lat,
        lng: lng,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<PostModel>> createElement() {
    return _FeedPostsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FeedPostsProvider &&
        other.page == page &&
        other.limit == limit &&
        other.categoryIds == categoryIds &&
        other.lat == lat &&
        other.lng == lng;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);
    hash = _SystemHash.combine(hash, categoryIds.hashCode);
    hash = _SystemHash.combine(hash, lat.hashCode);
    hash = _SystemHash.combine(hash, lng.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FeedPostsRef on AutoDisposeFutureProviderRef<List<PostModel>> {
  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `limit` of this provider.
  int get limit;

  /// The parameter `categoryIds` of this provider.
  List<String>? get categoryIds;

  /// The parameter `lat` of this provider.
  double? get lat;

  /// The parameter `lng` of this provider.
  double? get lng;
}

class _FeedPostsProviderElement
    extends AutoDisposeFutureProviderElement<List<PostModel>>
    with FeedPostsRef {
  _FeedPostsProviderElement(super.provider);

  @override
  int get page => (origin as FeedPostsProvider).page;
  @override
  int get limit => (origin as FeedPostsProvider).limit;
  @override
  List<String>? get categoryIds => (origin as FeedPostsProvider).categoryIds;
  @override
  double? get lat => (origin as FeedPostsProvider).lat;
  @override
  double? get lng => (origin as FeedPostsProvider).lng;
}

String _$postByIdHash() => r'8ee1a163f44d617eb9b265a2fc623b0197e261d6';

/// Post by ID Provider
///
/// Copied from [postById].
@ProviderFor(postById)
const postByIdProvider = PostByIdFamily();

/// Post by ID Provider
///
/// Copied from [postById].
class PostByIdFamily extends Family<AsyncValue<PostModel>> {
  /// Post by ID Provider
  ///
  /// Copied from [postById].
  const PostByIdFamily();

  /// Post by ID Provider
  ///
  /// Copied from [postById].
  PostByIdProvider call(
    String postId,
  ) {
    return PostByIdProvider(
      postId,
    );
  }

  @override
  PostByIdProvider getProviderOverride(
    covariant PostByIdProvider provider,
  ) {
    return call(
      provider.postId,
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
  String? get name => r'postByIdProvider';
}

/// Post by ID Provider
///
/// Copied from [postById].
class PostByIdProvider extends AutoDisposeFutureProvider<PostModel> {
  /// Post by ID Provider
  ///
  /// Copied from [postById].
  PostByIdProvider(
    String postId,
  ) : this._internal(
          (ref) => postById(
            ref as PostByIdRef,
            postId,
          ),
          from: postByIdProvider,
          name: r'postByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$postByIdHash,
          dependencies: PostByIdFamily._dependencies,
          allTransitiveDependencies: PostByIdFamily._allTransitiveDependencies,
          postId: postId,
        );

  PostByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.postId,
  }) : super.internal();

  final String postId;

  @override
  Override overrideWith(
    FutureOr<PostModel> Function(PostByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PostByIdProvider._internal(
        (ref) => create(ref as PostByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        postId: postId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<PostModel> createElement() {
    return _PostByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PostByIdProvider && other.postId == postId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, postId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PostByIdRef on AutoDisposeFutureProviderRef<PostModel> {
  /// The parameter `postId` of this provider.
  String get postId;
}

class _PostByIdProviderElement
    extends AutoDisposeFutureProviderElement<PostModel> with PostByIdRef {
  _PostByIdProviderElement(super.provider);

  @override
  String get postId => (origin as PostByIdProvider).postId;
}

String _$postCommentsHash() => r'7ccaf88b5defb32d8850e461b1c3e4e441a411fe';

/// Post Comments Provider
///
/// Copied from [postComments].
@ProviderFor(postComments)
const postCommentsProvider = PostCommentsFamily();

/// Post Comments Provider
///
/// Copied from [postComments].
class PostCommentsFamily extends Family<AsyncValue<List<CommentModel>>> {
  /// Post Comments Provider
  ///
  /// Copied from [postComments].
  const PostCommentsFamily();

  /// Post Comments Provider
  ///
  /// Copied from [postComments].
  PostCommentsProvider call(
    String postId, {
    int page = 1,
    int limit = 20,
  }) {
    return PostCommentsProvider(
      postId,
      page: page,
      limit: limit,
    );
  }

  @override
  PostCommentsProvider getProviderOverride(
    covariant PostCommentsProvider provider,
  ) {
    return call(
      provider.postId,
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
  String? get name => r'postCommentsProvider';
}

/// Post Comments Provider
///
/// Copied from [postComments].
class PostCommentsProvider
    extends AutoDisposeFutureProvider<List<CommentModel>> {
  /// Post Comments Provider
  ///
  /// Copied from [postComments].
  PostCommentsProvider(
    String postId, {
    int page = 1,
    int limit = 20,
  }) : this._internal(
          (ref) => postComments(
            ref as PostCommentsRef,
            postId,
            page: page,
            limit: limit,
          ),
          from: postCommentsProvider,
          name: r'postCommentsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$postCommentsHash,
          dependencies: PostCommentsFamily._dependencies,
          allTransitiveDependencies:
              PostCommentsFamily._allTransitiveDependencies,
          postId: postId,
          page: page,
          limit: limit,
        );

  PostCommentsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.postId,
    required this.page,
    required this.limit,
  }) : super.internal();

  final String postId;
  final int page;
  final int limit;

  @override
  Override overrideWith(
    FutureOr<List<CommentModel>> Function(PostCommentsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PostCommentsProvider._internal(
        (ref) => create(ref as PostCommentsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        postId: postId,
        page: page,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<CommentModel>> createElement() {
    return _PostCommentsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PostCommentsProvider &&
        other.postId == postId &&
        other.page == page &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, postId.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PostCommentsRef on AutoDisposeFutureProviderRef<List<CommentModel>> {
  /// The parameter `postId` of this provider.
  String get postId;

  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _PostCommentsProviderElement
    extends AutoDisposeFutureProviderElement<List<CommentModel>>
    with PostCommentsRef {
  _PostCommentsProviderElement(super.provider);

  @override
  String get postId => (origin as PostCommentsProvider).postId;
  @override
  int get page => (origin as PostCommentsProvider).page;
  @override
  int get limit => (origin as PostCommentsProvider).limit;
}

String _$postNotifierHash() => r'57d5203a8c29fa284b73970f6bb0a6ca8f5ace42';

/// Post Notifier for mutations
///
/// Copied from [PostNotifier].
@ProviderFor(PostNotifier)
final postNotifierProvider =
    AutoDisposeAsyncNotifierProvider<PostNotifier, PostModel?>.internal(
  PostNotifier.new,
  name: r'postNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$postNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PostNotifier = AutoDisposeAsyncNotifier<PostModel?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
