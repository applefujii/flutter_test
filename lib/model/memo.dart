import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';


/*
 Memoのモデル + データベース操作
 */
class Memo {

  final int? id;
  final String title;
  final String text;

  Memo({this.id, required this.title, required this.text});
  Memo.clone(Memo obj): this(id:obj.id, title: obj.title, text: obj.text);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'text': text,
    };
  }


  /////////////////////// 以下静的関数でデータベース操作を定義 ////////////////////////////////////////////////

  /*
    ゲッター。データベースに接続（なければテーブル作成）して戻す。
   */
  static Future<Database> get database async {
    //-- 関数。テーブルの作成
    FutureOr onCreate(db, value) async {
      db.execute('''
        CREATE TABLE memo(id INTEGER PRIMARY KEY, title TEXT, text TEXT)
      ''');
    }

    Database? _database = null;

    //-- PCの場合
    if (Platform.isLinux || Platform.isWindows) {
      String path = join(Directory.current.path, 'data', 'memo_database.db');
      var databaseFactory = databaseFactoryFfi;
      final options = OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) => onCreate(db, version),
      );
      print(path);
      _database = await databaseFactory.openDatabase(path, options: options);
    }
    //-- スマホの場合
    else {
      String dir = (await getApplicationDocumentsDirectory()).path;
      _database = await openDatabase(
        //join(await getDatabasesPath(), 'memo_database.db'),
        join(dir, 'memo_database.db'),
        onCreate: (db, version) {
          return db.execute(
            "CREATE TABLE memo(id INTEGER PRIMARY KEY, title TEXT, text TEXT)",
          );
        },
        version: 1,
      );
    }
    return _database;
  }

  /*
    メモを1件追加
   */
  static Future<void> insertMemo(Memo memo) async {
    final Database db = await database;
    await db.insert(
      'memo',
      memo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /*
    メモを全件取得
   */
  static Future<List<Memo>> getMemos() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('memo');
    return List.generate(maps.length, (i) {
      return Memo(
        id: maps[i]['id'],
        title: maps[i]['title'],
        text: maps[i]['text'],
      );
    });
  }

  /*
    メモを1件取得
   */
  static Future<Memo> getMemo(int id) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('memo', where: "id = ?", whereArgs: [id]);
    return Memo(
      id: maps[0]['id'],
      title: maps[0]['title'],
      text: maps[0]['text'],
    );
  }

  /*
    メモの更新
   */
  static Future<void> updateMemo(Memo memo) async {
    final db = await database;
    await db.update(
      'memo',
      memo.toMap(),
      where: "id = ?",
      whereArgs: [memo.id],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  /*
    メモを1件削除
   */
  static Future<void> deleteMemo(int id) async {
    final db = await database;
    await db.delete(
      'memo',
      where: "id = ?",
      whereArgs: [id],
    );
  }

}
