import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/roomcreator.dart';
import 'package:movies_app/roomjoiner.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

class InfoScreen extends StatefulWidget {
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  Color col = Color(int.parse("#4a3dbf".substring(1, 7), radix: 16) + 0xFF000000);
  Color col2 = Color(int.parse("#2b2a2e".substring(1, 7), radix: 16) + 0xFF000000);


  @override
  Widget build(BuildContext context) {
    String infoText = "Together with friends for a movienight and no inspiration \nwhat to watch? Movie Time can help you! "
        "\n\nCreate a virtual room, pick a genre and let your friends join with the code. Swipe through the list of movies we generated for you and pick your favorites. "
        "\n\nThe winner will be the one with the most votes.";

    String dataBaseInfo = "Movie Time uses a Realtime Database instance of Google's Firebase. \n\nThe database stores rooms and and a predefined set of movies from each category."
        "Rooms are identified with their 6-digit room code and are deleted after playing. Player information is never stored directly in the database, only in function of a room.";

    String realTimeInfo = "The Roomlobby gets realtime information about it's player. Whenever a player joins or leaves a room, this information is updated directly on all other room members. "
        "\n\nBoth the Roomlobby and the Resultscreen make use of Streams to continuously get information about updates in the database.";

    String QRInfo = "Movie Time uses the Flutter package qr_flutter to read and create QR codes.";

    String extraInfo = "Movie Time is created by Jeroen Verheyden, Anthony Van Roost, Seppe Lenaerts and Wout Van Kerkhoven.";

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("About Movie Time", textAlign: TextAlign.center),
        backgroundColor: col,
      ),
      body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                Image.asset("images/logo.png"),
                SizedBox(height: 20),
                Divider(
                  color: Colors.black,
                  height: 1,
                ),
                SizedBox(height: 10),
                Text("Database", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.justify,),
                SizedBox(height: 5),
                Text(dataBaseInfo, style: TextStyle(color: Colors.grey), textAlign: TextAlign.justify,),
                SizedBox(height: 40),
                Text("Realtime updates", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.justify,),
                SizedBox(height: 5),
                Text(realTimeInfo, style: TextStyle(color: Colors.grey), textAlign: TextAlign.justify,),
                SizedBox(height: 40),
                Text("QR code scanner", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.justify,),
                SizedBox(height: 5),
                Text(QRInfo, style: TextStyle(color: Colors.grey), textAlign: TextAlign.justify),
                SizedBox(height: 40),
                Text("Authors", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.justify,),
                SizedBox(height: 5),
                Text(extraInfo, style: TextStyle(color: Colors.grey), textAlign: TextAlign.justify),
                SizedBox(height: 20),
              ],
            ),
          )
          ),
    );

  }

}
