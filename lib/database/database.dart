import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_todoapp/model/task_model.dart';

class DbHelper {
  static final DbHelper databaseService = DbHelper.internal();
  factory DbHelper() => databaseService;

  DbHelper.internal();
  static Database? _db;

  final String _tasksTableName = 'tasks';

  final String _tasksColumnName = 'id';
  final String _tasksContentName = 'content';
  final String _tasksStatusColumnName = 'status';
  Future<Database?> get database async {
    if (_db != null) {
      return _db;
    }

    _db = await initializeDatabase();
    return _db;
  }

  Future<Database> initializeDatabase() async {
    print('object---------->1');
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "master_db.db");
    final database = await openDatabase(
      databasePath,
      version: 1,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
      onCreate: (db, version) async {
        await db.execute('''
CREATE TABLE $_tasksTableName(
$_tasksColumnName INTEGER PRIMARY KEY,
$_tasksContentName TEXT NOT NULL,
$_tasksStatusColumnName INTEGER NOT NULL
        )''');
      },
    );

    print('object---------->2');
    return database;
  }

  Future<void> addtotasks(String content) async {
    final db = await DbHelper.databaseService.database;
    await db?.insert(
        _tasksTableName,
        {
          _tasksStatusColumnName: 0,
          _tasksContentName: content,
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Task>?> getTasks() async {
    final db = await DbHelper.databaseService.database;
    final data = await db?.query(_tasksTableName);
    List<Task>? tasks = data
        ?.map((e) => Task(
            id: e['id'], status: e['status'], content: e['content'] as String))
        .toList();

    return tasks;
  }

  Future<void> updateStatus(int id, int status) async {
    final db = await DbHelper.databaseService.database;
    await db?.update(
      _tasksTableName,
      {
        _tasksStatusColumnName: status,
      },
      where: 'id=?',
      whereArgs: [
        id,
      ],
    );
  }

  Future<void> deleteTask(int id) async {
    final db = await DbHelper.databaseService.database;
    await db?.delete(
      _tasksTableName,
      where: 'id=?',
      whereArgs: [
        id,
      ],
    );
  }
}


// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:my_passwords/models/add_password_model.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';


// class DatabaseService with ChangeNotifier {
//   static final DatabaseService _databaseService = DatabaseService._internal();
//   factory DatabaseService() => _databaseService;
//   DatabaseService._internal();

//   static Database? _database;
//   Future<Database> get database async {
//     if (database != null) return database!;

//     database = await initDatabase();
//     return _database!;
//   }

//   Future<Database> _initDatabase() async {
//     final databasePath = await getDatabasesPath();
//     final path = join(databasePath, 'passwords.db');
//     return await openDatabase(
//       path,
//       onCreate: _onCreate,
//       version: 1,
//       onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
//     );
//   }

//   Future<void> _onCreate(Database db, int version) async {
//     await db.execute(
//       'CREATE TABLE passwords(id TEXT PRIMARY KEY, title TEXT, url TEXT,username TEXT,password TEXT,notes TEXT,addedDate TEXT)',
//     );
//   }

//   Future<void> addPassword({required AddPasswordModel password}) async {
//     final db = await _databaseService.database;

//     await db.insert(
//       'passwords',
//       password.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//     notifyListeners();
//     log('inputted data ${password.toMap().toString()}');
//   }

//   Future<List<AddPasswordModel>> passwords() async {
//     final db = await _databaseService.database;
//     final List<Map<String, dynamic>> maps = await db.query('passwords');
//     return List.generate(maps.length, (index) {
//       notifyListeners();
//       return AddPasswordModel.fromMap(maps[index]);
//     });
//   }

//   Future<AddPasswordModel> selectedPassword(int id) async {
//     final db = await _databaseService.database;
//     final List<Map<String, dynamic>> maps =
//         await db.query('passwords', where: 'id = ?', whereArgs: [id]);
//     notifyListeners();
//     return AddPasswordModel.fromMap(maps[0]);
//   }

//   Future<void> deletePassword(String id) async {
//     final db = await _databaseService.database;
//     await db.delete(
//       'passwords',
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//     notifyListeners();
//   }

//   Future<void> updatePassword({required AddPasswordModel password}) async {
//     final db = await _databaseService.database;

//     await db.update(
//       'passwords',
//       password.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//       where: 'id = ?',
//       whereArgs: [password.id],
//     );

//     log('${password.id} updated');
//     // log(db.toString());
//     notifyListeners();
//   }

//   Future<void> clearHistory() async {
//     final db = await _databaseService.database;

//     await db.delete(
//       'passwords',
//     );
//   }
// }