import 'package:equatable/equatable.dart';

import 'contact.dart';

class Chat extends Equatable {
  const Chat({
    required this.id,
    required this.contact,
    this.lastMessagePreview,
    this.lastMessageAt,
    this.unreadCount = 0,
  });

  final int id;
  final Contact contact;
  final String? lastMessagePreview;
  final int? lastMessageAt;
  final int unreadCount;

  @override
  List<Object?> get props => [id, contact, lastMessagePreview, lastMessageAt, unreadCount];
}
