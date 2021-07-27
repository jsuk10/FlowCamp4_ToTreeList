
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

const riveFile = 'assets/bookmark.riv';

class HomePage2 extends StatefulWidget {
  @override
  _HomePageState2 createState() => _HomePageState2();
}

class _HomePageState2 extends State<HomePage2> {
  bool darkTheme = false;
  Artboard? _artboard;
  late RiveAnimationController _animationController;

  @override
  void initState() {
    _loadRiveFile();
    super.initState();
  }

  void _loadRiveFile() async {
    _animationController = darkTheme
        ? _animationController = SimpleAnimation('dark')
        : _animationController = SimpleAnimation('light');
  }

  void _onSucess() {
    if (_artboard != null) {
      _artboard!.artboard.removeController(_animationController);
      _artboard!.addController(darkTheme
          ? SimpleAnimation('Mark')
          : SimpleAnimation('Mark'));
    }
  }

  void _onInit(Artboard artboard) {
    _artboard = artboard;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkTheme ? null : Colors.blue,
      body: Center(
        child: RiveAnimation.asset(
          riveFile,
          onInit: _onInit,
          controllers: [_animationController],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: _onSucess,
      ),
    );
  }
}