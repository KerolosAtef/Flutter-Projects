import 'package:flutter/material.dart';
class SetPointsFree extends StatefulWidget {
  @override
  State<StatefulWidget> createState()=>SetPointsFreeState();
}
class SetPointsFreeState extends State <SetPointsFree> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          //set background image in the container
          Container (
//            decoration: BoxDecoration(
//                image: DecorationImage(
//                  image: AssetImage('assets/images/backgraound.jpg'),
//                  fit: BoxFit.cover,
//                ),
//              ),
          ),
          SingleChildScrollView(
            child: Column(
              children: <Widget>[

              ],
            ),
          ),
        ],
      ),
    );
  }

}