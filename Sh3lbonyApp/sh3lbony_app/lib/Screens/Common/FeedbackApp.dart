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
  TextEditingController _feedbackText = new TextEditingController();
  final DatabaseReference writeFeedback =
      FirebaseDatabase.instance.reference().child("Feedback");
  var mAuth ;
  var readUsersData ;

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


  submit() {
    writeFeedback.child(userName).push().set(_feedbackText.text.toString());
    _feedbackText.clear();
    print("submitted");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text("Feedback",style: TextStyle(color: Color.fromARGB(255, 25, 25, 25)),),
        backgroundColor: Color.fromARGB(255, 173, 129, 41),
      ),
      body: new Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/black_background.png"),
                  fit: BoxFit.cover)),
          child: ListView(
            children: <Widget>[
              new Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      "Write your feedback \n about App and el mo2tmr",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Color.fromARGB(255, 173, 129, 41),
                        fontSize: 25.0,
                      ),
                    ),
                  ],
                ),
              ),
              new Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: new TextField(
                  decoration: InputDecoration(
                    fillColor: Color.fromARGB(255, 173, 129, 41),
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  ),
                  controller: _feedbackText,
                  autocorrect: true,
                  maxLines: 10,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  new Container(
                    margin: EdgeInsets.all(20.0),
                    child: new RaisedButton(
                      onPressed: submit,
                      child: new Text(
                        "submit",
                        style: TextStyle(color: Colors.black, fontSize: 20.0),
                      ),
                      color: Color.fromARGB(255, 173, 129, 41),
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
