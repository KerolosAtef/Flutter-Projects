import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';

import '../../GlobalState.dart';
class RoheyaDay2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RoheyaDay2State ();
  }

}
class RoheyaDay2State extends State<RoheyaDay2> {

  var snackBarKey =GlobalKey<ScaffoldState>();

  bool session3=false,session4=false;
  Future<void> openPDF(String name) async {
    PDFDocument doc = await PDFDocument.fromAsset(name);
    GlobalState.ourInstance.setValue("doc", doc);
    Navigator.pushNamed(context, '/PdfContent');
  }
  DatabaseReference readRef ;
  @override
  void initState() {
    readRef= FirebaseDatabase.instance.reference().child("Roheya");
    readRef.onChildAdded.listen(_onChildAddedFunction);
    readRef.onChildChanged.listen(_onChildUpdatedFunction);
//    readRef.onChildRemoved.listen(_onChildRemovedFunction);
    super.initState();
  }
  _onChildAddedFunction (Event e ){
    setState(() {
      if (e.snapshot.key=="Session3") session3=e.snapshot.value;
      else if (e.snapshot.key=="Session4") session4=e.snapshot.value;
    });
  }
  _onChildUpdatedFunction (Event e){
    setState(() {
      if (e.snapshot.key=="Session3") session3=e.snapshot.value;
      else if (e.snapshot.key=="Session4") session4=e.snapshot.value;
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      key: snackBarKey,
      body: new Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/background.png"),
                  fit: BoxFit.cover)),
          child: ListView(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
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
              Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.all(15),
                color: Color(0xff958d76),
                child: Text("Rou7ya Day 2",textAlign: TextAlign.start,
                style: TextStyle(color: Color(0xffffffff),fontSize: 35),),
              ),

              Container(
                decoration: BoxDecoration(
                  color: Color(0xff958d76),
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: EdgeInsets.only(left: 20,right: 20,top: 50),
                padding: EdgeInsets.all(45),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: (){
                            session3?openPDF("assets/Roheya/session3.pdf")
                                :snackBarKey.currentState.showSnackBar(
                              SnackBar(
                                content: Text("Estna shwya ..It's locked"),
                                duration: Duration(seconds: 2),
                              ),
                            )
                            ;},
                          child: Container(
                            width: 200,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Color(0xff6e644b),
                                border: Border.all(color: Colors.white,width: 1),
                              ),
                              child: Text("> Session 3",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 35,
                                ),
                              )
                          ),
                        ),
                        session3?Container():Spacer(),
                        session3?Container():Image.asset("assets/images/lock.png",height: 50,width: 50,),
                      ],
                    ),
                    Container(height: 1,
                      color: Color(0xffffffff),
                      margin: EdgeInsets.symmetric(vertical: 20),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: (){
                            session4?openPDF("assets/Roheya/session4.pdf")
                                :snackBarKey.currentState.showSnackBar(
                              SnackBar(
                                content: Text("Estna shwya ..It's locked"),
                                duration: Duration(seconds: 2),
                              ),
                            )
                            ;},
                          child: Container(
                            width: 200,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Color(0xff6e644b),
                                border: Border.all(color: Colors.white,width: 1),
                              ),
                              child: Text("> Session 4",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 35,
                                ),
                              )
                          ),
                        ),
                        session4?Container():Spacer(),
                        session4?Container():Image.asset("assets/images/lock.png",height: 50,width: 50,),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 18),),
              Image.asset("assets/images/roheya_day2.png",)

            ],
          )),
    );
  }
}