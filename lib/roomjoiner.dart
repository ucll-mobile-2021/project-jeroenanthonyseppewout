import 'dart:io';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/roomlobby.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class RoomJoiner extends StatefulWidget {
  @override
  _RoomJoinerState createState() => _RoomJoinerState();
}

class _RoomJoinerState extends State<RoomJoiner> {
  final _creatorFormKey = GlobalKey<FormState>();
  final database = FirebaseDatabase.instance;
  String username = "";
  String roomName = "";
  String genre = "";
  String enteredCode;
  DataSnapshot data;
  String retrievedData = "";
  String scanData = "";
  TextEditingController controller = new TextEditingController();
  Color col = Color(int.parse("#4a3dbf".substring(1, 7), radix: 16) + 0xFF000000);
  Color col2 = Color(int.parse("#e8e8e8".substring(1, 7), radix: 16) + 0xFF000000);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Join a room'),
        backgroundColor: col,
      ),
      body: SingleChildScrollView(
        child: Column(
        children: <Widget>[

      Card(
        color: Colors.black,
          margin: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 0),
          child: Container(
            margin: EdgeInsets.only(top: 20, left: 50, right: 50, bottom: 40),
            child: Form(
              key: _creatorFormKey,
              child: Column(
                children: <Widget>[
                  usernameField(),
                  codeInputField(),
                  FlatButton(child: Text('Alternatively, scan a QR code',
                      style: TextStyle(color: Colors.white, fontSize: 13)),
                      onPressed: () async {
                        setState(() {
                          scanData = _scan();
                          controller.text = scanData;
                        });
                      }
                  ),
                  SizedBox(height: 30),
                  joinButton(),
                ],
              ),
            )),
      ),
    ]))
    );
  }

    _scan() async{
    print("scanning");
    await FlutterBarcodeScanner.scanBarcode("#000000", "Cancel", true, ScanMode.QR).then((value) => setState((){
    scanData = value;
    controller.text = value;
    }));
    print(scanData);
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

  TextFormField codeInputField() {

    bool _isSixDigits(String str) {
      if (str == null || str.contains('.') || str.length != 6) {
        return false;
      }
      return double.tryParse(str) != null;
    }

    return TextFormField(
      style: TextStyle(color: Colors.white),
        controller: controller,
        decoration:
            InputDecoration(hintText: 'Enter 6-digit code',  hintStyle: TextStyle(color: Colors.grey)),
        validator: (value) {
        print("test");

          if (value.isEmpty) {
            return 'No code entered';
          }
          if (!_isSixDigits(value)) {
            return 'Please enter 6 digits code';
          }
          if (retrievedData.toString() == "null"){
            retrievedData = "";
            return 'Room does not exist';
          }
          enteredCode = value;
          return null;
        });
  }

  FlatButton joinButton(){
    return FlatButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0), side: BorderSide(color: col)),
      minWidth: 200,
      height: 40,
      color: col,
      onPressed: () async {
        if (_creatorFormKey.currentState.validate()) {
            checkExist();
        }
      },
      child: Text('Join', style: TextStyle(color: Colors.white),),
    );
  }

  String RandomString(int strlen) {
    const chars = "abcdefghijklmnopqrstuvwxyz";
    Random rnd = new Random(new DateTime.now().millisecondsSinceEpoch);
    String result = "";
    for (var i = 0; i < strlen; i++) {
      result += chars[rnd.nextInt(chars.length)];
    }
    return result;
  }

  Future checkExist() async{
    final db = database.reference();
    db.child('rooms').child(enteredCode).once().then((DataSnapshot snapshot) async{
      retrievedData = snapshot.value.toString();
      data = snapshot;
      _creatorFormKey.currentState.validate();

      String memberString = snapshot.value['members'].toString().replaceAll("[", "").replaceAll("]", "").replaceAll(" ", "");
      List participants = memberString.split(',');
      String playerNumber = RandomString(5) ;
      participants.add(username);
      db.child('rooms').child(enteredCode).child("members").set(participants.toString().replaceAll("]", "").replaceAll("[", ""));

      //Navigate to room lobby if code found
      if(retrievedData != ""){
        roomName = snapshot.value['roomname'] as String;
        genre = snapshot.value['genre'] as String;
        String code = snapshot.key;

        Navigator.push(
          context,
            MaterialPageRoute(builder: (context) => RoomLobby(
              username: username,
              roomName: roomName,
              genre: genre,
              code: code,
              playerNumber: playerNumber,
              movieList: null,
        ))
        );
      }
      return retrievedData;
    });
  }
}




