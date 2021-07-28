import 'package:flutter/material.dart';
import 'package:my_app/calendars/flutter_clean_calendar.dart';
import 'package:my_app/calendars/clean_calendar_event.dart';
import 'package:my_app/db_helper.dart';
import 'package:my_app/main.dart';

import 'models/todo_model.dart';

class CalendarScreen extends StatefulWidget {
  CalendarScreen({Key? key, required this.title, required this.donePer, required this.events}) : super(key: key);

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

  _CalendarScreenState(Map<String, double> events){
    this._events = events;
  }

  @override
  void initState() {
    super.initState();
    // Force selection of today on first load, so that the list of today's events gets shown.
    _handleNewDate(getNowDate(DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Route Transition Example"),
      ),
      body: SafeArea(
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
              color: Colors.black, fontWeight: FontWeight.w800, fontSize: 11),
        ),
      ),
    );
  }

  Future<void> _handleNewDate(date) async {
    var gotPer = await DBHelper().getPer(getNowDate(DateTime.now()));
  }
}

String getNowDate(DateTime now) {
  return now.year.toString() + now.month.toString() + now.day.toString();
}