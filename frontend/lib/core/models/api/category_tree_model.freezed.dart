// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_tree_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CategoryTreeModel _$CategoryTreeModelFromJson(Map<String, dynamic> json) {
  return _CategoryTreeModel.fromJson(json);
}

/// @nodoc
mixin _$CategoryTreeModel {
  String get id => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  int get level => throw _privateConstructorUsedError;
  @JsonKey(name: 'icon_url')
  String? get iconUrl => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  @JsonKey(name: 'display_order')
  int get displayOrder => throw _privateConstructorUsedError;
  @JsonKey(name: 'masters_count')
  int get mastersCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_popular')
  bool get isPopular => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  List<CategoryTreeModel> get children => throw _privateConstructorUsedError;

  /// Serializes this CategoryTreeModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CategoryTreeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoryTreeModelCopyWith<CategoryTreeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryTreeModelCopyWith<$Res> {
  factory $CategoryTreeModelCopyWith(
          CategoryTreeModel value, $Res Function(CategoryTreeModel) then) =
      _$CategoryTreeModelCopyWithImpl<$Res, CategoryTreeModel>;
  @useResult
  $Res call(
      {String id,
      String slug,
      int level,
      @JsonKey(name: 'icon_url') String? iconUrl,
      String? color,
      @JsonKey(name: 'display_order') int displayOrder,
      @JsonKey(name: 'masters_count') int mastersCount,
      @JsonKey(name: 'is_popular') bool isPopular,
      String name,
      String? description,
      List<CategoryTreeModel> children});
}

/// @nodoc
class _$CategoryTreeModelCopyWithImpl<$Res, $Val extends CategoryTreeModel>
    implements $CategoryTreeModelCopyWith<$Res> {
  _$CategoryTreeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategoryTreeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? slug = null,
    Object? level = null,
    Object? iconUrl = freezed,
    Object? color = freezed,
    Object? displayOrder = null,
    Object? mastersCount = null,
    Object? isPopular = null,
    Object? name = null,
    Object? description = freezed,
    Object? children = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
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
      isPopular: null == isPopular
          ? _value.isPopular
          : isPopular // ignore: cast_nullable_to_non_nullable
              as bool,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      children: null == children
          ? _value.children
          : children // ignore: cast_nullable_to_non_nullable
              as List<CategoryTreeModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CategoryTreeModelImplCopyWith<$Res>
    implements $CategoryTreeModelCopyWith<$Res> {
  factory _$$CategoryTreeModelImplCopyWith(_$CategoryTreeModelImpl value,
          $Res Function(_$CategoryTreeModelImpl) then) =
      __$$CategoryTreeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String slug,
      int level,
      @JsonKey(name: 'icon_url') String? iconUrl,
      String? color,
      @JsonKey(name: 'display_order') int displayOrder,
      @JsonKey(name: 'masters_count') int mastersCount,
      @JsonKey(name: 'is_popular') bool isPopular,
      String name,
      String? description,
      List<CategoryTreeModel> children});
}

/// @nodoc
class __$$CategoryTreeModelImplCopyWithImpl<$Res>
    extends _$CategoryTreeModelCopyWithImpl<$Res, _$CategoryTreeModelImpl>
    implements _$$CategoryTreeModelImplCopyWith<$Res> {
  __$$CategoryTreeModelImplCopyWithImpl(_$CategoryTreeModelImpl _value,
      $Res Function(_$CategoryTreeModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of CategoryTreeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? slug = null,
    Object? level = null,
    Object? iconUrl = freezed,
    Object? color = freezed,
    Object? displayOrder = null,
    Object? mastersCount = null,
    Object? isPopular = null,
    Object? name = null,
    Object? description = freezed,
    Object? children = null,
  }) {
    return _then(_$CategoryTreeModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
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
      isPopular: null == isPopular
          ? _value.isPopular
          : isPopular // ignore: cast_nullable_to_non_nullable
              as bool,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      children: null == children
          ? _value._children
          : children // ignore: cast_nullable_to_non_nullable
              as List<CategoryTreeModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CategoryTreeModelImpl implements _CategoryTreeModel {
  const _$CategoryTreeModelImpl(
      {required this.id,
      required this.slug,
      required this.level,
      @JsonKey(name: 'icon_url') this.iconUrl,
      this.color,
      @JsonKey(name: 'display_order') required this.displayOrder,
      @JsonKey(name: 'masters_count') this.mastersCount = 0,
      @JsonKey(name: 'is_popular') this.isPopular = false,
      required this.name,
      this.description,
      final List<CategoryTreeModel> children = const []})
      : _children = children;

  factory _$CategoryTreeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryTreeModelImplFromJson(json);

  @override
  final String id;
  @override
  final String slug;
  @override
  final int level;
  @override
  @JsonKey(name: 'icon_url')
  final String? iconUrl;
  @override
  final String? color;
  @override
  @JsonKey(name: 'display_order')
  final int displayOrder;
  @override
  @JsonKey(name: 'masters_count')
  final int mastersCount;
  @override
  @JsonKey(name: 'is_popular')
  final bool isPopular;
  @override
  final String name;
  @override
  final String? description;
  final List<CategoryTreeModel> _children;
  @override
  @JsonKey()
  List<CategoryTreeModel> get children {
    if (_children is EqualUnmodifiableListView) return _children;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_children);
  }

  @override
  String toString() {
    return 'CategoryTreeModel(id: $id, slug: $slug, level: $level, iconUrl: $iconUrl, color: $color, displayOrder: $displayOrder, mastersCount: $mastersCount, isPopular: $isPopular, name: $name, description: $description, children: $children)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryTreeModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.displayOrder, displayOrder) ||
                other.displayOrder == displayOrder) &&
            (identical(other.mastersCount, mastersCount) ||
                other.mastersCount == mastersCount) &&
            (identical(other.isPopular, isPopular) ||
                other.isPopular == isPopular) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._children, _children));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      slug,
      level,
      iconUrl,
      color,
      displayOrder,
      mastersCount,
      isPopular,
      name,
      description,
      const DeepCollectionEquality().hash(_children));

  /// Create a copy of CategoryTreeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryTreeModelImplCopyWith<_$CategoryTreeModelImpl> get copyWith =>
      __$$CategoryTreeModelImplCopyWithImpl<_$CategoryTreeModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryTreeModelImplToJson(
      this,
    );
  }
}

abstract class _CategoryTreeModel implements CategoryTreeModel {
  const factory _CategoryTreeModel(
      {required final String id,
      required final String slug,
      required final int level,
      @JsonKey(name: 'icon_url') final String? iconUrl,
      final String? color,
      @JsonKey(name: 'display_order') required final int displayOrder,
      @JsonKey(name: 'masters_count') final int mastersCount,
      @JsonKey(name: 'is_popular') final bool isPopular,
      required final String name,
      final String? description,
      final List<CategoryTreeModel> children}) = _$CategoryTreeModelImpl;

  factory _CategoryTreeModel.fromJson(Map<String, dynamic> json) =
      _$CategoryTreeModelImpl.fromJson;

  @override
  String get id;
  @override
  String get slug;
  @override
  int get level;
  @override
  @JsonKey(name: 'icon_url')
  String? get iconUrl;
  @override
  String? get color;
  @override
  @JsonKey(name: 'display_order')
  int get displayOrder;
  @override
  @JsonKey(name: 'masters_count')
  int get mastersCount;
  @override
  @JsonKey(name: 'is_popular')
  bool get isPopular;
  @override
  String get name;
  @override
  String? get description;
  @override
  List<CategoryTreeModel> get children;

  /// Create a copy of CategoryTreeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryTreeModelImplCopyWith<_$CategoryTreeModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
