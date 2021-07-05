import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:schejo/model/daily_memo.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const String TABLE_MEMO = "daily_memo";
  static const String COLUMN_ID = "id";
  static const String COLUMN_DATE = "date";
  static const String COLUMN_CONTENT = "content";

  static final DateFormat dailyMemoDateFormat = DateFormat('yyyy-MM-dd');

  DatabaseHelper._(); // Private constructor
  static final DatabaseHelper db = DatabaseHelper._();
  static Database? _database;

  Future<Database> get database async {
    return _database ??= await _initiateDatabase();
  }

  Future<Database> _initiateDatabase() async {
    String path = await getDatabasesPath();
    return await openDatabase(join(path, 'schejo.db'), version: 1,
        onCreate: (Database database, int version) async {
      database.execute('CREATE TABLE $TABLE_MEMO ('
          '$COLUMN_ID INTEGER PRIMARY KEY,'
          '$COLUMN_DATE TEXT,'
          '$COLUMN_CONTENT TEXT)');
    });
  }

  Future<List<DailyMemo>> getDailyMemoList() async {
    final db = await database;
    var dailyMemoMap = await db
        .query(TABLE_MEMO, columns: [COLUMN_ID, COLUMN_DATE, COLUMN_CONTENT]);
    List<DailyMemo> dailyMemoList = <DailyMemo>[];
    dailyMemoMap.forEach((element) {
      dailyMemoList.add(DailyMemo.fromMap(element));
    });
    return dailyMemoList;
  }

  /// Returns the id of the last inserted row.
  Future<int> insertDailyMemo(DailyMemo memo) async {
    Map<String, dynamic> mappedMemo = memo.toMap();
    final db = await database;
    return await db.insert(TABLE_MEMO, mappedMemo);
  }

  /// Returns the number of changes made.
  Future<int> updateDailyMemo(DailyMemo memo) async {
    Map<String, dynamic> mappedMemo = memo.toMap();
    final db = await database;
    return await db.update(TABLE_MEMO, mappedMemo,
        where: '$COLUMN_ID = ?', whereArgs: [memo.id]);
  }

  /// Returns the number of rows affected.
  Future<int> deleteDailyMemo(int id) async {
    final db = await database;
    return await db
        .delete(TABLE_MEMO, where: '$COLUMN_ID = ?', whereArgs: [id]);
  }
}
