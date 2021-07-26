//클래스의 상태를 바꿔줌.
//이 스테이트가 바뀔때마다 빌드 되게 함.
import 'package:english_words/english_words.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'saved.dart';
import 'bloc/Bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'RandomWord.dart';

class RandomWordState extends State<RandomWords> {
  final List<WordPair> _suggestion = <WordPair>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Naming"), actions: <Widget>[
        //아이콘 버튼
        IconButton(
          icon: Icon(Icons.list),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => SavedList()))
                .then((value) {
              setState(() {
                _bulidList();
              });
            });
          },
        )
      ]),
      //안드로이드 어답터랑 동일
      body: _bulidList(),
    );
  }

  Widget _bulidList() {
    return StreamBuilder<Set<WordPair>>(
        stream: bloc.savedStream,
        builder: (context, snapshot) {
          return ListView.builder(itemBuilder: (context, index) {
            //홀수에 각각 구분점 삽
            if (index.isOdd) {
              return Divider();
            }
            var realIndex = index ~/ 2;
            if (realIndex >= _suggestion.length) {
              _suggestion.addAll(generateWordPairs().take(10));
            }
            if (snapshot.data == null)
              return _buildRow(new Set<WordPair>(), _suggestion[realIndex]);
            else
              return _buildRow(snapshot.data!, _suggestion[realIndex]);
          });
        });
  }

  Widget _buildRow(Set<WordPair> saved, WordPair pair) {
    final bool alreadySaved = saved.contains(pair);

    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: ListTile(
        title: Text(
          pair.asPascalCase,
          textScaleFactor: 1.5,
        ),
        trailing: Icon(!alreadySaved ? Icons.favorite_border : Icons.favorite,
            color: Colors.pink),
        onLongPress: () => FlutterDialog(pair),
        onTap: () {
          //이 함수가 호출되면 안의 함수를 실행하고 함수를 재 실행 해준다.
          bloc.addToOrRemoveFromSavedList(pair);
        },
      ),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            setState(() {
              _suggestion.remove(pair);
            });
          },
        ),
      ],
    );
  }

  void FlutterDialog(WordPair pair) {
    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Column(
              children: <Widget>[
                new Text("4/7"),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                    decoration: InputDecoration(hintText: pair.asPascalCase)),
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text("확인"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
