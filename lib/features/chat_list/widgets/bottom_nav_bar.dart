import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class ChatBottomNavBar extends StatelessWidget {
  const ChatBottomNavBar({
    super.key,
    this.onHomeTap,
    this.onCallsTap,
    this.onNewChatTap,
    this.onCameraTap,
    this.onProfileTap,
  });

  final VoidCallback? onHomeTap;
  final VoidCallback? onCallsTap;
  final VoidCallback? onNewChatTap;
  final VoidCallback? onCameraTap;
  final VoidCallback? onProfileTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: const BoxDecoration(
        color: AppColors.primaryGreen,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavIcon(icon: Icons.home_rounded, onTap: onHomeTap),
            _NavIcon(icon: Icons.phone_rounded, onTap: onCallsTap),
            _NewChatButton(onTap: onNewChatTap),
            _NavIcon(icon: Icons.camera_alt_rounded, onTap: onCameraTap),
            _NavIcon(icon: Icons.person_rounded, onTap: onProfileTap),
          ],
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  const _NavIcon({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white, size: 26),
    );
  }
}

class _NewChatButton extends StatelessWidget {
  const _NewChatButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}
