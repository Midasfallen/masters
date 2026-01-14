// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$myBookingsHash() => r'0ceb6ca31f3f8e0479812d8cb2ade3eba28f32ac';

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

/// My Bookings Provider
///
/// Copied from [myBookings].
@ProviderFor(myBookings)
const myBookingsProvider = MyBookingsFamily();

/// My Bookings Provider
///
/// Copied from [myBookings].
class MyBookingsFamily extends Family<AsyncValue<List<BookingModel>>> {
  /// My Bookings Provider
  ///
  /// Copied from [myBookings].
  const MyBookingsFamily();

  /// My Bookings Provider
  ///
  /// Copied from [myBookings].
  MyBookingsProvider call({
    int page = 1,
    int limit = 20,
    BookingStatus? status,
    String? role,
  }) {
    return MyBookingsProvider(
      page: page,
      limit: limit,
      status: status,
      role: role,
    );
  }

  @override
  MyBookingsProvider getProviderOverride(
    covariant MyBookingsProvider provider,
  ) {
    return call(
      page: provider.page,
      limit: provider.limit,
      status: provider.status,
      role: provider.role,
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
  String? get name => r'myBookingsProvider';
}

/// My Bookings Provider
///
/// Copied from [myBookings].
class MyBookingsProvider extends AutoDisposeFutureProvider<List<BookingModel>> {
  /// My Bookings Provider
  ///
  /// Copied from [myBookings].
  MyBookingsProvider({
    int page = 1,
    int limit = 20,
    BookingStatus? status,
    String? role,
  }) : this._internal(
          (ref) => myBookings(
            ref as MyBookingsRef,
            page: page,
            limit: limit,
            status: status,
            role: role,
          ),
          from: myBookingsProvider,
          name: r'myBookingsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$myBookingsHash,
          dependencies: MyBookingsFamily._dependencies,
          allTransitiveDependencies:
              MyBookingsFamily._allTransitiveDependencies,
          page: page,
          limit: limit,
          status: status,
          role: role,
        );

  MyBookingsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.page,
    required this.limit,
    required this.status,
    required this.role,
  }) : super.internal();

  final int page;
  final int limit;
  final BookingStatus? status;
  final String? role;

  @override
  Override overrideWith(
    FutureOr<List<BookingModel>> Function(MyBookingsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MyBookingsProvider._internal(
        (ref) => create(ref as MyBookingsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        page: page,
        limit: limit,
        status: status,
        role: role,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<BookingModel>> createElement() {
    return _MyBookingsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MyBookingsProvider &&
        other.page == page &&
        other.limit == limit &&
        other.status == status &&
        other.role == role;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);
    hash = _SystemHash.combine(hash, status.hashCode);
    hash = _SystemHash.combine(hash, role.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MyBookingsRef on AutoDisposeFutureProviderRef<List<BookingModel>> {
  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `limit` of this provider.
  int get limit;

  /// The parameter `status` of this provider.
  BookingStatus? get status;

  /// The parameter `role` of this provider.
  String? get role;
}

class _MyBookingsProviderElement
    extends AutoDisposeFutureProviderElement<List<BookingModel>>
    with MyBookingsRef {
  _MyBookingsProviderElement(super.provider);

  @override
  int get page => (origin as MyBookingsProvider).page;
  @override
  int get limit => (origin as MyBookingsProvider).limit;
  @override
  BookingStatus? get status => (origin as MyBookingsProvider).status;
  @override
  String? get role => (origin as MyBookingsProvider).role;
}

String _$bookingByIdHash() => r'd2806382a7d66f6c7446e62a7b4edf05ba33b3b0';

/// Booking by ID Provider
///
/// Copied from [bookingById].
@ProviderFor(bookingById)
const bookingByIdProvider = BookingByIdFamily();

/// Booking by ID Provider
///
/// Copied from [bookingById].
class BookingByIdFamily extends Family<AsyncValue<BookingModel>> {
  /// Booking by ID Provider
  ///
  /// Copied from [bookingById].
  const BookingByIdFamily();

  /// Booking by ID Provider
  ///
  /// Copied from [bookingById].
  BookingByIdProvider call(
    String bookingId,
  ) {
    return BookingByIdProvider(
      bookingId,
    );
  }

  @override
  BookingByIdProvider getProviderOverride(
    covariant BookingByIdProvider provider,
  ) {
    return call(
      provider.bookingId,
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
  String? get name => r'bookingByIdProvider';
}

/// Booking by ID Provider
///
/// Copied from [bookingById].
class BookingByIdProvider extends AutoDisposeFutureProvider<BookingModel> {
  /// Booking by ID Provider
  ///
  /// Copied from [bookingById].
  BookingByIdProvider(
    String bookingId,
  ) : this._internal(
          (ref) => bookingById(
            ref as BookingByIdRef,
            bookingId,
          ),
          from: bookingByIdProvider,
          name: r'bookingByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$bookingByIdHash,
          dependencies: BookingByIdFamily._dependencies,
          allTransitiveDependencies:
              BookingByIdFamily._allTransitiveDependencies,
          bookingId: bookingId,
        );

  BookingByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.bookingId,
  }) : super.internal();

  final String bookingId;

  @override
  Override overrideWith(
    FutureOr<BookingModel> Function(BookingByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BookingByIdProvider._internal(
        (ref) => create(ref as BookingByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        bookingId: bookingId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<BookingModel> createElement() {
    return _BookingByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BookingByIdProvider && other.bookingId == bookingId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, bookingId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin BookingByIdRef on AutoDisposeFutureProviderRef<BookingModel> {
  /// The parameter `bookingId` of this provider.
  String get bookingId;
}

class _BookingByIdProviderElement
    extends AutoDisposeFutureProviderElement<BookingModel> with BookingByIdRef {
  _BookingByIdProviderElement(super.provider);

  @override
  String get bookingId => (origin as BookingByIdProvider).bookingId;
}

String _$bookingNotifierHash() => r'c9ed96283e8f9726b91bca5d8bbfa305de9977e3';

/// Booking Notifier for mutations
///
/// Copied from [BookingNotifier].
@ProviderFor(BookingNotifier)
final bookingNotifierProvider =
    AutoDisposeAsyncNotifierProvider<BookingNotifier, BookingModel?>.internal(
  BookingNotifier.new,
  name: r'bookingNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$bookingNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BookingNotifier = AutoDisposeAsyncNotifier<BookingModel?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
