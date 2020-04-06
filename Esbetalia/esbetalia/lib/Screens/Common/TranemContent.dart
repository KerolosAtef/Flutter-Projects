import 'package:flutter/material.dart';
import 'dart:async';
import 'package:esbetalia/GlobalState.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

class TranemContent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new TranemContentState();
  }

}
class TranemContentState extends State <TranemContent> {
  String content="";
  Future<String> loadAsset(String name) async {
      print(name);
      String path = "assets/tranem/"+name+".txt";
      return await rootBundle.loadString(path).then((data) {
        setState(() {
          content=data;
        });
        return data;
      });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadAsset(GlobalState.ourInstance.getValue("tarnemaName"));
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/background.png')
                ,fit: BoxFit.cover)
        ),
        child:Column(
          children: <Widget>[
            Container(
              height: 130,
              margin: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
              child: new Row(
                children: <Widget>[
                  GestureDetector(
                    child: new Image.asset("assets/images/back_arrow.png",width: 40,height: 40,),
                    onTap: ()=>Navigator.pop(context),
                  ),
                  Spacer(),
                  new Image.asset("assets/images/logo.png",height: 85,width: 85,),

                ],
              ),
            ),
            Expanded(
              child: new ListView(
                padding: EdgeInsets.all(20),
                children: <Widget>[
                  new Text(content,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                    ),),

                ],
              ),
            )
          ],
        )
      ),
    );
  }

}