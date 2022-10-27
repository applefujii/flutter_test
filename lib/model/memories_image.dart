import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';



/// MemoriesImageのモデル + データベース操作
/// id
class MemoriesImage {

  final int? id;
  final String fileName;
  final String text;

  MemoriesImage({this.id, required this.fileName, required this.text});
  MemoriesImage.clone(MemoriesImage obj): this(id:obj.id, fileName: obj.fileName, text: obj.text);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fileName': fileName,
      'text': text,
    };
  }


  /////////////////////// 以下静的関数でデータベース操作を定義 ////////////////////////////////////////////////

  /// ゲッター。データベースに接続（なければテーブル作成）して戻す。
  static Future<Database> get database async {
    //-- 関数。テーブルの作成
    FutureOr onCreate(db, value) async {
      db.execute('''
        CREATE TABLE memories_image(id INTEGER PRIMARY KEY, fileName TEXT, text TEXT)
      ''');
    }

    Database? _database = null;

    //-- PCの場合
    if (Platform.isLinux || Platform.isWindows) {
      String path = join(Directory.current.path, 'data', 'memories_image_database.db');
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
        join(dir, 'memories_image_database.db'),
        onCreate: (db, version) {
          return db.execute(
            "CREATE TABLE memories_image(id INTEGER PRIMARY KEY, fileName TEXT, text TEXT)",
          );
        },
        version: 1,
      );
    }
    // print("get");
    // print(_database.toString());
    // await _database.delete( 'memories_image' );
    return _database;
  }

  /// 1件追加
  static Future<void> insert(MemoriesImage memoriesImage) async {
    // print(memoriesImage.id);
    // print(memoriesImage.fileName);
    // print(memoriesImage.text);
    final Database db = await database;
    await db.insert(
      'memories_image',
      memoriesImage.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// 全件取得
  static Future<List<MemoriesImage>> getAll() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('memories_image');
    return List.generate(maps.length, (i) {
      return MemoriesImage(
        id: maps[i]['id'],
        fileName: maps[i]['fileName'],
        text: maps[i]['text'],
      );
    });
  }

  /// 1件取得
  static Future<MemoriesImage> get(int id) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('memories_image', where: "id = ?", whereArgs: [id]);
    return MemoriesImage(
      id: maps[0]['id'],
      fileName: maps[0]['title'],
      text: maps[0]['text'],
    );
  }

  /// 更新
  static Future<void> update(MemoriesImage memoriesImage) async {
    final db = await database;
    await db.update(
      'memories_image',
      memoriesImage.toMap(),
      where: "id = ?",
      whereArgs: [memoriesImage.id],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  /// 1件削除
  static Future<void> delete(int id) async {
    final db = await database;
    await db.delete(
      'memories_image',
      where: "id = ?",
      whereArgs: [id],
    );
  }

}
