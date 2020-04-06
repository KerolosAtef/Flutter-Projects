import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class ChooseLoginAndRegister extends StatefulWidget {
  @override
  ChooseLoginAndRegisterState createState() => ChooseLoginAndRegisterState();
}
class ChooseLoginAndRegisterState extends State<ChooseLoginAndRegister> {
  void login (){
    Navigator.pushNamed(context, '/Login');
  }
  void register(){
    Navigator.pushNamed(context, '/SignUp');
  }
  var mAuth =FirebaseAuth.instance ;
  var recordData=FirebaseDatabase.instance.reference().child("UserData");
  var snackBarKey =GlobalKey<ScaffoldState>();
  SharedPreferences preferences ;
  Future<bool> saveData(String key , bool value) async {
    preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(key, value);
  }
  Future registerWithFacebook() async {
    final facebookLogin = FacebookLogin();
    facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;

    facebookLogin.logInWithReadPermissions(['email','public_profile']).then((result){
      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          print(result.status);
          FacebookAccessToken myToken = result.accessToken;

          ///assuming sucess in FacebookLoginStatus.loggedIn
          /// we use FacebookAuthProvider class to get a credential from accessToken
          /// this will return an AuthCredential object that we will use to auth in firebase
          AuthCredential credential= FacebookAuthProvider.getCredential(accessToken: myToken.token);
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context){
              return new AlertDialog(
                content: new Row(
                  children: [
                    new CircularProgressIndicator(),
                    new Padding(padding: EdgeInsets.only(left: 10)),
                    new Text("Signing Up..."),
                  ],
                ),
              );
            },
          );
          FirebaseAuth.instance.signInWithCredential(credential).then((signedInUser) async {
            print(signedInUser.user.uid);
            final token = result.accessToken.token;
            final graphResponse = await http.get(
                'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
            final profile = json.decode(graphResponse.body);

            recordData=recordData.child(signedInUser.user.uid);

            recordData.child("name").set(profile["name"]);
            recordData.child("email").set(profile["email"]);
            recordData.child("password").set("facebook password");
            saveData("rememberMe", true);
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context,'/Profile');
          });
          break;
        case FacebookLoginStatus.cancelledByUser:
          print(result.status);

          print("cancel");
          break;
        case FacebookLoginStatus.error:
          print(result.status);

          print("error");
          break;
      }

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/backgraound.jpg'),
                fit: BoxFit.cover
            ),
          ),
          child:ListView(
            children: <Widget>[
              new Container(
                padding: EdgeInsets.only(top: 40),
              ),
              new Image.asset(
                'assets/images/login_logo.png',
                width: 210,
                height: 265,
              ),
              Container(
                margin: EdgeInsets.only(top: 80),
                height: 50,
                padding: EdgeInsets.symmetric( horizontal: 80),
                child: new RaisedButton(
                  onPressed: login,
                  shape: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Text("LOGIN",style: TextStyle(
                      color: Color(0xFF6A1B9A),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat'
                  ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                height: 50,
                padding: EdgeInsets.symmetric( horizontal: 80),
                child: new RaisedButton(
                  onPressed: registerWithFacebook,
                  shape: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Text("Login with Facebook",style: TextStyle(
                      color: Color(0xFF6A1B9A),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat'
                  ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                height: 50,
                padding: EdgeInsets.symmetric( horizontal: 80),
                child: new RaisedButton(
                  onPressed: register,
                  shape: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Text("REGISTER",style: TextStyle(
                      color: Color(0xFF6A1B9A),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat'
                  ),
                  ),
                ),
              ),

            ],

          ),
        )
    );
  }
}
