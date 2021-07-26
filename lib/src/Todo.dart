import 'package:my_app/models/todo_model.dart';
import 'package:transition/transition.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import '../calender.dart';
import '../db_helper.dart';

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
      appBar: AppBar(title: Text(widget.title), actions: <Widget>[
        IconButton(
          icon: Icon(Icons.list),
          onPressed: () {
            Navigator.push(
                context,
                Transition(
                    child: CalendarScreen(title: 'calendar'),
                    transitionEffect: TransitionEffect.TOP_TO_BOTTOM));
          },
        ),
      ]),
      body: FutureBuilder(
        future: DBHelper().getAllTodos(),
        builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == snapshot.data!.length) return addButton();
                Todo item = snapshot.data![index];
                return _buildRow(snapshot.data!, item);
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget addButton() {
    final myController = TextEditingController();
    return ListTile(
      title: Text(
        "투두 더하기",
        textScaleFactor: 1.5,
      ),
      trailing: Icon(Icons.add),
      onTap: () {
        showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return AlertDialog(
                // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                //Dialog Main Title
                title: new Text("Todo 추가"),
                content: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new TextField(
                        controller: myController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'ToDO',
                        ),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text("추가"),
                    onPressed: () {
                      var todo = new Todo(
                          name: myController.text,
                          date: getNowDate(DateTime.now()));
                      if(todo.name != "")
                        DBHelper().createData(todo);
                      Navigator.pop(context);
                      setState(() {});
                      print(todo.name);
                    },
                  ),
                ],
              );
            });
      },
    );
  }

  Widget _buildRow(List<Todo> saved, Todo todo) {
    final bool alreadySaved = !saved.contains(todo);

    //슬라이드가 가능한 버튼
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
        //길게 클릭시
        onLongPress: () => FlutterDialog(todo),
        //짥게 클릭시
        onTap: () {
          todo.state = todo.state == 0 ? 1 : 0;
          print(todo.state);
          DBHelper().updateTodo(todo);
        },
      ),
      //오른쪽 슬라이드
      // actions: <Widget>[]
      //왼쪽 슬라이드
      secondaryActions: <Widget>[
        IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () {
              DBHelper().deleteTodo(todo.id);
              setState(() {});
            })
      ],
    );
  }

  void FlutterDialog(Todo todo) {
    final myController = TextEditingController();
    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            //모양 둥글게 잡아줌
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Column(
              children: <Widget>[
                new Text("Todo 바꾸기"),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new TextField(
                  controller: myController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'ToDO',
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text("바꾸기"),
                onPressed: () {
                  todo.name = myController.text;
                  print(todo.name);
                  if (todo.name != "") {
                    DBHelper().updateTodo(todo);
                    setState(() {});
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}

///현재 날짜를 입력해서 정해진 형식을 뽑아옴
String getNowDate(DateTime now) {
  return now.year.toString() + now.month.toString() + now.day.toString();
}
