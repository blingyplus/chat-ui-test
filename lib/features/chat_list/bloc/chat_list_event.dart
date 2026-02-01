import 'package:equatable/equatable.dart';

abstract final class ChatListEvent extends Equatable {
  const ChatListEvent();

  @override
  List<Object?> get props => [];
}

final class ChatListLoadRequested extends ChatListEvent {
  const ChatListLoadRequested();
}

final class ChatListTabChanged extends ChatListEvent {
  const ChatListTabChanged({required this.tab});

  final ChatListTab tab;

  @override
  List<Object?> get props => [tab];
}

final class ChatListMarkChatRead extends ChatListEvent {
  const ChatListMarkChatRead({required this.chatId});

  final int chatId;

  @override
  List<Object?> get props => [chatId];
}

enum ChatListTab { chats, groups }
