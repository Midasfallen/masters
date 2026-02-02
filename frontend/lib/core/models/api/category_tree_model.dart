import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_tree_model.freezed.dart';
part 'category_tree_model.g.dart';

/// Модель категории для дерева категорий (упрощенная версия)
@freezed
class CategoryTreeModel with _$CategoryTreeModel {
  const factory CategoryTreeModel({
    required String id,
    required String slug,
    required int level,
    @JsonKey(name: 'icon_url') String? iconUrl,
    String? color,
    @JsonKey(name: 'display_order') required int displayOrder,
    @JsonKey(name: 'masters_count') @Default(0) int mastersCount,
    @JsonKey(name: 'is_popular') @Default(false) bool isPopular,
    required String name,
    String? description,
    @Default([]) List<CategoryTreeModel> children,
  }) = _CategoryTreeModel;

  factory CategoryTreeModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryTreeModelFromJson(json);
}
