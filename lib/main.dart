import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';

void main() => runApp(MaterialApp(
  title: 'Named Routes Demo',
  // Start the app with the "/" named route. In this case, the app starts
  // on the FirstScreen widget.
  initialRoute: '/',
  routes: {
    // When navigating to the "/" route, build the FirstScreen widget.
    '/': (context) => LoginScreen(),
    // When navigating to the "/second" route, build the SecondScreen widget.
    '/second': (context) => SecondScreen(),
  },
));

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MovieMatcher'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Container(
              width: 100.0,
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter name',
                ),
              ),
            ),
          ),
          Center(
            child: RaisedButton(
              onPressed: (){
                Navigator.pushNamed(context, '/second');
              },
              child: Text(
                'Login',
                style: TextStyle(
                    fontSize: 30.0
                ),
              ),
            ),
          ),
          Center(
            child: RaisedButton(
              onPressed: (){
                Navigator.pushNamed(context, '/second');
              },
              child: Text(
                'Create',
                style: TextStyle(
                    fontSize: 30.0
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  List<String> welcomeImages = [
    "assets/images/crying.png",
    "assets/images/sos werken nie meme.jpg",
    "assets/images/sossen meme.jpg",
    "assets/images/t-is-de-schuld-van-de-sossen-of-farid.jpg",
  ];
  @override
  Widget build(BuildContext context) {
    CardController controller;
    return Scaffold(
      appBar: AppBar(
        title: Text("Start Swiping"),
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
                child: RaisedButton(
                  onPressed: () {
                    print('insert matching code');
                  },
                  child: Text(
                    'Matcher',
                    style: TextStyle(
                      fontSize: 25.0,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
                width: 150.0,
                child: TextField(
                  style: TextStyle(
                    fontSize: 25.0,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter name',
                  ),
                ),
              ),
            ],
          ),
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              child: new TinderSwapCard(
                swipeUp: true,
                swipeDown: true,
                orientation: AmassOrientation.BOTTOM,
                totalNum: welcomeImages.length,
                stackNum: 5,
                swipeEdge: 4.0,
                maxWidth: MediaQuery.of(context).size.width * 0.9,
                maxHeight: MediaQuery.of(context).size.width * 0.9,
                minWidth: MediaQuery.of(context).size.width * 0.8,
                minHeight: MediaQuery.of(context).size.width * 0.8,
                cardBuilder: (context, index) => Card(
                  child: Image.asset('${welcomeImages[index]}'),
                ),
                cardController: controller = CardController(),
                swipeUpdateCallback:
                    (DragUpdateDetails details, Alignment align) {
                  /// Get swiping card's alignment
                  if (align.x < 0) {
                    //Card is LEFT swiping
                  } else if (align.x > 0) {
                    //Card is RIGHT swiping
                  }
                },
                swipeCompleteCallback:
                    (CardSwipeOrientation orientation, int index) {
                  /// Get orientation & index of swiped card!
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Text('Match'),
      ),
    );
  }
}