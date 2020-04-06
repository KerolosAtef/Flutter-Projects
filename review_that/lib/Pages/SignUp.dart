import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:review_that/Pages/Profile.dart';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../GlobalState.dart';


class SignUp extends StatefulWidget {
  @override
  SignUpPageState createState() => SignUpPageState();
}
class SignUpPageState extends State<SignUp> {
  TextEditingController _name =TextEditingController();
  TextEditingController _email =TextEditingController();
  TextEditingController _password =TextEditingController();
  TextEditingController _confirmPassword =TextEditingController();
  List<String> errors =["","",""];
  var mAuth =FirebaseAuth.instance ;
  var recordData=FirebaseDatabase.instance.reference().child("UserData");
  var snackBarKey =GlobalKey<ScaffoldState>();
  SharedPreferences preferences ;
  Future<bool> saveData(String key , bool value) async {
    preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(key, value);
  }



  Future register() async {
    if (_name.text.isNotEmpty||_email.text.isNotEmpty||
        _password.text.isNotEmpty ||_confirmPassword.text.isNotEmpty ){
        if (!_email.text.contains("@") || !_email.text.contains(".com")){
          setState(() {
            errors[0]="Invalid Emial Pattern";
          });
        }
        if (_password.text.trim() != _confirmPassword.text.trim()){
          setState(() {
            errors[1]="Password and confirm password are different";
          });
        }
        else if (_password.text.length<6 ){
          setState(() {
            errors[1]="Password should be more than 6 items";
            errors[2]="Password should be more than 6 items";
          });
        }
        if (!connected){
          snackBarKey.currentState.showSnackBar(SnackBar(content:
          Text("Can't SignUp ,NO internet Connection")));
        }
        if (_email.text.contains("@") && _email.text.contains(".com") &&
        _password.text.trim() == _confirmPassword.text.trim() &&
            _password.text.length>=6 && _confirmPassword.text.length>=6 && connected){
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context){
              return new AlertDialog(
                content: new Row(
                  children: [
                    new CircularProgressIndicator(),
                    new Padding(padding: EdgeInsets.only(left: 10)),
                    new Text("Signing up..."),
                  ],
                ),
              );
            },
          );
          await mAuth.createUserWithEmailAndPassword(email: _email.text, password: _password.text).then((user){
            // record the data
            recordData=recordData.child(user.user.uid);
            recordData.child("name").set(_name.text);
            recordData.child("email").set(_email.text);
            recordData.child("password").set(_password.text);
          }).then((_){
            Navigator.pop(context); //pop dialog
            Navigator.pushReplacementNamed(context, '/Profile');
          }).catchError((e){
            Navigator.pop(context); //pop dialog
            snackBarKey.currentState.showSnackBar(SnackBar(content:
            Text("Can't SignUp ,The email address is already in use by another account")));
          });
        }
    }
    else {
      snackBarKey.currentState.showSnackBar(SnackBar(content: Text("please fill all Data")));

    }
  }
  Connectivity _connectivity;
  StreamSubscription<ConnectivityResult> _subscription;
  bool connected =true ;
  void onConnectivityChange(ConnectivityResult result) {
    print(result);
    if (result==ConnectivityResult.none){
      setState(() {
        connected =false ;
      });
      snackBarKey.currentState.showSnackBar(
          SnackBar(
            content: Text("No internet connection"),
            duration: Duration(seconds: 5),
          ));
    }
    else {
      setState(() {
        connected =true ;
      });
      snackBarKey.currentState.hideCurrentSnackBar();
    }

  }
  @override
  void initState() {
    _connectivity = new Connectivity();
      _connectivity.checkConnectivity().then((result){
        onConnectivityChange(result);
      });
    _subscription = _connectivity.onConnectivityChanged.listen(onConnectivityChange);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: snackBarKey,
      body: new Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/backgraound.jpg'),
              fit: BoxFit.cover
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: new ListView(
          children: <Widget>[
            new Image.asset(
              "assets/images/login_logo.png",
              width: 200,
              height: 200,
            ),
            new Container(
              margin: EdgeInsets.only(left: 10,right: 10,top: 30),
              decoration: BoxDecoration(borderRadius:BorderRadius.circular(30.0),color: Color(0xffaaa4be) ),
              padding: EdgeInsets.all(30),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                        margin: EdgeInsets.only(top: 10,bottom: 10),
                        child: Text('Create an Account',
                          style: TextStyle(
                              fontSize: 25.0,
                              fontWeight:FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Montserrat'
                          ),
                        ),
                      )
                    ],
                  ),
                  TextField(
                    controller: _name,
                    decoration: InputDecoration(
                        filled: true,
                        focusColor: Colors.white,
                        focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        fillColor: Colors.white,
//                        border: OutlineInputBorder(
//                          borderRadius: BorderRadius.circular(15.0),
//                        ),
                        labelText: 'Full  Name',
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color:Color(0xFF6A1B9A)))),
                  ),
                SizedBox(height: 15.0),
                  TextField(
                    controller: _email,
                    decoration: InputDecoration(
                        filled: true,
                        focusColor: Colors.white,
                        fillColor: Colors.white,

                        labelText: 'Email',
//                        errorText: errors[0],
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF6A1B9A)))),
                  ),
                  Text(errors[0],style: TextStyle(color: Colors.red),),
                  SizedBox(height: 2.0),

                  TextField(
                    controller: _password,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        focusColor: Colors.white,
                        labelText: 'Password ',
//                        errorText: errors[1],
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF6A1B9A)))),
                    obscureText: true,
                  ),
                  Text(errors[1],style: TextStyle(color: Colors.red),),
                  SizedBox(height: 2.0),
                  TextFormField(
                    controller: _confirmPassword,
                    decoration: InputDecoration(
                        filled: true,
                        focusColor: Colors.white,
                        fillColor: Colors.white,
                        labelText: 'Confirm Password ',
//                        errorText: errors[2],
                        errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffaaa4be)),borderRadius:BorderRadius.circular(15.0) ),

                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF6A1B9A)))),
                    obscureText: true,
                  ),
                  Text(errors[2],style: TextStyle(color: Colors.red),),
                  SizedBox(height: 2.0),
//                  Container(
//                    padding:EdgeInsets.only( left: 50.0, right: 50.0,),
//                    height: 45.0,
//                    color: Colors.transparent,
//                    child: Container(
//                      decoration: BoxDecoration(
//                          border: Border.all(
//                              color: Colors.white,
//                              style: BorderStyle.solid,
//                              width: 1.0
//                          ),
//                          color: Colors.transparent,
//                          borderRadius: BorderRadius.circular(20.0)
//                      ),
//                      child: GestureDetector(
//                        onTap: registerWithFacebook,
//                        child: Row(
//                          mainAxisAlignment: MainAxisAlignment.center,
//                          children: <Widget>[
//                            ImageIcon(AssetImage('assets/icons/facebook.png'),
//                              color: Colors.white,
//                            ),
//                            Flexible(
//                              child: Text('Login with Facebook',
//                                style: TextStyle(
//                                    fontSize: 12.0,
//                                    fontWeight:FontWeight.bold,
//                                    color: Colors.white,
//                                    fontFamily: 'Montserrat'
//                                ),
//                              ),
//                            ),
//                          ],
//                        ),
//                      )
//                    ),
//                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    height: 40,
                    width: 150,
                    child: new RaisedButton(
                      onPressed: register,
                      color:Color(0xFF6A1B9A) ,
                      shape: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Text("Sign UP",style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat'
                      ),
                      ),
                    ),
                  ),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
