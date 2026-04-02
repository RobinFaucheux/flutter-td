import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import '../model/tasks.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    } else if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'task_database.db');

    return await openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Task(
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        title TEXT, 
        description TEXT, 
        difficuty INTEGER, 
        nbhours INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE Tags(
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        name TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE TaskTags(
        TaskId INTEGER, 
        TagId INTEGER,
        FOREIGN KEY (TaskId) REFERENCES Task(id) ON DELETE CASCADE,
        FOREIGN KEY (TagId) REFERENCES Tags(id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> insertTask(Task task) async {
    final db = await instance.database;

    int taskId = await db.insert(
      'Task',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    for (String tag in task.tags) {
      final List<Map<String, dynamic>> tagResult = await db.query(
        'Tags',
        where: 'name = ?',
        whereArgs: [tag],
      );

      int tagId;
      if (tagResult.isNotEmpty) {
        tagId = tagResult.first['id'] as int;
      } else {
        tagId = await db.insert(
          'Tags',
          {'name': tag},
        );
      }

      await db.insert(
        'TaskTags',
        {
          'TaskId': taskId,
          'TagId': tagId,
        },
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
  }

  Future<void> updateTask(Task task) async {
    final db = await instance.database;
    await db.update(
      'Task',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> deleteTask(int id) async {
    final db = await instance.database;
    await db.delete(
      'Task',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Task>> getAllTasks() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> taskMaps = await db.query('Task');

    List<Task> tasks = [];

    for (var taskMap in taskMaps) {
      int taskId = taskMap['id'] as int;

      final List<Map<String, dynamic>> tagMaps = await db.rawQuery('''
        SELECT Tags.name 
        FROM Tags 
        INNER JOIN TaskTags ON Tags.id = TaskTags.TagId 
        WHERE TaskTags.TaskId = ?
      ''', [taskId]);

      List<String> tagsList = tagMaps.map((t) => t['name'] as String).toList();

      tasks.add(Task(
        id: taskId,
        title: taskMap['title'] as String,
        description: taskMap['description'] as String,
        difficuty: taskMap['difficuty'] as int,
        nbhours: taskMap['nbhours'] as int,
        tags: tagsList,
      ));
    }

    return tasks;
  }
}

final database = DatabaseHelper.instance;