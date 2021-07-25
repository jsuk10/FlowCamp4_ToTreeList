import 'package:flutter/material.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import "package:flutter_localizations/flutter_localizations.dart";

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _selectedDate = new DateTime.now();

  @override
  void initState() {
    super.initState();
    _resetSelectedDate();
  }

  void _resetSelectedDate() {
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF333A47),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Calendar Timeline',
                style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.tealAccent[100]),
              ),
            ),
            CalendarTimeline(
              showYears: true,
              initialDate: _selectedDate,
              // firstDate: DateTime.now(),
              firstDate: new DateTime.utc(2021),
              lastDate: new DateTime.utc(2040),
              onDateSelected: (date) {
                setState(() {
                  _selectedDate = date;
                });
              },
              leftMargin: 20,
              monthColor: Colors.white70,
              dayColor: Colors.teal[200],
              dayNameColor: Color(0xFF333A47),
              activeDayColor: Colors.white,
              activeBackgroundDayColor: Colors.redAccent[100],
              dotsColor: Color(0xFF333A47),
              selectableDayPredicate: (date) => date.day != 23,
              locale: 'ko',
            ),
            SizedBox(height: 20),
            // 안에 들어갈 텍스트
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: TextButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.teal[200])),
                child: Text('RESET', style: TextStyle(color: Color(0xFF333A47))),
                onPressed: () => setState(() => _resetSelectedDate()),
              ),
            ),
            SizedBox(height: 20),
            Center(child: Text('텍스트가 들어갈 공간 $_selectedDate', style: TextStyle(color: Colors.white)))
          ],
        ),
      ),
    );
  }
}