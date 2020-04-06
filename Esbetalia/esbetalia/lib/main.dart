import 'package:esbetalia/Screens/Days/PdfContent.dart';
import 'package:flutter/material.dart';
import 'package:esbetalia/Screens/Login.dart';
import 'package:esbetalia/Screens/Register.dart';

//Days Directories
import 'package:esbetalia/Screens/Days/ScheduleDay1.dart';
import 'package:esbetalia/Screens/Days/ScheduleDay2.dart';
import 'package:esbetalia/Screens/Days/ScheduleDay3.dart';
import 'package:esbetalia/Screens/Days/GamesDay1.dart';
import 'package:esbetalia/Screens/Days/GamesDay2.dart';
import 'Screens/Days/RoheyaDay1.dart';
import 'package:esbetalia/Screens/Days/RoheyaDay2.dart';



// Common Directories
import 'package:esbetalia/Screens/Common/FeedbackApp.dart';
import 'package:esbetalia/Screens/Common/Scores.dart';
import 'package:esbetalia/Screens/Common/Rooms.dart';
import 'package:esbetalia/Screens/Common/Teams.dart';
import 'package:esbetalia/Screens/Common/Tranem.dart';
import 'package:esbetalia/Screens/Common/TranemContent.dart';


//notifiaction
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
//
import 'package:firebase_auth/firebase_auth.dart';
import 'package:splashscreen/splashscreen.dart';





void main() {
  runApp(
    new MaterialApp(
      debugShowCheckedModeBanner: false,

      home: new MyApp(),
      routes: <String,WidgetBuilder>{
        '/ScheduleDay1':(BuildContext context)=>new ScheduleDay1 (),
        '/ScheduleDay2':(BuildContext context)=>new ScheduleDay2 (),
        '/ScheduleDay3':(BuildContext context)=>new ScheduleDay3 (),
        '/GamesDay1':(BuildContext context)=>new GamesDay1 (),
        '/GamesDay2':(BuildContext context)=>new GamesDay2 (),
        '/Scores':(BuildContext context)=>new Scores (),
        '/Feedback':(BuildContext context)=> new FeedbackApp() ,
        '/Rooms':(BuildContext context)=>new Rooms(),
        '/Teams':(BuildContext context)=>new Teams (),
        '/Tranem':(BuildContext context)=>new Tranem (),
        '/Login' : (BuildContext context)=> new Login(),
        '/Register' : (BuildContext context) =>new Register(),
        '/TranemContent' : (BuildContext context) =>new TranemContent(),
        '/RoheyaDay1' : (BuildContext context) =>new RoheyaDay1(),
        '/RoheyaDay2' : (BuildContext context) =>new RoheyaDay2(),
        '/PdfContent' : (BuildContext context) =>new PdfContent(),
      },
      title: "Esbetalia",
      theme: ThemeData(
        fontFamily:'ErasMediumITC',
        accentColor: Color(0xffd5d1c6)
      ),
    )
  );
}
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var mAuth =FirebaseAuth.instance;
  var mToken ;
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var android =AndroidInitializationSettings('mipmap/ic_launcher');
    var ios=IOSInitializationSettings();
    var platform =InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(platform);
    //for ios permission
    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true , alert: true ,badge: true)
    );
    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings setting){
      print("onIosSettingsRegistered");
    });
    firebaseMessaging.configure(
      onLaunch: (Map <String,dynamic> map){
        print("onlaunch $map");
        showNotification (map);
      },
      onMessage:(Map <String,dynamic> map){
        print("onMessaging $map");
        showNotification (map);
      },
      onResume:(Map <String,dynamic> map){
        print("onResume $map");
        showNotification (map);
      },
    );
    firebaseMessaging.getToken().then((token){
      setState(() {
        mToken=token;
      });
    });
  }
  showNotification (Map myMap ) async{
    var android = AndroidNotificationDetails("1",
      "keroatef","channel Discription"
    );
    var ios =IOSNotificationDetails (presentSound: true,presentAlert: true,presentBadge: true);
    var platform = NotificationDetails(android,ios);

    await flutterLocalNotificationsPlugin.show(
        1,
        myMap['notification']['title'],
        myMap['notification']['body'],
        platform,
        payload: "koko");
  }

  start (){
    Future.delayed(Duration(seconds: 3)).then((_){
      mAuth.currentUser().then((user){
        if (user==null){
          Navigator.pushReplacementNamed(context, '/Login');
        }
        else{
          FirebaseDatabase.instance.reference().child("Users Data")
              .child(user.uid).child("token").set(mToken);

          Navigator.pushReplacementNamed(context, '/ScheduleDay1');
        }
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    start();
    return
      Scaffold(
        body:
        new SplashScreen(
          seconds: 3,
          loaderColor: Color(0xffd5d1c6),
          imageBackground: AssetImage('assets/images/splash_screen.jpg'),
          loadingText: Text("Loading",style: TextStyle(color: Color(0xffd5d1c6),fontSize: 25),),

        ),
      );
  }
}