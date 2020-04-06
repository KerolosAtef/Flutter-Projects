import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

//pages
import 'package:balghsoon/Pages/Home.dart';
import 'package:balghsoon/Pages/Departments.dart';
import 'package:balghsoon/Pages/KnowYourDoctor.dart';
import 'package:balghsoon/Pages/AboutBalghsoonClinics.dart';
import 'package:balghsoon/Pages/CallUs.dart';
import 'package:balghsoon/Pages/TimeTable.dart';
import 'package:balghsoon/Pages/DoctorsInformation.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String,WidgetBuilder>{
        '/AboutBalghsoonClinics' : (BuildContext context) => new AboutBalghsoonClinics(),
        '/CallUs' :(BuildContext context)=> new CallUs(),
        '/Departments' :(BuildContext context)=> new Departments(),
        '/Home' :(BuildContext context)=> new Home(),
        '/KnowYourDoctor' :(BuildContext context)=> new KnowYourDoctor(),
        '/TimeTable' :(BuildContext context)=>new TimeTable(),
        '/DoctorsInformation' :(BuildContext context)=>new DoctorsInformation(),
//        '/Profile': (BuildContext context)=> new Profile(),
//        '/Restaurant': (BuildContext context)=> new Restaurant(),
//        '/SignUp':(BuildContext context)=> new SignUp(),
      },
      title: 'Balghsoon',
      theme: ThemeData(
        primaryColor: Color(0xff45b0d4),
        primaryIconTheme: IconThemeData(color: Colors.white)
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
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: new SplashScreen(
        seconds: 3,
        loaderColor: Color(0xff45b0d4),
        loadingText: Text("Loading",style: TextStyle(fontSize: 25),),
        image: Image.asset('assets/images/logo.png',fit: BoxFit.fill,),
        photoSize: 170,
//        imageBackground: AssetImage('assets/images/splash_screen_background.jpg'),
        navigateAfterSeconds: new Home(),
      )
    );
  }

}
