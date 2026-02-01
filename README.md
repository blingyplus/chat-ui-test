# WhatsApp-like Chat UI

A Flutter app that replicates a WhatsApp-style chat list and conversation screen. All data is stored locally using SQLite; there is no backend or network.

## Tech stack

- **Flutter** – UI
- **SQLite** (sqflite) – local database for contacts, chats, and messages
- **flutter_bloc** – state management for the chat list and chat screens

## Features

- **Chat list**: Header, status/contact reel, Chats/Groups tabs, list of chats with avatar, name, last message, timestamp, and unread badge or checkmarks.
- **Chat screen**: Conversation view with sent/received message bubbles, text input, send button, and optional “Simulate receive” for demo.

## How to run

```bash
flutter pub get
flutter run
```

Run on an Android or iOS device/emulator (SQLite is used; web/desktop may require additional setup).

## Project structure

- `lib/core` – theme and constants
- `lib/data/database` – SQLite helper and schema
- `lib/domain/models` – Contact, Chat, Message (equatable)
- `lib/repository` – ChatRepository (single source of truth)
- `lib/features/chat_list` – ChatListBloc, screen, widgets
- `lib/features/chat` – ChatBloc, ChatScreen, message widgets
