import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../domain/models/message.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.message});

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isFromMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.75),
        decoration: BoxDecoration(
          color: message.isFromMe ? AppColors.messageBubbleSent : AppColors.messageBubbleReceived,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: Radius.circular(message.isFromMe ? 12 : 4),
            bottomRight: Radius.circular(message.isFromMe ? 4 : 12),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message.content,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTime(message.createdAt),
                  style: const TextStyle(fontSize: 11, color: Colors.black45),
                ),
                if (message.isFromMe) ...[
                  const SizedBox(width: 4),
                  Icon(
                    message.readStatus == MessageReadStatus.read ? Icons.done_all : Icons.done,
                    size: 14,
                    color: message.readStatus == MessageReadStatus.read ? AppColors.readCheckmark : AppColors.sentCheckmark,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(int ms) {
    final d = DateTime.fromMillisecondsSinceEpoch(ms);
    final h = d.hour > 12 ? d.hour - 12 : (d.hour == 0 ? 12 : d.hour);
    final am = d.hour < 12;
    final m = d.minute.toString().padLeft(2, '0');
    return '$h:$m ${am ? 'AM' : 'PM'}';
  }
}
