import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_template_model.freezed.dart';
part 'service_template_model.g.dart';

/// Модель шаблона услуги
@freezed
class ServiceTemplateModel with _$ServiceTemplateModel {
  const factory ServiceTemplateModel({
    required String id,
    @JsonKey(name: 'category_id') required String categoryId,
    required String slug,
    required String name,
    String? description,
    @JsonKey(name: 'icon_url') String? iconUrl,
    @JsonKey(name: 'default_duration_minutes') int? defaultDurationMinutes,
    @JsonKey(name: 'default_price_range_min') double? defaultPriceRangeMin,
    @JsonKey(name: 'default_price_range_max') double? defaultPriceRangeMax,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'display_order') @Default(0) int displayOrder,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _ServiceTemplateModel;

  factory ServiceTemplateModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceTemplateModelFromJson(json);
}

/// Список шаблонов услуг (ответ API)
@freezed
class ServiceTemplateListResponse with _$ServiceTemplateListResponse {
  const factory ServiceTemplateListResponse({
    required List<ServiceTemplateModel> data,
    required int total,
  }) = _ServiceTemplateListResponse;

  factory ServiceTemplateListResponse.fromJson(Map<String, dynamic> json) =>
      _$ServiceTemplateListResponseFromJson(json);
}
