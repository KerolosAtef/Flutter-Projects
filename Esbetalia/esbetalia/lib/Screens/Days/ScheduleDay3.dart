import 'package:flutter/material.dart';
import 'package:esbetalia/GlobalState.dart';
import 'package:firebase_auth/firebase_auth.dart';
class ScheduleDay3 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ScheduleDay3Class();
  }
}

class ScheduleDay3Class extends State<ScheduleDay3> {
  GlobalState intent = GlobalState.getInstance();
  var mAuth =FirebaseAuth.instance ;
  List <String> drawerTexts = [
    "Schedule Day1","Games Day1","Rou7ya Day1","Egtma3 El Salah","Teams","Scores Day1","Tranem","Rooms","Feedback"
  ];
  List <String> drawerIcons =[
    "assets/icons/days.png",
    "assets/icons/games.png",
    "assets/icons/roheya.png",
    "assets/icons/salah.png",
    "assets/icons/teams.png",
    "assets/icons/scores.png",
    "assets/icons/tranim.png",
    "assets/icons/rooms.png",
    "assets/icons/feedback.png",
  ];
  _onPressedBottomNavigationBar(int x) {
    switch (x) {
      case 0:
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/ScheduleDay1', (Route<dynamic> route) => false);
        break;
      case 1:
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/ScheduleDay2', (Route<dynamic> route) => false);
        break;
    }
  }

  final key =new GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: new AppBar(
        title: new Text("Schedule Day 3"),
        backgroundColor:Color(0xff494023),
        actions: <Widget>[
          new IconButton(
              icon:new Image.asset("assets/icons/logout.png"),
              onPressed: (){
                mAuth.signOut();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/Login', (Route<dynamic> route) => false);
              })
        ],
      ),
      bottomNavigationBar:  new Theme(
        data: Theme.of(context).copyWith(
          // sets the background color of the `BottomNavigationBar`
            canvasColor: Color(0xff494023),
            // sets the active color of the `BottomNavigationBar` if `Brightness` is light
            primaryColor: Color(0xffffffff),
            textTheme: Theme
                .of(context)
                .textTheme
                .copyWith(caption: new TextStyle(color: Color(0xff8d8255)))),

        child:  new BottomNavigationBar(
          items: [
            new BottomNavigationBarItem(
                icon: new Image.asset('assets/icons/days.png',width: 30,height: 30,), title: new Text("Day1")),
            new BottomNavigationBarItem(
                icon: new Image.asset('assets/icons/days.png',width: 30,height: 30,), title: new Text("Day2")),
            new BottomNavigationBarItem(
                icon: new Image.asset('assets/icons/days.png',width: 30,height: 30,), title: new Text("Day3")),
          ],
          onTap:_onPressedBottomNavigationBar,
          currentIndex: 2 ,
        ),
      ),
      body: new Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/background.png"),
                fit: BoxFit.cover)),
        child: ListView(
          children: <Widget>[
            new Image.asset(
              "assets/images/schedule_day3.png",
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),

    );
  }
}
