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

  static const double dockHeight = 64;
  static const double dockRadius = 32;
  static const double dockMargin = 16;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: dockHeight,
      decoration: BoxDecoration(
        color: AppColors.primaryDarkGreen,
        borderRadius: BorderRadius.circular(dockRadius),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _NavIcon(icon: Icons.home_rounded, active: true, onTap: onHomeTap),
          _NavIcon(icon: Icons.phone_rounded, active: false, onTap: onCallsTap),
          _CenterFab(onTap: onNewChatTap),
          _NavIcon(icon: Icons.camera_alt_rounded, active: false, onTap: onCameraTap),
          _NavIcon(icon: Icons.person_rounded, active: false, onTap: onProfileTap),
        ],
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  const _NavIcon({required this.icon, required this.active, this.onTap});

  final IconData icon;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(
        icon,
        color: active ? AppColors.cardBackground : AppColors.bottomNavInactive,
        size: 26,
      ),
    );
  }
}

class _CenterFab extends StatelessWidget {
  const _CenterFab({this.onTap});

  final VoidCallback? onTap;

  static const double _size = 48;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: _size,
          height: _size,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.add, color: AppColors.primaryDarkGreen, size: 26),
        ),
      ),
    );
  }
}
