import 'package:flutter/material.dart';
import 'package:sh3lbony_app/GlobalState.dart';
import 'package:firebase_auth/firebase_auth.dart';
class ScheduleDay1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ScheduleDay1Class();
  }
}

class ScheduleDay1Class extends State<ScheduleDay1> {
  GlobalState intent = GlobalState.getInstance();
  var mAuth =FirebaseAuth.instance ;

  onTapDrawer (int x){
    switch (x){
      case 0 : Navigator.pop(context);break ;
      case 1 : Navigator.of(context).pushNamed('/GamesDay1');break ;
      case 2 : Navigator.of(context).pushNamed('/Teams');break ;
      case 3 :
        intent.setValue("ScoresDay", "Day1");
        Navigator.of(context).pushNamed('/Scores');break ;
      case 4 : Navigator.of(context).pushNamed('/Tranem');break ;
      case 5 : Navigator.of(context).pushNamed('/Rooms');break ;
      case 6 : Navigator.of(context).pushNamed('/Feedback');break ;

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
        backgroundColor:Color.fromARGB(255, 173, 129, 41),
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
    canvasColor: Color.fromARGB(255, 25, 25, 25),
    // sets the active color of the `BottomNavigationBar` if `Brightness` is light
    primaryColor: Color.fromARGB(255, 173, 129, 41),
    textTheme: Theme
        .of(context)
        .textTheme
        .copyWith(caption: new TextStyle(color: Colors.white))),

        child:  new BottomNavigationBar(
          items: [
            new BottomNavigationBarItem(
                icon: new Image.asset('assets/icons/days_icon.png',width: 30,height: 30,), title: new Text("Day1")),
            new BottomNavigationBarItem(
                icon: new Image.asset('assets/icons/days_icon.png',width: 30,height: 30,), title: new Text("Day2")),
            new BottomNavigationBarItem(
                icon: new Image.asset('assets/icons/days_icon.png',width: 30,height: 30,), title: new Text("Day3")),
          ],
          onTap:_onPressedBottomNavigationBar,
          currentIndex: 0 ,
        ),
      ),
      drawer: new Drawer(
        child: new Container(
          color: Color.fromARGB(255, 173, 129, 41),
          child:ListView(
            children: <Widget>[
              new Image.asset("assets/images/logo.png",
              width: 120,
              height: 200,
              ),
              new ListTile(
                title: Text(
                  "Schedulde Day1",
                  style: TextStyle(
                  color: Color.fromARGB(255, 25, 25, 25),
                    fontSize: 18
                  ),
                ),
                onTap: ()=>onTapDrawer(0),
                leading: new Image.asset("assets/icons/days_icon_black.png",width: 30,height: 30,),
              ),
              new ListTile(
                title: Text(
                  "Games Day1",
                  style: TextStyle(
                      color:Color.fromARGB(255, 25, 25, 25),
                      fontSize: 18
                  ),
                ),
                onTap: ()=>onTapDrawer(1),
                leading:  new Image.asset("assets/icons/games_icon.png",width: 30,height: 30,),
              ),
              new ListTile(
                title: Text(
                  "Teams",
                  style: TextStyle(
                      color:Color.fromARGB(255, 25, 25, 25),
                      fontSize: 18
                  ),
                ),
                onTap: ()=>onTapDrawer(2),
                leading: new Image.asset("assets/icons/teams_icon.png",width: 30,height: 30,),
              ),
              new ListTile(
                title: Text(
                  "Scores Day1",
                  style: TextStyle(
                      color: Color.fromARGB(255, 25, 25, 25),
                      fontSize: 18
                  ),
                ),
                onTap: ()=>onTapDrawer(3),
                leading:  new Image.asset("assets/icons/scores_icon.png",width: 30,height: 30,),
              ),
              new ListTile(
                title: Text(
                  "Tranem",
                  style: TextStyle(
                      color:Color.fromARGB(255, 25, 25, 25),
                      fontSize: 18
                  ),
                ),
                onTap: ()=>onTapDrawer(4),
                leading:  new Image.asset("assets/icons/music_icon_black.png",width: 30,height: 30,),
              ),
              new ListTile(
                title: Text(
                  "Rooms",
                  style: TextStyle(
                      color: Color.fromARGB(255, 25, 25, 25),
                      fontSize: 18
                  ),
                ),
                onTap: ()=>onTapDrawer(5),
                leading: new Image.asset("assets/icons/rooms_icon.png",width: 30,height: 30,),
              ),
              new ListTile(
                title: Text(
                  "Feedback",
                  style: TextStyle(
                      color: Color.fromARGB(255, 25, 25, 25),
                      fontSize: 18
                  ),
                ),
                onTap: ()=>onTapDrawer(6),
                leading:  new Image.asset("assets/icons/feedback_icon.png",width: 30,height: 30,),
              ),

            ],
          ),
        ),
      ),

      body: new Container(
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
