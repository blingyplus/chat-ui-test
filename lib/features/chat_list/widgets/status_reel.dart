import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../domain/models/contact.dart';

class StatusReel extends StatelessWidget {
  const StatusReel({
    super.key,
    required this.contacts,
    this.onAddTap,
  });

  final List<Contact> contacts;
  final VoidCallback? onAddTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        children: [
          _AddCircle(onTap: onAddTap),
          ...contacts.take(8).map((c) => _ContactCircle(contact: c)),
        ],
      ),
    );
  }
}

class _AddCircle extends StatelessWidget {
  const _AddCircle({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.contactBorderGreen, width: 2, strokeAlign: BorderSide.strokeAlignInside),
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            ),
          ),
          const SizedBox(height: 6),
          const Text('Add', style: TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }
}

class _ContactCircle extends StatelessWidget {
  const _ContactCircle({required this.contact});

  final Contact contact;

  @override
  Widget build(BuildContext context) {
    final name = contact.name.length > 8 ? '${contact.name.substring(0, 8)}...' : contact.name;
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.contactBorderGreen, width: 2),
              color: Colors.grey.shade300,
            ),
            child: Center(
              child: Text(
                contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black54),
              ),
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 56,
            child: Text(
              name,
              style: const TextStyle(color: Colors.white, fontSize: 12),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
