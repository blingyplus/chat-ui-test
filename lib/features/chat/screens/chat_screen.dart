import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../repository/chat_repository.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_input.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({
    super.key,
    required this.chatId,
    required this.contactName,
  });

  final int chatId;
  final String contactName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ChatBloc(context.read<ChatRepository>(), chatId)
            ..add(ChatMessagesLoadRequested(chatId)),
      child: _ChatView(chatId: chatId, contactName: contactName),
    );
  }
}

class _ChatView extends StatefulWidget {
  const _ChatView({required this.chatId, required this.contactName});

  final int chatId;
  final String contactName;

  @override
  State<_ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<_ChatView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey.shade300,
              child: Text(
                widget.contactName.isNotEmpty
                    ? widget.contactName[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.contactName,
                style: const TextStyle(fontSize: 18),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: AppColors.listBackground,
              child: BlocBuilder<ChatBloc, ChatState>(
                buildWhen: (a, b) =>
                    a.messages != b.messages || a.status != b.status,
                builder: (context, state) {
                  if (state.status == ChatStatus.loading &&
                      state.messages.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.status == ChatStatus.error &&
                      state.messages.isEmpty) {
                    return Center(child: Text(state.errorMessage ?? 'Error'));
                  }
                  if (state.messages.isEmpty) {
                    return const Center(child: Text('No messages yet'));
                  }
                  return ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.messages[state.messages.length - 1 - index];
                      return MessageBubble(message: message);
                    },
                  );
                },
              ),
            ),
          ),
          MessageInput(
            onSend: (text) => context.read<ChatBloc>().add(
              ChatMessageSent(chatId: widget.chatId, content: text),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: TextButton.icon(
                onPressed: () {
                  context.read<ChatBloc>().add(
                    ChatSimulateReceived(
                      chatId: widget.chatId,
                      content: 'Simulated reply',
                    ),
                  );
                },
                icon: const Icon(Icons.reply, size: 18),
                label: const Text('Simulate receive'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
