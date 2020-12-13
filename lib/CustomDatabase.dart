import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

class CustomData extends StatefulWidget {
  CustomData({this.app});
  final FirebaseDatabase app;
  @override
  _CustomDataState createState() => _CustomDataState();
}

class _CustomDataState extends State<CustomData> {
  final referenceDatabase = FirebaseDatabase.instance;
  final movieName = 'MovieTitle';
  final movieController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final ref = referenceDatabase.reference();
    return Scaffold(
      appBar: AppBar(title: Text('Movies that I love')),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Center(
            child: Container(
              color: Colors.green,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Text(movieName),
                  TextField(
                    controller: movieController),
                  FlatButton(
                    color: Colors.grey,
                    onPressed: (){
                    ref.child('books')
                        .push()
                        .child(movieName)
                        .set(movieController.text)
                        .asStream();
                  },)
                ],
              )
            ),
          )
        ],
      )),
    );
  }
}
