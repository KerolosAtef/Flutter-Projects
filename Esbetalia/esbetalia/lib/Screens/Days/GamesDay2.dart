import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:url_launcher/url_launcher.dart';

class GamesDay2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new GamesDay2State();
  }

}
class GamesDay2State extends State<GamesDay2> {
  bool video1=false,video2=false,video3=false ;
  var snackBarKey =GlobalKey<ScaffoldState>();

  Future<void> openVideo (String link) async {
    if (Platform.isIOS) {
      if (await canLaunch('youtube://'+link)) {
        await launch('youtube://'+link,forceSafariVC: false);
      }
      else if (await canLaunch('https://'+link)) {
        await launch('https://'+link);
      }
      else {
        snackBarKey.currentState.showSnackBar(
          SnackBar(
            content: Text("Can't Launch URL"),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
    else {
      if (await canLaunch("https://"+link)) {
        await launch("https://"+link);
      }
      else {
        snackBarKey.currentState.showSnackBar(
          SnackBar(
            content: Text("Can't Launch URL"),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }
  DatabaseReference readRef ;
  @override
  void initState() {
    readRef= FirebaseDatabase.instance.reference().child("Active");
    readRef.onChildAdded.listen(_onChildAddedFunction);
    readRef.onChildChanged.listen(_onChildUpdatedFunction);
//    readRef.onChildRemoved.listen(_onChildRemovedFunction);
    super.initState();
  }
  _onChildAddedFunction (Event e ){
    setState(() {
      if (e.snapshot.key=="video1") video1=e.snapshot.value;
      else if (e.snapshot.key=="video2") video2=e.snapshot.value;
      else if (e.snapshot.key=="video3") video3=e.snapshot.value;
    });
  }
  _onChildUpdatedFunction (Event e){
    setState(() {
      if (e.snapshot.key=="video1") video1=e.snapshot.value;
      else if (e.snapshot.key=="video2") video2=e.snapshot.value;
      else if (e.snapshot.key=="video3") video3=e.snapshot.value;
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        key: snackBarKey,
        body: new Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/background.png')
                  ,fit: BoxFit.cover)
          ),
          padding: EdgeInsets.symmetric(vertical: 10),
          child: ListView(
            padding: EdgeInsets.only(top: 0),
            children: <Widget>[
              Container(
                height: 130,
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
              Container(
                margin: EdgeInsets.only(left: 10,bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text("Active Day 2" ,style: TextStyle(
                      fontSize: 25,
                      color: Color(0xffffffff),

                    ),textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
              Image.asset("assets/images/games_day2.png"),
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(top: 35),
                width: 1000,
                color: Color(0xff83774d),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 5),
                      padding: EdgeInsets.all(7),
                      color: Color(0xff5d532f),
                      child: Text("Workshop",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: ()=>video1
                              ? openVideo("www.youtube.com/watch?v=PdU28wNbDg8")
                              :snackBarKey.currentState.showSnackBar(
                            SnackBar(
                              content: Text("Estna shwya ..It's locked"),
                              duration: Duration(seconds: 2),
                            ),
                          )
                          ,
                          child: Container(
                            margin: EdgeInsets.only(left: 5,right: 5),
                            padding: EdgeInsets.all(5),
                            color: Color(0xff5d532f),
                            child: Text("Video 1",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        video1?Container():Image.asset("assets/images/lock.png",height: 35,width: 35,),
                        GestureDetector(
                          onTap: ()=> video2
                              ? openVideo("www.youtube.com/watch?v=sZv8kTT15F4&feature=youtu.be")
                              : snackBarKey.currentState.showSnackBar(
                            SnackBar(
                              content: Text("Estna shwya ..It's locked"),
                              duration: Duration(seconds: 2),
                            ),
                          ),
                          child: Container(
                            margin: EdgeInsets.only(left: 5,right: 5),
                            padding: EdgeInsets.all(5),
                            color: Color(0xff5d532f),
                            child: Text("Video 2",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        video2?Container(): Image.asset("assets/images/lock.png",height: 35,width: 35,),
                        GestureDetector(
                          onTap: ()=>video3
                              ?openVideo("www.youtube.com/watch?v=cZgp8_8-voQ&feature=youtu.be")
                              :snackBarKey.currentState.showSnackBar(
                            SnackBar(
                              content: Text("Estna shwya ..It's locked"),
                              duration: Duration(seconds: 2),
                            ),
                          ),
                          child: Container(
                            margin: EdgeInsets.only(left: 5,right: 5),
                            padding: EdgeInsets.all(5),
                            color: Color(0xff5d532f),
                            child: Text("Video 3",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        video3?Container():Image.asset("assets/images/lock.png",height: 35,width: 35,),

                      ],
                    ),
                  ],
                ),
              ),

            ],
          ),
        )
    );
  }
}