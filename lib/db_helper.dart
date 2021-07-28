import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:my_app/models/todo_model.dart';
import 'package:my_app/models/percent_model.dart';

final String tableName = 'Todo';
final String perTableName = 'Per';

class DBHelper {
  DBHelper._();

  static final DBHelper _db = DBHelper._();

  factory DBHelper() => _db;

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'MyDogsDB.db');

    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(
        "CREATE TABLE $tableName(id INTEGER PRIMARY KEY, name TEXT, date TEXT, state INTEGER, color Text)",
      );
      await db.execute(
        "CREATE TABLE $perTableName(date TEXT PRIMARY KEY, per DOUBLE)",
      );
    }, onUpgrade: (db, oldVersion, newVersion) {});
  }

  showTable() async {
    final db = await database;
    List result = await db!.rawQuery(
        "SELECT name FROM sqlite_master WHERE type = 'table' AND name NOT LIKE 'android_%'");
  }

  createPer(String date) async {
    final db = await database;
    var res = await db!.rawInsert(
        'INSERT OR REPLACE INTO $perTableName(date, per) VALUES(?, ?)',
        [date, 0.0]);
    return res;
  }

  updatePer(String date, double per) async {
    final db = await database;
    var res = db!.rawUpdate(
        'UPDATE $perTableName SET per = ? WHERE date = ?', [per, date]);
    return res;
  }

  getPer(String date) async {
    final db = await database;
    var res = await db!
        .rawQuery('Select * FROM $perTableName WHERE date = ?', [date]);
    if (res.isNotEmpty) {
      return res.first['per'];
    }
  }

  getAllPer() async {
    final db = await database;
    var res = await db!.rawQuery('SELECT * FROM $perTableName');
    return res;
  }

  deleteAllPer() async {
    final db = await database;
    db!.rawDelete('DELETE FROM $perTableName');
  }

  //Create
  createData(Todo todo) async {
    final db = await database;
    try {
      var res = await db!.rawInsert(
          'INSERT INTO $tableName (name, date, state , color) VALUES(?, ?, ?, ?)',
          [todo.name, todo.date, todo.state, todo.color]);
      return res;
    } on DatabaseException catch (e) {
      var res2 =
          await db!.execute('ALTER TABLE $tableName ADD COLUMN color TEXT');
      var res = await db.rawInsert(
          'INSERT INTO $tableName (name, date, state , color) VALUES(?, ?, ?, ?)',
          [todo.name, todo.date, todo.state, todo.color]);
      return res;
    }
  }

  //Read
  getTodo(int id) async {
    final db = await database;
    var res = await db!.rawQuery('SELECT * FROM $tableName WHERE id = ?', [id]);
    if (res.isNotEmpty) {
      return Todo(
          id: res.first['id'],
          name: res.first['name'],
          date: res.first['date'],
          state: res.first['state'],
          color: res.first['color']);
    } else {
      return Null;
    }
  }

  getDayTodos(String date) async{
    final db = await database;
    var res =
    await db!.rawQuery('SELECT * FROM $tableName WHERE date = ?', [date]);
    List<Todo> list = res.isNotEmpty
        ? res
        .map((c) => Todo(
        id: c['id'],
        name: c['name'],
        date: c['date'],
        state: c['state'],
        color: c['color']))
        .toList()
        : [];

    return list;
  }

  getDoneTodos(String date) async {
    final db = await database;
    var res =
        await db!.rawQuery('SELECT * FROM $tableName WHERE date = ? AND state = ?', [date,1]);
    List<Todo> list = res.isNotEmpty
        ? res
            .map((c) => Todo(
                id: c['id'],
                name: c['name'],
                date: c['date'],
                state: c['state'],
                color: c['color']))
            .toList()
        : [];

    return list.length;
  }

  //Read All
  Future<List<Todo>> getAllTodos() async {
    final db = await database;
    var res = await db!.rawQuery('SELECT * FROM $tableName');
    List<Todo> list = res.isNotEmpty
        ? res
            .map((c) => Todo(
                id: c['id'],
                name: c['name'],
                date: c['date'],
                state: c['state'],
                color: c['color']))
            .toList()
        : [];

    return list;
  }

  //Delete
  deleteTodo(int id) async {
    final db = await database;
    var res = db!.rawDelete('DELETE FROM $tableName WHERE id = ?', [id]);
    return res;
  }

  //Delete All
  deleteAllTodos() async {
    final db = await database;
    db!.rawDelete('DELETE FROM $tableName');
  }

  //Update
  updateTodoName(Todo todo) async {
    final db = await database;
    var res = db!.rawUpdate(
        'UPDATE $tableName SET name = ?, color = ? WHERE id = ?',
        [todo.name, todo.color, todo.id]);
    return res;
  }

  updateTodoState(Todo todo) async {
    final db = await database;
    var res = db!.rawUpdate(
        'UPDATE $tableName SET state = ? WHERE id = ?', [todo.state, todo.id]);
    return res;
  }
}
