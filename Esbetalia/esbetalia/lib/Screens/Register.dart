import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';


class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new RegisterState();
  }
}

class RegisterState extends State<Register> {
  TextEditingController _name = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  TextEditingController _phone = new TextEditingController();
  String errorPassword="" ,errorEmail="",errorPhone="",errorName="" ;

  final mAuth = FirebaseAuth.instance;
  var registerRef =FirebaseDatabase.instance.reference().child("Users Data");
  var key =GlobalKey<ScaffoldState>();
  bool undo =false ;

  undoFuc (){
    setState(() {
      undo=true ;
    });
  }

  register() {
    setState(() {
      errorPassword="" ;errorEmail="";errorPhone="";
      undo=false ;
    });
    if (_name.text.isNotEmpty && _password.text.isNotEmpty  &&
    _phone.text.isNotEmpty &&_email.text.isNotEmpty ){

      if (_password.text.length < 6){
        setState(() {
          errorPassword="password should be more than 6 charater";
        });
      }
      if (!_email.text.contains("@") || !_email.text.contains(".com")){
        setState(() {
          errorEmail="invaild email patern";
        });
      }
      if (_phone.text.length != 11){
        setState(() {
          errorPhone="Your phone should be 11 number";
        });
      }
      if (_password.text.length >= 6 &&_email.text.contains("@") &&
          _email.text.contains(".com")&&_phone.text.length == 11){

        key.currentState.showSnackBar(
            SnackBar(
              content: Text("Registering"),
              duration: Duration(seconds: 2),
              action: SnackBarAction(
                  label: "Undo",
                  onPressed: undoFuc
              ),

            ),

        );
        Future.delayed(Duration(seconds: 3)).then((_){
          print(undo);
          if (!undo){
            submitData();
          }
          else{
            key.currentState.showSnackBar(SnackBar(content: Text("Registration process has been Stopped"),
            ));
          }
        });

      }

    }
    else {
      key.currentState.showSnackBar(SnackBar(content: Text("please fill all Data")));
    }
  }
  Future <void> submitData () async{
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context){
        return new AlertDialog(
          content: new Row(
            children: [
              new CircularProgressIndicator(),
              new Padding(padding: EdgeInsets.only(left: 10)),
              new Text("Signning up..."),
            ],
          ),
        );
      },
    );
    print("submitted");
    print(_email.text);
    print(_password.text);

    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email.text,
        password: _password.text
    ).then((user){
      print("userId");
      registerRef=registerRef.child(user.user.uid);
      registerRef.child("name").set(_name.text.toString());
      registerRef.child("password").set(_password.text.toString());
      registerRef.child("email").set(_email.text.toString());
      registerRef.child("phone").set(_phone.text.toString());
    }).then((_){
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, '/ScheduleDay1');
    }).catchError((e){
      print("Auth error");
    }
    );
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      key: key,
      body: new Container(
        padding: EdgeInsets.symmetric(
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.cover
          ),
        ),
        child: new ListView(
          children: <Widget>[
            new Image.asset(
              "assets/images/logo.png",
              width: 100,
              height: 200,
            ),
            new Container(
              color: Color(0xff7e7862),
              margin: EdgeInsets.only(top: 15,bottom: 15),
              child: new TextField(
                style: TextStyle(
                    color: Color(0xffd5d1c6)
                ),
                decoration: InputDecoration(
                  labelText: "Name",
                  labelStyle: TextStyle(color: Color(0xffd5d1c6)),
                  hintText: "Enter your name",
                  hintStyle: TextStyle(color:Color(0xffd5d1c6)),
                  errorText: errorName,
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xffd5d1c6))),
                  enabledBorder:  UnderlineInputBorder(borderSide: BorderSide(color: Color(0xffd5d1c6))),
                  focusedErrorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xffd5d1c6))),
                  errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xffd5d1c6))),
                  icon: new Icon(
                    Icons.person,
                    color: Color(0xfff8dd82),),
                ),

                keyboardType: TextInputType.text,
                controller: _name,
              ),
            ),
            new Container(
              color: Color(0xff7e7862),
              margin: EdgeInsets.only(bottom: 15),
              child: new TextField(
                style: TextStyle(
                    color: Color(0xffd5d1c6)
                ),
                decoration: InputDecoration(
                  labelText: "password",
                  labelStyle: TextStyle(color:Color(0xffd5d1c6)),
                  hintText: "Enter your password",
                  hintStyle: TextStyle(color:Color(0xffd5d1c6)),
                  errorText: errorPassword,
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xffd5d1c6))),
                  enabledBorder:  UnderlineInputBorder(borderSide: BorderSide(color: Color(0xffd5d1c6))),
                  focusedErrorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xffd5d1c6))),
                  errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xffd5d1c6))),
                  icon: new Icon(
                    Icons.lock,
                  color: Color(0xfff8dd82)),
                ),
                keyboardType: TextInputType.text,
                obscureText: true,
                controller: _password,
              ),
            ),
            new Container(
              color: Color(0xff7e7862),
              margin: EdgeInsets.only(bottom: 15),
              child: new TextField(
                style: TextStyle(
                    color: Color(0xffd5d1c6)
                ),
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(color:Color(0xffd5d1c6)),
                  hintText: "Enter your email",
                  hintStyle: TextStyle(color:Color(0xffd5d1c6)),
                  errorText: errorEmail,
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xffd5d1c6))),
                  enabledBorder:  UnderlineInputBorder(borderSide: BorderSide(color: Color(0xffd5d1c6))),
                  focusedErrorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xffd5d1c6))),
                  errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xffd5d1c6))),
                  icon: new Icon(
                      Icons.mail,
                    color: Color(0xfff8dd82),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                controller: _email,
              ),
            ),
            new Container(
              color: Color(0xff7e7862),
              margin: EdgeInsets.only(bottom: 15),
              child: new TextField(

                style: TextStyle(
                    color: Color(0xffd5d1c6)
                ),
                decoration: InputDecoration(
                  labelText: "phone",
                  errorText: errorPhone,
                  labelStyle: TextStyle(color:Color(0xffd5d1c6)),
                  hintText: "Enter your phone number",
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xffd5d1c6))),
                  enabledBorder:  UnderlineInputBorder(borderSide: BorderSide(color: Color(0xffd5d1c6))),
                  focusedErrorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xffd5d1c6))),
                  errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xffd5d1c6))),
                  hintStyle: TextStyle(color: Color(0xffd5d1c6)),
                  icon: new Icon(
                    Icons.phone,
                    color: Color(0xfff8dd82),
                  ),
                ),
                keyboardType: TextInputType.phone,
                controller: _phone,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 120,vertical: 10),
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
          ],
        ),
      ),
    );
  }
}
