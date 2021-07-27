import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:my_app/models/todo_model.dart';

final String tableName = 'Todo';
final String perTableName = 'Per';

class DBHelper {

  DBHelper._();
  static final DBHelper _db = DBHelper._();
  factory DBHelper() => _db;

  static Database? _database;

  Future<Database?> get database async {
    print("DDDDDDDDDDATABASE");
    if(_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    print("INIIIIIIIIIIT)");
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    print(documentsDirectory.toString());
    String path = join(documentsDirectory.path, 'MyDogsDB.db');
    print("PPPPPPPPPPPPPATH" + path.toString());

    return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute(
            "CREATE TABLE $tableName(id INTEGER PRIMARY KEY, name TEXT, date TEXT, state INTEGER)",
          );
          await db.execute(
            "CREATE TABLE $perTableName(date TEXT PRIMARY KEY, per DOUBLE)",
          );
        },
        onUpgrade: (db, oldVersion, newVersion){}
    );
  }

  showTable() async {
    final db = await database;
    List result = await db!.rawQuery("SELECT name FROM sqlite_master WHERE type = 'table' AND name NOT LIKE 'android_%'");
    print(result);
  }

  createPer(String date) async{
    final db = await database;
    var res = await db!.rawInsert('INSERT INTO $perTableName(date, per) VALUES(?, ?)', [date, 0]);
    return res;
  }

  updatePer(String date, double per) async {
    final db = await database;
    var res = db!.rawUpdate('UPDATE $perTableName SET per = ? WHERE date = ?', [per, date]);
    return res;
  }

  getPer(String date) async{
    final db = await database;
    var res = await db!.rawQuery('Select * FROM $perTableName WHERE date = ?', [date]);
    if (res.isNotEmpty){
      return res.first['per'];
    }
  }

  //Create
  createData(Todo todo) async {
    final db = await database;
    var res = await db!.rawInsert('INSERT INTO $tableName(name, date, state) VALUES(?, ?, ?)', [todo.name, todo.date, todo.state]);
    return res;
  }

  //Read
  getTodo(int id) async {
    final db = await database;
    var res = await db!.rawQuery('SELECT * FROM $tableName WHERE id = ?', [id]);
    if (res.isNotEmpty) {
      return Todo(id: res.first['id'], name: res.first['name'], date:res.first['date'], state:res.first['state']);
    } else {
      return Null;
    }
  }

  getDayTodos(String date) async{
    final db = await database;
    var res = await db!.rawQuery('SELECT * FROM $tableName WHERE date = ? and state = ?', [date, 1]);
    List<Todo> list = res.isNotEmpty ? res.map((c) => Todo(id:c['id'], name:c['name'], date:c['date'], state:c['state'])).toList() : [];

    print(list.length);

    return list.length;
  }

  //Read All
  Future<List<Todo>> getAllTodos() async {
    final db = await database;
    var res = await db!.rawQuery('SELECT * FROM $tableName');
    List<Todo> list = res.isNotEmpty ? res.map((c) => Todo(id:c['id'], name:c['name'], date:c['date'], state:c['state'])).toList() : [];

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
    var res = db!.rawUpdate('UPDATE $tableName SET name = ? WHERE id = ?', [todo.name, todo.id]);
    return res;
  }

  updateTodoState(Todo todo) async {
    final db = await database;
    var res = db!.rawUpdate('UPDATE $tableName SET state = ? WHERE id = ?', [todo.state, todo.id]);
    return res;
  }
}