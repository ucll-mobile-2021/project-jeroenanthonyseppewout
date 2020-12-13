import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movies_app/roomcreator.dart';
import 'package:movies_app/startscreen.dart';

import 'CustomDatabase.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StartScreen(),
    );
  }
}
