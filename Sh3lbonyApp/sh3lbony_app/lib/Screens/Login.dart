import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'dart:io';

//notifiaction
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new LoginState();
  }

}
class LoginState extends State<Login> {
  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  String errorAuth ="" , errorEmail ="",errorPassword="";
  FirebaseAuth  mAuth ;

  Future <void>logIn ()async{
    if (_email.text.isNotEmpty && _password.text.isNotEmpty){
      if (!_email.text.contains("@") || !_email.text.contains(".com")){
        setState(() {
          errorEmail="invaild Email";
        });
      }
      else{
        setState(() {
          errorEmail="";
          errorAuth="";
        });
      }
      if (_password.text.length >= 6){
        setState(() {
          errorPassword="";
          errorAuth="";
        });
        //my code

      }
      else{
        setState(() {
          errorPassword ="Your password should has more than 6 character";
        });
      }


    }
    else{
      setState(() {
        errorAuth="Fill all data";
      });
    }

    if (_email.text.contains("@") && _email.text.contains(".com") && _password.text.length >= 6){
      await mAuth.signInWithEmailAndPassword(
          email: _email.text,
          password:_password.text
      ).then((FirebaseUser user){
        Navigator.pushReplacementNamed(context, '/ScheduleDay1');
      }).catchError((e){
        print(e);
        setState(() {
          errorAuth="Can't Login, please check your internet Connection or Emial and Password";
        });
      });
    }
  }
  register (){
    Navigator.pushNamed(context, '/Register');
  }
  @override
  void initState() {
    mAuth= FirebaseAuth.instance ;
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        title: new Text("Login",style: TextStyle(color: Color.fromARGB(255, 25, 25, 25)),),
        backgroundColor: Color.fromARGB(255, 173, 129, 41),
      ),
      backgroundColor: Colors.black,
      body:new Container(
        padding: EdgeInsets.symmetric(
          horizontal: 15
        ),
        child: new ListView(
          children: <Widget>[
        new Image.asset(
                'assets/images/logo.png',
              width: 180,
              height: 250,
            ),
            new TextField(
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                labelText:"Email",
                labelStyle: TextStyle(
                  color: Color.fromARGB(255, 173, 129, 41),
                  fontSize: 15,
                ),
                hintText: "Enter your email",
                  hintStyle: TextStyle(color: Colors.white70),
                  icon: new Icon(
                      Icons.email,
                  color: Color.fromARGB(255, 173, 129, 41),
                  ) ,
                errorText: errorEmail
              ),
              keyboardType: TextInputType.emailAddress,
              controller: _email,
            ),
            new TextField(
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                labelText:"password",
                labelStyle: TextStyle(
                    color: Color.fromARGB(255, 173, 129, 41),
                ),
                errorText: errorPassword,
                hintText: "Enter your password",
                hintStyle: TextStyle(color: Colors.white70),
                icon: new Icon(Icons.lock,
                color: Color.fromARGB(255, 173, 129, 41),
                ) ,
              ),
              keyboardType: TextInputType.text,
              obscureText: true,
              controller: _password,
            ),
            new Padding(padding: EdgeInsets.only(top: 20)),

            new Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: <Widget>[
                new RaisedButton(onPressed: logIn ,
                  child: new Text("Login" ,
                    style:TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 25, 25, 25),
                    ) ,
                  ),
                  shape: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                  color: Color.fromARGB(255, 173, 129, 41),
//                  padding: EdgeInsets.symmetric(horizontal: 35,vertical: 20),
                padding: EdgeInsets.all(15),

                ),
                new Padding(padding: EdgeInsets.only(left: 20)),
                new RaisedButton(onPressed: register ,
                  child: new Text("Register" ,
                    style:TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 25, 25, 25),
                    ) ,
                  ),
                  shape: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                  color: Color.fromARGB(255, 173, 129, 41),
                  padding: EdgeInsets.all(10),

                ),

              ],
            ),
            new Container(
              padding: EdgeInsets.only(top: 10),
              child: new Text(errorAuth,
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }

}