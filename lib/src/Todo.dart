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
  var itemCnt = 0;
  var donePer = 0.0;
  Map<DateTime, double> events  = {};

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
                    child: CalendarScreen(title: 'calendar', donePer: donePer, events: events),
                    transitionEffect: TransitionEffect.TOP_TO_BOTTOM));
          },
        ),
      ]),
      body: FutureBuilder(
        future: DBHelper().getAllTodos(),
        builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
          if (snapshot.hasData) {
            itemCnt = snapshot.data!.length;
            if (itemCnt==0){
              DBHelper().createPer(getNowDate(DateTime.now()));
              events[DateTime(
                  DateTime.now().year, DateTime.now().month, DateTime.now().day)] = 0;
            }
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
        onPressed: () => addButtonAction(),
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
                      child: CalendarScreen(title: 'calendar', donePer: donePer, events: events),
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
        )
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
                onPressed: () async {
                  var todo = new Todo(
                      name: myController.text,
                      state: 0,
                      date: getNowDate(DateTime.now()));
                  if (todo.name != "") DBHelper().createData(todo);
                  Navigator.pop(context);
                  setState(() {});
                  print(todo.name);
                  //await DBHelper().updatePer(DateTime.now().year.toString() + DateTime.now().month.toString() + DateTime.now().day.toString(), doneData);
                  //var per = await DBHelper().getPer(DateTime.now().year.toString() + DateTime.now().month.toString() + DateTime.now().day.toString());
                  //print("ADDDDDDDDDDDD" + per);

                },
              ),
            ],
          );
        });
  }

  Widget _buildRow(Todo todo) {
    final bool alreadySaved = todo.state == 1;

    //슬라이드가 가능한 버튼
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Card(
          margin: EdgeInsets.fromLTRB(8, 4, 8, 4),
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
              setState(() {});
              var doneData = await DBHelper().getDayTodos(getNowDate(DateTime.now()));
              donePer = doneData / itemCnt;
              print("DONEDATA" + donePer.toString());
              await DBHelper().updatePer(getNowDate(DateTime.now()), donePer);
              var gotPer = await DBHelper().getPer(getNowDate(DateTime.now()));
              print("PERCENT" + gotPer.toString());
              events[DateTime(
                  DateTime.now().year, DateTime.now().month, DateTime.now().day)] = donePer;
            },
          )),
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
                    DBHelper().updateTodoName(todo);
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
