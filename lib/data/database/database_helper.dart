import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'database_constants.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _init();
    return _db!;
  }

  Future<Database> _init() async {
    final dbPath = await getDatabasesPath();
    final pathToDb = join(dbPath, DatabaseConstants.dbName);
    return openDatabase(
      pathToDb,
      version: DatabaseConstants.dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${DatabaseConstants.tableContacts} (
        ${DatabaseConstants.columnContactId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DatabaseConstants.columnContactName} TEXT NOT NULL,
        ${DatabaseConstants.columnAvatarAsset} TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE ${DatabaseConstants.tableChats} (
        ${DatabaseConstants.columnChatId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DatabaseConstants.columnChatContactId} INTEGER NOT NULL,
        ${DatabaseConstants.columnLastMessagePreview} TEXT,
        ${DatabaseConstants.columnLastMessageAt} INTEGER,
        ${DatabaseConstants.columnUnreadCount} INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (${DatabaseConstants.columnChatContactId}) REFERENCES ${DatabaseConstants.tableContacts}(${DatabaseConstants.columnContactId})
      )
    ''');
    await db.execute('''
      CREATE TABLE ${DatabaseConstants.tableMessages} (
        ${DatabaseConstants.columnMessageId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DatabaseConstants.columnMessageChatId} INTEGER NOT NULL,
        ${DatabaseConstants.columnContent} TEXT NOT NULL,
        ${DatabaseConstants.columnIsFromMe} INTEGER NOT NULL,
        ${DatabaseConstants.columnCreatedAt} INTEGER NOT NULL,
        ${DatabaseConstants.columnRead} INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (${DatabaseConstants.columnMessageChatId}) REFERENCES ${DatabaseConstants.tableChats}(${DatabaseConstants.columnChatId})
      )
    ''');
    await _seed(db);
  }

  Future<void> _seed(Database db) async {
    final contactRows = await db.query(DatabaseConstants.tableContacts);
    if (contactRows.isNotEmpty) return;

    await db.insert(DatabaseConstants.tableContacts, {
      DatabaseConstants.columnContactName: 'John Doe',
      DatabaseConstants.columnAvatarAsset: null,
    });
    await db.insert(DatabaseConstants.tableContacts, {
      DatabaseConstants.columnContactName: 'Michal',
      DatabaseConstants.columnAvatarAsset: null,
    });
    await db.insert(DatabaseConstants.tableContacts, {
      DatabaseConstants.columnContactName: 'My Love',
      DatabaseConstants.columnAvatarAsset: null,
    });
    await db.insert(DatabaseConstants.tableContacts, {
      DatabaseConstants.columnContactName: 'Shamus',
      DatabaseConstants.columnAvatarAsset: null,
    });
    await db.insert(DatabaseConstants.tableContacts, {
      DatabaseConstants.columnContactName: 'Aliesa sham',
      DatabaseConstants.columnAvatarAsset: null,
    });
    await db.insert(DatabaseConstants.tableContacts, {
      DatabaseConstants.columnContactName: 'Klerence',
      DatabaseConstants.columnAvatarAsset: null,
    });

    final now = DateTime.now();
    final oct2 = DateTime(now.year, 10, 2).millisecondsSinceEpoch;

    for (var i = 1; i <= 6; i++) {
      await db.insert(DatabaseConstants.tableChats, {
        DatabaseConstants.columnChatContactId: i,
        DatabaseConstants.columnLastMessagePreview: _lastMessageForContact(i),
        DatabaseConstants.columnLastMessageAt: oct2,
        DatabaseConstants.columnUnreadCount: _unreadForContact(i),
      });
    }

    await _seedMessages(db);
  }

  String _lastMessageForContact(int contactId) {
    switch (contactId) {
      case 1:
        return 'Hi how are you?';
      case 2:
        return 'I am going out bro';
      case 3:
        return 'What are you doing';
      case 4:
      case 5:
        return 'Hi how are you?';
      default:
        return 'Hi';
    }
  }

  int _unreadForContact(int contactId) {
    switch (contactId) {
      case 1:
        return 2;
      case 2:
        return 5;
      default:
        return 0;
    }
  }

  Future<void> _seedMessages(Database db) async {
    final messages = [
      (1, 'Hi how are you?', 0, 2),
      (1, 'I am good, thanks!', 1, 2),
      (2, 'I am going out bro', 0, 2),
      (3, 'What are you doing', 0, 2),
      (4, 'Hi how are you?', 1, 0),
      (5, 'Hi how are you?', 1, 0),
    ];
    final oct2 = DateTime(DateTime.now().year, 10, 2).millisecondsSinceEpoch;
    for (final m in messages) {
      await db.insert(DatabaseConstants.tableMessages, {
        DatabaseConstants.columnMessageChatId: m.$1,
        DatabaseConstants.columnContent: m.$2,
        DatabaseConstants.columnIsFromMe: m.$3,
        DatabaseConstants.columnCreatedAt: oct2,
        DatabaseConstants.columnRead: m.$4,
      });
    }
  }

  Future<List<Map<String, dynamic>>> getChatsWithContacts() async {
    final db = await database;
    final chats = await db.query(
      DatabaseConstants.tableChats,
      orderBy: '${DatabaseConstants.columnLastMessageAt} DESC',
    );
    final result = <Map<String, dynamic>>[];
    for (final chat in chats) {
      final contactRows = await db.query(
        DatabaseConstants.tableContacts,
        where: '${DatabaseConstants.columnContactId} = ?',
        whereArgs: [chat[DatabaseConstants.columnChatContactId]],
      );
      if (contactRows.isNotEmpty) {
        result.add({...chat, 'contact': contactRows.first});
      }
    }
    return result;
  }

  Future<List<Map<String, dynamic>>> getContacts() async {
    final db = await database;
    return db.query(DatabaseConstants.tableContacts);
  }

  Future<List<Map<String, dynamic>>> getMessagesForChat(int chatId) async {
    final db = await database;
    return db.query(
      DatabaseConstants.tableMessages,
      where: '${DatabaseConstants.columnMessageChatId} = ?',
      whereArgs: [chatId],
      orderBy: '${DatabaseConstants.columnCreatedAt} ASC',
    );
  }

  Future<Map<String, dynamic>?> getChatWithContact(int chatId) async {
    final db = await database;
    final chatRows = await db.query(
      DatabaseConstants.tableChats,
      where: '${DatabaseConstants.columnChatId} = ?',
      whereArgs: [chatId],
    );
    if (chatRows.isEmpty) return null;
    final chat = chatRows.first;
    final contactId = chat[DatabaseConstants.columnChatContactId] as int;
    final contactRows = await db.query(
      DatabaseConstants.tableContacts,
      where: '${DatabaseConstants.columnContactId} = ?',
      whereArgs: [contactId],
    );
    if (contactRows.isEmpty) return null;
    return {...chat, 'contact': contactRows.first};
  }

  Future<int> insertMessage({
    required int chatId,
    required String content,
    required bool isFromMe,
  }) async {
    final db = await database;
    final now = DateTime.now().millisecondsSinceEpoch;
    final read = isFromMe ? 0 : 2;
    await db.insert(DatabaseConstants.tableMessages, {
      DatabaseConstants.columnMessageChatId: chatId,
      DatabaseConstants.columnContent: content,
      DatabaseConstants.columnIsFromMe: isFromMe ? 1 : 0,
      DatabaseConstants.columnCreatedAt: now,
      DatabaseConstants.columnRead: read,
    });
    final preview = content.length > 50 ? '${content.substring(0, 50)}...' : content;
    if (isFromMe) {
      await db.update(
        DatabaseConstants.tableChats,
        {
          DatabaseConstants.columnLastMessagePreview: preview,
          DatabaseConstants.columnLastMessageAt: now,
          DatabaseConstants.columnUnreadCount: 0,
        },
        where: '${DatabaseConstants.columnChatId} = ?',
        whereArgs: [chatId],
      );
    } else {
      final rows = await db.query(
        DatabaseConstants.tableChats,
        columns: [DatabaseConstants.columnUnreadCount],
        where: '${DatabaseConstants.columnChatId} = ?',
        whereArgs: [chatId],
      );
      final current = rows.isNotEmpty ? (rows.first[DatabaseConstants.columnUnreadCount] as int? ?? 0) : 0;
      await db.update(
        DatabaseConstants.tableChats,
        {
          DatabaseConstants.columnLastMessagePreview: preview,
          DatabaseConstants.columnLastMessageAt: now,
          DatabaseConstants.columnUnreadCount: current + 1,
        },
        where: '${DatabaseConstants.columnChatId} = ?',
        whereArgs: [chatId],
      );
    }
    final idRows = await db.rawQuery('SELECT last_insert_rowid() as id');
    return idRows.first['id'] as int;
  }

  Future<void> markChatRead(int chatId) async {
    final db = await database;
    await db.update(
      DatabaseConstants.tableChats,
      {DatabaseConstants.columnUnreadCount: 0},
      where: '${DatabaseConstants.columnChatId} = ?',
      whereArgs: [chatId],
    );
  }

  Future<void> simulateReceiveMessage(int chatId, String content) async {
    await insertMessage(chatId: chatId, content: content, isFromMe: false);
  }
}
