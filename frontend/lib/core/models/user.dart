import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String name,
    required String email,
    required String avatar,
    required String role, // 'client' | 'master'
    String? bio,
    String? phone,
    String? city,
    int? followersCount,
    int? followingCount,
    bool? isFollowing,
    bool? isFriend,
    double? rating,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
