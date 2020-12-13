import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/roomcreator.dart';
import 'package:movies_app/roomjoiner.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to moviepicker'),
      ),
        body: Center(
            child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(20),
                    child: FlatButton(
                      child: Text('Create a room'),
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RoomCreator()),
                        );
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
                    child: FlatButton(
                      child: Text('Join a room'),
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RoomJoiner()),
                        );
                      },
            ),
          ),
        ])),
    );
  }
}
