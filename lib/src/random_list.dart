import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'bloc/Bloc.dart';
import 'package:rive/rive.dart';

import 'saved_list.dart';

const riveFile = 'assets/bookmark.riv';

class RandomList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RandomListState();
  }
}

class _RandomListState extends State<RandomList> {
  final List<WordPair> _suggestions = <WordPair>[];
  final Set<WordPair> _saved = Set<WordPair>();
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
    final randomWord = WordPair.random();
    return Scaffold(
      appBar: AppBar(
        title: Text("naming app"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) =>
                      SavedList(saved: _saved,))
              ).then((value) {
                setState(() {
                  _buildList();
                });
              });
            },
          )
        ],

      ),
      body: _buildList(),
    );
  }

  Widget _buildList() {
    return ListView.builder(itemBuilder: (context, index) {
      if (index.isOdd) {
        return Divider();
      }

      var realIndex = index ~/ 2;

      if (realIndex >= _suggestions.length) {
        _suggestions.addAll(generateWordPairs().take(10));
      }

      return _buildRow(_suggestions[realIndex]);
    });
  }

  Widget _buildRow(WordPair pair) {
    final bool alreadySaved = _saved.contains(pair);

    return ListTile(
      title: Text(
        pair.asPascalCase,
        textScaleFactor: 1.5,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: Colors.pink,
      ),
      //body: RiveAnimation.asset(riveFile,
        //onInit: _onInit,
        //controllers: [_animationController],),

      onTap: () {
        setState(() {
          _onSucess();
          if (alreadySaved)
            _saved.remove(pair);
          else
            _saved.add(pair);

          print(_saved.toString());
        });
      },
    );
  }
}
