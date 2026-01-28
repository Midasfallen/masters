// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PostMediaModel _$PostMediaModelFromJson(Map<String, dynamic> json) {
  return _PostMediaModel.fromJson(json);
}

/// @nodoc
mixin _$PostMediaModel {
  String get id => throw _privateConstructorUsedError;
  MediaType get type => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  String? get thumbnailUrl => throw _privateConstructorUsedError;
  int? get width => throw _privateConstructorUsedError;
  int? get height => throw _privateConstructorUsedError;
  int? get duration => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;

  /// Serializes this PostMediaModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PostMediaModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PostMediaModelCopyWith<PostMediaModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostMediaModelCopyWith<$Res> {
  factory $PostMediaModelCopyWith(
          PostMediaModel value, $Res Function(PostMediaModel) then) =
      _$PostMediaModelCopyWithImpl<$Res, PostMediaModel>;
  @useResult
  $Res call(
      {String id,
      MediaType type,
      String url,
      String? thumbnailUrl,
      int? width,
      int? height,
      int? duration,
      int order});
}

/// @nodoc
class _$PostMediaModelCopyWithImpl<$Res, $Val extends PostMediaModel>
    implements $PostMediaModelCopyWith<$Res> {
  _$PostMediaModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PostMediaModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? url = null,
    Object? thumbnailUrl = freezed,
    Object? width = freezed,
    Object? height = freezed,
    Object? duration = freezed,
    Object? order = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MediaType,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      width: freezed == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int?,
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int?,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int?,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PostMediaModelImplCopyWith<$Res>
    implements $PostMediaModelCopyWith<$Res> {
  factory _$$PostMediaModelImplCopyWith(_$PostMediaModelImpl value,
          $Res Function(_$PostMediaModelImpl) then) =
      __$$PostMediaModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      MediaType type,
      String url,
      String? thumbnailUrl,
      int? width,
      int? height,
      int? duration,
      int order});
}

/// @nodoc
class __$$PostMediaModelImplCopyWithImpl<$Res>
    extends _$PostMediaModelCopyWithImpl<$Res, _$PostMediaModelImpl>
    implements _$$PostMediaModelImplCopyWith<$Res> {
  __$$PostMediaModelImplCopyWithImpl(
      _$PostMediaModelImpl _value, $Res Function(_$PostMediaModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of PostMediaModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? url = null,
    Object? thumbnailUrl = freezed,
    Object? width = freezed,
    Object? height = freezed,
    Object? duration = freezed,
    Object? order = null,
  }) {
    return _then(_$PostMediaModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MediaType,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      width: freezed == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int?,
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int?,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int?,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PostMediaModelImpl implements _PostMediaModel {
  const _$PostMediaModelImpl(
      {required this.id,
      required this.type,
      required this.url,
      this.thumbnailUrl,
      this.width,
      this.height,
      this.duration,
      this.order = 0});

  factory _$PostMediaModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostMediaModelImplFromJson(json);

  @override
  final String id;
  @override
  final MediaType type;
  @override
  final String url;
  @override
  final String? thumbnailUrl;
  @override
  final int? width;
  @override
  final int? height;
  @override
  final int? duration;
  @override
  @JsonKey()
  final int order;

  @override
  String toString() {
    return 'PostMediaModel(id: $id, type: $type, url: $url, thumbnailUrl: $thumbnailUrl, width: $width, height: $height, duration: $duration, order: $order)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostMediaModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.order, order) || other.order == order));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, type, url, thumbnailUrl, width, height, duration, order);

  /// Create a copy of PostMediaModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostMediaModelImplCopyWith<_$PostMediaModelImpl> get copyWith =>
      __$$PostMediaModelImplCopyWithImpl<_$PostMediaModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PostMediaModelImplToJson(
      this,
    );
  }
}

abstract class _PostMediaModel implements PostMediaModel {
  const factory _PostMediaModel(
      {required final String id,
      required final MediaType type,
      required final String url,
      final String? thumbnailUrl,
      final int? width,
      final int? height,
      final int? duration,
      final int order}) = _$PostMediaModelImpl;

  factory _PostMediaModel.fromJson(Map<String, dynamic> json) =
      _$PostMediaModelImpl.fromJson;

  @override
  String get id;
  @override
  MediaType get type;
  @override
  String get url;
  @override
  String? get thumbnailUrl;
  @override
  int? get width;
  @override
  int? get height;
  @override
  int? get duration;
  @override
  int get order;

  /// Create a copy of PostMediaModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostMediaModelImplCopyWith<_$PostMediaModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PostModel _$PostModelFromJson(Map<String, dynamic> json) {
  return _PostModel.fromJson(json);
}

/// @nodoc
mixin _$PostModel {
  String get id => throw _privateConstructorUsedError;
  String get authorId => throw _privateConstructorUsedError;
  UserModel? get author => throw _privateConstructorUsedError;
  String? get content => throw _privateConstructorUsedError;
  List<PostMediaModel> get media => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  int get likesCount => throw _privateConstructorUsedError;
  int get commentsCount => throw _privateConstructorUsedError;
  int get sharesCount => throw _privateConstructorUsedError;
  int get repostsCount => throw _privateConstructorUsedError;
  bool get isLiked => throw _privateConstructorUsedError;
  String? get locationName => throw _privateConstructorUsedError;
  double? get locationLat => throw _privateConstructorUsedError;
  double? get locationLng => throw _privateConstructorUsedError;
  bool get isPinned => throw _privateConstructorUsedError;
  bool get isArchived => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this PostModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PostModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PostModelCopyWith<PostModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostModelCopyWith<$Res> {
  factory $PostModelCopyWith(PostModel value, $Res Function(PostModel) then) =
      _$PostModelCopyWithImpl<$Res, PostModel>;
  @useResult
  $Res call(
      {String id,
      String authorId,
      UserModel? author,
      String? content,
      List<PostMediaModel> media,
      List<String> tags,
      int likesCount,
      int commentsCount,
      int sharesCount,
      int repostsCount,
      bool isLiked,
      String? locationName,
      double? locationLat,
      double? locationLng,
      bool isPinned,
      bool isArchived,
      DateTime createdAt,
      DateTime updatedAt});

  $UserModelCopyWith<$Res>? get author;
}

/// @nodoc
class _$PostModelCopyWithImpl<$Res, $Val extends PostModel>
    implements $PostModelCopyWith<$Res> {
  _$PostModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PostModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? authorId = null,
    Object? author = freezed,
    Object? content = freezed,
    Object? media = null,
    Object? tags = null,
    Object? likesCount = null,
    Object? commentsCount = null,
    Object? sharesCount = null,
    Object? repostsCount = null,
    Object? isLiked = null,
    Object? locationName = freezed,
    Object? locationLat = freezed,
    Object? locationLng = freezed,
    Object? isPinned = null,
    Object? isArchived = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      authorId: null == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String,
      author: freezed == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      media: null == media
          ? _value.media
          : media // ignore: cast_nullable_to_non_nullable
              as List<PostMediaModel>,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      likesCount: null == likesCount
          ? _value.likesCount
          : likesCount // ignore: cast_nullable_to_non_nullable
              as int,
      commentsCount: null == commentsCount
          ? _value.commentsCount
          : commentsCount // ignore: cast_nullable_to_non_nullable
              as int,
      sharesCount: null == sharesCount
          ? _value.sharesCount
          : sharesCount // ignore: cast_nullable_to_non_nullable
              as int,
      repostsCount: null == repostsCount
          ? _value.repostsCount
          : repostsCount // ignore: cast_nullable_to_non_nullable
              as int,
      isLiked: null == isLiked
          ? _value.isLiked
          : isLiked // ignore: cast_nullable_to_non_nullable
              as bool,
      locationName: freezed == locationName
          ? _value.locationName
          : locationName // ignore: cast_nullable_to_non_nullable
              as String?,
      locationLat: freezed == locationLat
          ? _value.locationLat
          : locationLat // ignore: cast_nullable_to_non_nullable
              as double?,
      locationLng: freezed == locationLng
          ? _value.locationLng
          : locationLng // ignore: cast_nullable_to_non_nullable
              as double?,
      isPinned: null == isPinned
          ? _value.isPinned
          : isPinned // ignore: cast_nullable_to_non_nullable
              as bool,
      isArchived: null == isArchived
          ? _value.isArchived
          : isArchived // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  /// Create a copy of PostModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res>? get author {
    if (_value.author == null) {
      return null;
    }

    return $UserModelCopyWith<$Res>(_value.author!, (value) {
      return _then(_value.copyWith(author: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PostModelImplCopyWith<$Res>
    implements $PostModelCopyWith<$Res> {
  factory _$$PostModelImplCopyWith(
          _$PostModelImpl value, $Res Function(_$PostModelImpl) then) =
      __$$PostModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String authorId,
      UserModel? author,
      String? content,
      List<PostMediaModel> media,
      List<String> tags,
      int likesCount,
      int commentsCount,
      int sharesCount,
      int repostsCount,
      bool isLiked,
      String? locationName,
      double? locationLat,
      double? locationLng,
      bool isPinned,
      bool isArchived,
      DateTime createdAt,
      DateTime updatedAt});

  @override
  $UserModelCopyWith<$Res>? get author;
}

/// @nodoc
class __$$PostModelImplCopyWithImpl<$Res>
    extends _$PostModelCopyWithImpl<$Res, _$PostModelImpl>
    implements _$$PostModelImplCopyWith<$Res> {
  __$$PostModelImplCopyWithImpl(
      _$PostModelImpl _value, $Res Function(_$PostModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of PostModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? authorId = null,
    Object? author = freezed,
    Object? content = freezed,
    Object? media = null,
    Object? tags = null,
    Object? likesCount = null,
    Object? commentsCount = null,
    Object? sharesCount = null,
    Object? repostsCount = null,
    Object? isLiked = null,
    Object? locationName = freezed,
    Object? locationLat = freezed,
    Object? locationLng = freezed,
    Object? isPinned = null,
    Object? isArchived = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$PostModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      authorId: null == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String,
      author: freezed == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      media: null == media
          ? _value._media
          : media // ignore: cast_nullable_to_non_nullable
              as List<PostMediaModel>,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      likesCount: null == likesCount
          ? _value.likesCount
          : likesCount // ignore: cast_nullable_to_non_nullable
              as int,
      commentsCount: null == commentsCount
          ? _value.commentsCount
          : commentsCount // ignore: cast_nullable_to_non_nullable
              as int,
      sharesCount: null == sharesCount
          ? _value.sharesCount
          : sharesCount // ignore: cast_nullable_to_non_nullable
              as int,
      repostsCount: null == repostsCount
          ? _value.repostsCount
          : repostsCount // ignore: cast_nullable_to_non_nullable
              as int,
      isLiked: null == isLiked
          ? _value.isLiked
          : isLiked // ignore: cast_nullable_to_non_nullable
              as bool,
      locationName: freezed == locationName
          ? _value.locationName
          : locationName // ignore: cast_nullable_to_non_nullable
              as String?,
      locationLat: freezed == locationLat
          ? _value.locationLat
          : locationLat // ignore: cast_nullable_to_non_nullable
              as double?,
      locationLng: freezed == locationLng
          ? _value.locationLng
          : locationLng // ignore: cast_nullable_to_non_nullable
              as double?,
      isPinned: null == isPinned
          ? _value.isPinned
          : isPinned // ignore: cast_nullable_to_non_nullable
              as bool,
      isArchived: null == isArchived
          ? _value.isArchived
          : isArchived // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PostModelImpl implements _PostModel {
  const _$PostModelImpl(
      {required this.id,
      required this.authorId,
      this.author,
      this.content,
      final List<PostMediaModel> media = const [],
      final List<String> tags = const [],
      this.likesCount = 0,
      this.commentsCount = 0,
      this.sharesCount = 0,
      this.repostsCount = 0,
      this.isLiked = false,
      this.locationName,
      this.locationLat,
      this.locationLng,
      this.isPinned = false,
      this.isArchived = false,
      required this.createdAt,
      required this.updatedAt})
      : _media = media,
        _tags = tags;

  factory _$PostModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostModelImplFromJson(json);

  @override
  final String id;
  @override
  final String authorId;
  @override
  final UserModel? author;
  @override
  final String? content;
  final List<PostMediaModel> _media;
  @override
  @JsonKey()
  List<PostMediaModel> get media {
    if (_media is EqualUnmodifiableListView) return _media;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_media);
  }

  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @JsonKey()
  final int likesCount;
  @override
  @JsonKey()
  final int commentsCount;
  @override
  @JsonKey()
  final int sharesCount;
  @override
  @JsonKey()
  final int repostsCount;
  @override
  @JsonKey()
  final bool isLiked;
  @override
  final String? locationName;
  @override
  final double? locationLat;
  @override
  final double? locationLng;
  @override
  @JsonKey()
  final bool isPinned;
  @override
  @JsonKey()
  final bool isArchived;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'PostModel(id: $id, authorId: $authorId, author: $author, content: $content, media: $media, tags: $tags, likesCount: $likesCount, commentsCount: $commentsCount, sharesCount: $sharesCount, repostsCount: $repostsCount, isLiked: $isLiked, locationName: $locationName, locationLat: $locationLat, locationLng: $locationLng, isPinned: $isPinned, isArchived: $isArchived, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.authorId, authorId) ||
                other.authorId == authorId) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality().equals(other._media, _media) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.likesCount, likesCount) ||
                other.likesCount == likesCount) &&
            (identical(other.commentsCount, commentsCount) ||
                other.commentsCount == commentsCount) &&
            (identical(other.sharesCount, sharesCount) ||
                other.sharesCount == sharesCount) &&
            (identical(other.repostsCount, repostsCount) ||
                other.repostsCount == repostsCount) &&
            (identical(other.isLiked, isLiked) || other.isLiked == isLiked) &&
            (identical(other.locationName, locationName) ||
                other.locationName == locationName) &&
            (identical(other.locationLat, locationLat) ||
                other.locationLat == locationLat) &&
            (identical(other.locationLng, locationLng) ||
                other.locationLng == locationLng) &&
            (identical(other.isPinned, isPinned) ||
                other.isPinned == isPinned) &&
            (identical(other.isArchived, isArchived) ||
                other.isArchived == isArchived) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      authorId,
      author,
      content,
      const DeepCollectionEquality().hash(_media),
      const DeepCollectionEquality().hash(_tags),
      likesCount,
      commentsCount,
      sharesCount,
      repostsCount,
      isLiked,
      locationName,
      locationLat,
      locationLng,
      isPinned,
      isArchived,
      createdAt,
      updatedAt);

  /// Create a copy of PostModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostModelImplCopyWith<_$PostModelImpl> get copyWith =>
      __$$PostModelImplCopyWithImpl<_$PostModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PostModelImplToJson(
      this,
    );
  }
}

abstract class _PostModel implements PostModel {
  const factory _PostModel(
      {required final String id,
      required final String authorId,
      final UserModel? author,
      final String? content,
      final List<PostMediaModel> media,
      final List<String> tags,
      final int likesCount,
      final int commentsCount,
      final int sharesCount,
      final int repostsCount,
      final bool isLiked,
      final String? locationName,
      final double? locationLat,
      final double? locationLng,
      final bool isPinned,
      final bool isArchived,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$PostModelImpl;

  factory _PostModel.fromJson(Map<String, dynamic> json) =
      _$PostModelImpl.fromJson;

  @override
  String get id;
  @override
  String get authorId;
  @override
  UserModel? get author;
  @override
  String? get content;
  @override
  List<PostMediaModel> get media;
  @override
  List<String> get tags;
  @override
  int get likesCount;
  @override
  int get commentsCount;
  @override
  int get sharesCount;
  @override
  int get repostsCount;
  @override
  bool get isLiked;
  @override
  String? get locationName;
  @override
  double? get locationLat;
  @override
  double? get locationLng;
  @override
  bool get isPinned;
  @override
  bool get isArchived;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of PostModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostModelImplCopyWith<_$PostModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreatePostRequest _$CreatePostRequestFromJson(Map<String, dynamic> json) {
  return _CreatePostRequest.fromJson(json);
}

/// @nodoc
mixin _$CreatePostRequest {
  String get content => throw _privateConstructorUsedError;
  @JsonKey(name: 'media_urls')
  List<String>? get mediaUrls => throw _privateConstructorUsedError;
  List<String>? get tags => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_name')
  String? get locationName => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_lat')
  double? get locationLat => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_lng')
  double? get locationLng => throw _privateConstructorUsedError;

  /// Serializes this CreatePostRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreatePostRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreatePostRequestCopyWith<CreatePostRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreatePostRequestCopyWith<$Res> {
  factory $CreatePostRequestCopyWith(
          CreatePostRequest value, $Res Function(CreatePostRequest) then) =
      _$CreatePostRequestCopyWithImpl<$Res, CreatePostRequest>;
  @useResult
  $Res call(
      {String content,
      @JsonKey(name: 'media_urls') List<String>? mediaUrls,
      List<String>? tags,
      @JsonKey(name: 'location_name') String? locationName,
      @JsonKey(name: 'location_lat') double? locationLat,
      @JsonKey(name: 'location_lng') double? locationLng});
}

/// @nodoc
class _$CreatePostRequestCopyWithImpl<$Res, $Val extends CreatePostRequest>
    implements $CreatePostRequestCopyWith<$Res> {
  _$CreatePostRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreatePostRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? mediaUrls = freezed,
    Object? tags = freezed,
    Object? locationName = freezed,
    Object? locationLat = freezed,
    Object? locationLng = freezed,
  }) {
    return _then(_value.copyWith(
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      mediaUrls: freezed == mediaUrls
          ? _value.mediaUrls
          : mediaUrls // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      tags: freezed == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      locationName: freezed == locationName
          ? _value.locationName
          : locationName // ignore: cast_nullable_to_non_nullable
              as String?,
      locationLat: freezed == locationLat
          ? _value.locationLat
          : locationLat // ignore: cast_nullable_to_non_nullable
              as double?,
      locationLng: freezed == locationLng
          ? _value.locationLng
          : locationLng // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreatePostRequestImplCopyWith<$Res>
    implements $CreatePostRequestCopyWith<$Res> {
  factory _$$CreatePostRequestImplCopyWith(_$CreatePostRequestImpl value,
          $Res Function(_$CreatePostRequestImpl) then) =
      __$$CreatePostRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String content,
      @JsonKey(name: 'media_urls') List<String>? mediaUrls,
      List<String>? tags,
      @JsonKey(name: 'location_name') String? locationName,
      @JsonKey(name: 'location_lat') double? locationLat,
      @JsonKey(name: 'location_lng') double? locationLng});
}

/// @nodoc
class __$$CreatePostRequestImplCopyWithImpl<$Res>
    extends _$CreatePostRequestCopyWithImpl<$Res, _$CreatePostRequestImpl>
    implements _$$CreatePostRequestImplCopyWith<$Res> {
  __$$CreatePostRequestImplCopyWithImpl(_$CreatePostRequestImpl _value,
      $Res Function(_$CreatePostRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreatePostRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? mediaUrls = freezed,
    Object? tags = freezed,
    Object? locationName = freezed,
    Object? locationLat = freezed,
    Object? locationLng = freezed,
  }) {
    return _then(_$CreatePostRequestImpl(
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      mediaUrls: freezed == mediaUrls
          ? _value._mediaUrls
          : mediaUrls // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      tags: freezed == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      locationName: freezed == locationName
          ? _value.locationName
          : locationName // ignore: cast_nullable_to_non_nullable
              as String?,
      locationLat: freezed == locationLat
          ? _value.locationLat
          : locationLat // ignore: cast_nullable_to_non_nullable
              as double?,
      locationLng: freezed == locationLng
          ? _value.locationLng
          : locationLng // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreatePostRequestImpl implements _CreatePostRequest {
  const _$CreatePostRequestImpl(
      {required this.content,
      @JsonKey(name: 'media_urls') final List<String>? mediaUrls,
      final List<String>? tags,
      @JsonKey(name: 'location_name') this.locationName,
      @JsonKey(name: 'location_lat') this.locationLat,
      @JsonKey(name: 'location_lng') this.locationLng})
      : _mediaUrls = mediaUrls,
        _tags = tags;

  factory _$CreatePostRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreatePostRequestImplFromJson(json);

  @override
  final String content;
  final List<String>? _mediaUrls;
  @override
  @JsonKey(name: 'media_urls')
  List<String>? get mediaUrls {
    final value = _mediaUrls;
    if (value == null) return null;
    if (_mediaUrls is EqualUnmodifiableListView) return _mediaUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _tags;
  @override
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'location_name')
  final String? locationName;
  @override
  @JsonKey(name: 'location_lat')
  final double? locationLat;
  @override
  @JsonKey(name: 'location_lng')
  final double? locationLng;

  @override
  String toString() {
    return 'CreatePostRequest(content: $content, mediaUrls: $mediaUrls, tags: $tags, locationName: $locationName, locationLat: $locationLat, locationLng: $locationLng)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreatePostRequestImpl &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality()
                .equals(other._mediaUrls, _mediaUrls) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.locationName, locationName) ||
                other.locationName == locationName) &&
            (identical(other.locationLat, locationLat) ||
                other.locationLat == locationLat) &&
            (identical(other.locationLng, locationLng) ||
                other.locationLng == locationLng));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      content,
      const DeepCollectionEquality().hash(_mediaUrls),
      const DeepCollectionEquality().hash(_tags),
      locationName,
      locationLat,
      locationLng);

  /// Create a copy of CreatePostRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreatePostRequestImplCopyWith<_$CreatePostRequestImpl> get copyWith =>
      __$$CreatePostRequestImplCopyWithImpl<_$CreatePostRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreatePostRequestImplToJson(
      this,
    );
  }
}

abstract class _CreatePostRequest implements CreatePostRequest {
  const factory _CreatePostRequest(
          {required final String content,
          @JsonKey(name: 'media_urls') final List<String>? mediaUrls,
          final List<String>? tags,
          @JsonKey(name: 'location_name') final String? locationName,
          @JsonKey(name: 'location_lat') final double? locationLat,
          @JsonKey(name: 'location_lng') final double? locationLng}) =
      _$CreatePostRequestImpl;

  factory _CreatePostRequest.fromJson(Map<String, dynamic> json) =
      _$CreatePostRequestImpl.fromJson;

  @override
  String get content;
  @override
  @JsonKey(name: 'media_urls')
  List<String>? get mediaUrls;
  @override
  List<String>? get tags;
  @override
  @JsonKey(name: 'location_name')
  String? get locationName;
  @override
  @JsonKey(name: 'location_lat')
  double? get locationLat;
  @override
  @JsonKey(name: 'location_lng')
  double? get locationLng;

  /// Create a copy of CreatePostRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreatePostRequestImplCopyWith<_$CreatePostRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UpdatePostRequest _$UpdatePostRequestFromJson(Map<String, dynamic> json) {
  return _UpdatePostRequest.fromJson(json);
}

/// @nodoc
mixin _$UpdatePostRequest {
  String? get content => throw _privateConstructorUsedError;
  List<String>? get tags => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_pinned')
  bool? get isPinned => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_archived')
  bool? get isArchived => throw _privateConstructorUsedError;

  /// Serializes this UpdatePostRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdatePostRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdatePostRequestCopyWith<UpdatePostRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdatePostRequestCopyWith<$Res> {
  factory $UpdatePostRequestCopyWith(
          UpdatePostRequest value, $Res Function(UpdatePostRequest) then) =
      _$UpdatePostRequestCopyWithImpl<$Res, UpdatePostRequest>;
  @useResult
  $Res call(
      {String? content,
      List<String>? tags,
      @JsonKey(name: 'is_pinned') bool? isPinned,
      @JsonKey(name: 'is_archived') bool? isArchived});
}

/// @nodoc
class _$UpdatePostRequestCopyWithImpl<$Res, $Val extends UpdatePostRequest>
    implements $UpdatePostRequestCopyWith<$Res> {
  _$UpdatePostRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdatePostRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = freezed,
    Object? tags = freezed,
    Object? isPinned = freezed,
    Object? isArchived = freezed,
  }) {
    return _then(_value.copyWith(
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: freezed == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      isPinned: freezed == isPinned
          ? _value.isPinned
          : isPinned // ignore: cast_nullable_to_non_nullable
              as bool?,
      isArchived: freezed == isArchived
          ? _value.isArchived
          : isArchived // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdatePostRequestImplCopyWith<$Res>
    implements $UpdatePostRequestCopyWith<$Res> {
  factory _$$UpdatePostRequestImplCopyWith(_$UpdatePostRequestImpl value,
          $Res Function(_$UpdatePostRequestImpl) then) =
      __$$UpdatePostRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? content,
      List<String>? tags,
      @JsonKey(name: 'is_pinned') bool? isPinned,
      @JsonKey(name: 'is_archived') bool? isArchived});
}

/// @nodoc
class __$$UpdatePostRequestImplCopyWithImpl<$Res>
    extends _$UpdatePostRequestCopyWithImpl<$Res, _$UpdatePostRequestImpl>
    implements _$$UpdatePostRequestImplCopyWith<$Res> {
  __$$UpdatePostRequestImplCopyWithImpl(_$UpdatePostRequestImpl _value,
      $Res Function(_$UpdatePostRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdatePostRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = freezed,
    Object? tags = freezed,
    Object? isPinned = freezed,
    Object? isArchived = freezed,
  }) {
    return _then(_$UpdatePostRequestImpl(
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: freezed == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      isPinned: freezed == isPinned
          ? _value.isPinned
          : isPinned // ignore: cast_nullable_to_non_nullable
              as bool?,
      isArchived: freezed == isArchived
          ? _value.isArchived
          : isArchived // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdatePostRequestImpl implements _UpdatePostRequest {
  const _$UpdatePostRequestImpl(
      {this.content,
      final List<String>? tags,
      @JsonKey(name: 'is_pinned') this.isPinned,
      @JsonKey(name: 'is_archived') this.isArchived})
      : _tags = tags;

  factory _$UpdatePostRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdatePostRequestImplFromJson(json);

  @override
  final String? content;
  final List<String>? _tags;
  @override
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'is_pinned')
  final bool? isPinned;
  @override
  @JsonKey(name: 'is_archived')
  final bool? isArchived;

  @override
  String toString() {
    return 'UpdatePostRequest(content: $content, tags: $tags, isPinned: $isPinned, isArchived: $isArchived)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdatePostRequestImpl &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.isPinned, isPinned) ||
                other.isPinned == isPinned) &&
            (identical(other.isArchived, isArchived) ||
                other.isArchived == isArchived));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, content,
      const DeepCollectionEquality().hash(_tags), isPinned, isArchived);

  /// Create a copy of UpdatePostRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdatePostRequestImplCopyWith<_$UpdatePostRequestImpl> get copyWith =>
      __$$UpdatePostRequestImplCopyWithImpl<_$UpdatePostRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdatePostRequestImplToJson(
      this,
    );
  }
}

abstract class _UpdatePostRequest implements UpdatePostRequest {
  const factory _UpdatePostRequest(
          {final String? content,
          final List<String>? tags,
          @JsonKey(name: 'is_pinned') final bool? isPinned,
          @JsonKey(name: 'is_archived') final bool? isArchived}) =
      _$UpdatePostRequestImpl;

  factory _UpdatePostRequest.fromJson(Map<String, dynamic> json) =
      _$UpdatePostRequestImpl.fromJson;

  @override
  String? get content;
  @override
  List<String>? get tags;
  @override
  @JsonKey(name: 'is_pinned')
  bool? get isPinned;
  @override
  @JsonKey(name: 'is_archived')
  bool? get isArchived;

  /// Create a copy of UpdatePostRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdatePostRequestImplCopyWith<_$UpdatePostRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CommentModel _$CommentModelFromJson(Map<String, dynamic> json) {
  return _CommentModel.fromJson(json);
}

/// @nodoc
mixin _$CommentModel {
  String get id => throw _privateConstructorUsedError;
  String get postId => throw _privateConstructorUsedError;
  String get authorId => throw _privateConstructorUsedError;
  UserModel? get author => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String? get parentId => throw _privateConstructorUsedError;
  int get likesCount => throw _privateConstructorUsedError;
  bool get isLiked => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this CommentModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CommentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommentModelCopyWith<CommentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommentModelCopyWith<$Res> {
  factory $CommentModelCopyWith(
          CommentModel value, $Res Function(CommentModel) then) =
      _$CommentModelCopyWithImpl<$Res, CommentModel>;
  @useResult
  $Res call(
      {String id,
      String postId,
      String authorId,
      UserModel? author,
      String content,
      String? parentId,
      int likesCount,
      bool isLiked,
      DateTime createdAt,
      DateTime updatedAt});

  $UserModelCopyWith<$Res>? get author;
}

/// @nodoc
class _$CommentModelCopyWithImpl<$Res, $Val extends CommentModel>
    implements $CommentModelCopyWith<$Res> {
  _$CommentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CommentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? postId = null,
    Object? authorId = null,
    Object? author = freezed,
    Object? content = null,
    Object? parentId = freezed,
    Object? likesCount = null,
    Object? isLiked = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      postId: null == postId
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String,
      authorId: null == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String,
      author: freezed == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      likesCount: null == likesCount
          ? _value.likesCount
          : likesCount // ignore: cast_nullable_to_non_nullable
              as int,
      isLiked: null == isLiked
          ? _value.isLiked
          : isLiked // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  /// Create a copy of CommentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res>? get author {
    if (_value.author == null) {
      return null;
    }

    return $UserModelCopyWith<$Res>(_value.author!, (value) {
      return _then(_value.copyWith(author: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CommentModelImplCopyWith<$Res>
    implements $CommentModelCopyWith<$Res> {
  factory _$$CommentModelImplCopyWith(
          _$CommentModelImpl value, $Res Function(_$CommentModelImpl) then) =
      __$$CommentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String postId,
      String authorId,
      UserModel? author,
      String content,
      String? parentId,
      int likesCount,
      bool isLiked,
      DateTime createdAt,
      DateTime updatedAt});

  @override
  $UserModelCopyWith<$Res>? get author;
}

/// @nodoc
class __$$CommentModelImplCopyWithImpl<$Res>
    extends _$CommentModelCopyWithImpl<$Res, _$CommentModelImpl>
    implements _$$CommentModelImplCopyWith<$Res> {
  __$$CommentModelImplCopyWithImpl(
      _$CommentModelImpl _value, $Res Function(_$CommentModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of CommentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? postId = null,
    Object? authorId = null,
    Object? author = freezed,
    Object? content = null,
    Object? parentId = freezed,
    Object? likesCount = null,
    Object? isLiked = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$CommentModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      postId: null == postId
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String,
      authorId: null == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String,
      author: freezed == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      likesCount: null == likesCount
          ? _value.likesCount
          : likesCount // ignore: cast_nullable_to_non_nullable
              as int,
      isLiked: null == isLiked
          ? _value.isLiked
          : isLiked // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CommentModelImpl implements _CommentModel {
  const _$CommentModelImpl(
      {required this.id,
      required this.postId,
      required this.authorId,
      this.author,
      required this.content,
      this.parentId,
      required this.likesCount,
      required this.isLiked,
      required this.createdAt,
      required this.updatedAt});

  factory _$CommentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommentModelImplFromJson(json);

  @override
  final String id;
  @override
  final String postId;
  @override
  final String authorId;
  @override
  final UserModel? author;
  @override
  final String content;
  @override
  final String? parentId;
  @override
  final int likesCount;
  @override
  final bool isLiked;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'CommentModel(id: $id, postId: $postId, authorId: $authorId, author: $author, content: $content, parentId: $parentId, likesCount: $likesCount, isLiked: $isLiked, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommentModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.postId, postId) || other.postId == postId) &&
            (identical(other.authorId, authorId) ||
                other.authorId == authorId) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.likesCount, likesCount) ||
                other.likesCount == likesCount) &&
            (identical(other.isLiked, isLiked) || other.isLiked == isLiked) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, postId, authorId, author,
      content, parentId, likesCount, isLiked, createdAt, updatedAt);

  /// Create a copy of CommentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommentModelImplCopyWith<_$CommentModelImpl> get copyWith =>
      __$$CommentModelImplCopyWithImpl<_$CommentModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CommentModelImplToJson(
      this,
    );
  }
}

abstract class _CommentModel implements CommentModel {
  const factory _CommentModel(
      {required final String id,
      required final String postId,
      required final String authorId,
      final UserModel? author,
      required final String content,
      final String? parentId,
      required final int likesCount,
      required final bool isLiked,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$CommentModelImpl;

  factory _CommentModel.fromJson(Map<String, dynamic> json) =
      _$CommentModelImpl.fromJson;

  @override
  String get id;
  @override
  String get postId;
  @override
  String get authorId;
  @override
  UserModel? get author;
  @override
  String get content;
  @override
  String? get parentId;
  @override
  int get likesCount;
  @override
  bool get isLiked;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of CommentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommentModelImplCopyWith<_$CommentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateCommentRequest _$CreateCommentRequestFromJson(Map<String, dynamic> json) {
  return _CreateCommentRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateCommentRequest {
  String get content => throw _privateConstructorUsedError;
  @JsonKey(name: 'parent_id')
  String? get parentId => throw _privateConstructorUsedError;

  /// Serializes this CreateCommentRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateCommentRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateCommentRequestCopyWith<CreateCommentRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateCommentRequestCopyWith<$Res> {
  factory $CreateCommentRequestCopyWith(CreateCommentRequest value,
          $Res Function(CreateCommentRequest) then) =
      _$CreateCommentRequestCopyWithImpl<$Res, CreateCommentRequest>;
  @useResult
  $Res call({String content, @JsonKey(name: 'parent_id') String? parentId});
}

/// @nodoc
class _$CreateCommentRequestCopyWithImpl<$Res,
        $Val extends CreateCommentRequest>
    implements $CreateCommentRequestCopyWith<$Res> {
  _$CreateCommentRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateCommentRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? parentId = freezed,
  }) {
    return _then(_value.copyWith(
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateCommentRequestImplCopyWith<$Res>
    implements $CreateCommentRequestCopyWith<$Res> {
  factory _$$CreateCommentRequestImplCopyWith(_$CreateCommentRequestImpl value,
          $Res Function(_$CreateCommentRequestImpl) then) =
      __$$CreateCommentRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String content, @JsonKey(name: 'parent_id') String? parentId});
}

/// @nodoc
class __$$CreateCommentRequestImplCopyWithImpl<$Res>
    extends _$CreateCommentRequestCopyWithImpl<$Res, _$CreateCommentRequestImpl>
    implements _$$CreateCommentRequestImplCopyWith<$Res> {
  __$$CreateCommentRequestImplCopyWithImpl(_$CreateCommentRequestImpl _value,
      $Res Function(_$CreateCommentRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateCommentRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? parentId = freezed,
  }) {
    return _then(_$CreateCommentRequestImpl(
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateCommentRequestImpl implements _CreateCommentRequest {
  const _$CreateCommentRequestImpl(
      {required this.content, @JsonKey(name: 'parent_id') this.parentId});

  factory _$CreateCommentRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateCommentRequestImplFromJson(json);

  @override
  final String content;
  @override
  @JsonKey(name: 'parent_id')
  final String? parentId;

  @override
  String toString() {
    return 'CreateCommentRequest(content: $content, parentId: $parentId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateCommentRequestImpl &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, content, parentId);

  /// Create a copy of CreateCommentRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateCommentRequestImplCopyWith<_$CreateCommentRequestImpl>
      get copyWith =>
          __$$CreateCommentRequestImplCopyWithImpl<_$CreateCommentRequestImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateCommentRequestImplToJson(
      this,
    );
  }
}

abstract class _CreateCommentRequest implements CreateCommentRequest {
  const factory _CreateCommentRequest(
          {required final String content,
          @JsonKey(name: 'parent_id') final String? parentId}) =
      _$CreateCommentRequestImpl;

  factory _CreateCommentRequest.fromJson(Map<String, dynamic> json) =
      _$CreateCommentRequestImpl.fromJson;

  @override
  String get content;
  @override
  @JsonKey(name: 'parent_id')
  String? get parentId;

  /// Create a copy of CreateCommentRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateCommentRequestImplCopyWith<_$CreateCommentRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
