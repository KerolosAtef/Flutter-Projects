import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:esbetalia/GlobalState.dart';
import 'dart:async';

class Scores extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ScoresState();
  }
}

class ScoresState extends State<Scores> {
  DatabaseReference readRef ;
  GlobalState scoresDay = GlobalState.getInstance();
  String ourDay ;
  String winnerTeam = "";
  int maxScore =0;
  List<String> teamsAndScores=[
    "Teams","Scores",
    "Blue","Blue",
    "Green","Green",
    "Cyan","Cyan",
    "Red","Red",
    "Black","Black",
    "Yellow","Yellow",
  ];
  List<dynamic>teamsColors =[
    Colors.white,Colors.white,
    Color(0xff000cb8),Color(0xff000cb8),
    Color(0xff00b61e),Color(0xff00b61e),
    Color(0xff2bd8ff),Color(0xff2bd8ff),
    Color(0xffc00000),Color(0xffc00000),
    Color(0xff000000),Color(0xff000000),
    Color(0xffd1d100),Color(0xffd1d100),
  ];
  Map <String,int> teamsScores ;
  Map <String,dynamic> colors ={
    "Blue":Color(0xff000cb8),
    "Green":Color(0xff00b61e),
    "Cyan":Color(0xff2bd8ff),
    "Red":Color(0xffc00000),
    "Black":Color(0xff000000),
    "Yellow":Color(0xffd1d100),
  };
  @override
  void initState() {
    super.initState();
    ourDay = scoresDay.getValue("ScoresDay");
    teamsScores =new Map();
    readRef= FirebaseDatabase.instance.reference().child("Scores").child(ourDay);
    readRef.onChildAdded.listen(_onChildAddedFunction);
    readRef.onChildChanged.listen(_onChildUpdatedFunction);
    readRef.onChildRemoved.listen(_onChildRemovedFunction);

  }


  _onChildAddedFunction (Event e ){
    setState(() {
      teamsScores [e.snapshot.key]=e.snapshot.value;
      if (e.snapshot.value>maxScore){
        maxScore=e.snapshot.value;
        winnerTeam=e.snapshot.key;
      }
    });

  }
  _onChildUpdatedFunction (Event e){
    setState(() {
      teamsScores [e.snapshot.key]=e.snapshot.value;
      if (e.snapshot.value>maxScore){
        maxScore=e.snapshot.value;
        winnerTeam=e.snapshot.key;
      }
      if (e.snapshot.key==winnerTeam){
        maxScore=0;
        winnerTeam="";
        teamsScores.forEach((key, value) {
          if (value>maxScore){
            maxScore=value;
            winnerTeam=key;
          }
        });
      }
    });
  }
  _onChildRemovedFunction (Event e){
    print("kokka");
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: new Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/background.png')
                ,fit: BoxFit.cover)
        ),
        child:Column(
          children: <Widget>[
            Container(
              height: 150,
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: new Row(
                children: <Widget>[
                  GestureDetector(
                    child: new Image.asset("assets/images/back_arrow.png",width: 40,height: 40,),
                    onTap: ()=>Navigator.pop(context),
                  ),
                  Spacer(),
                  new Image.asset("assets/images/logo.png",height: 85,width: 85,),

                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("The Winner Of "+ourDay+"\n Till Now Is",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25
                  ),
                ),
                Container(
                  width: 85,
                  height: 85,
                  margin: EdgeInsets.only(left: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(500),
                    border: Border.all(color: Color(0xffffffff),width: 2),
                  ),
                  child: Center(
                    child: Text(winnerTeam,style: TextStyle(
                      color: (winnerTeam !="")? colors[winnerTeam]:Colors.white,
                      fontSize: 22
                    ),),
                  ),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 15),),
            Container(
              width: 350,
              height: 490,
              color: Colors.white,
              child: new GridView.builder(
                gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 1,
                  childAspectRatio: 2.5,//change the height of each element
                  crossAxisSpacing: 1,
                ) ,
                padding: EdgeInsets.only(top: 0),
                itemBuilder: (BuildContext context,int position)=>
                new Container(
                    color: Color(0xdd36311e),
                    child: Center(
                      child:
                      Text(
                        (position%2==0|| position==1)
                            ? teamsAndScores[position]
                            :teamsScores[teamsAndScores[position-1]].toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: teamsColors[position],
                            fontSize: 25
                        ),
                      )
                      ,
                    )
                ),
                itemCount: teamsAndScores.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
