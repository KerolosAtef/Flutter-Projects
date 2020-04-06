import 'package:flutter/material.dart';
import 'package:review_that/Pages/SignUp.dart';
import 'package:review_that/Pages/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

//notifiaction
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

// Pages
import 'package:review_that/Pages/ChooseLoginAndRegister.dart';
import 'package:review_that/Pages/Login.dart';
import 'package:review_that/Pages/SignUp.dart';
import 'package:review_that/Pages/Profile.dart';
import 'package:review_that/Pages/MenuHome.dart';
import 'package:review_that/Pages/CategoryHome.dart';
import 'package:review_that/Pages/Restaurant.dart';
import 'package:review_that/Pages/CategoryDetalis.dart';
import 'package:review_that/GlobalState.dart';
import 'package:review_that/Pages/AllReviews.dart';
import 'package:review_that/Pages/DatabaseTest.dart';
import 'Pages/AddNewCategory.dart';
import 'Pages/WebView.dart';

void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String,WidgetBuilder>{
        '/AddNewCategory' : (BuildContext context) => new AddNewCategory(),
        '/ChooseLoginAndRegister' :(BuildContext context)=> new ChooseLoginAndRegister(),
        '/CategoryDetalis' :(BuildContext context)=> new CategoryDetails(),
        '/CategoryHome' :(BuildContext context)=> new CategoryHome(),
        '/Login' :(BuildContext context)=> new Login(),
        '/MenuHome' :(BuildContext context)=>new MenuHome(),
        '/AllReviews' :(BuildContext context)=>new AllReviews(),
        '/Profile': (BuildContext context)=> new Profile(),
        '/Restaurant': (BuildContext context)=> new Restaurant(),
        '/SignUp':(BuildContext context)=> new SignUp(),
//        '/WebView':(BuildContext context)=> new WebView(),
      },
      title: 'Review That',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: new MyHomePage(),
    );
  }
}
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {

  String userToken = 'Hello World !';
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  new FlutterLocalNotificationsPlugin();



  SharedPreferences preferences ;
  Future<bool> saveData(String key , bool value) async {
    preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(key, value);
  }
  Future<bool> loadData(String key) async {
    preferences= await SharedPreferences.getInstance();
    return preferences.getBool(key);
  }
  var mAuth =FirebaseAuth.instance;
  start (){
    Future.delayed(Duration(seconds: 3)).then((_){
      mAuth.currentUser().then((user){
        if (user!=null && remembered ){
          Navigator.pushReplacementNamed(context, '/Profile');
        }
        else{
          Navigator.pushReplacementNamed(context, '/ChooseLoginAndRegister');
        }
      }).catchError((e){
        Navigator.pushReplacementNamed(context, '/ChooseLoginAndRegister');
      });
    });
  }
  showNotification(Map<String, dynamic> msg) async {
    var android = new AndroidNotificationDetails(
      'sdffds dsffds',
      "CHANNLE NAME",
      "channelDescription",
    );
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(
        0,
        msg['notification']['title'],
        msg['notification']['body']
        , platform
    );
  }

//  update(String token) {
//    print(token);
//    DatabaseReference databaseReference = new FirebaseDatabase().reference();
//    databaseReference.child('fcm-token/${token}').set({"token": token});
//  }
  bool remembered ;
  @override
  initState(){
    super.initState();
    loadData("rememberMe").then((value){
      setState(() {
        remembered=value;
      });
    });

    //notification
    var android = new AndroidInitializationSettings('mipmap/ic_launcher');
    var ios = new IOSInitializationSettings();
    var platform = new InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(platform);

    firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> msg) {
        showNotification(msg);
        print(" onLaunch called ${(msg)}");
      },
      onResume: (Map<String, dynamic> msg) {
        showNotification(msg);
        print(" onResume called ${(msg)}");
      },
      onMessage: (Map<String, dynamic> msg) {
        showNotification(msg);
        print(" onMessage called ${(msg)}");
      },
    );
    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, alert: true, badge: true));
    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings setting) {
      print('IOS Setting Registed');
    });
    firebaseMessaging.getToken().then((token) {
      GlobalState.ourInstance.setValue("userToken", token);
//      update(token);
    });
  }
  @override
  Widget build(BuildContext context) {
    start();
    return Scaffold(
        body:
        new SplashScreen(
          seconds: 3,
          loaderColor: Colors.purple,
          loadingText: Text("Loading",style: TextStyle(fontSize: 25),),
          image: Image.asset('assets/images/splash_screen_logo.png',fit: BoxFit.fill,),
          photoSize: 170,
          imageBackground: AssetImage('assets/images/splash_screen_background.jpg'),
        )
    );
  }
}
