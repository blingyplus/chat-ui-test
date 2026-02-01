import 'package:equatable/equatable.dart';

import '../../../domain/models/message.dart';

enum ChatStatus { initial, loading, loaded, error }

final class ChatState extends Equatable {
  const ChatState({
    required this.chatId,
    this.messages = const [],
    this.status = ChatStatus.initial,
    this.errorMessage,
  });

  final int chatId;
  final List<Message> messages;
  final ChatStatus status;
  final String? errorMessage;

  @override
  List<Object?> get props => [chatId, messages, status, errorMessage];

  ChatState copyWith({
    int? chatId,
    List<Message>? messages,
    ChatStatus? status,
    String? errorMessage,
  }) {
    return ChatState(
      chatId: chatId ?? this.chatId,
      messages: messages ?? this.messages,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}
