import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

class RoomLobby extends StatefulWidget{
  String username;
  String roomName;
  String genre;
  int code;
  RoomLobby({Key key, @required this.username, @required this.roomName, @required this.code, @required this.genre}) : super(key: key);
  @override
  _RoomLobbyState createState() => _RoomLobbyState(username, roomName, code, genre);
}

class _RoomLobbyState extends State<RoomLobby> {
  String username = "e";
  String roomName = "e";
  String genre = "e";
  int code = 0;
  List<String> participants = ["test","test2","test2","test2","test2","test2","test2","test2"];

  _RoomLobbyState(String username, String roomName, int code, String genre) :
        this.username = username,
        this.roomName = roomName,
        this.genre = genre,
        this.code = code;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Room lobby"),
      ),
      body: lobbyStream(),
    );
  }

  StreamBuilder<List<String>> lobbyStream(){
    return StreamBuilder<List<String>>(
        stream: participantNames,
        builder: (context, snapshot){
          List<String> participantData = snapshot.data;
          return ListView.separated(
              itemCount: participants.length,
              itemBuilder: (BuildContext context, int index){
                return Text("test");
              },
              separatorBuilder: (context, index) => Divider(),
              );
    });
  }

  Stream<List<String>> get participantNames async*{
    for(var i = 0; i < participants.length; i++){
      await Future.delayed(Duration(seconds: 1));
      yield participants.sublist(0, i + 1);
    }

  }


}
