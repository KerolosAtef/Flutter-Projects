import 'package:flutter/material.dart';

import '../../AppCommon.dart';
class AdminProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState()=>AdminProfileState();
}
class AdminProfileState extends State <AdminProfile> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(),
      bottomNavigationBar: new BottomNavigationBar(
        items: [
          new BottomNavigationBarItem(
              icon: new Icon(Icons.home,), title: new Text("Home")),
          new BottomNavigationBarItem(
              icon: new Image.asset("assets/icons/Bottom Navigation bar/2.png",width: 25,height: 25,), title: new Text("Scan Winners")),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.person,), title: new Text("Place Profile")),
        ],
        onTap:_onPressedBottomNavigationBar,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: 2,
      ),
    );
  }

  void _onPressedBottomNavigationBar (int position){
    switch (position) {
      case 0 : Navigator.pushNamed(context, '/AdminHome');break;
      case 1 : Navigator.pushNamed(context, '/ScanWinners');break;
    }
  }

}