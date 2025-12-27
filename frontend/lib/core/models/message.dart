import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';
part 'message.g.dart';

@freezed
class Message with _$Message {
  const factory Message({
    required String id,
    required String chatId,
    required String senderId,
    required String senderName,
    required String senderAvatar,
    required String type, // 'text', 'image', 'video', 'audio', 'location', 'booking', 'service', 'system'
    required String content,
    required DateTime createdAt,
    required String status, // 'sent', 'delivered', 'read'
    String? mediaUrl,
    Map<String, dynamic>? metadata,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);
}
