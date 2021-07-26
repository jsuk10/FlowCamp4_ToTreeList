import 'package:flutter/material.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import "package:flutter_localizations/flutter_localizations.dart";
import 'calendar.dart';
import 'src/RandomWord.dart';

import 'package:my_app/db_helper.dart';
import 'package:my_app/models/todo_model.dart';
import 'dart:math';

List<Todo> todos = [
  Todo(name: '물마시기', id: null, date: '2021', state: 0),
  Todo(name: '공부하기', id: null, date: '2021', state: 0),
];

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Todo Database'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: FutureBuilder(
          future: DBHelper().getAllTodos(),
          builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  Todo item = snapshot.data![index];
                  print("IIIIIIIIIIIIIIIIIIIIITEM" + item.name.toString());
                  return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      DBHelper().deleteTodo(item.id);
                      setState(() {});
                    },
                    child: Center(child: Text(item.name)),
                  );
                },
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            /**FloatingActionButton(
              child: Icon(Icons.refresh),
              onPressed: () {
                DBHelper().deleteAllDogs();
                setState(() {});
              },
            ),
            */
            SizedBox(height: 8.0),
            FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Todo todo = todos[Random().nextInt(todos.length)];
                DBHelper().createData(todo);
                setState(() {});
              },
            ),
          ],
        ));
  }
}
