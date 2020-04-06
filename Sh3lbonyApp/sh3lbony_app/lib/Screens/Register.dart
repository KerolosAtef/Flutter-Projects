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
    print("submitted");
    print(_email.text);
    print(_password.text);

    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email.text,
        password: _password.text
    ).then((user){
      print("userId");
      registerRef=registerRef.child(user.uid);
      registerRef.child("name").set(_name.text.toString());
      registerRef.child("password").set(_password.text.toString());
      registerRef.child("email").set(_email.text.toString());
      registerRef.child("phone").set(_phone.text.toString());
    }).then((_){
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
      appBar: AppBar(
        title: new Text("Register",style: TextStyle(color: Color.fromARGB(255, 25, 25, 25)),),
        backgroundColor: Color.fromARGB(255, 173, 129, 41),
      ),
      backgroundColor: Color.fromARGB(255, 25, 25, 25),
      body: new Container(
        padding: EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: new ListView(
          children: <Widget>[
            new Image.asset(
              "assets/images/logo.png",
              width: 100,
              height: 150,
            ),
            new Container(
              child: new TextField(
                style: TextStyle(
                    color: Colors.white
                ),
                decoration: InputDecoration(
                  labelText: "Name",
                  labelStyle: TextStyle(color: Color.fromARGB(255, 173, 129, 41)),
                  hintText: "Enter your name",
                  hintStyle: TextStyle(color: Colors.white70),
                  errorText: errorName,
                  icon: new Icon(
                    Icons.person,
                    color: Color.fromARGB(255, 173, 129, 41),),
                ),
                keyboardType: TextInputType.text,
                controller: _name,
              ),
            ),
            new Container(
              child: new TextField(
                style: TextStyle(
                    color: Colors.white
                ),
                decoration: InputDecoration(
                  labelText: "password",
                  labelStyle: TextStyle(color: Color.fromARGB(255, 173, 129, 41)),
                  hintText: "Enter your password",
                  hintStyle: TextStyle(color: Colors.white70),
                  errorText: errorPassword,
                  icon: new Icon(
                    Icons.lock,
                  color: Color.fromARGB(255, 173, 129, 41),),
                ),
                keyboardType: TextInputType.text,
                obscureText: true,
                controller: _password,
              ),
            ),
            new Container(
              child: new TextField(
                style: TextStyle(
                    color: Colors.white
                ),
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(color: Color.fromARGB(255, 173, 129, 41)),
                  hintText: "Enter your email",
                  hintStyle: TextStyle(color: Colors.white70),
                  errorText: errorEmail,
                  icon: new Icon(
                      Icons.mail,
                    color: Color.fromARGB(255, 173, 129, 41),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                controller: _email,
              ),
            ),
            new Container(
              child: new TextField(
                style: TextStyle(
                    color: Colors.white
                ),
                decoration: InputDecoration(
                  labelText: "phone",
                  errorText: errorPhone,
                  labelStyle: TextStyle(color: Color.fromARGB(255, 173, 129, 41)),
                  hintText: "Enter your phone number",
                  hintStyle: TextStyle(color: Colors.white70),
                  icon: new Icon(
                    Icons.phone,
                    color: Color.fromARGB(255, 173, 129, 41),
                  ),
                ),
                keyboardType: TextInputType.phone,
                controller: _phone,
              ),
            ),
            new Container(

              padding: EdgeInsets.symmetric(
                vertical: 20
              ),
              child:new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new RaisedButton(onPressed: register ,
                    child: new Text("Register" ,
                      style:TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 25, 25, 25),
                      ) ,
                    ),
                    shape: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                    color: Color.fromARGB(255, 173, 129, 41),
                    padding: EdgeInsets.all(15),

                  ),
                ],
              ),

            ),
          ],
        ),
      ),
    );
  }
}
