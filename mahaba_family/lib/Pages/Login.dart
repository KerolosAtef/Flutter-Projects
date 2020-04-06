import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../AppCommon.dart';
import '../GlobalState.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }

}
class LoginState extends State <Login> {
  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();

  void login (){
    AppCommon.mAuth.signInWithEmailAndPassword(
        email: _email.text.toString(),
        password: _password.text.toString()
    ).then((user){
      GlobalState.ourInstance.setValue("userId", user.user.uid);
      FirebaseDatabase.instance.reference().child("Admins").child(user.user.uid).once().then((snapshot){
        print(snapshot.value);
        if (user != null && snapshot.value!=null){
          Navigator.pushReplacementNamed(context, '/AdminHome');
        }
        else if (user!=null && user.user.uid=="WFw6OwAAulYPsVEPzkVTqg2yZX73"){
          Navigator.pushReplacementNamed(context, '/AdminRegidter');
        }
        else if (user!=null){
          Navigator.pushReplacementNamed(context, '/UserHome');
        }
        else {
          Navigator.pushReplacementNamed(context, '/Login');
        }
      });
    }).catchError((e){
      Navigator.pushReplacementNamed(context, '/Login');
    });
  }
  void signUp (){
    Navigator.pushNamed(context, '/UserRegister');
  }
  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: <Widget>[
            new Image.asset("",width: 200,height: 200,),
            new TextField(
              decoration: InputDecoration(
                hintText: "Email"
              ),
              controller: _email,
            ),
            new TextField(
              decoration: InputDecoration(
                hintText: "Password"
              ),
              controller: _password,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 120,vertical: 20),
              child: RaisedButton(onPressed: login, child: Text("Login"),),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 120,vertical: 20),
              child: RaisedButton(onPressed: signUp, child: Text("Register"),),
            ),
          ],
        ),
      ),

    );
  }

}