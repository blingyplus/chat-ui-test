abstract final class DatabaseConstants {
  static const String dbName = 'chat_app.db';
  static const int dbVersion = 1;

  static const String tableContacts = 'contacts';
  static const String columnContactId = 'id';
  static const String columnContactName = 'name';
  static const String columnAvatarAsset = 'avatar_asset';

  static const String tableChats = 'chats';
  static const String columnChatId = 'id';
  static const String columnChatContactId = 'contact_id';
  static const String columnLastMessagePreview = 'last_message_preview';
  static const String columnLastMessageAt = 'last_message_at';
  static const String columnUnreadCount = 'unread_count';

  static const String tableMessages = 'messages';
  static const String columnMessageId = 'id';
  static const String columnMessageChatId = 'chat_id';
  static const String columnContent = 'content';
  static const String columnIsFromMe = 'is_from_me';
  static const String columnCreatedAt = 'created_at';
  static const String columnRead = 'read';
}
