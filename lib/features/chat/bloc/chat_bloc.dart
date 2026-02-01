import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repository/chat_repository.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc(this._repository, int chatId) : super(ChatState(chatId: chatId)) {
    on<ChatMessagesLoadRequested>(_onLoadRequested);
    on<ChatMessageSent>(_onMessageSent);
    on<ChatSimulateReceived>(_onSimulateReceived);
  }

  final ChatRepository _repository;

  Future<void> _onLoadRequested(ChatMessagesLoadRequested event, Emitter<ChatState> emit) async {
    if (event.chatId != state.chatId) return;
    emit(state.copyWith(status: ChatStatus.loading));
    try {
      final messages = await _repository.getMessages(state.chatId);
      emit(state.copyWith(messages: messages, status: ChatStatus.loaded, errorMessage: null));
    } catch (e) {
      emit(state.copyWith(status: ChatStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> _onMessageSent(ChatMessageSent event, Emitter<ChatState> emit) async {
    if (event.chatId != state.chatId) return;
    try {
      await _repository.sendMessage(event.chatId, event.content);
      final messages = await _repository.getMessages(state.chatId);
      emit(state.copyWith(messages: messages, status: ChatStatus.loaded, errorMessage: null));
    } catch (e) {
      emit(state.copyWith(status: ChatStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> _onSimulateReceived(ChatSimulateReceived event, Emitter<ChatState> emit) async {
    if (event.chatId != state.chatId) return;
    try {
      await _repository.simulateReceiveMessage(event.chatId, event.content);
      final messages = await _repository.getMessages(state.chatId);
      emit(state.copyWith(messages: messages, status: ChatStatus.loaded, errorMessage: null));
    } catch (e) {
      emit(state.copyWith(status: ChatStatus.error, errorMessage: e.toString()));
    }
  }
}
