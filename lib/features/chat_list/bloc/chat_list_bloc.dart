import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repository/chat_repository.dart';
import 'chat_list_event.dart';
import 'chat_list_state.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  ChatListBloc(this._repository) : super(const ChatListState()) {
    on<ChatListLoadRequested>(_onLoadRequested);
    on<ChatListTabChanged>(_onTabChanged);
    on<ChatListMarkChatRead>(_onMarkChatRead);
  }

  final ChatRepository _repository;

  Future<void> _onLoadRequested(ChatListLoadRequested event, Emitter<ChatListState> emit) async {
    emit(state.copyWith(status: ChatListStatus.loading));
    try {
      final chats = await _repository.getChats();
      emit(state.copyWith(chats: chats, status: ChatListStatus.loaded, errorMessage: null));
    } catch (e) {
      emit(state.copyWith(
        status: ChatListStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onTabChanged(ChatListTabChanged event, Emitter<ChatListState> emit) {
    emit(state.copyWith(selectedTab: event.tab));
  }

  Future<void> _onMarkChatRead(ChatListMarkChatRead event, Emitter<ChatListState> emit) async {
    await _repository.markChatRead(event.chatId);
    add(const ChatListLoadRequested());
  }
}
