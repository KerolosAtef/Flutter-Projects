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
    // TODO: implement build
    return new Scaffold(
        body: new Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/background.png')
                    ,fit: BoxFit.cover)
            ),
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  height: 130,
                  margin: EdgeInsets.symmetric(horizontal: 15),
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 10,bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text("Active Day 1" ,style: TextStyle(
                            fontSize: 25,
                            color: Color(0xffffffff),

                          ),textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                    Image.asset("assets/images/games_day1.png")
                  ],
                ),

              ],
            )
        )
    );
  }
}