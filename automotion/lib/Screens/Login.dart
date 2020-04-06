import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


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
  TextEditingController _reset = new TextEditingController();
  TextEditingController _commitController = new TextEditingController();

  String errorAuth ="" , errorEmail ="",errorPassword="",resetStatus="";
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
      ).then((FirebaseUser user){
        if (user != null) {
          if (user.uid=="xm4Gyf0TUvaPsnuNuKhxrITy0IO2"){
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, '/Admin');
          }else {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, '/Home');
          }
        }
      }).catchError((e){
        print(e);
        setState(() {
          errorAuth="Can't Login, please check your internet Connection or Emial and Password";
          Navigator.pop(context);
        });
      });
    }
  }
  register (){
    Navigator.pushNamed(context, '/Register');
  }
  forgetPassword (){
    //show popup
    setState(() {
      resetStatus="";
    });
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
            content: new Column(
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
            ),
          );
        });
  }
  commitFunction(){
    _commitController.text="Submitted";
    showDialog(
        context: context,
        builder: (BuildContext context)=>
        new AlertDialog(
          title: new TextField(
            autofocus: true,
            controller: _commitController,
          ),
        ));
    Future.delayed(Duration(milliseconds: 300)).then((_){
      Navigator.pop(context);
    });
  }
  resetPassword (){
    if (_reset.text.contains("@") && _reset.text.contains(".com")) {
      mAuth.sendPasswordResetEmail(email: _reset.text).then((_) {
        setState(() {
          resetStatus = "We have sent you instructions to reset your password";
        });
      }).catchError((e){
        setState(() {
          resetStatus="Faild to send the reset Email ,check your internet connection";
        });
      });
    }
    else {
      setState(() {
        resetStatus="Invalid Email";
      });
    }
    commitFunction();
  }
  Connectivity _connectivity;
  StreamSubscription<ConnectivityResult> _subscription;
  var snackBarKey =GlobalKey<ScaffoldState>();

  void onConnectivityChange(ConnectivityResult result) {
    // TODO: Show snackbar, etc if no connectivity
    print(result);
    if (result==ConnectivityResult.none){
      snackBarKey.currentState.showSnackBar(
          SnackBar(
            content: Text("No internet connection"),
            duration: Duration(hours: 1),
          ));
    }
    else {
      snackBarKey.currentState.hideCurrentSnackBar();
    }

  }
  @override
  void initState() {
    _connectivity = new Connectivity();
    _subscription = _connectivity.onConnectivityChanged.listen(onConnectivityChange);
    // TODO: implement initState
    super.initState();
    mAuth= FirebaseAuth.instance ;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      key: snackBarKey,
      appBar: AppBar(
        title: new Text("Login",
            style: TextStyle(
                color: Color(0xFF5F6066)
        ),
        ),
        backgroundColor: Color(0xff3DABB8),
      ),
      backgroundColor: Color(0xFFEEEEEE),
      body:new Container(
        padding: EdgeInsets.all(
            15
        ),
        child: new ListView(
          children: <Widget>[
            new Image.asset(
              'assets/images/logo.png',
              width: 180,
              height: 200,
            ),
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
                  hintStyle: TextStyle(color: Color(0xFF5F6066),fontFamily:'Raleway',),
                  icon: new Icon(
                    Icons.email,
                    color: Color(0xFF5F6066),
                  ) ,
                  errorText: errorEmail,
                  errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF5F6066))),

    ),
              keyboardType: TextInputType.emailAddress,
              controller: _email,
            ),
            new TextField(
              style: TextStyle(
                color: Color(0xFF5F6066),
                  fontFamily:'Raleway'
              ),
              decoration: InputDecoration(
                labelText:"Password",
                labelStyle: TextStyle(
                  color: Color(0xFF5F6066),
                ),
                errorText: errorPassword,
                errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF5F6066))),
                hintText: "Enter your password",
                hintStyle: TextStyle(color: Color(0xFF5F6066)),
                icon: new Icon(Icons.lock,
                  color: Color(0xFF5F6066),
                ) ,
              ),
              keyboardType: TextInputType.text,
              obscureText: true,
              controller: _password,
            ),

            new Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: <Widget>[
                new RaisedButton(onPressed: logIn ,
                  child: new Text("Login" ,
                    style:TextStyle(
                      fontSize: 20,
                      color: Color(0xFFEEEEEE),
                    ) ,
                  ),
                  shape: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                  color: Color(0xFF5F6066),
//                  padding: EdgeInsets.symmetric(horizontal: 35,vertical: 20),
                  padding: EdgeInsets.all(15),

                ),
                new FlatButton(onPressed: forgetPassword,
                    child: new Text("Forget My Password"),
                ),
                new Padding(padding: EdgeInsets.only(top: 15)),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text("Don't have an account?"),
                    new FlatButton(onPressed: register,
                        child: new Text("SIGN UP!",style: TextStyle(color: Color(0xff3DABB8),fontSize: 20),)
                    ),
                  ],
                ),

              ],
            ),
            new Container(
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