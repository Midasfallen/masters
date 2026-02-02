// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CategoryTranslationModel _$CategoryTranslationModelFromJson(
    Map<String, dynamic> json) {
  return _CategoryTranslationModel.fromJson(json);
}

/// @nodoc
mixin _$CategoryTranslationModel {
  String get id => throw _privateConstructorUsedError;
  String get language => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  List<String> get keywords => throw _privateConstructorUsedError;

  /// Serializes this CategoryTranslationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CategoryTranslationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoryTranslationModelCopyWith<CategoryTranslationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryTranslationModelCopyWith<$Res> {
  factory $CategoryTranslationModelCopyWith(CategoryTranslationModel value,
          $Res Function(CategoryTranslationModel) then) =
      _$CategoryTranslationModelCopyWithImpl<$Res, CategoryTranslationModel>;
  @useResult
  $Res call(
      {String id,
      String language,
      String name,
      String? description,
      List<String> keywords});
}

/// @nodoc
class _$CategoryTranslationModelCopyWithImpl<$Res,
        $Val extends CategoryTranslationModel>
    implements $CategoryTranslationModelCopyWith<$Res> {
  _$CategoryTranslationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategoryTranslationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? language = null,
    Object? name = null,
    Object? description = freezed,
    Object? keywords = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      keywords: null == keywords
          ? _value.keywords
          : keywords // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CategoryTranslationModelImplCopyWith<$Res>
    implements $CategoryTranslationModelCopyWith<$Res> {
  factory _$$CategoryTranslationModelImplCopyWith(
          _$CategoryTranslationModelImpl value,
          $Res Function(_$CategoryTranslationModelImpl) then) =
      __$$CategoryTranslationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String language,
      String name,
      String? description,
      List<String> keywords});
}

/// @nodoc
class __$$CategoryTranslationModelImplCopyWithImpl<$Res>
    extends _$CategoryTranslationModelCopyWithImpl<$Res,
        _$CategoryTranslationModelImpl>
    implements _$$CategoryTranslationModelImplCopyWith<$Res> {
  __$$CategoryTranslationModelImplCopyWithImpl(
      _$CategoryTranslationModelImpl _value,
      $Res Function(_$CategoryTranslationModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of CategoryTranslationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? language = null,
    Object? name = null,
    Object? description = freezed,
    Object? keywords = null,
  }) {
    return _then(_$CategoryTranslationModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      keywords: null == keywords
          ? _value._keywords
          : keywords // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CategoryTranslationModelImpl implements _CategoryTranslationModel {
  const _$CategoryTranslationModelImpl(
      {required this.id,
      required this.language,
      required this.name,
      this.description,
      final List<String> keywords = const []})
      : _keywords = keywords;

  factory _$CategoryTranslationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryTranslationModelImplFromJson(json);

  @override
  final String id;
  @override
  final String language;
  @override
  final String name;
  @override
  final String? description;
  final List<String> _keywords;
  @override
  @JsonKey()
  List<String> get keywords {
    if (_keywords is EqualUnmodifiableListView) return _keywords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_keywords);
  }

  @override
  String toString() {
    return 'CategoryTranslationModel(id: $id, language: $language, name: $name, description: $description, keywords: $keywords)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryTranslationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._keywords, _keywords));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, language, name, description,
      const DeepCollectionEquality().hash(_keywords));

  /// Create a copy of CategoryTranslationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryTranslationModelImplCopyWith<_$CategoryTranslationModelImpl>
      get copyWith => __$$CategoryTranslationModelImplCopyWithImpl<
          _$CategoryTranslationModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryTranslationModelImplToJson(
      this,
    );
  }
}

abstract class _CategoryTranslationModel implements CategoryTranslationModel {
  const factory _CategoryTranslationModel(
      {required final String id,
      required final String language,
      required final String name,
      final String? description,
      final List<String> keywords}) = _$CategoryTranslationModelImpl;

  factory _CategoryTranslationModel.fromJson(Map<String, dynamic> json) =
      _$CategoryTranslationModelImpl.fromJson;

  @override
  String get id;
  @override
  String get language;
  @override
  String get name;
  @override
  String? get description;
  @override
  List<String> get keywords;

  /// Create a copy of CategoryTranslationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryTranslationModelImplCopyWith<_$CategoryTranslationModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) {
  return _CategoryModel.fromJson(json);
}

/// @nodoc
mixin _$CategoryModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'parent_id')
  String? get parentId => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  int get level => throw _privateConstructorUsedError;
  @JsonKey(name: 'icon_url')
  String? get iconUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  @JsonKey(name: 'display_order')
  int get displayOrder => throw _privateConstructorUsedError;
  @JsonKey(name: 'masters_count')
  int get mastersCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'services_count')
  int get servicesCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_popular')
  bool get isPopular => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;
  List<CategoryTranslationModel> get translations =>
      throw _privateConstructorUsedError;
  List<CategoryModel> get children => throw _privateConstructorUsedError;
  CategoryModel? get parent => throw _privateConstructorUsedError;

  /// Serializes this CategoryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoryModelCopyWith<CategoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryModelCopyWith<$Res> {
  factory $CategoryModelCopyWith(
          CategoryModel value, $Res Function(CategoryModel) then) =
      _$CategoryModelCopyWithImpl<$Res, CategoryModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'parent_id') String? parentId,
      String slug,
      int level,
      @JsonKey(name: 'icon_url') String? iconUrl,
      @JsonKey(name: 'image_url') String? imageUrl,
      String? color,
      @JsonKey(name: 'display_order') int displayOrder,
      @JsonKey(name: 'masters_count') int mastersCount,
      @JsonKey(name: 'services_count') int servicesCount,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'is_popular') bool isPopular,
      Map<String, dynamic>? metadata,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      List<CategoryTranslationModel> translations,
      List<CategoryModel> children,
      CategoryModel? parent});

  $CategoryModelCopyWith<$Res>? get parent;
}

/// @nodoc
class _$CategoryModelCopyWithImpl<$Res, $Val extends CategoryModel>
    implements $CategoryModelCopyWith<$Res> {
  _$CategoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? parentId = freezed,
    Object? slug = null,
    Object? level = null,
    Object? iconUrl = freezed,
    Object? imageUrl = freezed,
    Object? color = freezed,
    Object? displayOrder = null,
    Object? mastersCount = null,
    Object? servicesCount = null,
    Object? isActive = null,
    Object? isPopular = null,
    Object? metadata = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? translations = null,
    Object? children = null,
    Object? parent = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      iconUrl: freezed == iconUrl
          ? _value.iconUrl
          : iconUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      displayOrder: null == displayOrder
          ? _value.displayOrder
          : displayOrder // ignore: cast_nullable_to_non_nullable
              as int,
      mastersCount: null == mastersCount
          ? _value.mastersCount
          : mastersCount // ignore: cast_nullable_to_non_nullable
              as int,
      servicesCount: null == servicesCount
          ? _value.servicesCount
          : servicesCount // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isPopular: null == isPopular
          ? _value.isPopular
          : isPopular // ignore: cast_nullable_to_non_nullable
              as bool,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      translations: null == translations
          ? _value.translations
          : translations // ignore: cast_nullable_to_non_nullable
              as List<CategoryTranslationModel>,
      children: null == children
          ? _value.children
          : children // ignore: cast_nullable_to_non_nullable
              as List<CategoryModel>,
      parent: freezed == parent
          ? _value.parent
          : parent // ignore: cast_nullable_to_non_nullable
              as CategoryModel?,
    ) as $Val);
  }

  /// Create a copy of CategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CategoryModelCopyWith<$Res>? get parent {
    if (_value.parent == null) {
      return null;
    }

    return $CategoryModelCopyWith<$Res>(_value.parent!, (value) {
      return _then(_value.copyWith(parent: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CategoryModelImplCopyWith<$Res>
    implements $CategoryModelCopyWith<$Res> {
  factory _$$CategoryModelImplCopyWith(
          _$CategoryModelImpl value, $Res Function(_$CategoryModelImpl) then) =
      __$$CategoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'parent_id') String? parentId,
      String slug,
      int level,
      @JsonKey(name: 'icon_url') String? iconUrl,
      @JsonKey(name: 'image_url') String? imageUrl,
      String? color,
      @JsonKey(name: 'display_order') int displayOrder,
      @JsonKey(name: 'masters_count') int mastersCount,
      @JsonKey(name: 'services_count') int servicesCount,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'is_popular') bool isPopular,
      Map<String, dynamic>? metadata,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      List<CategoryTranslationModel> translations,
      List<CategoryModel> children,
      CategoryModel? parent});

  @override
  $CategoryModelCopyWith<$Res>? get parent;
}

/// @nodoc
class __$$CategoryModelImplCopyWithImpl<$Res>
    extends _$CategoryModelCopyWithImpl<$Res, _$CategoryModelImpl>
    implements _$$CategoryModelImplCopyWith<$Res> {
  __$$CategoryModelImplCopyWithImpl(
      _$CategoryModelImpl _value, $Res Function(_$CategoryModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of CategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? parentId = freezed,
    Object? slug = null,
    Object? level = null,
    Object? iconUrl = freezed,
    Object? imageUrl = freezed,
    Object? color = freezed,
    Object? displayOrder = null,
    Object? mastersCount = null,
    Object? servicesCount = null,
    Object? isActive = null,
    Object? isPopular = null,
    Object? metadata = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? translations = null,
    Object? children = null,
    Object? parent = freezed,
  }) {
    return _then(_$CategoryModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      iconUrl: freezed == iconUrl
          ? _value.iconUrl
          : iconUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      displayOrder: null == displayOrder
          ? _value.displayOrder
          : displayOrder // ignore: cast_nullable_to_non_nullable
              as int,
      mastersCount: null == mastersCount
          ? _value.mastersCount
          : mastersCount // ignore: cast_nullable_to_non_nullable
              as int,
      servicesCount: null == servicesCount
          ? _value.servicesCount
          : servicesCount // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isPopular: null == isPopular
          ? _value.isPopular
          : isPopular // ignore: cast_nullable_to_non_nullable
              as bool,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      translations: null == translations
          ? _value._translations
          : translations // ignore: cast_nullable_to_non_nullable
              as List<CategoryTranslationModel>,
      children: null == children
          ? _value._children
          : children // ignore: cast_nullable_to_non_nullable
              as List<CategoryModel>,
      parent: freezed == parent
          ? _value.parent
          : parent // ignore: cast_nullable_to_non_nullable
              as CategoryModel?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CategoryModelImpl implements _CategoryModel {
  const _$CategoryModelImpl(
      {required this.id,
      @JsonKey(name: 'parent_id') this.parentId,
      required this.slug,
      required this.level,
      @JsonKey(name: 'icon_url') this.iconUrl,
      @JsonKey(name: 'image_url') this.imageUrl,
      this.color,
      @JsonKey(name: 'display_order') required this.displayOrder,
      @JsonKey(name: 'masters_count') this.mastersCount = 0,
      @JsonKey(name: 'services_count') this.servicesCount = 0,
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'is_popular') this.isPopular = false,
      final Map<String, dynamic>? metadata,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt,
      final List<CategoryTranslationModel> translations = const [],
      final List<CategoryModel> children = const [],
      this.parent})
      : _metadata = metadata,
        _translations = translations,
        _children = children;

  factory _$CategoryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'parent_id')
  final String? parentId;
  @override
  final String slug;
  @override
  final int level;
  @override
  @JsonKey(name: 'icon_url')
  final String? iconUrl;
  @override
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @override
  final String? color;
  @override
  @JsonKey(name: 'display_order')
  final int displayOrder;
  @override
  @JsonKey(name: 'masters_count')
  final int mastersCount;
  @override
  @JsonKey(name: 'services_count')
  final int servicesCount;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'is_popular')
  final bool isPopular;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  final List<CategoryTranslationModel> _translations;
  @override
  @JsonKey()
  List<CategoryTranslationModel> get translations {
    if (_translations is EqualUnmodifiableListView) return _translations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_translations);
  }

  final List<CategoryModel> _children;
  @override
  @JsonKey()
  List<CategoryModel> get children {
    if (_children is EqualUnmodifiableListView) return _children;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_children);
  }

  @override
  final CategoryModel? parent;

  @override
  String toString() {
    return 'CategoryModel(id: $id, parentId: $parentId, slug: $slug, level: $level, iconUrl: $iconUrl, imageUrl: $imageUrl, color: $color, displayOrder: $displayOrder, mastersCount: $mastersCount, servicesCount: $servicesCount, isActive: $isActive, isPopular: $isPopular, metadata: $metadata, createdAt: $createdAt, updatedAt: $updatedAt, translations: $translations, children: $children, parent: $parent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.displayOrder, displayOrder) ||
                other.displayOrder == displayOrder) &&
            (identical(other.mastersCount, mastersCount) ||
                other.mastersCount == mastersCount) &&
            (identical(other.servicesCount, servicesCount) ||
                other.servicesCount == servicesCount) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isPopular, isPopular) ||
                other.isPopular == isPopular) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality()
                .equals(other._translations, _translations) &&
            const DeepCollectionEquality().equals(other._children, _children) &&
            (identical(other.parent, parent) || other.parent == parent));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      parentId,
      slug,
      level,
      iconUrl,
      imageUrl,
      color,
      displayOrder,
      mastersCount,
      servicesCount,
      isActive,
      isPopular,
      const DeepCollectionEquality().hash(_metadata),
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(_translations),
      const DeepCollectionEquality().hash(_children),
      parent);

  /// Create a copy of CategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryModelImplCopyWith<_$CategoryModelImpl> get copyWith =>
      __$$CategoryModelImplCopyWithImpl<_$CategoryModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryModelImplToJson(
      this,
    );
  }
}

abstract class _CategoryModel implements CategoryModel {
  const factory _CategoryModel(
      {required final String id,
      @JsonKey(name: 'parent_id') final String? parentId,
      required final String slug,
      required final int level,
      @JsonKey(name: 'icon_url') final String? iconUrl,
      @JsonKey(name: 'image_url') final String? imageUrl,
      final String? color,
      @JsonKey(name: 'display_order') required final int displayOrder,
      @JsonKey(name: 'masters_count') final int mastersCount,
      @JsonKey(name: 'services_count') final int servicesCount,
      @JsonKey(name: 'is_active') final bool isActive,
      @JsonKey(name: 'is_popular') final bool isPopular,
      final Map<String, dynamic>? metadata,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'updated_at') required final DateTime updatedAt,
      final List<CategoryTranslationModel> translations,
      final List<CategoryModel> children,
      final CategoryModel? parent}) = _$CategoryModelImpl;

  factory _CategoryModel.fromJson(Map<String, dynamic> json) =
      _$CategoryModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'parent_id')
  String? get parentId;
  @override
  String get slug;
  @override
  int get level;
  @override
  @JsonKey(name: 'icon_url')
  String? get iconUrl;
  @override
  @JsonKey(name: 'image_url')
  String? get imageUrl;
  @override
  String? get color;
  @override
  @JsonKey(name: 'display_order')
  int get displayOrder;
  @override
  @JsonKey(name: 'masters_count')
  int get mastersCount;
  @override
  @JsonKey(name: 'services_count')
  int get servicesCount;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'is_popular')
  bool get isPopular;
  @override
  Map<String, dynamic>? get metadata;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @override
  List<CategoryTranslationModel> get translations;
  @override
  List<CategoryModel> get children;
  @override
  CategoryModel? get parent;

  /// Create a copy of CategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryModelImplCopyWith<_$CategoryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
