import 'dart:async';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movies_app/startscreen.dart';
import 'movieswiper.dart';
import 'package:qr_flutter/qr_flutter.dart';

class RoomLobby extends StatefulWidget{
  String username;
  String roomName;
  String genre;
  String code;
  String playerNumber;
  List<List> movieList;
  RoomLobby({Key key, @required this.username, @required this.roomName, @required this.code, @required this.genre, this.movieList, this.playerNumber}) : super(key: key);
  @override
  _RoomLobbyState createState() => _RoomLobbyState(username, roomName, code, genre, movieList, playerNumber);
}

class _RoomLobbyState extends State<RoomLobby> {
  String username;
  String roomName;
  String genre;
  String code;
  String playerNumber;
  int movieNumbers = 5;
  String retrievedData;
  String retrievedData2 = "";
  int i = 0;
  Timer t;
  bool reloaded = false;
  Color col = Color(int.parse("#4a3dbf".substring(1, 7), radix: 16) + 0xFF000000);

  final database = FirebaseDatabase.instance;
  List<String> participants = [];
  List<List> movieList = [];
  final GlobalKey<AnimatedListState> _key = GlobalKey();

  _RoomLobbyState(String username, String roomName, String code, String genre, List<List> movieList, String playerNumber) :
        this.username = username,
        this.roomName = roomName,
        this.genre = genre.toLowerCase(),
        this.code = code,
        this.movieList = movieList,
        this.playerNumber = playerNumber;

  @override
  Widget build(BuildContext context) {

    //Roep listAdder functie elke second op
    if(reloaded == false){
      const oneSecond = const Duration(seconds: 1);
      t = Timer.periodic(oneSecond, (Timer t) => listAdder());
      reloaded = true;
    }
    getMovieList();
    getMembersList(true);


    return new WillPopScope(
        onWillPop: () async => false,
    child: Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Roomlobby - $roomName"),
        backgroundColor: col,
        automaticallyImplyLeading: false,
      ),
      body: Column(children: <Widget>[
        SizedBox(height: 10),
        Text("Room code:", textAlign: TextAlign.center, style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20)),
        Text(code, textAlign: TextAlign.center, style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 40)),
        Expanded(
            child: QrImage(
                data: code,
                version: QrVersions.auto,
                foregroundColor: Colors.white,
                size: 150)),

        Text("• LIVE", style: TextStyle(color: Colors.red)),
        Text("Players in this room:", textAlign: TextAlign.center, style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20)),
        Expanded(
          child: AnimatedList(
            key: _key,
            initialItemCount: participants.length,
            itemBuilder: (context, index, animation) {
              if(index <= participants.length -1){
                return _buildList(participants[index], animation, index);
              }
              else{
                return null;
              }
            },
          ),
        ),
        Row(
          children: <Widget>[
            exitButton(),
            SizedBox(width: 5),
            Expanded(child: startButton())
          ],
        ),

        SizedBox(height: 10),
      ],
      )
    ));
  }

  void getMembersList(bool begin) async{
    final db = database.reference();

    await
    db.child('rooms').child(code).child('members').once().then((DataSnapshot snapshot){
      retrievedData = snapshot.value.toString();
      //retrievedData2 = snapshot.value.toString();

      if(begin == true){
      participants = retrievedData.split(',');
      for (int offset = 0; offset < participants.length; offset++) {
        _key.currentState.insertItem(offset);
      }}});
  }


  Widget _buildList(String item, Animation animation, int index){
    return SizeTransition(
        sizeFactor: animation,
        child: Card(
          color: col,
          elevation: 2,
            child: ListTile(
              title: Text(item, style: TextStyle(
                  color: Colors.white, fontSize: 20))

    )
    ));
  }

  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive: print('inactive');
    }}


  void listAdder(){


    int participantsSize = participants.length;
    final db = database.reference();

    db.child('rooms').child(code).child('members').once().then((DataSnapshot snapshot) async{
      retrievedData = snapshot.value.toString();
      participants = retrievedData.split(',');
      int index = participants.length - 1;
      if(participantsSize < participants.length){
        _key.currentState.insertItem(index);
      }
      if(participantsSize > participants.length){
        setState(() {
        });
      }
    });

  }

  FlatButton startButton(){
    return FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        minWidth: 150,
        height: 50,
        color: col,
        onPressed: (){

          t.cancel();

          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MovieSwiper(
                  username: username,
                  code: code.toString(),
                  playerNumber: playerNumber,
                  movieList: movieList,
              ))
          );

    },
        child: Text("Start swiping ➔", style: TextStyle(
             color: Colors.white, fontSize: 20)),
    );
  }

  FlatButton exitButton(){
    return FlatButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      minWidth: 150,
      height: 50,
      color: Colors.red,
      onPressed: (){


        t.cancel();
        final db = database.reference();
        //getMembersList(false);
        print(retrievedData);
        String newData = retrievedData.replaceFirst(", $username", "");
        if(newData == retrievedData){
          newData = newData.replaceFirst("$username, ", "");
          print(retrievedData);
          print(newData);
          if(newData == retrievedData){
            newData = newData.replaceFirst(username, "");
            print(retrievedData);
            print(newData);
            if(newData == retrievedData){
              newData = newData.replaceFirst(username, "");
            }
          }
        }

        if(newData.isEmpty){
          db.child("rooms").child(code).remove();
        }else{
          db.child('rooms').child(code).child("members").set(newData);
        }

        int ind = participants.indexOf(username);

        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            StartScreen()), (Route<dynamic> route) => false);

    /*    Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StartScreen(
            ))
        );*/

      },
      child: Text("Exit room", style: TextStyle(
          color: Colors.white, fontSize: 20)),
    );
  }

  void getMovieList() async{
    final db = database.reference();

    if(movieList == null){
      movieList = [];

      await
      db.child('rooms').child(code).child('movielist').once().then((
          DataSnapshot snapshot) {
        DataSnapshot data = snapshot;

        //movieList.add([9,9,data.value[0]['title'].toString()]);
        //movieList.add([data.value[0]['id'].toString(), data.value[0]['title'].toString(), data.value[0]['description'].toString()]);
        //movieList.add([data.value[1]['id'].toString(), data.value[1]['title'].toString(), data.value[1]['description'].toString()]);
        //movieList.add([data.value[4]['id'].toString(), data.value[4]['title'].toString(), data.value[4]['description'].toString()]);

        for(int i = 0; i < movieNumbers; i++){
          movieList.add([data.value[i]['id'].toString(), data.value[i]['title'].toString(), data.value[i]['description'].toString(), data.value[i]['image'].toString()]);
        }
      });
    }
  }
}

