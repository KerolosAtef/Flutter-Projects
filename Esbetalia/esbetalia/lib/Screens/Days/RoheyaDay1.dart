import 'package:esbetalia/GlobalState.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
class RoheyaDay1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RoheyaDay1State ();
  }

}
class RoheyaDay1State extends State<RoheyaDay1> {
  var snackBarKey =GlobalKey<ScaffoldState>();

  bool intro=false,session1=false,session2=false,session2Workshop=false;
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
      if (e.snapshot.key=="Intro") intro=e.snapshot.value;
      else if (e.snapshot.key=="Session1") session1=e.snapshot.value;
      else if (e.snapshot.key=="Session2") session2=e.snapshot.value;
      else if (e.snapshot.key=="Session2 Workshop") session2Workshop=e.snapshot.value;
    });
  }
  _onChildUpdatedFunction (Event e){
    setState(() {
      if (e.snapshot.key=="Intro") intro=e.snapshot.value;
      else if (e.snapshot.key=="Session1") session1=e.snapshot.value;
      else if (e.snapshot.key=="Session2") session2=e.snapshot.value;
      else if (e.snapshot.key=="Session2 Workshop") session2Workshop=e.snapshot.value;
    });
  }
//  _onChildRemovedFunction (Event e){
//    print("kokka");
//  }

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
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.all(15),
                color: Color(0xff423d2a),
                child: Text("Rou7ya Day 1",textAlign: TextAlign.start,
                  style: TextStyle(color: Color(0xffffffff),fontSize: 35),),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xff453d26),
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: EdgeInsets.only(left: 15,right: 15,top: 10),
                padding: EdgeInsets.only(left: 50,right: 50,top: 10,bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: <Widget>[
                    GestureDetector(
                      onTap: (){
                        intro?openPDF("assets/Roheya/intro.pdf")
                            :snackBarKey.currentState.showSnackBar(
                          SnackBar(
                            content: Text("Estna shwya ..It's locked"),
                            duration: Duration(seconds: 2),
                          ),
                        )
                        ;},
                      child: Container(
                          width: 170,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Color(0xff443e26),
                            border: Border.all(color: Colors.white,width: 1),
                          ),
                          child: Text("> Intro",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                            ),
                          )
                      ),
                    ),
                    intro?Container():Spacer(),
                    intro?Container():Image.asset("assets/images/lock.png",height: 50,width: 50,),
                  ],
                ),
              ),

              Container(
                decoration: BoxDecoration(
                  color: Color(0xff453d26),
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: EdgeInsets.only(left: 15,right: 15,top: 20),
                padding: EdgeInsets.only(left: 50,right: 50,top: 30,bottom: 30),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: <Widget>[
                        GestureDetector(
                          onTap: (){
                            session1?openPDF("assets/Roheya/session1.pdf")
                                :snackBarKey.currentState.showSnackBar(
                              SnackBar(
                                content: Text("Estna shwya ..It's locked"),
                                duration: Duration(seconds: 2),
                              ),
                            )
                            ;},
                          child: Container(
                              width: 170,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Color(0xff443e26),
                                border: Border.all(color: Colors.white,width: 1),
                              ),
                              child: Text("> Session 1",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                ),
                              )
                          ),
                        ),
                        session1?Container():Spacer(),
                        session1?Container():Image.asset("assets/images/lock.png",height: 50,width: 50,),
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
                            session2Workshop?openPDF("assets/Roheya/session2_workshop.pdf")
                                :snackBarKey.currentState.showSnackBar(
                              SnackBar(
                                content: Text("Estna shwya ..It's locked"),
                                duration: Duration(seconds: 2),
                              ),
                            )
                            ;},                          child: Container(
                              width: 200,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Color(0xff443e26),
                                border: Border.all(color: Colors.white,width: 1),
                              ),
                              child: Column(
                                children: <Widget>[
                                  Text("> Session 2",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text("Workshop",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )
                          ),
                        ),
                        session2Workshop?Container():Spacer(),
                        session2Workshop?Container():Image.asset("assets/images/lock.png",height: 50,width: 50,),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 15),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: (){
                            session2?openPDF("assets/Roheya/session2.pdf")
                                :snackBarKey.currentState.showSnackBar(
                              SnackBar(
                                content: Text("Estna shwya ..It's locked"),
                                duration: Duration(seconds: 2),
                              ),
                            )
                            ;},
                          child: Container(
                              width: 170,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Color(0xff443e26),
                                border: Border.all(color: Colors.white,width: 1),
                              ),
                              child: Text("> Session 2",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                ),
                              )
                          ),
                        ),
                        session2?Container():Spacer(),
                        session2?Container():Image.asset("assets/images/lock.png",height: 50,width: 50,),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 18),),
              Image.asset("assets/images/roheya_day1.png",)

            ],
          )),
    );
  }
}