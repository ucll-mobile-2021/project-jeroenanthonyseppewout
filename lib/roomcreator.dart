import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:movies_app/roomlobby.dart';

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
  int code;
  List movieNumbers = [];
  List<List> movieList = [];
  Color col = Color(int.parse("#4a3dbf".substring(1, 7), radix: 16) + 0xFF000000);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Create a room to start swiping', style: TextStyle(color: Colors.white),),
        backgroundColor: col,
      ),
      body: SingleChildScrollView(
          child: Column(
              children: <Widget>[
            Card(
              color: Colors.black,
              margin: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 0),
              child:  Container(
                  margin: EdgeInsets.only(top: 20, bottom: 40, left: 50, right: 50),
                  child: Form(
                    key: _creatorFormKey,
                    child: Column(
                      children: <Widget>[
                        usernameField(),
                        roomNameField(),
                        SizedBox(height: 10),
                        Row(
                            children: <Widget>[
                              Text("Select a genre:     ", style: TextStyle(color: Colors.white, fontSize: 17),),
                              categoryPicker(),
                            ],
                          ),
                        SizedBox(height: 20),
                        createButton(),
                      ],
                    ),
                  )),
            )
        //Text("Create a room"),

      ])),
    );
  }

  TextFormField usernameField() {
    return TextFormField(
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(hintText: 'Enter username', hintStyle: TextStyle(color: Colors.grey)),
        validator: (value) {
          if (value.isEmpty) {
            return 'Username cannot be empty';
          }
          if (value.contains(" ") || value.contains(",") || value.contains("\"") || value.contains(";") || value.contains("\'")) {
            return 'Username contains invalid characters';
          }
          else{
            username = value;
          }
          return null;
        });
  }

  TextFormField roomNameField() {
    return TextFormField(
      style: TextStyle(color: Colors.white),
        decoration: InputDecoration(hintText: 'Enter room name', hintStyle: TextStyle(color: Colors.grey)),
        validator: (value) {
          if (value.isEmpty) {
            return 'Room name cannot be empty';
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
      dropdownColor: col,
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
            child: new Text(value, style: TextStyle(color: Colors.white),),
          );
        }).toList(),
    );
  }

  FlatButton createButton() {
    return FlatButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0), side: BorderSide(color: col)),
      minWidth: 200,
      height: 40,
      color: Colors.white,
      onPressed: () {
        if (_creatorFormKey.currentState.validate()) {

          //code genereren
          Random random = new Random();
          code = random.nextInt(899999) + 100000;

          //gegevens in db
          final db = database.reference();
          db.child('rooms').child(code.toString()).child("roomname").set(roomName);
          db.child('rooms').child(code.toString()).child("creator").set(username);
          db.child('rooms').child(code.toString()).child("genre").set(genre.toLowerCase());
          db.child('rooms').child(code.toString()).child("members").set(username);

          //5 random movie ID's kiezen
          int randomNumber;
          while(movieNumbers.length < 9){
            randomNumber = random.nextInt(9) + 1;
            if(!movieNumbers.contains(randomNumber)){
              movieNumbers.add(randomNumber);
            }
            if(movieNumbers.length ==9){

              //lijst van movies creeren uit random ID's en in database zetten
              goToMovieSwiper();
            }
          }
        }
      },
      child: Text('Create', style: TextStyle(fontSize: 17),),
      textColor: col,
    );
  }

  void goToMovieSwiper() async{

    movieList = await createMovieList();

    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RoomLobby(
            username: username,
            roomName: roomName,
            genre: genre.toLowerCase(),
            code: code.toString(),
            playerNumber: "AAAAA",
            movieList: movieList))
    );

  }

  Future<List> createMovieList() async{
    final db = database.reference();
    var test = [];

    for(int i = 0; i < movieNumbers.length; i++){

      await
      db.child('movies').child(genre.toLowerCase()).child(movieNumbers[i].toString()).once().then((DataSnapshot snapshot) async{
        DataSnapshot data = snapshot;

        db.child('rooms').child(code.toString()).child('movielist').child(i.toString()).child('id').set(data.key);
        db.child('rooms').child(code.toString()).child('movielist').child(i.toString()).child('title').set(data.value['title']);
        db.child('rooms').child(code.toString()).child('movielist').child(i.toString()).child('description').set(data.value['description']);
        db.child('rooms').child(code.toString()).child('movielist').child(i.toString()).child('image').set(data.value['image']);

        movieList.add([data.key, data.value['title'], data.value['description'], data.value['image']]);
      });
    }
    return movieList;
  }

}
