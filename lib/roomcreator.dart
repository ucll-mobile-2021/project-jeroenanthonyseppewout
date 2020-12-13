import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:movies_app/roomlobby.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

class RoomCreator extends StatefulWidget {
  @override
  _RoomCreatorState createState() => _RoomCreatorState();
}

class _RoomCreatorState extends State<RoomCreator> {
  final _creatorFormKey = GlobalKey<FormState>();
  final database = FirebaseDatabase.instance;
  String username = "";
  String roomName = "";
  String genre = "Action";

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
                  roomNameField(),
                  Text("Select a genre"),
                  categoryPicker(),
                  createButton(),
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

  TextFormField roomNameField() {
    return TextFormField(
        decoration: InputDecoration(hintText: 'Enter room name'),
        validator: (value) {
          if (value.isEmpty) {
            return 'Name cannot be empty';
          }
          else{
            roomName = value;
          }
          return null;
        });
  }

  DropdownButton categoryPicker(){
    String selectedCategory;
    return DropdownButton<String>(
        //hint: Text('Choose a genre'),
        onChanged: (String changedValue) {
          genre = changedValue;
          setState(() {
            genre;
          });
        },
        value: genre,
        items: <String>['Action', 'Comedy', 'Drama', 'Romance']
            .map((String value) {
          return new DropdownMenuItem<String>(
            value: value,
            child: new Text(value),
          );
        }).toList(),
    );
  }

  ElevatedButton createButton() {
    return ElevatedButton(
      onPressed: () {
        if (_creatorFormKey.currentState.validate()) {

          //code genereren
          Random random = new Random();
          int code = random.nextInt(899999) + 100000;

          //gegevens in db
          final db = database.reference();
          db.child('rooms').child(code.toString()).child("roomname").set(roomName);
          db.child('rooms').child(code.toString()).child("creator").set(username);
          db.child('rooms').child(code.toString()).child("genre").set(genre.toLowerCase());

          Navigator.push(
            context,
              MaterialPageRoute(builder: (context) => RoomLobby(
                  username: username,
                  roomName: roomName,
                  genre: genre,
                  code: code))
          );
        }
      },
      child: Text('Create'),
    );
  }
}
