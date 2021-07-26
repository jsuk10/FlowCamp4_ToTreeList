import 'package:flutter/material.dart';

import 'package:my_app/db_helper.dart';
import 'package:my_app/models/todo_model.dart';
import 'dart:math';


List<Dog> dogs = [
  Dog(name: '푸들이', id: null),
  Dog(name: '삽살이', id: null),
  Dog(name: '말티말티', id: null),
  Dog(name: '강돌이', id: null),
  Dog(name: '진져', id: null),
  Dog(name: '백구', id: null),
];

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Dog Database'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: FutureBuilder(
          future: DBHelper().getAllDogs(),
          builder: (BuildContext context, AsyncSnapshot<List<Dog>> snapshot) {

            if(snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  Dog item = snapshot.data![index];
                  return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      DBHelper().deleteDog(item.id);
                      setState(() {});
                    },
                    child: Center(child: Text(item.name)),
                  );
                },
              );
            }
            else
            {
              return Center(child: CircularProgressIndicator(),);
            }
          },
        ),

        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FloatingActionButton(
              child: Icon(Icons.refresh),
              onPressed: () {
                DBHelper().deleteAllDogs();
                setState(() {});
              },
            ),
            SizedBox(height: 8.0),
            FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Dog dog = dogs[Random().nextInt(dogs.length)];
                DBHelper().createData(dog);
                setState(() {});
              },
            ),
          ],
        )

    );
  }
}