import 'package:flutter/material.dart';
import 'package:stamp/AppCommon.dart';
class UserHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState()=>UserHomeState();
}
class UserHomeState extends State <UserHome> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(),
      bottomNavigationBar: new BottomNavigationBar(
        items: [
          new BottomNavigationBarItem(
              icon: new Icon(Icons.home,), title: new Text("Home")),
          new BottomNavigationBarItem(
              icon: new Image.asset("assets/icons/Bottom Navigation bar/1.png",width: 25,height: 25,), title: new Text("My Offers")),
          new BottomNavigationBarItem(
              icon: new Image.asset("assets/icons/Bottom Navigation bar/2.png",width: 25,height: 25,), title: new Text("Scan")),

          new BottomNavigationBarItem(
              icon: new Icon(Icons.person,), title: new Text("Profile")),
        ],
        onTap:_onPressedBottomNavigationBar,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
      ),

    );
  }
  void _onPressedBottomNavigationBar (int position){
    switch (position) {
      case 0 :AppCommon.mAuth.signOut();break;
      case 1 :Navigator.pushNamed(context, '/MyOffers');break;
      case 2 :Navigator.pushNamed(context, '/QRReader');break;
      case 3 :Navigator.pushNamed(context, '/UserProfile');break;
    }

  }

}