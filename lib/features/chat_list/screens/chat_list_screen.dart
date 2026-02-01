import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../domain/models/chat.dart';
import '../../../repository/chat_repository.dart';
import '../../chat/screens/chat_screen.dart';
import '../bloc/chat_list_bloc.dart';
import '../bloc/chat_list_event.dart';
import '../bloc/chat_list_state.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/chat_list_item.dart';
import '../widgets/chat_list_tabs.dart';
import '../widgets/status_reel.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatListBloc(context.read<ChatRepository>())
        ..add(const ChatListLoadRequested()),
      child: const _ChatListView(),
    );
  }
}

class _ChatListView extends StatelessWidget {
  const _ChatListView();

  static const double _headerHeight = 56;
  static const double _headerPaddingHorizontal = 16;
  static const double _cardTopRadius = 28;
  static const double _cardPaddingTop = 16;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildBackground(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                BlocBuilder<ChatListBloc, ChatListState>(
                  buildWhen: (a, b) => a.chats != b.chats,
                  builder: (context, state) {
                    final contacts = state.chats.map((c) => c.contact).toList();
                    return StatusReel(contacts: contacts);
                  },
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(_cardTopRadius)),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(_cardTopRadius)),
                      child: Column(
                        children: [
                          const SizedBox(height: _cardPaddingTop),
                          BlocBuilder<ChatListBloc, ChatListState>(
                            buildWhen: (a, b) => a.selectedTab != b.selectedTab,
                            builder: (context, state) {
                              return ChatListTabs(
                                selectedTab: state.selectedTab,
                                onTabSelected: (tab) =>
                                    context.read<ChatListBloc>().add(ChatListTabChanged(tab: tab)),
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: BlocBuilder<ChatListBloc, ChatListState>(
                              buildWhen: (a, b) => a.chats != b.chats || a.status != b.status,
                              builder: (context, state) {
                                if (state.status == ChatListStatus.loading && state.chats.isEmpty) {
                                  return const Center(child: CircularProgressIndicator());
                                }
                                if (state.status == ChatListStatus.error && state.chats.isEmpty) {
                                  return Center(child: Text(state.errorMessage ?? 'Error'));
                                }
                                final chats = state.selectedTab == ChatListTab.groups ? <Chat>[] : state.chats;
                                if (chats.isEmpty) {
                                  return const Center(child: Text('No chats'));
                                }
                                return ListView.builder(
                                  padding: const EdgeInsets.only(
                                    bottom: ChatBottomNavBar.dockHeight + ChatBottomNavBar.dockMargin,
                                  ),
                                  itemCount: chats.length,
                                  itemBuilder: (context, index) {
                                    final chat = chats[index];
                                    return ChatListItem(
                                      chat: chat,
                                      onTap: () => _openChat(context, chat),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Positioned(
              left: ChatBottomNavBar.dockMargin,
              right: ChatBottomNavBar.dockMargin,
              bottom: ChatBottomNavBar.dockMargin,
              child: ChatBottomNavBar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primaryDarkGreen,
            AppColors.gradientMiddle,
            AppColors.nearBlack,
          ],
          stops: [0.0, 0.55, 1.0],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: _headerHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: _headerPaddingHorizontal),
        child: const Row(
          children: [
            Icon(Icons.chat_bubble, size: 28, color: AppColors.cardBackground),
            SizedBox(width: 8),
            Text(
              'Whatsapp',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.cardBackground,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openChat(BuildContext context, Chat chat) {
    context.read<ChatListBloc>().add(ChatListMarkChatRead(chatId: chat.id));
    Navigator.of(context)
        .push(
          MaterialPageRoute<void>(
            builder: (context) => ChatScreen(chatId: chat.id, contactName: chat.contact.name),
          ),
        )
        .then((_) {
          if (context.mounted) {
            context.read<ChatListBloc>().add(const ChatListLoadRequested());
          }
        });
  }
}
