import 'package:equatable/equatable.dart';

import '../../../domain/models/chat.dart';
import 'chat_list_event.dart';

enum ChatListStatus { initial, loading, loaded, error }

final class ChatListState extends Equatable {
  const ChatListState({
    this.chats = const [],
    this.selectedTab = ChatListTab.chats,
    this.status = ChatListStatus.initial,
    this.errorMessage,
  });

  final List<Chat> chats;
  final ChatListTab selectedTab;
  final ChatListStatus status;
  final String? errorMessage;

  @override
  List<Object?> get props => [chats, selectedTab, status, errorMessage];

  ChatListState copyWith({
    List<Chat>? chats,
    ChatListTab? selectedTab,
    ChatListStatus? status,
    String? errorMessage,
  }) {
    return ChatListState(
      chats: chats ?? this.chats,
      selectedTab: selectedTab ?? this.selectedTab,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}
