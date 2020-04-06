import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sh3lbony_app/GlobalState.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

class TranemContent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new TranemContentState();
  }

}
class TranemContentState extends State <TranemContent> {
  String content,tarnemaName ;
  GlobalState intent =GlobalState.getInstance();

  Future<String> loadAsset(String name) async {
      String path = "assets/tranem/"+name+".txt";
      return await rootBundle.loadString(path).then((data){
        setState(() {
          content =data ;
        });
      });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      tarnemaName =intent.getValue("tarnemaName");
      print(tarnemaName);
    });
    loadAsset(tarnemaName);
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text("Content",style: TextStyle(color: Color.fromARGB(255, 25, 25, 25)),),
        backgroundColor: Color.fromARGB(255, 173, 129, 41),
      ),
      body: new Container(
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/black_background.png'),fit: BoxFit.cover)),
        padding: EdgeInsets.all(15),
        child:new ListView(
          children: <Widget>[
            new Text(content,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Color.fromARGB(255, 173, 129, 41),
            ),),

          ],
        ),
      ),
    );
  }

}