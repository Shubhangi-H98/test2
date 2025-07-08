import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _db;

  // डेटाबेस को get करना (या initialize करना)
  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  // डेटाबेस initialize करना
  static Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'user.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Table बनाना
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL,
            password TEXT NOT NULL
          )
        ''');
      },
    );
  }

  // 👤 नया यूज़र insert करना
  static Future<void> insertUser(String username, String password) async {
    final db = await database;

    await db.insert(
      'users',
      {
        'username': username,
        'password': password,
      },
      conflictAlgorithm: ConflictAlgorithm.replace, // अगर same username हो तो replace कर दो
    );
  }

  // 🔍 यूज़र को username से ढूंढना (लॉगिन के लिए)
  static Future<Map<String, dynamic>?> getUser(String username) async {
    final db = await database;

    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }
}
