import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:my_app/models/todo_model.dart';
import 'package:rive/rive.dart';
import 'package:transition/transition.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import '../calender.dart';
import '../db_helper.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;
import 'funtion.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double sliderValue = 100;
  var itemCnt = 0;
  var donePer = 0.0;
  Map<String, double> events = {};
  late RiveAnimationController _controller;
  Artboard? _artboard;
  var count = 0;

  void _onSucess() {
    if (_artboard != null) {
      if (count == 1) {
        _artboard!.artboard.removeController(_controller);
        _artboard!.addController(SimpleAnimation('FourToThree'));
        count++;
      } else if (count == 2) {
        _artboard!.artboard.removeController(_controller);
        _artboard!.addController(SimpleAnimation('ThreeToTwo'));
        count++;
      } else if (count == 3) {
        _artboard!.artboard.removeController(_controller);
        _artboard!.addController(SimpleAnimation('TwoToOne'));
        count++;
      } else if (count == 4) {
        _artboard!.artboard.removeController(_controller);
        _artboard!.addController(SimpleAnimation('OneToTwo'));
        count++;
      } else if (count == 5) {
        _artboard!.artboard.removeController(_controller);
        _artboard!.addController(SimpleAnimation('TwoToThree'));
        count++;
      } else if (count == 6) {
        _artboard!.artboard.removeController(_controller);
        _artboard!.addController(SimpleAnimation('ThreeToFour'));
        count++;
      } else if (count == 7) {
        _artboard!.artboard.removeController(_controller);
        _artboard!.addController(SimpleAnimation('ToFall'));
        count++;
      } else if (count == 8) {
        _artboard!.artboard.removeController(_controller);
        _artboard!.addController(SimpleAnimation('ToWinter'));
        count++;
      } else if (count == 9) {
        _artboard!.artboard.removeController(_controller);
        _artboard!.addController(SimpleAnimation('FallToWinter'));
        count++;
      } else {
        count++;
        _artboard!.artboard.removeController(_controller);
        _artboard!.addController(SimpleAnimation('MoveUp'));
      }
      Future.delayed(const Duration(milliseconds: 1500), () {
        _Wind();
      });
    }
  }

  void _Wind() {
    _artboard!.artboard.removeController(_controller);
    _artboard!.addController(SimpleAnimation('Wind'));
  }

  void _onInit(Artboard artboard) {
    _artboard = artboard;
  }

  @override
  void initState() {
    super.initState();
    _loadRiveFile();
  }

  void _loadRiveFile() async {
    _controller = SimpleAnimation('MoveUp');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    //await DBHelper().createPer(DateTime.now().year.toString() + (DateTime.now().month+5).toString() + (DateTime.now().day-2).toString());
    //await DBHelper().updatePer(DateTime.now().year.toString() + (DateTime.now().month+5).toString() + (DateTime.now().day-2).toString(), 0.5);
    var allPer = await DBHelper().getAllPer();
    for (int i = 0; i < allPer.length; i++) {
      events[allPer[i]['date']] = allPer[i]['per'].toDouble();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(getNowDate(DateTime.now())),
      ),
      body: FutureBuilder(
        future: DBHelper().getAllTodos(),
        builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
          if (snapshot.hasData) {
            itemCnt = snapshot.data!.length;
            if (itemCnt == 0) {
              DBHelper().createPer(getNowDate(DateTime.now()));
              //events[getNowDate(DateTime.now())] = 0.0;
            }
            return Stack(
              children: <Widget>[
                Center(
                    child: GestureDetector(
                  onTap: _onSucess,
                  child: RiveAnimation.asset(
                    'assets/cloud.riv',
                    onInit: _onInit,
                    fit: BoxFit.cover,
                    controllers: [_controller],
                  ),
                )),
                Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 30,
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        // if (index == snapshot.data!.length) return addButton();
                        Todo item = snapshot.data![index];
                        return _buildRow(item, sliderValue / 100);
                      },
                    )),
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(104, 65, 50, 1),
        elevation: 0,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
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
                (sliderValue == 20) ? Icons.visibility : Icons.visibility_off,
                color: Colors.white,
              ),
              onPressed: () {
                sliderValue = (sliderValue == 20) ? 100 : 20;
                setState(() {});
              },
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
                      child: CalendarScreen(
                          title: 'calendar', donePer: donePer, events: events),
                      transitionEffect: TransitionEffect.TOP_TO_BOTTOM)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addButtonAction() async {
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
                onPressed: () async {
                  var todo = new Todo(
                      name: myController.text,
                      state: 0,
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

  Widget _buildRow(Todo todo, double opacity) {
    final bool alreadySaved = todo.state == 1;
    Color otherColor = Colors.white;
    if (todo.color != null) {
      otherColor = stringtoColor(todo);
    }
    //슬라이드가 가능한 버튼
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: AnimatedOpacity(
          opacity: opacity,
          duration: Duration(seconds: 1),
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
                onTap: () async {
                  if (todo.state == null) todo.state = 0;
                  todo.state = todo.state == 0 ? 1 : 0;
                  DBHelper().updateTodoState(todo);
                  setState(() {
                    _onSucess();
                  });

                  var doneData =
                      await DBHelper().getDoneTodos(getNowDate(DateTime.now()));
                  donePer = (doneData / itemCnt).toDouble();
                  await DBHelper().updatePer(
                      getNowDate(DateTime.now()), donePer.toDouble());

                  events[getNowDate(DateTime.now())] = donePer;
                },
              ))),
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
