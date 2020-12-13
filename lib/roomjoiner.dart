import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/roomlobby.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

class RoomJoiner extends StatefulWidget {
  @override
  _RoomJoinerState createState() => _RoomJoinerState();
}

class _RoomJoinerState extends State<RoomJoiner> {
  final _creatorFormKey = GlobalKey<FormState>();
  final database = FirebaseDatabase.instance;
  String username = "";
  String roomName = "";
  String genre = "";
  String enteredCode;
  String retrievedData = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Moviepicker room creator'),
      ),
      body: SingleChildScrollView(
          child: Column(children: <Widget>[
        //Text("Create a room"),
        Container(
            margin: EdgeInsets.all(20),
            child: Form(
              key: _creatorFormKey,
              child: Column(
                children: <Widget>[
                  usernameField(),
                  codeInputField(),
                  joinButton(),
                ],
              ),
            )),
      ])),
    );
  }

  TextFormField usernameField() {
    return TextFormField(
        decoration: InputDecoration(hintText: 'Enter username'),
        validator: (value) {
          if (value.isEmpty) {
            return 'Name cannot be empty';
          }
          else{
            username = value;
          }
          return null;
        });
  }

  TextFormField codeInputField() {

    bool _isSixDigits(String str) {
      if (str == null || str.contains('.') || str.length != 6) {
        return false;
      }
      return double.tryParse(str) != null;
    }

    return TextFormField(
        decoration:
            InputDecoration(hintText: 'Enter 6-digit code to join a room'),
        validator: (value) {

          if (value.isEmpty) {
            return 'Name cannot be empty';
          }
          if (!_isSixDigits(value)) {
            return 'Please enter 6 digits code';
          }
          if (retrievedData.toString() == "null"){
            retrievedData = "";
            return 'Room does not exist';
          }
          enteredCode = value;
          return null;
        });
  }

  ElevatedButton joinButton(){
    return ElevatedButton(
      onPressed: () async {
        if (_creatorFormKey.currentState.validate()) {
            checkExist();
        }
      },
      child: Text('Create'),
    );
  }

  Future checkExist() async{
    final db = database.reference();
    db.child('rooms').child(enteredCode).once().then((DataSnapshot snapshot) async{
      retrievedData = snapshot.value.toString();
      _creatorFormKey.currentState.validate();

      //Navigate to room lobby if code found
      if(retrievedData != ""){
        roomName = snapshot.value['roomname'] as String;
        genre = snapshot.value['genre'] as String;
        int code = int.parse(snapshot.key);

        Navigator.push(
          context,
            MaterialPageRoute(builder: (context) => RoomLobby(
              username: username,
              roomName: roomName,
              genre: genre,
              code: code,
        ))
        );
      }
      return retrievedData;
    });
  }
}




