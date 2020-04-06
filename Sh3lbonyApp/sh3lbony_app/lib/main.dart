import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:sh3lbony_app/Screens/Login.dart';
import 'package:sh3lbony_app/Screens/Register.dart';

//Days Directories
import 'package:sh3lbony_app/Screens/Days/ScheduleDay1.dart';
import 'package:sh3lbony_app/Screens/Days/ScheduleDay2.dart';
import 'package:sh3lbony_app/Screens/Days/ScheduleDay3.dart';
import 'package:sh3lbony_app/Screens/Days/GamesDay1.dart';
import 'package:sh3lbony_app/Screens/Days/GamesDay2.dart';

// Common Directories
import 'package:sh3lbony_app/Screens/Common/FeedbackApp.dart';
import 'package:sh3lbony_app/Screens/Common/Scores.dart';
import 'package:sh3lbony_app/Screens/Common/Rooms.dart';
import 'package:sh3lbony_app/Screens/Common/Teams.dart';
import 'package:sh3lbony_app/Screens/Common/Tranem.dart';
import 'package:sh3lbony_app/Screens/Common/TranemContent.dart';


//notifiaction
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
//
import 'package:firebase_auth/firebase_auth.dart';




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
      },
      title: "Sh3lbony",
      theme: ThemeData(
        fontFamily:'Adventure'
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
      print("token = "+ token);
      print("koko");
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
          loaderColor: Color.fromARGB(255, 173, 129, 41),
          imageBackground: AssetImage('assets/images/splash_screen.png'),
          loadingText: Text("Loading"),
        ),
      );
  }
}