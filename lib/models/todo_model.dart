import 'package:flutter/material.dart';

class Todo {
  dynamic id;
  dynamic name;
  dynamic date;
  dynamic state;
  dynamic color;

  Todo(
      {this.id,
      required this.name,
      required this.date,
      this.state = 0,
      this.color = Colors.white});

  @override
  toString() => name;
}
