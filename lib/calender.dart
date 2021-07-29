import 'package:flutter/material.dart';
import 'package:my_app/calendars/flutter_clean_calendar.dart';
import 'package:my_app/calendars/clean_calendar_event.dart';
import 'package:my_app/db_helper.dart';
import 'package:my_app/main.dart';
import 'package:rive/rive.dart';

import 'Bloc.dart';
import 'models/todo_model.dart';
import 'src/funtion.dart';

class CalendarScreen extends StatefulWidget {
  CalendarScreen({Key? key,
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

  late RiveAnimationController _controller;Artboard? _artboard;
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

  void _ActiveAnimation(double? percent) {
    if (_artboard != null) {
      if(percent! == 1.0){
        _artboard!.artboard.removeController(_controller);
        _artboard!.addController(SimpleAnimation('ToFour'));
      }
      else if(percent >= 0.75){
        _artboard!.artboard.removeController(_controller);
        _artboard!.addController(SimpleAnimation('ToSpring'));
      }
      else if(percent >= 0.5){
        _artboard!.artboard.removeController(_controller);
        _artboard!.addController(SimpleAnimation('ToTwo'));
      }
      else if(percent >= 0.25){
        _artboard!.artboard.removeController(_controller);
        _artboard!.addController(SimpleAnimation('ToOne'));
      }
      debugPrint(percent.toString());
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
    return StreamBuilder<double>(
      stream: bloc.savedStream,
      builder: (context, snapshot) {
        if(snapshot.data != null){
          _ActiveAnimation(snapshot.data);
        }
        return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text("Route Transition Example"),
            ),
            body: Stack(
              children: <Widget>[
                Positioned(
                  left: 0,
                  right: 0,
                  top: 60,
                  bottom: 0,
                  child: GestureDetector(
                    child: RiveAnimation.asset(
                      'assets/cloud.riv',
                      onInit: _onInit,
                      fit: BoxFit.cover,
                      controllers: [_controller],
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: GestureDetector(
                      child: Calendar(
                        startOnMonday: true,
                        weekDays: ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'],
                        events: _events,
                        isExpandable: true,
                        eventDoneColor: Colors.green,
                        selectedColor: Colors.pink,
                        todayColor: Colors.blue,
                        eventColor: Colors.grey,
                        locale: 'ko',
                        isExpanded: true,
                        expandableDateFormat: 'EEEE, dd. MMMM yyyy',
                        dayOfWeekStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontSize: 11),
                      )),
                )
              ],
            ));
      }
    );
  }

  Future<void> _handleNewDate(date) async {
    var gotPer = await DBHelper().getPer(getNowDate(DateTime.now()));
  }
}
