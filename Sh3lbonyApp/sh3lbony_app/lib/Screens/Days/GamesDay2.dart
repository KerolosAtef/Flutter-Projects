import 'package:flutter/material.dart';
class GamesDay2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new GamesDay2State();
  }

}
class GamesDay2State extends State<GamesDay2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("Games Day2",style: TextStyle(color: Color.fromARGB(255, 25, 25, 25)),),
        backgroundColor: Color.fromARGB(255, 173, 129, 41),
      ),
      body: new Container(
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/games_day2.png'),fit: BoxFit.cover)),

      ),
    );
  }
}