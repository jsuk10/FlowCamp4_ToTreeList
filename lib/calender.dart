import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_app/calendars/flutter_clean_calendar.dart';
import 'package:my_app/calendars/clean_calendar_event.dart';
import 'package:my_app/db_helper.dart';
import 'package:my_app/main.dart';
import 'package:rive/rive.dart';

import 'models/todo_model.dart';
import 'src/funtion.dart';

class CalendarScreen extends StatefulWidget {
  CalendarScreen(
      {Key? key,
      required this.title,
      required this.donePer,
      required this.events})
      : super(key: key);

  final String title;
  final double donePer;
  final Map<String, double> events;

  @override
  State<StatefulWidget> createState() {
    return _CalendarScreenState(events);
  }
}

//여기서 todo data 보여줌
class _CalendarScreenState extends State<CalendarScreen> {
  Map<String, double> _events = {};

  late RiveAnimationController _controller;
  Artboard? _artboard;
  var count = 0;

  _CalendarScreenState(Map<String, double> events) {
    this._events = events;
  }

  @override
  void initState() {
    super.initState();
    // Force selection of today on first load, so that the list of today's events gets shown.
    _handleNewDate(getNowDate(DateTime.now()));
    _loadRiveFile();
  }

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

  void _loadRiveFile() async {
    _controller = SimpleAnimation('MoveUp');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double opicty = 0.8;
    var controller = StreamController<double>();
    Stream<double> stream = controller.stream;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
              child: new StreamBuilder(
                  stream: stream,
                  builder: (context, snapshot) {
                    return AnimatedOpacity(
                      opacity: (snapshot.data != null) ? snapshot.data as double : opicty,
                      duration: Duration(seconds: 1),
                      child: RiveAnimation.asset(
                        'assets/cloud.riv',
                        onInit: _onInit,
                        fit: BoxFit.cover,
                        controllers: [_controller],
                      ),
                    );
                  })),
          SafeArea(
            child: Calendar(
              startOnMonday: true,
              onExpandStateChanged: (value) {
                opicty = value ? 0.5 : 0.8;
                controller.add(opicty);
                setState(() {});
              },
              weekDays: ['mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'],
              events: _events,
              isExpandable: true,
              eventDoneColor: Colors.green,
              selectedColor: Colors.pink,
              todayColor: Colors.blue,
              eventColor: Colors.grey,
              locale: 'ko',
              isExpanded: false,
              expandableDateFormat: 'EEEE, dd. MMMM yyyy',
              dayOfWeekStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontSize: 11),
            ),
          ),
        ],
      ),
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
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleNewDate(date) async {
    var gotPer = await DBHelper().getPer(getNowDate(DateTime.now()));
  }
}
