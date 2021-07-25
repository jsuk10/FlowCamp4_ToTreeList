import 'package:flutter/material.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import "package:flutter_localizations/flutter_localizations.dart";
import 'calendar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ko', 'KR'),  
        const Locale('en', 'US')  
      ],
      home: Calendar(),
    );
  }
}