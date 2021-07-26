import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:my_app/models/todo_model.dart';

final String tableName = 'Todo';

class DBHelper {

  DBHelper._();
  static final DBHelper _db = DBHelper._();
  factory DBHelper() => _db;

  static Database? _database;

  Future<Database?> get database async {
    if(_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    print("DDDDDDDDDDDDDDDDDDDDDDDDDD" + documentsDirectory.toString());
    String path = join(documentsDirectory.path, 'MyDogsDB.db');

    return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute(
            "CREATE TABLE $tableName(id INTEGER PRIMARY KEY, name TEXT, date TEXT, state INTEGER)",
          );
        },
        onUpgrade: (db, oldVersion, newVersion){}
    );
  }

  //Create
  createData(Todo todo) async {
    final db = await database;
    var res = await db!.rawInsert('INSERT INTO $tableName(name) VALUES(?)', [todo.name]);
    return res;
  }

  //Read
  getTodo(int id) async {
    print("GGGGGGGGGGGGGGGGGGGGGGGGGGGGGEEEEEEEEEEEEETTTTTTTTTTTT");
    final db = await database;
    var res = await db!.rawQuery('SELECT * FROM $tableName WHERE id = ?', [id]);
    if (res.isNotEmpty) {
      return Todo(id: res.first['id'], name: res.first['name'], date:res.first['date'], state:res.first['state']);
    } else {
      return Null;
    }
  }

  Future<List<Todo>> getDayTodos(String date) async{
    final db = await database;
    var res = await db!.rawQuery('SELECT * FROM $tableName WHERE date = ?', [date]);
    List<Todo> list = res.isNotEmpty ? res.map((c) => Todo(id:c['id'], name:c['name'], date:c['date'], state:c['state'])).toList() : [];

    return list;
  }

  //Read All
  Future<List<Todo>> getAllTodos() async {
    print("GGGGGGGEEEEEEEETAAAAAAAAAAALLLLLLLLLLLLLLL");
    final db = await database;
    var res = await db!.rawQuery('SELECT * FROM $tableName');
    List<Todo> list = res.isNotEmpty ? res.map((c) => Todo(id:c['id'], name:c['name'], date:c['date'], state:c['state'])).toList() : [];

    return list;
  }

  //Delete
  deleteTodo(int id) async {
    final db = await database;
    var res = db!.rawDelete('DELETE FROM $tableName WHERE id = ?', [id]);
    //print("ididididididididididididid" + id.toString());
    return res;
  }

  //Delete All
  deleteAllTodos() async {
    final db = await database;
    db!.rawDelete('DELETE FROM $tableName');
  }

  //Update
  updateTodo(Todo todo) async {
    final db = await database;
    var res = db!.rawUpdate('UPDATE $tableName SET name = ? WHERE = ?', [todo.name, todo.id]);
    return res;
  }
}