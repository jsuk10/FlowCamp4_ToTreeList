import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:rive/rive.dart';

class TestImg extends StatefulWidget {


  @override
  _TestImgstat createState() => _TestImgstat();
}

class _TestImgstat extends State<TestImg> {
  late RiveAnimationController _controller;
  Artboard? _artboard;
  var count = 0;

  void _togglePlay() => _controller.isActive = !_controller.isActive;

  void _onSucess() {
    if (_artboard != null) {

      if(count==1){
        _artboard!.artboard.removeController(_controller);
        _artboard!.addController(SimpleAnimation('FourToThree'));
        count++;
      }
      else if(count==2){
        _artboard!.artboard.removeController(_controller);
        _artboard!.addController(SimpleAnimation('ThreeToTwo'));
        count++;
      }
      else if(count==3){
        _artboard!.artboard.removeController(_controller);
        _artboard!.addController(SimpleAnimation('TwoToOne'));
        count++;
      }
      else if(count==4){
        _artboard!.artboard.removeController(_controller);
        _artboard!.addController(SimpleAnimation('OneToTwo'));
        count++;
      }
      else if(count==5){
        _artboard!.artboard.removeController(_controller);
        _artboard!.addController(SimpleAnimation('TwoToThree'));
        count++;
      }
      else if(count==6){
        _artboard!.artboard.removeController(_controller);
        _artboard!.addController(SimpleAnimation('ThreeToFour'));
        count++;
      }
      else if(count==7){
        _artboard!.artboard.removeController(_controller);
        _artboard!.addController(SimpleAnimation('ToFall'));
        count++;
      }
      else if(count==8){
        _artboard!.artboard.removeController(_controller);
        _artboard!.addController(SimpleAnimation('ToWinter'));
        count++;
      }
      else if(count==9){
        _artboard!.artboard.removeController(_controller);
        _artboard!.addController(SimpleAnimation('FallToWinter'));
        count++;
      }
      else{
        count++;
        _artboard!.artboard.removeController(_controller);
        _artboard!.addController(SimpleAnimation('MoveUp'));
      }
      Future.delayed(const Duration(milliseconds: 1500), () {
        _Wind();
      });
    }
  }

  void _Wind(){
    _artboard!.artboard.removeController(_controller);
    _artboard!.addController(SimpleAnimation('Wind'));
  }

  void _onInit(Artboard artboard) {
    _artboard = artboard;
  }

  @override
  void initState() {
    super.initState();
    _loadRiveFile();
  }

  void _loadRiveFile() async {
    _controller = SimpleAnimation('Idle');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: GestureDetector(
            onTap: _onSucess,
              child: RiveAnimation.asset(
                'assets/cloud.riv',
                onInit: _onInit,
                fit: BoxFit.cover,
                controllers: [_controller],
      ),

    )));
  }
}
