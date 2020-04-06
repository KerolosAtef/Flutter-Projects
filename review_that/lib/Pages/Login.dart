import 'dart:async';

import 'package:flutter/material.dart';
import 'package:review_that/Pages/SignUp.dart';
import 'package:review_that/Pages/SignUp.dart';
import 'package:review_that/Pages/Profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:review_that/GlobalState.dart';
import 'package:connectivity/connectivity.dart';

import 'package:shared_preferences/shared_preferences.dart';
class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}
class LoginState extends State<Login> {
  bool rememberMeValue =false ;
  TextEditingController _email =TextEditingController();
  TextEditingController _password =TextEditingController();

  var mAuth = FirebaseAuth.instance;
  var snackBarKey = GlobalKey<ScaffoldState>();


  void login(){
    if (_email.text.isNotEmpty&&_password.text.isNotEmpty){
      if (! _email.text.contains("@") || !_email.text.contains(".com") ){
        snackBarKey.currentState.showSnackBar(SnackBar(content: Text("Invalid Email Pattern")));
      }
      if (_password.text.length < 6){
        snackBarKey.currentState.showSnackBar(SnackBar(content: Text("Password must be more than 6 characters")));
      }
      if (!connected){
        snackBarKey.currentState.showSnackBar(SnackBar(content: Text("Can't login ,There is no internet Connection")));
      }
      if (_email.text.contains("@") &&
          _email.text.contains(".com") && _password.text.length>= 6 && connected){
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
        mAuth.signInWithEmailAndPassword(email: _email.text.trim(), password: _password.text.trim()).then((user){
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context,'/Profile');
        }).catchError((e){
          print(e) ;
          Navigator.pop(context);
          snackBarKey.currentState.showSnackBar(SnackBar(content: Text("Wrong Email or Password")));

        });
      }
    }
    else {
      snackBarKey.currentState.showSnackBar(SnackBar(content: Text("Enter your Email and Password")));
    }

  }
  forgetPassword (){
    //show popup
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color(0xFFEEEEEE),
            title:new Row(
              children: <Widget>[
                new Expanded(child: new Text("Reset Your Password"),),
                new IconButton(icon: new Icon(Icons.close), onPressed:()=>Navigator.pop(context)),

              ],
            ),
            content: new myDialog()
          );
        });
  }

  SharedPreferences preferences ;
  Future<bool> saveData(String key , bool value) async {
    preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(key, value);
  }
  Future<bool> loadData(String key) async {
    preferences= await SharedPreferences.getInstance();
    return preferences.getBool(key);
  }
  void rememberMe (bool value){
    setState(() {
      rememberMeValue=value;
    });
    saveData("rememberMe", value);
  }
  Connectivity _connectivity;
  StreamSubscription<ConnectivityResult> _subscription;
  bool connected =true ;
  void onConnectivityChange(ConnectivityResult result) {
    // TODO: Show snackbar, etc if no connectivity
    print(result);
    if (result==ConnectivityResult.none){
      setState(() {
        connected=false ;
      });
      snackBarKey.currentState.showSnackBar(
          SnackBar(
            content: Text("No internet connection"),
            duration: Duration(seconds: 5),
          ));
    }
    else {
      setState(() {
        connected=true ;
      });
      snackBarKey.currentState.hideCurrentSnackBar();
    }

  }

  bool resetPasswordFocus=true;

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
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/backgraound.jpg'),
                fit: BoxFit.cover
            ),
          ),
        child: ListView(
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
                width: 400.0,
                height: 240.0,
                child: Center(child: Image.asset('assets/images/login_logo.png'),)
            ),
            new Container(
              margin: EdgeInsets.only(left: 20,right: 20,top: 30),
              decoration: BoxDecoration(borderRadius:BorderRadius.circular(30.0),color: Color(0xffaaa4be) ),
              padding: EdgeInsets.only(top: 40,left: 25,right: 25,bottom: 20),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  TextField(
                    controller: _email,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
//                      border: OutlineInputBorder(
//                          borderRadius: BorderRadius.circular(15.0)
//                      ),
                        prefixIcon: Icon(Icons.account_circle),
                        labelText: 'EMAIL',
                        labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,

                        ),
//                        focusedBorder: UnderlineInputBorder(
//                            borderSide: BorderSide(color: Colors.purple)
//                        )
                    ),
                  ),
                  SizedBox(height: 15.0),

                  TextField(
                    controller: _password,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
//                        border: OutlineInputBorder(
//                            borderRadius: BorderRadius.circular(15.0)
//                        ),
                        prefixIcon: Icon(Icons.lock),
                        labelText: 'PASSWORD',
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.black54
                        ),
//                        focusedBorder: UnderlineInputBorder(
//                            borderSide: BorderSide(color: Colors.white)
//                        )
                    ),
                    obscureText: true,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    height: 50,
                    width: 300,
                    child: new RaisedButton(
                      onPressed: login,
                      color:Color(0xFF6A1B9A) ,
                      shape: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Text("LOGIN",style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat'
                      ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: new Row(
                      children: <Widget>[
                        new Checkbox(value: rememberMeValue, onChanged: rememberMe),
                        Text('Remember Me',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                              decoration: TextDecoration.underline),
                        ),
                      ],
                    ),

                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FlatButton(onPressed: forgetPassword, child: Text('Forgot Password..?',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                            decoration: TextDecoration.underline),
                      ),),
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
class myDialog extends StatefulWidget {
  myDialog({
    Key key,
  }): super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new myDialogState();
  }

}
class myDialogState extends State<myDialog> {
  String resetStatus ="";
  var mAuth=FirebaseAuth.instance;
  TextEditingController _reset = new TextEditingController();

  resetPassword (){
    if (_reset.text.contains("@") && _reset.text.contains(".com")) {
      FocusScope.of(context).requestFocus(new FocusNode());
      mAuth.sendPasswordResetEmail(email: _reset.text).then((_) {
        setState(() {
          resetStatus = "We have sent an email which includes the instructions to reset your password";
        });
      }).catchError((e){
        setState(() {
          resetStatus="Faild to send the reset Email ,check your internet connection or your Email";
        });
      });
    }
    else {
      setState(() {
        resetStatus="Invalid Email";
      });
    }
  }
  @override
  void initState() {
    setState(() {
      resetStatus="";
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return new Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        new TextField(
          style: TextStyle(
            color: Color(0xFF5F6066),
          ),
          decoration: InputDecoration(
            labelText:"Email",
            labelStyle: TextStyle(
              color: Color(0xFF5F6066),
              fontSize: 15,
            ),
            hintText: "Enter your email",
            hintStyle: TextStyle(color: Color(0xFF5F6066)),
            errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF5F6066))),
            icon: new Icon(
              Icons.email,
              color: Color(0xFF5F6066),
            ) ,
          ),
          keyboardType: TextInputType.emailAddress,

          controller: _reset,
        ),
        new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Padding(padding: EdgeInsets.only(top: 15)),
            new RaisedButton(onPressed: resetPassword ,
              child: new Text("Reset" ,
                style:TextStyle(
                  color: Color(0xFF5F6066),
                ) ,
              ),
              shape: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
              color: Color(0xff3DABB8),

            ),
          ],
        ),
        new Text(resetStatus),
      ],
    );
  }
}
