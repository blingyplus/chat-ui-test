import 'package:equatable/equatable.dart';

enum MessageReadStatus { sent, delivered, read }

class Message extends Equatable {
  const Message({
    required this.id,
    required this.chatId,
    required this.content,
    required this.isFromMe,
    required this.createdAt,
    this.readStatus = MessageReadStatus.sent,
  });

  final int id;
  final int chatId;
  final String content;
  final bool isFromMe;
  final int createdAt;
  final MessageReadStatus readStatus;

  @override
  List<Object?> get props => [id, chatId, content, isFromMe, createdAt, readStatus];
}
