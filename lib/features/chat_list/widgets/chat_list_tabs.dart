import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../bloc/chat_list_event.dart';

class ChatListTabs extends StatelessWidget {
  const ChatListTabs({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  final ChatListTab selectedTab;
  final ValueChanged<ChatListTab> onTabSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _TabChip(
            label: 'Chats',
            isSelected: selectedTab == ChatListTab.chats,
            onTap: () => onTabSelected(ChatListTab.chats),
          ),
          const SizedBox(width: 8),
          _TabChip(
            label: 'Groups',
            isSelected: selectedTab == ChatListTab.groups,
            onTap: () => onTabSelected(ChatListTab.groups),
          ),
        ],
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  const _TabChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.tabSelected : AppColors.tabUnselected,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.tabUnselectedText,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
