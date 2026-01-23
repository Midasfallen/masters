import 'package:freezed_annotation/freezed_annotation.dart';

part 'favorite.freezed.dart';
part 'favorite.g.dart';

enum FavoriteEntityType {
  @JsonValue('master')
  master,
  @JsonValue('post')
  post,
}

@freezed
class Favorite with _$Favorite {
  const factory Favorite({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'entity_type') required FavoriteEntityType entityType,
    @JsonKey(name: 'entity_id') required String entityId,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    dynamic entity,
  }) = _Favorite;

  factory Favorite.fromJson(Map<String, dynamic> json) =>
      _$FavoriteFromJson(json);
}

@freezed
class AddFavoriteRequest with _$AddFavoriteRequest {
  const factory AddFavoriteRequest({
    @JsonKey(name: 'entity_type') required FavoriteEntityType entityType,
    @JsonKey(name: 'entity_id') required String entityId,
  }) = _AddFavoriteRequest;

  factory AddFavoriteRequest.fromJson(Map<String, dynamic> json) =>
      _$AddFavoriteRequestFromJson(json);
}
