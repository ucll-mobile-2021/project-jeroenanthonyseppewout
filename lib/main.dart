import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('MovieMatcher'),
      ),
      body: Center(
        child: Text(
            'Login',
          style: TextStyle(
            fontSize: 30.0
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Text('login'),
      ),
    ),
  ));
}


class loginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}