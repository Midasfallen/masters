// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_aggregation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CategorySearchResultModel _$CategorySearchResultModelFromJson(
    Map<String, dynamic> json) {
  return _CategorySearchResultModel.fromJson(json);
}

/// @nodoc
mixin _$CategorySearchResultModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  int get level => throw _privateConstructorUsedError;
  @JsonKey(name: 'parent_id')
  String? get parentId => throw _privateConstructorUsedError;
  String get language => throw _privateConstructorUsedError;
  @JsonKey(name: 'name_highlighted')
  String? get nameHighlighted => throw _privateConstructorUsedError;

  /// Serializes this CategorySearchResultModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CategorySearchResultModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategorySearchResultModelCopyWith<CategorySearchResultModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategorySearchResultModelCopyWith<$Res> {
  factory $CategorySearchResultModelCopyWith(CategorySearchResultModel value,
          $Res Function(CategorySearchResultModel) then) =
      _$CategorySearchResultModelCopyWithImpl<$Res, CategorySearchResultModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      String slug,
      int level,
      @JsonKey(name: 'parent_id') String? parentId,
      String language,
      @JsonKey(name: 'name_highlighted') String? nameHighlighted});
}

/// @nodoc
class _$CategorySearchResultModelCopyWithImpl<$Res,
        $Val extends CategorySearchResultModel>
    implements $CategorySearchResultModelCopyWith<$Res> {
  _$CategorySearchResultModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategorySearchResultModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? level = null,
    Object? parentId = freezed,
    Object? language = null,
    Object? nameHighlighted = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      nameHighlighted: freezed == nameHighlighted
          ? _value.nameHighlighted
          : nameHighlighted // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CategorySearchResultModelImplCopyWith<$Res>
    implements $CategorySearchResultModelCopyWith<$Res> {
  factory _$$CategorySearchResultModelImplCopyWith(
          _$CategorySearchResultModelImpl value,
          $Res Function(_$CategorySearchResultModelImpl) then) =
      __$$CategorySearchResultModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String slug,
      int level,
      @JsonKey(name: 'parent_id') String? parentId,
      String language,
      @JsonKey(name: 'name_highlighted') String? nameHighlighted});
}

/// @nodoc
class __$$CategorySearchResultModelImplCopyWithImpl<$Res>
    extends _$CategorySearchResultModelCopyWithImpl<$Res,
        _$CategorySearchResultModelImpl>
    implements _$$CategorySearchResultModelImplCopyWith<$Res> {
  __$$CategorySearchResultModelImplCopyWithImpl(
      _$CategorySearchResultModelImpl _value,
      $Res Function(_$CategorySearchResultModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of CategorySearchResultModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? level = null,
    Object? parentId = freezed,
    Object? language = null,
    Object? nameHighlighted = freezed,
  }) {
    return _then(_$CategorySearchResultModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      nameHighlighted: freezed == nameHighlighted
          ? _value.nameHighlighted
          : nameHighlighted // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CategorySearchResultModelImpl implements _CategorySearchResultModel {
  const _$CategorySearchResultModelImpl(
      {required this.id,
      required this.name,
      required this.slug,
      required this.level,
      @JsonKey(name: 'parent_id') this.parentId,
      required this.language,
      @JsonKey(name: 'name_highlighted') this.nameHighlighted});

  factory _$CategorySearchResultModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategorySearchResultModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String slug;
  @override
  final int level;
  @override
  @JsonKey(name: 'parent_id')
  final String? parentId;
  @override
  final String language;
  @override
  @JsonKey(name: 'name_highlighted')
  final String? nameHighlighted;

  @override
  String toString() {
    return 'CategorySearchResultModel(id: $id, name: $name, slug: $slug, level: $level, parentId: $parentId, language: $language, nameHighlighted: $nameHighlighted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategorySearchResultModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.nameHighlighted, nameHighlighted) ||
                other.nameHighlighted == nameHighlighted));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, slug, level, parentId, language, nameHighlighted);

  /// Create a copy of CategorySearchResultModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategorySearchResultModelImplCopyWith<_$CategorySearchResultModelImpl>
      get copyWith => __$$CategorySearchResultModelImplCopyWithImpl<
          _$CategorySearchResultModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CategorySearchResultModelImplToJson(
      this,
    );
  }
}

abstract class _CategorySearchResultModel implements CategorySearchResultModel {
  const factory _CategorySearchResultModel(
          {required final String id,
          required final String name,
          required final String slug,
          required final int level,
          @JsonKey(name: 'parent_id') final String? parentId,
          required final String language,
          @JsonKey(name: 'name_highlighted') final String? nameHighlighted}) =
      _$CategorySearchResultModelImpl;

  factory _CategorySearchResultModel.fromJson(Map<String, dynamic> json) =
      _$CategorySearchResultModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get slug;
  @override
  int get level;
  @override
  @JsonKey(name: 'parent_id')
  String? get parentId;
  @override
  String get language;
  @override
  @JsonKey(name: 'name_highlighted')
  String? get nameHighlighted;

  /// Create a copy of CategorySearchResultModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategorySearchResultModelImplCopyWith<_$CategorySearchResultModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

MasterPreviewInSearch _$MasterPreviewInSearchFromJson(
    Map<String, dynamic> json) {
  return _MasterPreviewInSearch.fromJson(json);
}

/// @nodoc
mixin _$MasterPreviewInSearch {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'first_name')
  String get firstName => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_name')
  String get lastName => throw _privateConstructorUsedError;
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'average_rating')
  double get averageRating => throw _privateConstructorUsedError;

  /// Serializes this MasterPreviewInSearch to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MasterPreviewInSearch
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MasterPreviewInSearchCopyWith<MasterPreviewInSearch> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MasterPreviewInSearchCopyWith<$Res> {
  factory $MasterPreviewInSearchCopyWith(MasterPreviewInSearch value,
          $Res Function(MasterPreviewInSearch) then) =
      _$MasterPreviewInSearchCopyWithImpl<$Res, MasterPreviewInSearch>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'first_name') String firstName,
      @JsonKey(name: 'last_name') String lastName,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      @JsonKey(name: 'average_rating') double averageRating});
}

/// @nodoc
class _$MasterPreviewInSearchCopyWithImpl<$Res,
        $Val extends MasterPreviewInSearch>
    implements $MasterPreviewInSearchCopyWith<$Res> {
  _$MasterPreviewInSearchCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MasterPreviewInSearch
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? avatarUrl = freezed,
    Object? averageRating = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      averageRating: null == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MasterPreviewInSearchImplCopyWith<$Res>
    implements $MasterPreviewInSearchCopyWith<$Res> {
  factory _$$MasterPreviewInSearchImplCopyWith(
          _$MasterPreviewInSearchImpl value,
          $Res Function(_$MasterPreviewInSearchImpl) then) =
      __$$MasterPreviewInSearchImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'first_name') String firstName,
      @JsonKey(name: 'last_name') String lastName,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      @JsonKey(name: 'average_rating') double averageRating});
}

/// @nodoc
class __$$MasterPreviewInSearchImplCopyWithImpl<$Res>
    extends _$MasterPreviewInSearchCopyWithImpl<$Res,
        _$MasterPreviewInSearchImpl>
    implements _$$MasterPreviewInSearchImplCopyWith<$Res> {
  __$$MasterPreviewInSearchImplCopyWithImpl(_$MasterPreviewInSearchImpl _value,
      $Res Function(_$MasterPreviewInSearchImpl) _then)
      : super(_value, _then);

  /// Create a copy of MasterPreviewInSearch
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? avatarUrl = freezed,
    Object? averageRating = null,
  }) {
    return _then(_$MasterPreviewInSearchImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      averageRating: null == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MasterPreviewInSearchImpl implements _MasterPreviewInSearch {
  const _$MasterPreviewInSearchImpl(
      {required this.id,
      @JsonKey(name: 'first_name') required this.firstName,
      @JsonKey(name: 'last_name') required this.lastName,
      @JsonKey(name: 'avatar_url') this.avatarUrl,
      @JsonKey(name: 'average_rating') required this.averageRating});

  factory _$MasterPreviewInSearchImpl.fromJson(Map<String, dynamic> json) =>
      _$$MasterPreviewInSearchImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'first_name')
  final String firstName;
  @override
  @JsonKey(name: 'last_name')
  final String lastName;
  @override
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  @override
  @JsonKey(name: 'average_rating')
  final double averageRating;

  @override
  String toString() {
    return 'MasterPreviewInSearch(id: $id, firstName: $firstName, lastName: $lastName, avatarUrl: $avatarUrl, averageRating: $averageRating)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MasterPreviewInSearchImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.averageRating, averageRating) ||
                other.averageRating == averageRating));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, firstName, lastName, avatarUrl, averageRating);

  /// Create a copy of MasterPreviewInSearch
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MasterPreviewInSearchImplCopyWith<_$MasterPreviewInSearchImpl>
      get copyWith => __$$MasterPreviewInSearchImplCopyWithImpl<
          _$MasterPreviewInSearchImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MasterPreviewInSearchImplToJson(
      this,
    );
  }
}

abstract class _MasterPreviewInSearch implements MasterPreviewInSearch {
  const factory _MasterPreviewInSearch(
      {required final String id,
      @JsonKey(name: 'first_name') required final String firstName,
      @JsonKey(name: 'last_name') required final String lastName,
      @JsonKey(name: 'avatar_url') final String? avatarUrl,
      @JsonKey(name: 'average_rating')
      required final double averageRating}) = _$MasterPreviewInSearchImpl;

  factory _MasterPreviewInSearch.fromJson(Map<String, dynamic> json) =
      _$MasterPreviewInSearchImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'first_name')
  String get firstName;
  @override
  @JsonKey(name: 'last_name')
  String get lastName;
  @override
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl;
  @override
  @JsonKey(name: 'average_rating')
  double get averageRating;

  /// Create a copy of MasterPreviewInSearch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MasterPreviewInSearchImplCopyWith<_$MasterPreviewInSearchImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ServiceSearchResultModel _$ServiceSearchResultModelFromJson(
    Map<String, dynamic> json) {
  return _ServiceSearchResultModel.fromJson(json);
}

/// @nodoc
mixin _$ServiceSearchResultModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  @JsonKey(name: 'duration_minutes')
  int get durationMinutes => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_name')
  String? get categoryName => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  @JsonKey(name: 'photo_urls')
  List<String> get photoUrls => throw _privateConstructorUsedError;
  MasterPreviewInSearch get master => throw _privateConstructorUsedError;

  /// Serializes this ServiceSearchResultModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ServiceSearchResultModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ServiceSearchResultModelCopyWith<ServiceSearchResultModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServiceSearchResultModelCopyWith<$Res> {
  factory $ServiceSearchResultModelCopyWith(ServiceSearchResultModel value,
          $Res Function(ServiceSearchResultModel) then) =
      _$ServiceSearchResultModelCopyWithImpl<$Res, ServiceSearchResultModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      double price,
      @JsonKey(name: 'duration_minutes') int durationMinutes,
      @JsonKey(name: 'category_name') String? categoryName,
      List<String> tags,
      @JsonKey(name: 'photo_urls') List<String> photoUrls,
      MasterPreviewInSearch master});

  $MasterPreviewInSearchCopyWith<$Res> get master;
}

/// @nodoc
class _$ServiceSearchResultModelCopyWithImpl<$Res,
        $Val extends ServiceSearchResultModel>
    implements $ServiceSearchResultModelCopyWith<$Res> {
  _$ServiceSearchResultModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ServiceSearchResultModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? price = null,
    Object? durationMinutes = null,
    Object? categoryName = freezed,
    Object? tags = null,
    Object? photoUrls = null,
    Object? master = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      durationMinutes: null == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      categoryName: freezed == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      photoUrls: null == photoUrls
          ? _value.photoUrls
          : photoUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      master: null == master
          ? _value.master
          : master // ignore: cast_nullable_to_non_nullable
              as MasterPreviewInSearch,
    ) as $Val);
  }

  /// Create a copy of ServiceSearchResultModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MasterPreviewInSearchCopyWith<$Res> get master {
    return $MasterPreviewInSearchCopyWith<$Res>(_value.master, (value) {
      return _then(_value.copyWith(master: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ServiceSearchResultModelImplCopyWith<$Res>
    implements $ServiceSearchResultModelCopyWith<$Res> {
  factory _$$ServiceSearchResultModelImplCopyWith(
          _$ServiceSearchResultModelImpl value,
          $Res Function(_$ServiceSearchResultModelImpl) then) =
      __$$ServiceSearchResultModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      double price,
      @JsonKey(name: 'duration_minutes') int durationMinutes,
      @JsonKey(name: 'category_name') String? categoryName,
      List<String> tags,
      @JsonKey(name: 'photo_urls') List<String> photoUrls,
      MasterPreviewInSearch master});

  @override
  $MasterPreviewInSearchCopyWith<$Res> get master;
}

/// @nodoc
class __$$ServiceSearchResultModelImplCopyWithImpl<$Res>
    extends _$ServiceSearchResultModelCopyWithImpl<$Res,
        _$ServiceSearchResultModelImpl>
    implements _$$ServiceSearchResultModelImplCopyWith<$Res> {
  __$$ServiceSearchResultModelImplCopyWithImpl(
      _$ServiceSearchResultModelImpl _value,
      $Res Function(_$ServiceSearchResultModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ServiceSearchResultModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? price = null,
    Object? durationMinutes = null,
    Object? categoryName = freezed,
    Object? tags = null,
    Object? photoUrls = null,
    Object? master = null,
  }) {
    return _then(_$ServiceSearchResultModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      durationMinutes: null == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      categoryName: freezed == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      photoUrls: null == photoUrls
          ? _value._photoUrls
          : photoUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      master: null == master
          ? _value.master
          : master // ignore: cast_nullable_to_non_nullable
              as MasterPreviewInSearch,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ServiceSearchResultModelImpl implements _ServiceSearchResultModel {
  const _$ServiceSearchResultModelImpl(
      {required this.id,
      required this.name,
      this.description,
      required this.price,
      @JsonKey(name: 'duration_minutes') required this.durationMinutes,
      @JsonKey(name: 'category_name') this.categoryName,
      final List<String> tags = const [],
      @JsonKey(name: 'photo_urls') final List<String> photoUrls = const [],
      required this.master})
      : _tags = tags,
        _photoUrls = photoUrls;

  factory _$ServiceSearchResultModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServiceSearchResultModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? description;
  @override
  final double price;
  @override
  @JsonKey(name: 'duration_minutes')
  final int durationMinutes;
  @override
  @JsonKey(name: 'category_name')
  final String? categoryName;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  final List<String> _photoUrls;
  @override
  @JsonKey(name: 'photo_urls')
  List<String> get photoUrls {
    if (_photoUrls is EqualUnmodifiableListView) return _photoUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_photoUrls);
  }

  @override
  final MasterPreviewInSearch master;

  @override
  String toString() {
    return 'ServiceSearchResultModel(id: $id, name: $name, description: $description, price: $price, durationMinutes: $durationMinutes, categoryName: $categoryName, tags: $tags, photoUrls: $photoUrls, master: $master)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServiceSearchResultModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality()
                .equals(other._photoUrls, _photoUrls) &&
            (identical(other.master, master) || other.master == master));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      price,
      durationMinutes,
      categoryName,
      const DeepCollectionEquality().hash(_tags),
      const DeepCollectionEquality().hash(_photoUrls),
      master);

  /// Create a copy of ServiceSearchResultModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServiceSearchResultModelImplCopyWith<_$ServiceSearchResultModelImpl>
      get copyWith => __$$ServiceSearchResultModelImplCopyWithImpl<
          _$ServiceSearchResultModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ServiceSearchResultModelImplToJson(
      this,
    );
  }
}

abstract class _ServiceSearchResultModel implements ServiceSearchResultModel {
  const factory _ServiceSearchResultModel(
          {required final String id,
          required final String name,
          final String? description,
          required final double price,
          @JsonKey(name: 'duration_minutes') required final int durationMinutes,
          @JsonKey(name: 'category_name') final String? categoryName,
          final List<String> tags,
          @JsonKey(name: 'photo_urls') final List<String> photoUrls,
          required final MasterPreviewInSearch master}) =
      _$ServiceSearchResultModelImpl;

  factory _ServiceSearchResultModel.fromJson(Map<String, dynamic> json) =
      _$ServiceSearchResultModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  double get price;
  @override
  @JsonKey(name: 'duration_minutes')
  int get durationMinutes;
  @override
  @JsonKey(name: 'category_name')
  String? get categoryName;
  @override
  List<String> get tags;
  @override
  @JsonKey(name: 'photo_urls')
  List<String> get photoUrls;
  @override
  MasterPreviewInSearch get master;

  /// Create a copy of ServiceSearchResultModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServiceSearchResultModelImplCopyWith<_$ServiceSearchResultModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

SearchAggregationModel _$SearchAggregationModelFromJson(
    Map<String, dynamic> json) {
  return _SearchAggregationModel.fromJson(json);
}

/// @nodoc
mixin _$SearchAggregationModel {
  List<MasterSearchResultModel> get masters =>
      throw _privateConstructorUsedError;
  List<ServiceSearchResultModel> get services =>
      throw _privateConstructorUsedError;
  List<CategorySearchResultModel> get categories =>
      throw _privateConstructorUsedError;
  String get query => throw _privateConstructorUsedError;
  @JsonKey(name: 'processing_time_ms')
  int get processingTimeMs => throw _privateConstructorUsedError;

  /// Serializes this SearchAggregationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SearchAggregationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SearchAggregationModelCopyWith<SearchAggregationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchAggregationModelCopyWith<$Res> {
  factory $SearchAggregationModelCopyWith(SearchAggregationModel value,
          $Res Function(SearchAggregationModel) then) =
      _$SearchAggregationModelCopyWithImpl<$Res, SearchAggregationModel>;
  @useResult
  $Res call(
      {List<MasterSearchResultModel> masters,
      List<ServiceSearchResultModel> services,
      List<CategorySearchResultModel> categories,
      String query,
      @JsonKey(name: 'processing_time_ms') int processingTimeMs});
}

/// @nodoc
class _$SearchAggregationModelCopyWithImpl<$Res,
        $Val extends SearchAggregationModel>
    implements $SearchAggregationModelCopyWith<$Res> {
  _$SearchAggregationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchAggregationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? masters = null,
    Object? services = null,
    Object? categories = null,
    Object? query = null,
    Object? processingTimeMs = null,
  }) {
    return _then(_value.copyWith(
      masters: null == masters
          ? _value.masters
          : masters // ignore: cast_nullable_to_non_nullable
              as List<MasterSearchResultModel>,
      services: null == services
          ? _value.services
          : services // ignore: cast_nullable_to_non_nullable
              as List<ServiceSearchResultModel>,
      categories: null == categories
          ? _value.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<CategorySearchResultModel>,
      query: null == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
      processingTimeMs: null == processingTimeMs
          ? _value.processingTimeMs
          : processingTimeMs // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SearchAggregationModelImplCopyWith<$Res>
    implements $SearchAggregationModelCopyWith<$Res> {
  factory _$$SearchAggregationModelImplCopyWith(
          _$SearchAggregationModelImpl value,
          $Res Function(_$SearchAggregationModelImpl) then) =
      __$$SearchAggregationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<MasterSearchResultModel> masters,
      List<ServiceSearchResultModel> services,
      List<CategorySearchResultModel> categories,
      String query,
      @JsonKey(name: 'processing_time_ms') int processingTimeMs});
}

/// @nodoc
class __$$SearchAggregationModelImplCopyWithImpl<$Res>
    extends _$SearchAggregationModelCopyWithImpl<$Res,
        _$SearchAggregationModelImpl>
    implements _$$SearchAggregationModelImplCopyWith<$Res> {
  __$$SearchAggregationModelImplCopyWithImpl(
      _$SearchAggregationModelImpl _value,
      $Res Function(_$SearchAggregationModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SearchAggregationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? masters = null,
    Object? services = null,
    Object? categories = null,
    Object? query = null,
    Object? processingTimeMs = null,
  }) {
    return _then(_$SearchAggregationModelImpl(
      masters: null == masters
          ? _value._masters
          : masters // ignore: cast_nullable_to_non_nullable
              as List<MasterSearchResultModel>,
      services: null == services
          ? _value._services
          : services // ignore: cast_nullable_to_non_nullable
              as List<ServiceSearchResultModel>,
      categories: null == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<CategorySearchResultModel>,
      query: null == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
      processingTimeMs: null == processingTimeMs
          ? _value.processingTimeMs
          : processingTimeMs // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SearchAggregationModelImpl implements _SearchAggregationModel {
  const _$SearchAggregationModelImpl(
      {required final List<MasterSearchResultModel> masters,
      required final List<ServiceSearchResultModel> services,
      required final List<CategorySearchResultModel> categories,
      required this.query,
      @JsonKey(name: 'processing_time_ms') required this.processingTimeMs})
      : _masters = masters,
        _services = services,
        _categories = categories;

  factory _$SearchAggregationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SearchAggregationModelImplFromJson(json);

  final List<MasterSearchResultModel> _masters;
  @override
  List<MasterSearchResultModel> get masters {
    if (_masters is EqualUnmodifiableListView) return _masters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_masters);
  }

  final List<ServiceSearchResultModel> _services;
  @override
  List<ServiceSearchResultModel> get services {
    if (_services is EqualUnmodifiableListView) return _services;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_services);
  }

  final List<CategorySearchResultModel> _categories;
  @override
  List<CategorySearchResultModel> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  @override
  final String query;
  @override
  @JsonKey(name: 'processing_time_ms')
  final int processingTimeMs;

  @override
  String toString() {
    return 'SearchAggregationModel(masters: $masters, services: $services, categories: $categories, query: $query, processingTimeMs: $processingTimeMs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchAggregationModelImpl &&
            const DeepCollectionEquality().equals(other._masters, _masters) &&
            const DeepCollectionEquality().equals(other._services, _services) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            (identical(other.query, query) || other.query == query) &&
            (identical(other.processingTimeMs, processingTimeMs) ||
                other.processingTimeMs == processingTimeMs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_masters),
      const DeepCollectionEquality().hash(_services),
      const DeepCollectionEquality().hash(_categories),
      query,
      processingTimeMs);

  /// Create a copy of SearchAggregationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchAggregationModelImplCopyWith<_$SearchAggregationModelImpl>
      get copyWith => __$$SearchAggregationModelImplCopyWithImpl<
          _$SearchAggregationModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SearchAggregationModelImplToJson(
      this,
    );
  }
}

abstract class _SearchAggregationModel implements SearchAggregationModel {
  const factory _SearchAggregationModel(
      {required final List<MasterSearchResultModel> masters,
      required final List<ServiceSearchResultModel> services,
      required final List<CategorySearchResultModel> categories,
      required final String query,
      @JsonKey(name: 'processing_time_ms')
      required final int processingTimeMs}) = _$SearchAggregationModelImpl;

  factory _SearchAggregationModel.fromJson(Map<String, dynamic> json) =
      _$SearchAggregationModelImpl.fromJson;

  @override
  List<MasterSearchResultModel> get masters;
  @override
  List<ServiceSearchResultModel> get services;
  @override
  List<CategorySearchResultModel> get categories;
  @override
  String get query;
  @override
  @JsonKey(name: 'processing_time_ms')
  int get processingTimeMs;

  /// Create a copy of SearchAggregationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchAggregationModelImplCopyWith<_$SearchAggregationModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
