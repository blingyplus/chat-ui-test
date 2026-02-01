import '../data/database/database_constants.dart';
import '../data/database/database_helper.dart';
import '../domain/models/chat.dart';
import '../domain/models/contact.dart';
import '../domain/models/message.dart';

class ChatRepository {
  ChatRepository({DatabaseHelper? db}) : _db = db ?? DatabaseHelper.instance;

  final DatabaseHelper _db;

  Future<List<Chat>> getChats() async {
    final rows = await _db.getChatsWithContacts();
    return rows.map(_chatFromRow).toList();
  }

  Future<List<Contact>> getContacts() async {
    final rows = await _db.getContacts();
    return rows.map(_contactFromRow).toList();
  }

  Future<Chat?> getChat(int chatId) async {
    final row = await _db.getChatWithContact(chatId);
    return row != null ? _chatFromRow(row) : null;
  }

  Future<List<Message>> getMessages(int chatId) async {
    final rows = await _db.getMessagesForChat(chatId);
    return rows.map((r) => _messageFromRow(r, chatId)).toList();
  }

  Future<void> sendMessage(int chatId, String content) async {
    if (content.trim().isEmpty) return;
    await _db.insertMessage(chatId: chatId, content: content.trim(), isFromMe: true);
  }

  Future<void> markChatRead(int chatId) async {
    await _db.markChatRead(chatId);
  }

  Future<void> simulateReceiveMessage(int chatId, String content) async {
    if (content.trim().isEmpty) return;
    await _db.simulateReceiveMessage(chatId, content.trim());
  }

  Chat _chatFromRow(Map<String, dynamic> row) {
    final contactMap = row['contact'] as Map<String, dynamic>?;
    final contact = contactMap != null ? _contactFromRow(contactMap) : const Contact(id: 0, name: '');
    return Chat(
      id: row[DatabaseConstants.columnChatId] as int,
      contact: contact,
      lastMessagePreview: row[DatabaseConstants.columnLastMessagePreview] as String?,
      lastMessageAt: row[DatabaseConstants.columnLastMessageAt] as int?,
      unreadCount: row[DatabaseConstants.columnUnreadCount] as int? ?? 0,
    );
  }

  Contact _contactFromRow(Map<String, dynamic> row) {
    return Contact(
      id: row[DatabaseConstants.columnContactId] as int,
      name: row[DatabaseConstants.columnContactName] as String,
      avatarAsset: row[DatabaseConstants.columnAvatarAsset] as String?,
    );
  }

  Message _messageFromRow(Map<String, dynamic> row, int chatId) {
    final read = row[DatabaseConstants.columnRead] as int? ?? 0;
    MessageReadStatus status;
    if (read >= 2) {
      status = MessageReadStatus.read;
    } else if (read >= 1) {
      status = MessageReadStatus.delivered;
    } else {
      status = MessageReadStatus.sent;
    }
    return Message(
      id: row[DatabaseConstants.columnMessageId] as int,
      chatId: chatId,
      content: row[DatabaseConstants.columnContent] as String,
      isFromMe: (row[DatabaseConstants.columnIsFromMe] as int) == 1,
      createdAt: row[DatabaseConstants.columnCreatedAt] as int,
      readStatus: status,
    );
  }
}
