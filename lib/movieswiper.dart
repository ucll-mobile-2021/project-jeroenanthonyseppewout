import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:movies_app/resultScreen.dart';

import 'movieswiper.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

class MovieSwiper extends StatefulWidget{
  String username;
  String code;
  List<List> movieList;
  String playerNumber;
  MovieSwiper({Key key, @required this.username, @required this.code, @required this.movieList, @required this.playerNumber}) : super(key: key);
  @override
  _MovieSwiperState createState() => _MovieSwiperState(username, code, movieList, playerNumber);
}

class _MovieSwiperState extends State<MovieSwiper> {
  String username = "e";
  String code = "e";
  List<List> movieList;
  String playerNumber;
  final database = FirebaseDatabase.instance;
  List likeList = [];
  int stackNum = 5;
  bool isVisible = false;
  String swipeDirection = "images/thumbsdown.png";
  Color swipeDirectionColor = Colors.green;
  bool isLikeVisible = false;
  Color col = Color(int.parse("#4a3dbf".substring(1, 7), radix: 16) + 0xFF000000);
  Color col2 = Color(int.parse("#404142".substring(1, 7), radix: 16) + 0xFF000000);

  _MovieSwiperState(String username, String code, List<List> movieList, String playerNumber) :
        this.username = username,
        this.code = code,
        this.movieList = movieList,
        this.playerNumber = playerNumber;

  @override
  Widget build(BuildContext context) {

    CardController controller; //Use this to trigger swap.

    return new Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 30),
            Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    swipeVisibility(),
                    Image.asset("images/logo.png", height: 50),
                    swipeVisibility(),
              ]
              )
            ),
            Expanded(
              //height: MediaQuery.of(context).size.height * 0.8,

              child: new Stack(children: <Widget>[
                new TinderSwapCard(
                  orientation: AmassOrientation.TOP,
                  totalNum: stackNum,
                  stackNum: 2,
                  swipeEdge: 4.0,
                  maxWidth: MediaQuery.of(context).size.width * 1.8,
                  maxHeight: MediaQuery.of(context).size.width * 2,
                  minWidth: 0,
                  minHeight: MediaQuery.of(context).size.width * 0.6,
                  cardBuilder: (context, index) => Card(
                      color: col2.withOpacity(0.5),
                      child: Column(
                          children: [
                            SizedBox(height: 10),
                            Text(movieList[index][1].toString(), style: TextStyle(color: Colors.white, fontSize: 20),
                                textAlign: TextAlign.center),
                            SizedBox(height: 20),
                            Expanded(
                              child: Image.network(movieList[index][3].toString(), fit: BoxFit.fitWidth, height: 350),
                            ),
                            SizedBox(height: 20),
                            Text(movieList[index][2].toString(), style: TextStyle(color: Colors.white, fontSize: 15),
                                        textAlign: TextAlign.center
                                    ),
                            SizedBox(height: 20),
                          ]
                      )
                  ),
                  cardController: controller = CardController(),
                  swipeUpdateCallback:
                      (DragUpdateDetails details, Alignment align) {
                    /// Get swiping card's alignment
                    if (align.x > -4 && align.x < 4){
                      setState(() {
                        isLikeVisible = false;
                      });
                    }
                    if (align.x < -4) {
                      setState(() {
                        swipeDirection = "images/thumbsdown.png";
                        swipeDirectionColor = Colors.red;
                        isLikeVisible = true;
                      });
                    } else if (align.x > 4) {
                      setState(() {
                        swipeDirection = "images/thumbsup.png";
                        swipeDirectionColor = Colors.green;
                        isLikeVisible = true;
                      });
                    }
                  },
                  swipeCompleteCallback:
                      (CardSwipeOrientation orientation, int index) {
                    likeList.add(0);
                    orientation.index == 1 ? likeList[index] = 1: likeList[index] = 0;
                    checkVisible(index);
                    setState(() {
                      isLikeVisible = false;
                    });
                  },

                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(height: 500),
                    SizedBox(
                      width: 150,
                        height: 60,
                        child: AnimatedOpacity(
                          opacity: isVisible ? 1.0 : 0.0,
                          duration: Duration(milliseconds: 1500),
                          child: buttonVisibility()),
                        ),
                    SizedBox(height: 300),
                  ],
                )

              ],
              ),
            ),
        Text("Swipe right to like a movie. Swipe left to dislike", style: TextStyle(color: Colors.grey),
        textAlign: TextAlign.center,),
            SizedBox(height: 10)
          ],
        ),
      ),
    );

  }

  Visibility swipeVisibility(){
    return Visibility(child:
        Image.asset(swipeDirection, height: 40,),
    //Text(swipeDirection, style: TextStyle(color: swipeDirectionColor, fontSize: 30)),
        visible: isLikeVisible);
  }

  Visibility buttonVisibility(){
    return Visibility(child: finishButton(), visible: isVisible);
  }

  FlatButton finishButton(){
    final db = database.reference();

    return FlatButton(
      color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        onPressed: (){

      likeList = likeList.sublist(0, stackNum);
      db.child('rooms').child(code.toString()).child('votes').child(playerNumber.toString()).set(likeList);

      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ResultScreen(
            code: code
          ))
      );
    },
    child: Text("See results")
    );

  }

  void checkVisible(index){
    if(likeList.length >= stackNum && index == stackNum - 1){
      setState(() {
        isVisible = true;
      });
    }
  }

}
