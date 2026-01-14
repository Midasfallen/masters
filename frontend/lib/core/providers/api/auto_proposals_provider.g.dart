// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_proposals_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$autoProposalSettingsHash() =>
    r'a4e18767347a01bff986bfaba9f272bd41f1583d';

/// Auto Proposal Settings Provider
///
/// Copied from [autoProposalSettings].
@ProviderFor(autoProposalSettings)
final autoProposalSettingsProvider =
    AutoDisposeFutureProvider<AutoProposalSettingsModel>.internal(
  autoProposalSettings,
  name: r'autoProposalSettingsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$autoProposalSettingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AutoProposalSettingsRef
    = AutoDisposeFutureProviderRef<AutoProposalSettingsModel>;
String _$autoProposalsListHash() => r'c799de51a76c13a7470f9b65a1a6503a6c0acd9e';

/// All Proposals List Provider
///
/// Copied from [autoProposalsList].
@ProviderFor(autoProposalsList)
final autoProposalsListProvider =
    AutoDisposeFutureProvider<List<AutoProposalModel>>.internal(
  autoProposalsList,
  name: r'autoProposalsListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$autoProposalsListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AutoProposalsListRef
    = AutoDisposeFutureProviderRef<List<AutoProposalModel>>;
String _$activeProposalsListHash() =>
    r'e932c08df80d17ada662096f41670adb9228b0cf';

/// Active Proposals List Provider
///
/// Copied from [activeProposalsList].
@ProviderFor(activeProposalsList)
final activeProposalsListProvider =
    AutoDisposeFutureProvider<List<AutoProposalModel>>.internal(
  activeProposalsList,
  name: r'activeProposalsListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$activeProposalsListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveProposalsListRef
    = AutoDisposeFutureProviderRef<List<AutoProposalModel>>;
String _$autoProposalByIdHash() => r'494f95d6231fc4968d44c98320af89e6f341c417';

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

/// Proposal by ID Provider
///
/// Copied from [autoProposalById].
@ProviderFor(autoProposalById)
const autoProposalByIdProvider = AutoProposalByIdFamily();

/// Proposal by ID Provider
///
/// Copied from [autoProposalById].
class AutoProposalByIdFamily extends Family<AsyncValue<AutoProposalModel>> {
  /// Proposal by ID Provider
  ///
  /// Copied from [autoProposalById].
  const AutoProposalByIdFamily();

  /// Proposal by ID Provider
  ///
  /// Copied from [autoProposalById].
  AutoProposalByIdProvider call(
    String proposalId,
  ) {
    return AutoProposalByIdProvider(
      proposalId,
    );
  }

  @override
  AutoProposalByIdProvider getProviderOverride(
    covariant AutoProposalByIdProvider provider,
  ) {
    return call(
      provider.proposalId,
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
  String? get name => r'autoProposalByIdProvider';
}

/// Proposal by ID Provider
///
/// Copied from [autoProposalById].
class AutoProposalByIdProvider
    extends AutoDisposeFutureProvider<AutoProposalModel> {
  /// Proposal by ID Provider
  ///
  /// Copied from [autoProposalById].
  AutoProposalByIdProvider(
    String proposalId,
  ) : this._internal(
          (ref) => autoProposalById(
            ref as AutoProposalByIdRef,
            proposalId,
          ),
          from: autoProposalByIdProvider,
          name: r'autoProposalByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$autoProposalByIdHash,
          dependencies: AutoProposalByIdFamily._dependencies,
          allTransitiveDependencies:
              AutoProposalByIdFamily._allTransitiveDependencies,
          proposalId: proposalId,
        );

  AutoProposalByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.proposalId,
  }) : super.internal();

  final String proposalId;

  @override
  Override overrideWith(
    FutureOr<AutoProposalModel> Function(AutoProposalByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AutoProposalByIdProvider._internal(
        (ref) => create(ref as AutoProposalByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        proposalId: proposalId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<AutoProposalModel> createElement() {
    return _AutoProposalByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AutoProposalByIdProvider && other.proposalId == proposalId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, proposalId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AutoProposalByIdRef on AutoDisposeFutureProviderRef<AutoProposalModel> {
  /// The parameter `proposalId` of this provider.
  String get proposalId;
}

class _AutoProposalByIdProviderElement
    extends AutoDisposeFutureProviderElement<AutoProposalModel>
    with AutoProposalByIdRef {
  _AutoProposalByIdProviderElement(super.provider);

  @override
  String get proposalId => (origin as AutoProposalByIdProvider).proposalId;
}

String _$autoProposalSettingsNotifierHash() =>
    r'e41b6f77aff6233f717b02b5a816018891eae7b0';

/// Settings Notifier for mutations
///
/// Copied from [AutoProposalSettingsNotifier].
@ProviderFor(AutoProposalSettingsNotifier)
final autoProposalSettingsNotifierProvider = AutoDisposeAsyncNotifierProvider<
    AutoProposalSettingsNotifier, AutoProposalSettingsModel?>.internal(
  AutoProposalSettingsNotifier.new,
  name: r'autoProposalSettingsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$autoProposalSettingsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AutoProposalSettingsNotifier
    = AutoDisposeAsyncNotifier<AutoProposalSettingsModel?>;
String _$autoProposalNotifierHash() =>
    r'516438375395fc36eaae98056debd2df1446f13a';

/// Proposal Notifier for mutations
///
/// Copied from [AutoProposalNotifier].
@ProviderFor(AutoProposalNotifier)
final autoProposalNotifierProvider = AutoDisposeAsyncNotifierProvider<
    AutoProposalNotifier, AutoProposalModel?>.internal(
  AutoProposalNotifier.new,
  name: r'autoProposalNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$autoProposalNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AutoProposalNotifier = AutoDisposeAsyncNotifier<AutoProposalModel?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
