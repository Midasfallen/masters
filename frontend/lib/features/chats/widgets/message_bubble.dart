import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/models/api/chat_model.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessageModel message;
  final bool isMe;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    final time = DateFormat('HH:mm').format(message.createdAt);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            // Avatar для входящих сообщений
            const SizedBox(
              width: 32,
              child: CircleAvatar(
                radius: 14,
                child: Icon(Icons.person, size: 16),
              ),
            ),
            const SizedBox(width: 8),
          ],

          // Message bubble
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: isMe
                    ? Theme.of(context).primaryColor
                    : Colors.grey[200],
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isMe ? 18 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 18),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Message content
                  _buildMessageContent(context),
                  const SizedBox(height: 4),

                  // Time and status
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 11,
                          color: isMe
                              ? Colors.white.withOpacity(0.7)
                              : Colors.grey[600],
                        ),
                      ),
                      if (isMe) ...[
                        const SizedBox(width: 4),
                        _buildStatusIcon(),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),

          if (isMe) ...[
            const SizedBox(width: 40),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageContent(BuildContext context) {
    // Разные типы сообщений
    switch (message.type) {
      case 'text':
        return Text(
          message.content,
          style: TextStyle(
            fontSize: 15,
            color: isMe ? Colors.white : Colors.black87,
          ),
        );

      case 'image':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.metadata != null &&
                message.metadata!['url'] != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  message.metadata!['url'] as String,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      width: 200,
                      height: 200,
                      color: Colors.grey[300],
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                ),
              ),
            if (message.content.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                message.content,
                style: TextStyle(
                  fontSize: 15,
                  color: isMe ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ],
        );

      case 'service':
        return Row(
          children: [
            Icon(
              Icons.work_outline,
              size: 20,
              color: isMe ? Colors.white : Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Услуга: ${message.content}',
                style: TextStyle(
                  fontSize: 15,
                  color: isMe ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ],
        );

      case 'booking':
        return Row(
          children: [
            Icon(
              Icons.calendar_today,
              size: 20,
              color: isMe ? Colors.white : Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Запись: ${message.content}',
                style: TextStyle(
                  fontSize: 15,
                  color: isMe ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ],
        );

      default:
        return Text(
          message.content,
          style: TextStyle(
            fontSize: 15,
            color: isMe ? Colors.white : Colors.black87,
          ),
        );
    }
  }

  Widget _buildStatusIcon() {
    IconData icon;
    Color? color;

    switch (message.status) {
      case 'sent':
        icon = Icons.done;
        color = Colors.white.withOpacity(0.7);
        break;
      case 'delivered':
        icon = Icons.done_all;
        color = Colors.white.withOpacity(0.7);
        break;
      case 'read':
        icon = Icons.done_all;
        color = Colors.blue[300];
        break;
      default:
        icon = Icons.access_time;
        color = Colors.white.withOpacity(0.7);
    }

    return Icon(
      icon,
      size: 14,
      color: color,
    );
  }
}
