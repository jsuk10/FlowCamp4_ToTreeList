import 'dart:async';

class Bloc{
  final _dateController = StreamController<double?>.broadcast();
  final _todayController = StreamController<double?>.broadcast();

  get savedStream => _dateController.stream;
  get todayStream => _todayController.stream;

  changeTreeFromHeart(double? percent){
    _todayController.sink.add(percent);
  }

  changeTreeFromClick(double? percent){
    _dateController.sink.add(percent);
  }

  dispose(){
    _dateController.close();
    _todayController.close();
  }
}
var bloc = Bloc();