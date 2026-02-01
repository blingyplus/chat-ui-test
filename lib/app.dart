import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'features/chat_list/screens/chat_list_screen.dart';
import 'repository/chat_repository.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<ChatRepository>(
      create: (_) => ChatRepository(),
      child: MaterialApp(
        title: 'WhatsApp-like Chat',
        theme: AppTheme.light,
        home: const ChatListScreen(),
      ),
    );
  }
}
