import 'package:equatable/equatable.dart';

abstract final class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

final class ChatMessagesLoadRequested extends ChatEvent {
  const ChatMessagesLoadRequested(this.chatId);

  final int chatId;

  @override
  List<Object?> get props => [chatId];
}

final class ChatMessageSent extends ChatEvent {
  const ChatMessageSent({required this.chatId, required this.content});

  final int chatId;
  final String content;

  @override
  List<Object?> get props => [chatId, content];
}

final class ChatSimulateReceived extends ChatEvent {
  const ChatSimulateReceived({required this.chatId, required this.content});

  final int chatId;
  final String content;

  @override
  List<Object?> get props => [chatId, content];
}
