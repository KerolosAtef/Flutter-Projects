import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sh3lbony_app/GlobalState.dart';
import 'dart:async';

class Scores extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ScoresState();
  }
}

class ScoresState extends State<Scores> {
  DatabaseReference readRef ;
  StreamSubscription <Event> _onChildAdded ,_onChildUpdated,_onChildRemoved ;
  GlobalState scoresDay = GlobalState.getInstance();
  String ourDay ;
  readFromDatabase() {


  }
  Map <String,int> teamsScores ;
  @override
  void initState() {
    super.initState();
    ourDay = scoresDay.getValue("ScoresDay");
//    ourDay="Day1";
    teamsScores =new Map();
    readRef= FirebaseDatabase.instance.reference().child("Scores").child(ourDay);
    _onChildAdded =readRef.onChildAdded.listen(_onChildAddedFunction);
    _onChildUpdated=readRef.onChildChanged.listen(_onChildUpdatedFunction);
    _onChildRemoved=readRef.onChildRemoved.listen(_onChildRemovedFunction);

  }


  _onChildAddedFunction (Event e ){
    setState(() {
      teamsScores [e.snapshot.key]=e.snapshot.value;
    });

  }
  _onChildUpdatedFunction (Event e){
    setState(() {
      teamsScores [e.snapshot.key]=e.snapshot.value;
    });
  }
  _onChildRemovedFunction (Event e){
    print("kokka");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text("Scores",style: TextStyle(color: Color.fromARGB(255, 25, 25, 25)),),
        backgroundColor: Color.fromARGB(255, 173, 129, 41),
      ),
      body: new Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/black_background.png"),
                fit: BoxFit.cover)),
        child: new ListView(
          children: <Widget>[
            new Padding(padding: EdgeInsets.only(top: 10)),
            new Image.asset("assets/images/scores_logo.png",width: 150,height: 150,),
            new Center(
              child:new Text("Scores",
                  style: TextStyle(
                    color: Color.fromARGB(255, 173, 129, 41),
                    fontSize: 45,
                  ),
              ),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(
                  "Green Team",
                  style: TextStyle(color: Colors.green,fontSize: 30),
                ),
                new Padding(
                    padding: EdgeInsets.only(
                        left: 20.0
                    )
                ),
                new Container(
                  width: 100,
                  child: new PhysicalModel(
                    color: Color.fromARGB(255, 173, 129, 41),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: new Center(
                      child: new Text(
                        teamsScores['green'].toString(),
                        style: TextStyle(color: Colors.green,fontSize: 35),
                      ),
                    )
                  ),
                ),

              ],
            ),
            new Padding(padding: EdgeInsets.only(bottom: 10)),

            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(
                  "White Team",
                  style: TextStyle(color: Colors.white,fontSize: 30),
                ),
                new Padding(
                    padding: EdgeInsets.only(
                        left: 20.0
                    )
                ),
                new Container(
                  width: 100,
                  child: new PhysicalModel(
                      color: Color.fromARGB(255, 173, 129, 41),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      child: new Center(
                        child: new Text(
                          teamsScores['white'].toString(),
                          style: TextStyle(color: Colors.white,fontSize: 35),
                        ),
                      )
                  ),
                ),

              ],
            ),
            new Padding(padding: EdgeInsets.only(bottom: 10)),

            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(
                  "Blue Team",
                  style: TextStyle(color: Colors.blue,fontSize: 30),
                ),
                new Padding(
                    padding: EdgeInsets.only(
                        left: 20.0
                    )
                ),
                new Container(
                  width: 100,
                  child: new PhysicalModel(
                      color: Color.fromARGB(255, 173, 129, 41),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      child: new Center(
                        child: new Text(
                          teamsScores['blue'].toString(),
                          style: TextStyle(color: Colors.blue,fontSize: 35),
                        ),
                      )
                  ),
                ),

              ],
            ),
            new Padding(padding: EdgeInsets.only(bottom: 10)),

            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(
                  "Red Team",
                  style: TextStyle(color: Colors.red,fontSize: 30),
                ),
                new Padding(
                    padding: EdgeInsets.only(
                        left: 20.0
                    )
                ),
                new Container(
                  width: 100,
                  child: new PhysicalModel(
                      color: Color.fromARGB(255, 173, 129, 41),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      child: new Center(
                        child: new Text(
                          teamsScores['red'].toString(),
                          style: TextStyle(color: Colors.red,fontSize: 35),
                        ),
                      )
                  ),
                ),

              ],
            ),
            new Padding(padding: EdgeInsets.only(bottom: 10)),

            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(
                  "Yellow Team",
                  style: TextStyle(color: Colors.yellow,fontSize: 30),
                ),
                new Padding(
                    padding: EdgeInsets.only(
                        left: 20.0
                    )
                ),
                new Container(
                  width: 100,
                  child: new PhysicalModel(
                      color: Color.fromARGB(255, 173, 129, 41),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      child: new Center(
                        child: new Text(
                          teamsScores['yellow'].toString(),
                          style: TextStyle(color: Colors.yellow,fontSize: 35),
                        ),
                      )
                  ),
                ),

              ],
            ),
            new Padding(padding: EdgeInsets.only(bottom: 10)),

            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(
                  "Purple Team",
                  style: TextStyle(color: Colors.purple,fontSize: 30),
                ),
                new Padding(
                    padding: EdgeInsets.only(
                        left: 20.0
                    )
                ),
                new Container(
                  width: 100,
                  child: new PhysicalModel(
                      color: Color.fromARGB(255, 173, 129, 41),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      child: new Center(
                        child: new Text(
                          teamsScores['purple'].toString(),
                          style: TextStyle(color: Colors.purple,fontSize: 35),
                        ),
                      )
                  ),
                ),

              ],
            ),

          ],
        ),
      ),
    );
  }

}
