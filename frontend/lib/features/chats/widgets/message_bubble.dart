import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/models/message.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isNextMessageSameSender;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isNextMessageSameSender,
  });

  @override
  Widget build(BuildContext context) {
    final isMyMessage = message.senderId == 'me';
    final time = DateFormat('HH:mm').format(message.createdAt);

    return Padding(
      padding: EdgeInsets.only(
        bottom: isNextMessageSameSender ? 2 : 12,
      ),
      child: Row(
        mainAxisAlignment:
            isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMyMessage) ...[
            // Avatar for received messages (only if next message is different sender)
            SizedBox(
              width: 32,
              child: !isNextMessageSameSender
                  ? CircleAvatar(
                      radius: 14,
                      backgroundImage: NetworkImage(message.senderAvatar),
                    )
                  : null,
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
                color: isMyMessage
                    ? Theme.of(context).primaryColor
                    : Colors.grey[200],
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isMyMessage ? 18 : 4),
                  bottomRight: Radius.circular(isMyMessage ? 4 : 18),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Message content
                  Text(
                    message.content,
                    style: TextStyle(
                      fontSize: 15,
                      color: isMyMessage ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Time and status
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 11,
                          color: isMyMessage
                              ? Colors.white.withValues(alpha: 0.7)
                              : Colors.grey[600],
                        ),
                      ),
                      if (isMyMessage) ...[
                        const SizedBox(width: 4),
                        Icon(
                          message.status == 'read'
                              ? Icons.done_all
                              : message.status == 'delivered'
                                  ? Icons.done_all
                                  : Icons.done,
                          size: 14,
                          color: message.status == 'read'
                              ? Colors.blue[300]
                              : Colors.white.withValues(alpha: 0.7),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),

          if (isMyMessage) ...[
            const SizedBox(width: 40),
          ],
        ],
      ),
    );
  }
}
