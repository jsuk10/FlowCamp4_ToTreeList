import 'dart:async';

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
    return _CalendarScreenState(events, donePer);
  }
}

//여기서 todo data 보여줌
class _CalendarScreenState extends State<CalendarScreen> {
  Map<String, double> _events = {};
  double _donePer = 0;

  late RiveAnimationController _controller;
  Artboard? _artboard;
  double gotPer = 0;

  _CalendarScreenState(Map<String, double> events, double donePer) {
    this._events = events;
    this._donePer = donePer;
  }

  @override
  void initState() {
    super.initState();
    // Force selection of today on first load, so that the list of today's events gets shown.
    _handleNewDate(getNowDate(DateTime.now()));
    _loadRiveFile();
  }

  void _ActiveAnimation(double? percent) {
    debugPrint(percent.toString());
    if (_artboard != null) {
      if (percent! < 20) {
        percent = percent - 10;
        if (percent == 1.0) {
          _artboard!.artboard.removeController(_controller);
          _artboard!.addController(SimpleAnimation('ToFourSpring'));
        } else if (percent >= 0.75) {
          _artboard!.artboard.removeController(_controller);
          _artboard!.addController(SimpleAnimation('ToThreeSpring'));
        } else if (percent >= 0.5) {
          _artboard!.artboard.removeController(_controller);
          _artboard!.addController(SimpleAnimation('ToTwoSpring'));
        } else if (percent >= 0.25) {
          _artboard!.artboard.removeController(_controller);
          _artboard!.addController(SimpleAnimation('ToOneSpring'));
        } else {
          _artboard!.artboard.removeController(_controller);
          _artboard!.addController(SimpleAnimation('ToZeroSpring'));
        }
      } else if (percent < 30) {
        percent = percent - 20;
        if (percent == 1.0) {
          _artboard!.artboard.removeController(_controller);
          _artboard!.addController(SimpleAnimation('ToFourSummer'));
        } else if (percent >= 0.75) {
          _artboard!.artboard.removeController(_controller);
          _artboard!.addController(SimpleAnimation('ToThreeSummer'));
        } else if (percent >= 0.5) {
          _artboard!.artboard.removeController(_controller);
          _artboard!.addController(SimpleAnimation('ToTwoSummer'));
        } else if (percent >= 0.25) {
          _artboard!.artboard.removeController(_controller);
          _artboard!.addController(SimpleAnimation('ToOneSummer'));
        } else {
          _artboard!.artboard.removeController(_controller);
          _artboard!.addController(SimpleAnimation('ToZeroSummer'));
        }
      } else if (percent < 40) {
        percent = percent - 30;
        if (percent == 1.0) {
          _artboard!.artboard.removeController(_controller);
          _artboard!.addController(SimpleAnimation('ToFourFall'));
        } else if (percent >= 0.75) {
          _artboard!.artboard.removeController(_controller);
          _artboard!.addController(SimpleAnimation('ToThreeFall'));
        } else if (percent >= 0.5) {
          _artboard!.artboard.removeController(_controller);
          _artboard!.addController(SimpleAnimation('ToTwoFall'));
        } else if (percent >= 0.25) {
          _artboard!.artboard.removeController(_controller);
          _artboard!.addController(SimpleAnimation('ToOneFall'));
        } else {
          _artboard!.artboard.removeController(_controller);
          _artboard!.addController(SimpleAnimation('ToZeroFall'));
        }
      } else if (percent < 50) {
        percent = percent - 40;
        if (percent == 1.0) {
          _artboard!.artboard.removeController(_controller);
          _artboard!.addController(SimpleAnimation('ToFourWinter'));
        } else if (percent >= 0.75) {
          _artboard!.artboard.removeController(_controller);
          _artboard!.addController(SimpleAnimation('ToThreeWinter'));
        } else if (percent >= 0.5) {
          _artboard!.artboard.removeController(_controller);
          _artboard!.addController(SimpleAnimation('ToTwoWinter'));
        } else if (percent >= 0.25) {
          _artboard!.artboard.removeController(_controller);
          _artboard!.addController(SimpleAnimation('ToOneWinter'));
        } else {
          _artboard!.artboard.removeController(_controller);
          _artboard!.addController(SimpleAnimation('ToZeroWinter'));
        }
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
    debugPrint(gotPer.toString());
    if (_donePer == 1.0) {
      _controller = SimpleAnimation('ToFourSummer');
    } else if (_donePer >= 0.75) {
      _controller = SimpleAnimation('ToThreeSummer');
    } else if (_donePer >= 0.5) {
      _controller = SimpleAnimation('ToTwoSummer');
    } else if (_donePer >= 0.25) {
      _controller = SimpleAnimation('ToOneSummer');
    } else {
      _controller = SimpleAnimation('ToZeroSummer');
    }
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
          if (snapshot.data != null) {
            _ActiveAnimation(snapshot.data);
          }
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
                            opacity: (snapshot.data != null)
                                ? snapshot.data as double
                                : opicty,
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
                      Icons.keyboard_backspace,
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
        });
  }

  Future<void> _handleNewDate(date) async {
    gotPer = await DBHelper().getPer(getNowDate(DateTime.now()));
  }
}
