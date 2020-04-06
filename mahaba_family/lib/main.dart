import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mahabafamily/Pages/Admin/AddNewOffer.dart';
import 'package:mahabafamily/Pages/Admin/AdminRegister.dart';
import 'package:mahabafamily/Pages/User/MahabaOffers.dart';
import 'package:splashscreen/splashscreen.dart';


import 'AppCommon.dart';
import 'GlobalState.dart';

import 'Pages/Admin/GenerateQRCode.dart';
import 'Pages/Admin/SetPointsFree.dart';
import 'Pages/Login.dart';
import 'Pages/User/QRReader.dart';
import 'Pages/User/UserHome.dart';
import 'Pages/User/UserProfile.dart';
import 'Pages/UserRegister.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      routes:<String,WidgetBuilder>{
        '/AddNewOffer' :(BuildContext context)=> new AddNewOffer(),
        '/AdminRegister' :(BuildContext context)=> new AdminRegister(),
        '/GenerateQRCode' :(BuildContext context)=> new GenerateQRCode(),
        '/SetPointsFree' :(BuildContext context)=> new SetPointsFree(),
        '/MahabaOffers' :(BuildContext context)=> new MahabaOffers(),
        '/QRReader' :(BuildContext context)=> new QRReader(),
        '/UserHome' :(BuildContext context)=> new UserHome(),
        '/UserProfile' :(BuildContext context)=> new UserProfile(),
        '/Login' :(BuildContext context)=> new Login(),
        '/UserRegister' :(BuildContext context)=> new UserRegister(),

      },
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  start (){
    Future.delayed(Duration(seconds: 2)).then((_){
      AppCommon.mAuth.currentUser().then((user){
        GlobalState.ourInstance.setValue("userId", user.uid);
        FirebaseDatabase.instance.reference().child("Admins").child(user.uid).once().then((snapshot){
          if (user != null && snapshot.value!=null){
            Navigator.pushReplacementNamed(context, '/AdminHome');
          }
          else if (user!=null && user.uid=="aSus02wXPJPiV8ruCHvFS1fLnqB2"){
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
    });
  }

  @override
  Widget build(BuildContext context) {
    start();
    return Scaffold(
        body:
        new SplashScreen(
          seconds: 2,
          loaderColor: Colors.purple,
          loadingText: Text("Loading",style: TextStyle(fontSize: 25),),
          image: Image.asset('assets/images/splash_screen_logo.png',fit: BoxFit.fill,),
          photoSize: 170,
          imageBackground: AssetImage('assets/images/splash_screen_background.jpg'),
        )
    );
  }
}
