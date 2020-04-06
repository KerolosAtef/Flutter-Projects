import 'package:flutter/material.dart';
import 'package:esbetalia/GlobalState.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
class ScheduleDay1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ScheduleDay1Class();
  }
}

class ScheduleDay1Class extends State<ScheduleDay1> {
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

  onTapDrawer (int x) async {
    switch (x){
      case 0 : Navigator.pop(context);break ;
      case 1 : Navigator.of(context).pushNamed('/GamesDay1');break ;
      case 2 : Navigator.of(context).pushNamed('/RoheyaDay1');break ;
      case 3 :
        PDFDocument doc = await PDFDocument.fromAsset("assets/Roheya/salah.pdf");
        GlobalState.ourInstance.setValue("doc", doc);
        Navigator.of(context).pushNamed('/PdfContent');break ;
      case 4 : Navigator.of(context).pushNamed('/Teams');break ;
      case 5 :
        intent.setValue("ScoresDay", "Day1");
        Navigator.of(context).pushNamed('/Scores');break ;
      case 6 : Navigator.of(context).pushNamed('/Tranem');break ;
      case 7 : Navigator.of(context).pushNamed('/Rooms');break ;
      case 8 : Navigator.of(context).pushNamed('/Feedback');break ;

    }
  }
  _onPressedBottomNavigationBar(int x) {
    switch (x) {
      case 1:
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/ScheduleDay2', (Route<dynamic> route) => false);
        break;
      case 2:
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/ScheduleDay3', (Route<dynamic> route) => false);
        break;
    }
  }

  final key =new GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: new AppBar(
        title: new Text("Schedule Day 1"),
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
          currentIndex: 0 ,
        ),
      ),
      drawer: new Drawer(
        child: new Container(
            color: Color(0xff60593f),
            child:ListView.builder(itemBuilder: (BuildContext context ,int position){
              return  (position==0)
                  ?new Image.asset("assets/images/logo.png",
                width: 120,
                height: 200,)
                  :
              new GestureDetector(
                onTap:()=>onTapDrawer(position-1) ,
                child: Container(
                    margin: EdgeInsets.only(top: 12),
                    padding: EdgeInsets.all(8),
                    color: Color(0xff8d8674),
                    child: Row(
                      children: <Widget>[
                        new Image.asset(drawerIcons[position-1],width: 30,height: 30,),
                        Padding(padding: EdgeInsets.only(left: 15),),
                        Text(
                          drawerTexts[position-1],
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20
                          ),
                        ),
                      ],
                    ),
                ) ,
              );
            }
              ,itemCount:drawerTexts.length+1,

            )
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
              "assets/images/schedule_day1.png",
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),

    );
  }
}
