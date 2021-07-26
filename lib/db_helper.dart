import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:my_app/models/todo_model.dart';

final String tableName = 'Dog';

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
            "CREATE TABLE $tableName(id INTEGER PRIMARY KEY, name TEXT)",
          );
        },
        onUpgrade: (db, oldVersion, newVersion){}
    );
  }

  //Create
  createData(Dog dog) async {
    final db = await database;
    var res = await db!.rawInsert('INSERT INTO $tableName(name) VALUES(?)', [dog.name]);
    return res;
  }

  //Read
  getDog(int id) async {
    print("GGGGGGGGGGGGGGGGGGGGGGGGGGGGGEEEEEEEEEEEEETTTTTTTTTTTT");
    final db = await database;
    var res = await db!.rawQuery('SELECT * FROM $tableName WHERE id = ?', [id]);
    if (res.isNotEmpty) {
      return Dog(id: res.first['id'], name: res.first['name']);
    } else {
      return Null;
    }
  }

  //Read All
  Future<List<Dog>> getAllDogs() async {
    print("GGGGGGGEEEEEEEETAAAAAAAAAAALLLLLLLLLLLLLLL");
    final db = await database;
    var res = await db!.rawQuery('SELECT * FROM $tableName');
    List<Dog> list = res.isNotEmpty ? res.map((c) => Dog(id:c['id'], name:c['name'])).toList() : [];

    return list;
  }

  //Delete
  deleteDog(int id) async {
    final db = await database;
    var res = db!.rawDelete('DELETE FROM $tableName WHERE id = ?', [id]);
    //print("ididididididididididididid" + id.toString());
    return res;
  }

  //Delete All
  deleteAllDogs() async {
    final db = await database;
    db!.rawDelete('DELETE FROM $tableName');
  }
}