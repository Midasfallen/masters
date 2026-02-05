import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_template_model.freezed.dart';
part 'service_template_model.g.dart';

/// Модель шаблона услуги (API возвращает camelCase)
@freezed
class ServiceTemplateModel with _$ServiceTemplateModel {
  const factory ServiceTemplateModel({
    required String id,
    @JsonKey(name: 'categoryId') required String categoryId,
    required String slug,
    required String name,
    String? description,
    @JsonKey(name: 'iconUrl') String? iconUrl,
    @JsonKey(name: 'defaultDurationMinutes') int? defaultDurationMinutes,
    @JsonKey(name: 'defaultPriceRangeMin') double? defaultPriceRangeMin,
    @JsonKey(name: 'defaultPriceRangeMax') double? defaultPriceRangeMax,
    @JsonKey(name: 'isActive') @Default(true) bool isActive,
    @JsonKey(name: 'displayOrder') @Default(0) int displayOrder,
    @JsonKey(name: 'createdAt') required DateTime createdAt,
    @JsonKey(name: 'updatedAt') required DateTime updatedAt,
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
