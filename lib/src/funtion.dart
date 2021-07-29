import 'dart:ui';
import 'package:my_app/models/todo_model.dart';


///현재 날짜를 입력해서 정해진 형식을 뽑아옴
String getNowDate(DateTime now) {
  String year = now.year.toString();
  var month = (now.month < 10) ? ".0" : ".";
  month += now.month.toString();
  var day = (now.day < 10) ? ".0" : ".";
  day += now.day.toString();
  return year + month + day;
}

Color stringtoColor(Todo todo) {
  String valueString =
  todo.color?.split('(0x')[1].split(')')[0]; // kind of hacky..
  int value = int.parse(valueString, radix: 16);
  return new Color(value);
}
Color codeToColor(String color) {
  String valueString = color;
  int value = int.parse(valueString, radix: 16);
  return new Color(value);
}

int getSeason(DateTime now){
  var season = (now.month) ~/ 3;
  if(season == 0)
    season = 4;
  return season;
}