import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../domain/models/chat.dart';

class ChatListItem extends StatelessWidget {
  const ChatListItem({
    super.key,
    required this.chat,
    required this.onTap,
  });

  final Chat chat;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        radius: 28,
        backgroundColor: Colors.grey.shade300,
        child: Text(
          chat.contact.name.isNotEmpty ? chat.contact.name[0].toUpperCase() : '?',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black54),
        ),
      ),
      title: Text(
        chat.contact.name,
        style: const TextStyle(
          color: AppColors.chatName,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        chat.lastMessagePreview ?? '',
        style: const TextStyle(
          color: AppColors.lastMessage,
          fontSize: 14,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: SizedBox(
        width: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _formatDate(chat.lastMessageAt),
              style: const TextStyle(color: AppColors.timestamp, fontSize: 12),
            ),
            const SizedBox(height: 4),
            if (chat.unreadCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: const BoxDecoration(
                  color: AppColors.unreadBadgeGreen,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Text(
                  '${chat.unreadCount}',
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              )
            else
              _CheckmarkIcon(read: chat.unreadCount == 0 && (chat.lastMessagePreview?.isNotEmpty ?? false)),
          ],
        ),
      ),
    );
  }

  String _formatDate(int? ms) {
    if (ms == null) return '';
    final d = DateTime.fromMillisecondsSinceEpoch(ms);
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[d.month - 1]} ${d.day}';
  }
}

class _CheckmarkIcon extends StatelessWidget {
  const _CheckmarkIcon({required this.read});

  final bool read;

  @override
  Widget build(BuildContext context) {
    if (read) {
      return const Icon(Icons.done_all, size: 18, color: AppColors.readCheckmark);
    }
    return const Icon(Icons.done, size: 18, color: AppColors.sentCheckmark);
  }
}
