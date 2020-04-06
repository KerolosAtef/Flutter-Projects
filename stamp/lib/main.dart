import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:stamp/AppCommon.dart';
import 'package:stamp/Pages/Admin/AddNewOffer.dart';
import 'package:stamp/Pages/Admin/AdminHome.dart';
import 'package:stamp/Pages/Admin/AdminProfile.dart';
import 'package:stamp/Pages/Admin/AdminRegister.dart';
import 'package:stamp/Pages/Admin/GenerateQRCode.dart';
import 'package:stamp/Pages/Admin/ScanWinners.dart';
import 'package:stamp/Pages/Login.dart';
import 'package:stamp/Pages/User/Congratulation.dart';
import 'package:stamp/Pages/User/UserProfile.dart';
import 'package:stamp/Pages/User/QRReader.dart';
import 'package:stamp/Pages/User/UserHome.dart';

import 'GlobalState.dart';
import 'Pages/User/MyOffers.dart';
import 'Pages/User/NewOffers.dart';
import 'Pages/User/UserRegister.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      routes:<String,WidgetBuilder>{
        '/AdminRegister' : (BuildContext context) => new AdminRegister(),
        '/GenerateQRCode' :(BuildContext context)=> new GenerateQRCode(),
        '/Login' :(BuildContext context)=> new Login(),
        '/QRReader' :(BuildContext context)=> new QRReader(),
        '/UserRegister' :(BuildContext context)=> new UserRegister(),
        '/MyOffers' :(BuildContext context)=> new MyOffers(),
        '/NewOffers' :(BuildContext context)=> new NewOffers(),
        '/AddNewOffer' :(BuildContext context)=> new AddNewOffer(),
        '/AdminHome' :(BuildContext context)=> new AdminHome(),
        '/UserHome' :(BuildContext context)=> new UserHome(),
        '/ScanWinners' :(BuildContext context)=> new ScanWinners(),
        '/Congratulation' :(BuildContext context)=> new Congratulation(),
        '/UserProfile' :(BuildContext context)=> new UserProfile(),
        '/AdminProfile' :(BuildContext context)=> new AdminProfile(),

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
          else if (user!=null && user.uid=="WFw6OwAAulYPsVEPzkVTqg2yZX73"){
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
