import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../bloc/chat_list_event.dart';

/// Pill-shaped segmented control floating above the chat list.
/// Container: white bg, 44px height, 22px radius, 4px padding, shadow.
class ChatListTabs extends StatelessWidget {
  const ChatListTabs({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  final ChatListTab selectedTab;
  final ValueChanged<ChatListTab> onTabSelected;

  static const double _height = 44;
  static const double _radius = 22;
  static const double _padding = 4;
  static const double _horizontalMargin = 16;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _horizontalMargin),
      child: Container(
        height: _height,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(_radius),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(_padding),
        child: Row(
          children: [
            Expanded(
              child: _Segment(
                label: 'Chats',
                isSelected: selectedTab == ChatListTab.chats,
                onTap: () => onTabSelected(ChatListTab.chats),
              ),
            ),
            Expanded(
              child: _Segment(
                label: 'Groups',
                isSelected: selectedTab == ChatListTab.groups,
                onTap: () => onTabSelected(ChatListTab.groups),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
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
      behavior: HitTestBehavior.opaque,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryMidGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.cardBackground : AppColors.tabUnselectedText,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
