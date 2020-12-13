import 'package:flutter/material.dart';

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
              child: TextFormField(
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
      
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Text('login'),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Screen"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate back to first screen when tapped.
            Navigator.pushNamed(context, '/');
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}