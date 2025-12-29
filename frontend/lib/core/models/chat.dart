import 'package:freezed_annotation/freezed_annotation.dart';
import 'message.dart';

part 'chat.freezed.dart';
part 'chat.g.dart';

@freezed
class Chat with _$Chat {
  const factory Chat({
    required String id,
    required String participantId,
    required String participantName,
    required String participantAvatar,
    Message? lastMessage,
    required int unreadCount,
    required DateTime updatedAt,
    bool? isOnline,
    @Default(false) bool isPinned,
  }) = _Chat;

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);
}
