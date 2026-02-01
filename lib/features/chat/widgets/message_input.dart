import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class MessageInput extends StatelessWidget {
  const MessageInput({
    super.key,
    required this.onSend,
    this.hintText = 'Type a message',
  });

  final ValueChanged<String> onSend;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return _MessageInputStateful(
      onSend: onSend,
      hintText: hintText,
    );
  }
}

class _MessageInputStateful extends StatefulWidget {
  const _MessageInputStateful({
    required this.onSend,
    required this.hintText,
  });

  final ValueChanged<String> onSend;
  final String hintText;

  @override
  State<_MessageInputStateful> createState() => _MessageInputStatefulState();
}

class _MessageInputStatefulState extends State<_MessageInputStateful> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: (_) => _submit(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: _submit,
              icon: const Icon(Icons.send_rounded),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
