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

  static const double _avatarSize = 48;
  static const double _avatarBorderWidth = 2;
  static const double _unreadBadgeSize = 20;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        width: _avatarSize,
        height: _avatarSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.contactBorderGreen, width: _avatarBorderWidth),
          color: Colors.grey.shade300,
        ),
        child: ClipOval(
          child: Center(
            child: Text(
              chat.contact.name.isNotEmpty ? chat.contact.name[0].toUpperCase() : '?',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black54),
            ),
          ),
        ),
      ),
      title: Text(
        chat.contact.name,
        style: const TextStyle(
          color: AppColors.chatName,
          fontWeight: FontWeight.w600,
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
                width: _unreadBadgeSize,
                height: _unreadBadgeSize,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.unreadBadgeGreen,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${chat.unreadCount}',
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
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
