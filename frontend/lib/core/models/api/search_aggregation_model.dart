import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:service_platform/core/models/api/master_model.dart';

part 'search_aggregation_model.freezed.dart';
part 'search_aggregation_model.g.dart';

/// Результат поиска категории (L0/L1)
@freezed
class CategorySearchResultModel with _$CategorySearchResultModel {
  const factory CategorySearchResultModel({
    required String id,
    required String name,
    required String slug,
    required int level,
    @JsonKey(name: 'parent_id') String? parentId,
    required String language,
    @JsonKey(name: 'name_highlighted') String? nameHighlighted,
  }) = _CategorySearchResultModel;

  factory CategorySearchResultModel.fromJson(Map<String, dynamic> json) =>
      _$CategorySearchResultModelFromJson(json);
}

/// Превью мастера в результате поиска услуги
@freezed
class MasterPreviewInSearch with _$MasterPreviewInSearch {
  const factory MasterPreviewInSearch({
    required String id,
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') required String lastName,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'average_rating') required double averageRating,
  }) = _MasterPreviewInSearch;

  factory MasterPreviewInSearch.fromJson(Map<String, dynamic> json) =>
      _$MasterPreviewInSearchFromJson(json);
}

/// Результат поиска услуги (формат ответа /search/all и /search/services)
@freezed
class ServiceSearchResultModel with _$ServiceSearchResultModel {
  const factory ServiceSearchResultModel({
    required String id,
    required String name,
    String? description,
    required double price,
    @JsonKey(name: 'duration_minutes') required int durationMinutes,
    @JsonKey(name: 'category_name') String? categoryName,
    @Default([]) List<String> tags,
    @JsonKey(name: 'photo_urls') @Default([]) List<String> photoUrls,
    required MasterPreviewInSearch master,
  }) = _ServiceSearchResultModel;

  factory ServiceSearchResultModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceSearchResultModelFromJson(json);
}

/// Агрегированный ответ поиска: мастера, услуги, категории
@freezed
class SearchAggregationModel with _$SearchAggregationModel {
  const factory SearchAggregationModel({
    required List<MasterSearchResultModel> masters,
    required List<ServiceSearchResultModel> services,
    required List<CategorySearchResultModel> categories,
    required String query,
    @JsonKey(name: 'processing_time_ms') required int processingTimeMs,
  }) = _SearchAggregationModel;

  factory SearchAggregationModel.fromJson(Map<String, dynamic> json) =>
      _$SearchAggregationModelFromJson(json);
}
