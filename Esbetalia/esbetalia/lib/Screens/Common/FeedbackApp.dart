import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
class FeedbackApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new FeedbackAppState();
  }
}

class FeedbackAppState extends State<FeedbackApp> {
  TextEditingController _feedbackMo2tmeText = new TextEditingController();
  TextEditingController _feedbackAppText = new TextEditingController();

  final DatabaseReference writeFeedback =
      FirebaseDatabase.instance.reference().child("Feedback");
  var mAuth ;
  var readUsersData ;

  String errorSubmitting ="";
  StreamSubscription <Event> _onChildAdded ;

  String userId , userName;
  Map <dynamic,dynamic> user ;

  @override
  void initState() {
    super.initState();
    mAuth=FirebaseAuth.instance.currentUser()
       .then(
           (user){
             setState(() {
               userId =user.uid;
               print(userId);
               readUsersData = FirebaseDatabase.instance.reference().child("Users Data").child(userId);
               _onChildAdded =readUsersData.onChildAdded.listen(_onChildAddedFunction);
             });
           }
           );

  }
  _onChildAddedFunction (Event e){
    if (e.snapshot.key=="name"){
      setState(() {
        userName=e.snapshot.value.toString();
        print(userName);
      });
    }
  }


  dynamic mColor ;
  submit() {
    if (_feedbackMo2tmeText.text.length> 0 && _feedbackAppText.text.length>0){
      writeFeedback.child(userName).child("Mo2tmr").push().set(_feedbackMo2tmeText.text.toString());
      _feedbackMo2tmeText.clear();
      writeFeedback.child(userName).child("App").push().set(_feedbackAppText.text.toString());
      _feedbackAppText.clear();
      setState(() {
        mColor=Colors.green ;
        errorSubmitting="Your Feedback has been Submitted successflully";
      });
    }
    else {
      setState(() {
        mColor=Colors.red ;
        errorSubmitting="You Should fill the data before submitting";
      });
    }


    print("submitted");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/background.png"),
                  fit: BoxFit.cover)),
          child: ListView(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
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
              new Container(
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                child: new Text(
                  "Write Your Feedback About...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xfff7f9ee),
                    fontSize: 25.0,
                  ),
                ),
              ),
              new Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: new Text(
                  "Mo2tamar El ESBETALIA",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xfff7f9ee),
                    fontSize: 20.0,
                  ),
                ),
              ),
              new Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: new TextField(
                  decoration: InputDecoration(
                    fillColor: Color(0xff928457),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide:BorderSide(color: Color(0xff928457)) ),
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide:BorderSide(color: Color(0xff928457)) ),
                  ),
                  controller: _feedbackMo2tmeText,
                  autocorrect: true,
                  maxLines: 8,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              new Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: new Text(
                  "THIS APP",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xfff7f9ee),
                    fontSize: 20.0,
                  ),
                ),
              ),
              new Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: new TextField(
                  decoration: InputDecoration(
                    fillColor: Color(0xff928457),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide:BorderSide(color: Color(0xff928457)) ),
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide:BorderSide(color: Color(0xff928457)) ),
                  ),
                  controller: _feedbackAppText,
                  autocorrect: true,
                  maxLines: 8,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              new Container(
                margin: EdgeInsets.only(top: 15,left: 120,right: 120),
                child: new RaisedButton(onPressed: submit ,
                  child: new Text("Submit" ,
                    style:TextStyle(
                      fontSize: 20,
                    ) ,
                  ),
                  textColor: Color(0xff503a15),
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 3,
                      )
                  ),
                  color: Color(0xfff8dd82),
                ),
              ),
              Text(errorSubmitting,style: TextStyle(color: mColor),)
            ],
          )),
    );
  }
}
