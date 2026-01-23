// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notificationsListHash() => r'963a4c3e21853f9f51c2fb26be33c7dd0af45889';

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

/// Notifications List Provider
///
/// Copied from [notificationsList].
@ProviderFor(notificationsList)
const notificationsListProvider = NotificationsListFamily();

/// Notifications List Provider
///
/// Copied from [notificationsList].
class NotificationsListFamily
    extends Family<AsyncValue<List<NotificationModel>>> {
  /// Notifications List Provider
  ///
  /// Copied from [notificationsList].
  const NotificationsListFamily();

  /// Notifications List Provider
  ///
  /// Copied from [notificationsList].
  NotificationsListProvider call({
    int page = 1,
    int limit = 50,
    bool? isRead,
    String? type,
  }) {
    return NotificationsListProvider(
      page: page,
      limit: limit,
      isRead: isRead,
      type: type,
    );
  }

  @override
  NotificationsListProvider getProviderOverride(
    covariant NotificationsListProvider provider,
  ) {
    return call(
      page: provider.page,
      limit: provider.limit,
      isRead: provider.isRead,
      type: provider.type,
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
  String? get name => r'notificationsListProvider';
}

/// Notifications List Provider
///
/// Copied from [notificationsList].
class NotificationsListProvider
    extends AutoDisposeFutureProvider<List<NotificationModel>> {
  /// Notifications List Provider
  ///
  /// Copied from [notificationsList].
  NotificationsListProvider({
    int page = 1,
    int limit = 50,
    bool? isRead,
    String? type,
  }) : this._internal(
          (ref) => notificationsList(
            ref as NotificationsListRef,
            page: page,
            limit: limit,
            isRead: isRead,
            type: type,
          ),
          from: notificationsListProvider,
          name: r'notificationsListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$notificationsListHash,
          dependencies: NotificationsListFamily._dependencies,
          allTransitiveDependencies:
              NotificationsListFamily._allTransitiveDependencies,
          page: page,
          limit: limit,
          isRead: isRead,
          type: type,
        );

  NotificationsListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.page,
    required this.limit,
    required this.isRead,
    required this.type,
  }) : super.internal();

  final int page;
  final int limit;
  final bool? isRead;
  final String? type;

  @override
  Override overrideWith(
    FutureOr<List<NotificationModel>> Function(NotificationsListRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: NotificationsListProvider._internal(
        (ref) => create(ref as NotificationsListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        page: page,
        limit: limit,
        isRead: isRead,
        type: type,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<NotificationModel>> createElement() {
    return _NotificationsListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NotificationsListProvider &&
        other.page == page &&
        other.limit == limit &&
        other.isRead == isRead &&
        other.type == type;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);
    hash = _SystemHash.combine(hash, isRead.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin NotificationsListRef
    on AutoDisposeFutureProviderRef<List<NotificationModel>> {
  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `limit` of this provider.
  int get limit;

  /// The parameter `isRead` of this provider.
  bool? get isRead;

  /// The parameter `type` of this provider.
  String? get type;
}

class _NotificationsListProviderElement
    extends AutoDisposeFutureProviderElement<List<NotificationModel>>
    with NotificationsListRef {
  _NotificationsListProviderElement(super.provider);

  @override
  int get page => (origin as NotificationsListProvider).page;
  @override
  int get limit => (origin as NotificationsListProvider).limit;
  @override
  bool? get isRead => (origin as NotificationsListProvider).isRead;
  @override
  String? get type => (origin as NotificationsListProvider).type;
}

String _$notificationByIdHash() => r'39b7c9b0fe407d79365808662167e828c0fd17d6';

/// Notification by ID Provider
///
/// Copied from [notificationById].
@ProviderFor(notificationById)
const notificationByIdProvider = NotificationByIdFamily();

/// Notification by ID Provider
///
/// Copied from [notificationById].
class NotificationByIdFamily extends Family<AsyncValue<NotificationModel>> {
  /// Notification by ID Provider
  ///
  /// Copied from [notificationById].
  const NotificationByIdFamily();

  /// Notification by ID Provider
  ///
  /// Copied from [notificationById].
  NotificationByIdProvider call(
    String notificationId,
  ) {
    return NotificationByIdProvider(
      notificationId,
    );
  }

  @override
  NotificationByIdProvider getProviderOverride(
    covariant NotificationByIdProvider provider,
  ) {
    return call(
      provider.notificationId,
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
  String? get name => r'notificationByIdProvider';
}

/// Notification by ID Provider
///
/// Copied from [notificationById].
class NotificationByIdProvider
    extends AutoDisposeFutureProvider<NotificationModel> {
  /// Notification by ID Provider
  ///
  /// Copied from [notificationById].
  NotificationByIdProvider(
    String notificationId,
  ) : this._internal(
          (ref) => notificationById(
            ref as NotificationByIdRef,
            notificationId,
          ),
          from: notificationByIdProvider,
          name: r'notificationByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$notificationByIdHash,
          dependencies: NotificationByIdFamily._dependencies,
          allTransitiveDependencies:
              NotificationByIdFamily._allTransitiveDependencies,
          notificationId: notificationId,
        );

  NotificationByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.notificationId,
  }) : super.internal();

  final String notificationId;

  @override
  Override overrideWith(
    FutureOr<NotificationModel> Function(NotificationByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: NotificationByIdProvider._internal(
        (ref) => create(ref as NotificationByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        notificationId: notificationId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<NotificationModel> createElement() {
    return _NotificationByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NotificationByIdProvider &&
        other.notificationId == notificationId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, notificationId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin NotificationByIdRef on AutoDisposeFutureProviderRef<NotificationModel> {
  /// The parameter `notificationId` of this provider.
  String get notificationId;
}

class _NotificationByIdProviderElement
    extends AutoDisposeFutureProviderElement<NotificationModel>
    with NotificationByIdRef {
  _NotificationByIdProviderElement(super.provider);

  @override
  String get notificationId =>
      (origin as NotificationByIdProvider).notificationId;
}

String _$notificationsUnreadCountHash() =>
    r'a4565e734694cde1aecc59e0ca27805125189a4b';

/// Unread Count Provider
///
/// Copied from [notificationsUnreadCount].
@ProviderFor(notificationsUnreadCount)
final notificationsUnreadCountProvider =
    AutoDisposeFutureProvider<int>.internal(
  notificationsUnreadCount,
  name: r'notificationsUnreadCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationsUnreadCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NotificationsUnreadCountRef = AutoDisposeFutureProviderRef<int>;
String _$notificationNotifierHash() =>
    r'ad4be5375bf396e6c779db006e5ec1364f564a70';

/// Notification Notifier for mutations
///
/// Copied from [NotificationNotifier].
@ProviderFor(NotificationNotifier)
final notificationNotifierProvider = AutoDisposeAsyncNotifierProvider<
    NotificationNotifier, NotificationModel?>.internal(
  NotificationNotifier.new,
  name: r'notificationNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NotificationNotifier = AutoDisposeAsyncNotifier<NotificationModel?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
