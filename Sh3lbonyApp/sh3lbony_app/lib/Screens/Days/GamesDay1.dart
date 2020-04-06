import 'package:flutter/material.dart';
class GamesDay1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new GamesDay1State();
  }

}
class GamesDay1State extends State<GamesDay1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("Games Day1",style: TextStyle(color: Color.fromARGB(255, 25, 25, 25)),),
        backgroundColor: Color.fromARGB(255, 173, 129, 41),
      ),
      body: new Container(
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/games_day1.png'),fit: BoxFit.cover)),

      ),
    );
  }
}