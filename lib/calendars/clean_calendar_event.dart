import 'package:flutter/material.dart';

class CleanCalendarEvent {
  String summary;
  bool isDone;

  CleanCalendarEvent(
      this.summary,
      {this.isDone = false});
}