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
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context){
          return new AlertDialog(
            content: new Row(
              children: [
                new CircularProgressIndicator(),
                new Padding(padding: EdgeInsets.only(left: 10)),
                new Text("Logging in..."),
              ],
            ),
          );
        },
      );
      await mAuth.signInWithEmailAndPassword(
          email: _email.text,
          password:_password.text
      ).then((user){
        print("LOged in");
        Navigator.pop(context);
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
      body:new Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover
            ),
          ),
        padding: EdgeInsets.symmetric(
          horizontal: 15
        ),
        child: new ListView(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 10),),
        new Image.asset(
                'assets/images/logo.png',
              width: 180,
              height: 280,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              color: Color(0xff7e7862),
              margin: EdgeInsets.only(top: 15,bottom: 15),
              child: new TextField(
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  labelText:"Email",
                  labelStyle: TextStyle(
                    color: Color(0xffd5d1c6),
                    fontSize: 15,
                  ),
                  hintText: "Enter your email",
                  errorText: errorEmail,
                  hintStyle: TextStyle(color: Color(0xffd5d1c6)),
                  icon: new Icon(
                    Icons.email,
                    color: Color(0xfff8dd82),
                  ) ,
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xffd5d1c6))),
                  enabledBorder:  UnderlineInputBorder(borderSide: BorderSide(color: Color(0xffd5d1c6))),
                  focusedErrorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xffd5d1c6))),
                  errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xffd5d1c6))),

                ),
                keyboardType: TextInputType.emailAddress,
                controller: _email,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              color: Color(0xff7e7862),
              child: new TextField(
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  labelText:"password",
                  labelStyle: TextStyle(
                    color: Color(0xffd5d1c6),
                  ),

                  hintText: "Enter your password",
                  hintStyle: TextStyle(color: Colors.white70),
                  errorText: errorPassword,
                  icon: new Icon(Icons.lock,
                    color: Color(0xfff8dd82),
                  ) ,
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xffd5d1c6))),
                  enabledBorder:  UnderlineInputBorder(borderSide: BorderSide(color: Color(0xffd5d1c6))),
                  focusedErrorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xffd5d1c6))),
                  errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xffd5d1c6))),

                ),
                keyboardType: TextInputType.text,
                obscureText: true,
                controller: _password,
              ),
            ),
            new Padding(padding: EdgeInsets.only(top: 20)),

            Container(
              margin: EdgeInsets.only(left: 100,right: 100,bottom: 15),
              height: 40,
              child: new RaisedButton(onPressed: logIn ,
                child: new Text("Login" ,
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

            Container(
              margin: EdgeInsets.symmetric(horizontal: 100),
              height: 40,
              child: new RaisedButton(onPressed: register ,
                child: new Text("Register" ,
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