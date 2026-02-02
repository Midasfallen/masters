import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

@freezed
class CategoryTranslationModel with _$CategoryTranslationModel {
  const factory CategoryTranslationModel({
    required String id,
    required String language,
    required String name,
    String? description,
    @Default([]) List<String> keywords,
  }) = _CategoryTranslationModel;

  factory CategoryTranslationModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryTranslationModelFromJson(json);
}

@freezed
class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    required String id,
    @JsonKey(name: 'parent_id') String? parentId,
    required String slug,
    required int level,
    @JsonKey(name: 'icon_url') String? iconUrl,
    @JsonKey(name: 'image_url') String? imageUrl,
    String? color,
    @JsonKey(name: 'display_order') required int displayOrder,
    @JsonKey(name: 'masters_count') @Default(0) int mastersCount,
    @JsonKey(name: 'services_count') @Default(0) int servicesCount,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'is_popular') @Default(false) bool isPopular,
    Map<String, dynamic>? metadata,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @Default([]) List<CategoryTranslationModel> translations,
    @Default([]) List<CategoryModel> children,
    CategoryModel? parent,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);
}
