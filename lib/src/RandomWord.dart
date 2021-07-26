import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/models/todo_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class RandomWords extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RandomWordState();
}
//클래스의 상태를 바꿔줌.

class RandomWordState extends State<RandomWords> {
  final List<Todo> _suggestion = <Todo>[
    Todo(name: '물마시기', id: null, date: '2021', state: 0),
    Todo(name: '공부하기', id: null, date: '2021', state: 0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Naming"), actions: <Widget>[
      ]),
      body: _bulidList(_suggestion),
    );
  }
}

Widget _bulidList(List<Todo> _suggestion) {
  return ListView.builder(
      itemCount: _suggestion.length * 2,
      itemBuilder: (context, index) {
        if (index.isOdd) {
          return Divider();
        }
        var realIndex = index ~/ 2;
        return _buildRow(_suggestion,_suggestion[realIndex]);
      });
}

Widget _buildRow(List<Todo> saved, Todo todo) {
  final bool alreadySaved = saved.contains(todo);

  return Slidable(
    actionPane: SlidableDrawerActionPane(),
    actionExtentRatio: 0.25,
    child: ListTile(
      title: Text(
        todo.toString(),
        textScaleFactor: 1.5,
      ),
      trailing: Icon(!alreadySaved ? Icons.favorite_border : Icons.favorite,
          color: Colors.pink),
      // onLongPress: () => FlutterDialog(todo),
      onTap: () {
          print("clock");
          todo.state = todo.state == 0 ? 1:0;
      },
    ),
    secondaryActions: <Widget>[
      IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            print("slieds");
          })
    ],
  );
}