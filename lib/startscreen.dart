import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/roomcreator.dart';
import 'package:movies_app/roomjoiner.dart';

import 'infoScreen.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  Color col = Color(int.parse("#4a3dbf".substring(1, 7), radix: 16) + 0xFF000000);
  Color col2 = Color(int.parse("#2b2a2e".substring(1, 7), radix: 16) + 0xFF000000);


  @override
  Widget build(BuildContext context) {
    String infoText = "Together with friends for a movienight and no inspiration what to watch? Movie Time can help you! "
        "\n\nCreate a virtual room, pick a genre and let your friends join with the code. Swipe through the list of movies we generated for you and pick your favorites. "
        "\n\nThe winner will be the one with the most votes."
        "\n\nclick 'Read more' for more technical information about this app.";

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Welcome", textAlign: TextAlign.center),
        backgroundColor: col,
      ),
        body: SingleChildScrollView(
            child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 30, bottom: 20),
                    child: ListTile(
                      title: Image.asset("images/logo.png", height: 100,)
                      //Text("Movie picker", textAlign: TextAlign.center, style: TextStyle(
                          //fontWeight: FontWeight.bold, color: col, fontSize: 40)),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
                    child: FlatButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                      child: Text('Create a room', style: TextStyle(fontSize: 17)),
                      color: col,
                      textColor: Colors.white,
                      height: 50,
                      minWidth: 200,
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0), side: BorderSide(color: col)),
                      child: Text('Join a room', style: TextStyle(color: col, fontSize: 17)),
                      color: Colors.white,
                      textColor: Colors.blueAccent,
                      height: 50,
                      minWidth: 200,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RoomJoiner()),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    child: FlatButton(
                      child: Text('How does it work?', textAlign: TextAlign.center, style: TextStyle(
                          color: Colors.blue, fontSize: 17)),
                      onPressed: (){
                        showDialog(
                            context: context,
                            child: AlertDialog(
                              title: Text("How does Movie Time work?", textAlign: TextAlign.center),
                              content: Text(infoText),
                              actions: [
                                close(),
                                readMore()
                              ],
                            ));
                      },
                    ),
                  ),
        ])),
    );

  }

  FlatButton close(){
    return FlatButton(
        onPressed: (){ Navigator.pop(context);},
        child: Text("Close", style: TextStyle(color: Colors.blue)));
  }

  FlatButton readMore(){
    return FlatButton(
        onPressed: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => InfoScreen()),
        );
        },
        child: Text("Read more", style: TextStyle(color: Colors.blue)));

  }
}
