import 'dart:async';

import 'package:my_app/models/todo_model.dart';
import 'package:transition/transition.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import '../calender.dart';
import '../db_helper.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;

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
      resizeToAvoidBottomInset: false,
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
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                // if (index == snapshot.data!.length) return addButton();
                Todo item = snapshot.data![index];
                return _buildRow(item);
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(Icons.add),
        onPressed: () => SliderDialog(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: new BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: Color.fromRGBO(104, 65, 50, 1),
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () => addButtonAction(),
            ),
            new Expanded(child: new SizedBox()),
            IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () => Navigator.push(
                  context,
                  Transition(
                      child: CalendarScreen(title: 'calendar'),
                      transitionEffect: TransitionEffect.TOP_TO_BOTTOM)),
            ),
          ],
        ),
      ),
    );
  }

  Widget addButton() {
    return Container(
        child: ListTile(
      title: Text(
        "투두 더하기",
        textScaleFactor: 1,
      ),
      trailing: Icon(Icons.add),
      onTap: () => addButtonAction(),
    ));
  }

  void addButtonAction() {
    final myController = TextEditingController();
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
            content: ListView(children: <Widget>[
              Column(
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
            ]),
            actions: <Widget>[
              new FlatButton(
                child: new Text("추가"),
                onPressed: () {
                  var todo = new Todo(
                      name: myController.text,
                      date: getNowDate(DateTime.now()));
                  if (todo.name != "") DBHelper().createData(todo);
                  Navigator.pop(context);
                  setState(() {});
                },
              ),
            ],
          );
        });
  }

  Widget _buildRow(Todo todo) {
    final bool alreadySaved = todo.state == 1;
    Color otherColor = Colors.white;
    if (todo.color != null) {
      otherColor = stringtoColor(todo);
    }

    //슬라이드가 가능한 버튼
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Card(
          margin: EdgeInsets.fromLTRB(8, 4, 8, 4),
          color: otherColor,
          child: ListTile(
            title: Text(
              todo.toString(),
              textScaleFactor: 1,
            ),
            leading: Icon(
                !alreadySaved ? Icons.favorite_border : Icons.favorite,
                color: Colors.pink),
            //길게 클릭시
            onLongPress: () => FlutterDialog(todo),
            //짥게 클릭시
            onTap: () {
              if (todo.state == null) todo.state = 0;
              todo.state = todo.state == 0 ? 1 : 0;
              DBHelper().updateTodoState(todo);
              setState(() {});
            },
          )),
      //오른쪽 슬라이드
      // actions: <Widget>[]
      //왼쪽 슬라이드
      secondaryActions: <Widget>[
        IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete_rounded,
            onTap: () {
              DBHelper().deleteTodo(todo.id);
              setState(() {});
            })
      ],
    );
  }

  void FlutterDialog(Todo todo) {
    Color pickerColor = stringtoColor(todo);
    var controller = StreamController<Color>();
    Stream<Color> stream = controller.stream;

    void changeColor(Color color) {
      controller.add(color);
      setState(() {
        pickerColor = color;
      });
    }

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
                    labelText: todo.name,
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: new MaterialPicker(
                      pickerColor: pickerColor,
                      onColorChanged: (Color color) =>
                          setState(() => changeColor(color))),
                ),
              ],
            ),
            actions: <Widget>[
              new StreamBuilder(
                  stream: stream,
                  builder: (context, snapshot) {
                    return Center(
                      child: new FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.white)),
                          color: pickerColor,
                          child: new Text("Change"),
                          onPressed: () {
                            if (myController.text != "")
                              todo.name = myController.text;
                            todo.color = pickerColor.toString();
                            DBHelper().updateTodoName(todo);
                            Navigator.pop(context);
                            setState(() {});
                          }),
                    );
                  }),
            ],
          );
        });
  }

  void SliderDialog() {
    Color pickerColor = Colors.lightGreen;
    StreamController<Color> controller = StreamController<Color>();
    Stream<Color> stream = controller.stream;

    void changeColor(Color color) {
      controller.add(color);
      setState(() {
        pickerColor = color;
      });
    }

    final myController = TextEditingController();
    print("dia");
    slideDialog.showSlideDialog(
        barrierColor: Colors.white.withOpacity(0.7),
        context: context,
        child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.max,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
              TextField(
                controller: myController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'ToDO',
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                child: new MaterialPicker(
                    pickerColor: pickerColor,
                    onColorChanged: (Color color) =>
                        setState(() => changeColor(color))),
              ),
              StreamBuilder(
                  stream: stream,
                  builder: (context, snapshot) {
                    return Center(
                      child: new FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.white)),
                          color: pickerColor,
                          child: new Text("Add Todo"),
                          onPressed: () {
                            var todo = new Todo(
                                name: myController.text,
                                date: getNowDate(DateTime.now()),
                                color: pickerColor.toString());
                            if (todo.name != "") DBHelper().createData(todo);
                            Navigator.pop(context);
                            setState(() {});
                          }),
                    );
                  })
            ])));
  }
}

///현재 날짜를 입력해서 정해진 형식을 뽑아옴
String getNowDate(DateTime now) {
  return now.year.toString() + now.month.toString() + now.day.toString();
}

Color stringtoColor(Todo todo) {
  String valueString =
      todo.color?.split('(0x')[1].split(')')[0]; // kind of hacky..
  int value = int.parse(valueString, radix: 16);
  return new Color(value);
}
