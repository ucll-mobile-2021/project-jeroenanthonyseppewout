import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/roomcreator.dart';
import 'package:movies_app/roomjoiner.dart';
import 'package:movies_app/startscreen.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

class ResultScreen extends StatefulWidget {
  String code;

  ResultScreen({Key key, @required this.code}) : super(key: key);
  @override
  _ResultScreenState createState() => _ResultScreenState(code);
}

class _ResultScreenState extends State<ResultScreen> {
  String code;
  List results = [];
  bool isProgressVisible = true;
  int playerAmount = 1000;
  double progress = 0;
  int resultsIn = 0;
  int previousResultsIn = 0;
  int stackNum = 5;
  String multiWinnerText = "Grab some popcorn and enjoy!";
  final GlobalKey<AnimatedListState> _key = GlobalKey();
  final database = FirebaseDatabase.instance;
  String winTitle = ".";
  String winDescription = ".";
  String winImage = "https://images-na.ssl-images-amazon.com/images/I/21MzLY2IHBL._SX331_BO1,204,203,200_.jpg";
  String winVoteCount;
  Timer timer;
  bool alreadyCalled = false;
  Color col = Color(0xff123456);

  _ResultScreenState(String code) : this.code = code;

  @override
  Widget build(BuildContext context) {
    //Roep listAdder functie elke second op
    if(!alreadyCalled){
      const oneSecond = const Duration(seconds: 1);
      timer = Timer.periodic(oneSecond, (Timer t) => dataStream());
      alreadyCalled = true;
    }
   /* const oneSecond = const Duration(seconds: 1);
    Timer.periodic(oneSecond, (Timer t) => dataStream());*/

    return new WillPopScope(
        onWillPop: () async => false,
        child: new Scaffold(
          backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: col,
              title: Text("Results"),
              automaticallyImplyLeading: false,
            ),
            body: Center(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20),
                  Container(child: progressVisibility()),
                  Expanded(child:  Container(child: resultsVisibility())),
                  FlatButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    onPressed: () => {
                      timer.cancel(),
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                    StartScreen()), (Route<dynamic> route) => false)
                  }
                 , child: Text("home"), color: Colors.white,)
                ],
              ),
            )));
  }

  Visibility resultsVisibility() {
    return Visibility(child: resultColumn(), visible: !isProgressVisible);
  }

  Column resultColumn() {
    return Column(
      children: <Widget>[
        Container(child: Text("Winner:", style: TextStyle(fontSize: 20, color: Colors.white),)),
        Container(
          alignment: Alignment.center,
          child: winnerCard(),


        ),
      ],
    );
  }

  Card winnerCard() {
    return Card(
      color: Colors.black,
        child: Expanded(
          child: Column(
              children: <Widget>[
                Text(winTitle, style: TextStyle(color: Colors.white)),
                SizedBox(height: 20),
                Image.network(winImage,height: 320, fit: BoxFit.fill),
                SizedBox(height: 10),
                Text("$winVoteCount votes", style: TextStyle(color: Colors.white)),
                SizedBox(height: 10),
                Text(multiWinnerText, style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center)
              ]
          ),
        )

    );
  }

  void dataStream() {
    if (playerAmount == 1000) {
      getPlayerAmount();
    }

    final db = database.reference();

    db
        .child('rooms')
        .child(code)
        .child('votes')
        .once()
        .then((DataSnapshot snapshot) async {
          String str = snapshot.value.toString().replaceAll(new RegExp("[a-zA-Z]"), "").replaceAll(": ", "").replaceAll("{", "").replaceAll("}", "");

          
      List retrievedData = str
          .replaceAll("[[", "")
          .replaceAll("]]", "")
          .split("], [");
      resultsIn = retrievedData.length;
      if (retrievedData.length == playerAmount) {
        timer.cancel();
        calculateWinner(retrievedData);
        setState(() {
          isProgressVisible = false;
        });
        playerAmount = 0;
      }
      if (resultsIn != previousResultsIn) {
        setState(() {
          progress = playerAmount != 0 ? resultsIn / playerAmount : 100;
        });
        previousResultsIn = resultsIn;
      }
    });
  }

  void calculateWinner(List retrievedData) async {
    List finalResults = [];
    retrievedData = retrievedData
        .toString()
        .replaceAll("[", "")
        .replaceAll("]", "")
        .replaceAll(" ", "")
        .split(",");
    int tempTotal = 0;

    for (int i = 0; i < stackNum; i++) {
      tempTotal = 0;
      for (int j = 0; j < playerAmount; j++) {
        tempTotal += int.parse(retrievedData[j * stackNum + i]);
      }
      finalResults.add(tempTotal);
    }

    int maxValue = 0;
    List maxList = [];
    for (int i = 0; i < finalResults.length; i++) {
      if (finalResults[i] >= maxValue) {
        if (finalResults[i] > maxValue) {
          maxList = [];
          maxValue = finalResults[i];
        }
        maxList.add(i);
      }
    }
    winVoteCount = maxValue.toString();

    final db = database.reference();

    await db
        .child('rooms')
        .child(code)
        .child('movielist')
        .child(maxList[0].toString())
        .once()
        .then((DataSnapshot snapshot) async {
      setState(() {

        if(maxValue == 0){
          winTitle = "There is no winner. No movies got any votes.";
          multiWinnerText = "Maybe try again with another genre?";
        }
        else {
          winTitle = snapshot.value['title'].toString();
          winImage = snapshot.value['image'].toString();
          winDescription = snapshot.value['description'].toString();

          if(maxList.length > 1){
            multiWinnerText = "There were multiple winners. \n we randomly picked this movie from the winners to watch. Enjoy!";
          }
        }
      });
    });

    Future.delayed(const Duration(milliseconds: 2000), () {
      db.child('rooms').child(code).remove();
    });
  }

  void getPlayerAmount() async {
    final db = database.reference();

    await db
        .child('rooms')
        .child(code)
        .child('members')
        .once()
        .then((DataSnapshot snapshot) async {
      List retrievedData = snapshot.value.toString().split(",");
      playerAmount = retrievedData.length;
    });
  }

  Visibility progressVisibility() {
    return Visibility(
        child: progressColumn(), visible: isProgressVisible, key: _key);
  }

  Column progressColumn() {
    return Column(
      children: <Widget>[
        Text("LIVE", style: TextStyle(color: Colors.red)),
        SizedBox(height: 10),
        Container(child: Text("Waiting for all players to finish swiping", style: TextStyle(color: Colors.white))),
        Container(
          alignment: Alignment.center,
          height: 30,
          width: 300,
          child: progressIndicator(),
        ),
        Container(
          child: Text("Progress:  ${(progress * 100).round()}%", style: TextStyle(color: Colors.white)),
        )
      ],
    );
  }

  LinearProgressIndicator progressIndicator() {
    return LinearProgressIndicator(
      value: progress,
    );
  }

  Stream<String> get resultData async* {
    for (int i = 0; i < 20; i++) {
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        isProgressVisible = !isProgressVisible;
      });
    }
  }
}
