import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';


// pages
import 'package:automotion/Screens/Login.dart';
import 'package:automotion/Screens/Register.dart';
import 'package:automotion/Screens/Home.dart';
import 'package:automotion/Screens/Rooms/Room1.dart';
import 'package:automotion/Screens/Rooms/Room2.dart';
import 'package:automotion/Screens/Rooms/Room3.dart';
import 'package:automotion/Screens/Rooms/Room4.dart';
import 'package:automotion/Screens/Rooms/Room5.dart';
import 'package:automotion/Screens/Rooms/Room6.dart';
import 'package:automotion/Screens/Rooms/Room7.dart';
import 'package:automotion/Screens/Rooms/Room8.dart';
import 'package:automotion/Screens/Admin.dart';
import 'package:automotion/Screens/CustomRooms.dart';
// desktop
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;


void main() {
  // See https://github.com/flutter/flutter/wiki/Desktop-shells#target-platform-override
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title:"Automotion App" ,
      home:MyHomePage(),
      routes: <String,WidgetBuilder>{
        '/Login': (BuildContext context) => new Login(),
        '/Register' : (BuildContext context)=>new Register(),
        '/Home' : (BuildContext context)=>new Home(),
        '/Room1': (BuildContext context) => new Room1(),
        '/Room2': (BuildContext context) => new Room2(),
        '/Room3': (BuildContext context) => new Room3(),
        '/Room4': (BuildContext context) => new Room4(),
        '/Room5': (BuildContext context) => new Room5(),
        '/Room6': (BuildContext context) => new Room6(),
        '/Room7': (BuildContext context) => new Room7(),
        '/Room8': (BuildContext context) => new Room8(),
        '/CustomRooms': (BuildContext context) => new CustomRooms(),
        '/Admin': (BuildContext context) => new Admin(),

      }
      ,theme: ThemeData(
      scaffoldBackgroundColor:  Color(0xFFEEEEEE),
      dialogBackgroundColor: Color(0xFFEEEEEE),
//      fontFamily:'Adventure',
      primaryColor: Color(0xff3DABB8),
      accentColor: Color(0xff3DABB8)
    ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyHomePageState();
  }

}

class _MyHomePageState extends State<MyHomePage> {
  var mAuth =FirebaseAuth.instance;
  start (){
    Future.delayed(Duration(seconds: 3)).then((_){
      mAuth.currentUser().then((user){
        if (user==null){
          Navigator.pushReplacementNamed(context, '/Login');
        }
        else{
          if (user.uid=="x6CWA3dByHdkwEHdfyciSA7rnX12"){
            Navigator.pushReplacementNamed(context, '/Admin');
          }
          else {
            Navigator.pushReplacementNamed(context, '/Home');
          }
        }
      });
    });
  }
  final flutterWebViewPlugin = new FlutterWebviewPlugin();
  String urlRoom="http://192.168.1.150/Room/";
  String urlSW="http://192.168.1.150/";

  click (String roomNum ,String swNum,String status){
    flutterWebViewPlugin.close();
    flutterWebViewPlugin.launch(urlRoom+roomNum,
      rect: new Rect.fromLTWH(
        0.0,
        0.0,
        MediaQuery.of(context).size.width,
        0.0,
      ),
    );
    Future.delayed(Duration(milliseconds: 500)).then((_){
      flutterWebViewPlugin.close();
      flutterWebViewPlugin.launch(urlSW+"SW/"+swNum+"/"+status,
        rect: new Rect.fromLTWH(
          0.0,
          0.0,
          MediaQuery.of(context).size.width,
          0.0,
        ),
      );
    });
  }

  _launchURL() async {
    const url = 'https://flutter.io';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    start();
    return new Scaffold(
      body:
      new SplashScreen(
        seconds: 3,
        loaderColor: Color(0xff4DD0E1),
        loadingText: Text("Loading",style: TextStyle(fontSize: 25),),
        image: Image.asset('assets/images/logo.png',fit: BoxFit.fill,),
        photoSize: 130,
      )
    );
  }

}
