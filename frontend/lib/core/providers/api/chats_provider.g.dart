// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chats_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatsListHash() => r'ed89a94ae4fca16c8dc4705230f6fe294049babd';

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

/// Chats List Provider
///
/// Copied from [chatsList].
@ProviderFor(chatsList)
const chatsListProvider = ChatsListFamily();

/// Chats List Provider
///
/// Copied from [chatsList].
class ChatsListFamily extends Family<AsyncValue<List<ChatModel>>> {
  /// Chats List Provider
  ///
  /// Copied from [chatsList].
  const ChatsListFamily();

  /// Chats List Provider
  ///
  /// Copied from [chatsList].
  ChatsListProvider call({
    int page = 1,
    int limit = 20,
  }) {
    return ChatsListProvider(
      page: page,
      limit: limit,
    );
  }

  @override
  ChatsListProvider getProviderOverride(
    covariant ChatsListProvider provider,
  ) {
    return call(
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
  String? get name => r'chatsListProvider';
}

/// Chats List Provider
///
/// Copied from [chatsList].
class ChatsListProvider extends AutoDisposeFutureProvider<List<ChatModel>> {
  /// Chats List Provider
  ///
  /// Copied from [chatsList].
  ChatsListProvider({
    int page = 1,
    int limit = 20,
  }) : this._internal(
          (ref) => chatsList(
            ref as ChatsListRef,
            page: page,
            limit: limit,
          ),
          from: chatsListProvider,
          name: r'chatsListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chatsListHash,
          dependencies: ChatsListFamily._dependencies,
          allTransitiveDependencies: ChatsListFamily._allTransitiveDependencies,
          page: page,
          limit: limit,
        );

  ChatsListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.page,
    required this.limit,
  }) : super.internal();

  final int page;
  final int limit;

  @override
  Override overrideWith(
    FutureOr<List<ChatModel>> Function(ChatsListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChatsListProvider._internal(
        (ref) => create(ref as ChatsListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        page: page,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ChatModel>> createElement() {
    return _ChatsListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatsListProvider &&
        other.page == page &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ChatsListRef on AutoDisposeFutureProviderRef<List<ChatModel>> {
  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _ChatsListProviderElement
    extends AutoDisposeFutureProviderElement<List<ChatModel>>
    with ChatsListRef {
  _ChatsListProviderElement(super.provider);

  @override
  int get page => (origin as ChatsListProvider).page;
  @override
  int get limit => (origin as ChatsListProvider).limit;
}

String _$chatByIdHash() => r'c8ea66796aaa30ed2e1bd53f71080e6af95aea0f';

/// Chat by ID Provider
///
/// Copied from [chatById].
@ProviderFor(chatById)
const chatByIdProvider = ChatByIdFamily();

/// Chat by ID Provider
///
/// Copied from [chatById].
class ChatByIdFamily extends Family<AsyncValue<ChatModel>> {
  /// Chat by ID Provider
  ///
  /// Copied from [chatById].
  const ChatByIdFamily();

  /// Chat by ID Provider
  ///
  /// Copied from [chatById].
  ChatByIdProvider call(
    String chatId,
  ) {
    return ChatByIdProvider(
      chatId,
    );
  }

  @override
  ChatByIdProvider getProviderOverride(
    covariant ChatByIdProvider provider,
  ) {
    return call(
      provider.chatId,
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
  String? get name => r'chatByIdProvider';
}

/// Chat by ID Provider
///
/// Copied from [chatById].
class ChatByIdProvider extends AutoDisposeFutureProvider<ChatModel> {
  /// Chat by ID Provider
  ///
  /// Copied from [chatById].
  ChatByIdProvider(
    String chatId,
  ) : this._internal(
          (ref) => chatById(
            ref as ChatByIdRef,
            chatId,
          ),
          from: chatByIdProvider,
          name: r'chatByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chatByIdHash,
          dependencies: ChatByIdFamily._dependencies,
          allTransitiveDependencies: ChatByIdFamily._allTransitiveDependencies,
          chatId: chatId,
        );

  ChatByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.chatId,
  }) : super.internal();

  final String chatId;

  @override
  Override overrideWith(
    FutureOr<ChatModel> Function(ChatByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChatByIdProvider._internal(
        (ref) => create(ref as ChatByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        chatId: chatId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ChatModel> createElement() {
    return _ChatByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatByIdProvider && other.chatId == chatId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, chatId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ChatByIdRef on AutoDisposeFutureProviderRef<ChatModel> {
  /// The parameter `chatId` of this provider.
  String get chatId;
}

class _ChatByIdProviderElement
    extends AutoDisposeFutureProviderElement<ChatModel> with ChatByIdRef {
  _ChatByIdProviderElement(super.provider);

  @override
  String get chatId => (origin as ChatByIdProvider).chatId;
}

String _$chatMessagesHash() => r'a88acb75a137d8d9b3d0c038f3eec54e7c7a011b';

/// Chat Messages Provider
///
/// Copied from [chatMessages].
@ProviderFor(chatMessages)
const chatMessagesProvider = ChatMessagesFamily();

/// Chat Messages Provider
///
/// Copied from [chatMessages].
class ChatMessagesFamily extends Family<AsyncValue<List<MessageModel>>> {
  /// Chat Messages Provider
  ///
  /// Copied from [chatMessages].
  const ChatMessagesFamily();

  /// Chat Messages Provider
  ///
  /// Copied from [chatMessages].
  ChatMessagesProvider call(
    String chatId, {
    int page = 1,
    int limit = 50,
  }) {
    return ChatMessagesProvider(
      chatId,
      page: page,
      limit: limit,
    );
  }

  @override
  ChatMessagesProvider getProviderOverride(
    covariant ChatMessagesProvider provider,
  ) {
    return call(
      provider.chatId,
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
  String? get name => r'chatMessagesProvider';
}

/// Chat Messages Provider
///
/// Copied from [chatMessages].
class ChatMessagesProvider
    extends AutoDisposeFutureProvider<List<MessageModel>> {
  /// Chat Messages Provider
  ///
  /// Copied from [chatMessages].
  ChatMessagesProvider(
    String chatId, {
    int page = 1,
    int limit = 50,
  }) : this._internal(
          (ref) => chatMessages(
            ref as ChatMessagesRef,
            chatId,
            page: page,
            limit: limit,
          ),
          from: chatMessagesProvider,
          name: r'chatMessagesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chatMessagesHash,
          dependencies: ChatMessagesFamily._dependencies,
          allTransitiveDependencies:
              ChatMessagesFamily._allTransitiveDependencies,
          chatId: chatId,
          page: page,
          limit: limit,
        );

  ChatMessagesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.chatId,
    required this.page,
    required this.limit,
  }) : super.internal();

  final String chatId;
  final int page;
  final int limit;

  @override
  Override overrideWith(
    FutureOr<List<MessageModel>> Function(ChatMessagesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChatMessagesProvider._internal(
        (ref) => create(ref as ChatMessagesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        chatId: chatId,
        page: page,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<MessageModel>> createElement() {
    return _ChatMessagesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatMessagesProvider &&
        other.chatId == chatId &&
        other.page == page &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, chatId.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ChatMessagesRef on AutoDisposeFutureProviderRef<List<MessageModel>> {
  /// The parameter `chatId` of this provider.
  String get chatId;

  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _ChatMessagesProviderElement
    extends AutoDisposeFutureProviderElement<List<MessageModel>>
    with ChatMessagesRef {
  _ChatMessagesProviderElement(super.provider);

  @override
  String get chatId => (origin as ChatMessagesProvider).chatId;
  @override
  int get page => (origin as ChatMessagesProvider).page;
  @override
  int get limit => (origin as ChatMessagesProvider).limit;
}

String _$unreadChatsCountHash() => r'a05830c8a14a6f30ead2cd7f6d3c16e6356384a8';

/// Unread chats count — сумма unreadCount по всем чатам
///
/// Copied from [unreadChatsCount].
@ProviderFor(unreadChatsCount)
final unreadChatsCountProvider = AutoDisposeProvider<int>.internal(
  unreadChatsCount,
  name: r'unreadChatsCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$unreadChatsCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UnreadChatsCountRef = AutoDisposeProviderRef<int>;
String _$searchUsersForChatHash() =>
    r'e77445ce5b7b5262ec179c712c9129affeeb1367';

/// Search users for chat creation
///
/// Copied from [searchUsersForChat].
@ProviderFor(searchUsersForChat)
const searchUsersForChatProvider = SearchUsersForChatFamily();

/// Search users for chat creation
///
/// Copied from [searchUsersForChat].
class SearchUsersForChatFamily extends Family<AsyncValue<List<UserModel>>> {
  /// Search users for chat creation
  ///
  /// Copied from [searchUsersForChat].
  const SearchUsersForChatFamily();

  /// Search users for chat creation
  ///
  /// Copied from [searchUsersForChat].
  SearchUsersForChatProvider call(
    String query,
  ) {
    return SearchUsersForChatProvider(
      query,
    );
  }

  @override
  SearchUsersForChatProvider getProviderOverride(
    covariant SearchUsersForChatProvider provider,
  ) {
    return call(
      provider.query,
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
  String? get name => r'searchUsersForChatProvider';
}

/// Search users for chat creation
///
/// Copied from [searchUsersForChat].
class SearchUsersForChatProvider
    extends AutoDisposeFutureProvider<List<UserModel>> {
  /// Search users for chat creation
  ///
  /// Copied from [searchUsersForChat].
  SearchUsersForChatProvider(
    String query,
  ) : this._internal(
          (ref) => searchUsersForChat(
            ref as SearchUsersForChatRef,
            query,
          ),
          from: searchUsersForChatProvider,
          name: r'searchUsersForChatProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchUsersForChatHash,
          dependencies: SearchUsersForChatFamily._dependencies,
          allTransitiveDependencies:
              SearchUsersForChatFamily._allTransitiveDependencies,
          query: query,
        );

  SearchUsersForChatProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String query;

  @override
  Override overrideWith(
    FutureOr<List<UserModel>> Function(SearchUsersForChatRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchUsersForChatProvider._internal(
        (ref) => create(ref as SearchUsersForChatRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<UserModel>> createElement() {
    return _SearchUsersForChatProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchUsersForChatProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchUsersForChatRef on AutoDisposeFutureProviderRef<List<UserModel>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _SearchUsersForChatProviderElement
    extends AutoDisposeFutureProviderElement<List<UserModel>>
    with SearchUsersForChatRef {
  _SearchUsersForChatProviderElement(super.provider);

  @override
  String get query => (origin as SearchUsersForChatProvider).query;
}

String _$chatNotifierHash() => r'8c5a4a0c90a8d90210341c6576339705cda0ac54';

/// Chat Notifier for mutations
///
/// Copied from [ChatNotifier].
@ProviderFor(ChatNotifier)
final chatNotifierProvider =
    AutoDisposeAsyncNotifierProvider<ChatNotifier, ChatModel?>.internal(
  ChatNotifier.new,
  name: r'chatNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$chatNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ChatNotifier = AutoDisposeAsyncNotifier<ChatModel?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
