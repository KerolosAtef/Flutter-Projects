import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
class Admin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new AdminState();
  }
}
class AdminState extends State <Admin> {
  TextEditingController addLicence = new TextEditingController();
  var mAuth=FirebaseAuth.instance ;
  var addLicenceRef =FirebaseDatabase.instance.reference().child("Licenses");
  List<String> licences =new List();
  List<String>ips =new List();
  Icon _editIcon =new Icon(Icons.edit);
  bool canEdit= false ;
  addFunc (){
    showDialog(
      barrierDismissible: false,
      context:context ,
      builder: (BuildContext context)=>new AlertDialog(
        title: new Row(
          children: <Widget>[
            Text("Add IP"),
            Spacer(),
            new IconButton(icon: new Icon(Icons.cancel), onPressed: ()=>Navigator.pop(context)),
            
          ],
        ),
        content: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: addLicence,
              decoration: InputDecoration(
                  labelText: "Add IP",
                  hintText: "add",
                  icon:new Icon(Icons.library_books) ),
            ),
            RaisedButton( onPressed:submit ,child:Text("Submit") ,
            ),
          ],
        ),
      )
    );
    
  }
  submit (){
    addLicenceRef.push().child("ip").set(addLicence.text);
    Navigator.pop(context);
  }
  Connectivity _connectivity;
  StreamSubscription<ConnectivityResult> _subscription;
  var snackBarKey =GlobalKey<ScaffoldState>();

  void onConnectivityChange(ConnectivityResult result) {
    // TODO: Show snackbar, etc if no connectivity
    print(result);
    if (result==ConnectivityResult.none){
      snackBarKey.currentState.showSnackBar(
          SnackBar(
            content: Text("No internet connection"),
            duration: Duration(hours: 1),
          ));
    }
    else {
      snackBarKey.currentState.hideCurrentSnackBar();
    }

  }

  @override
  void initState() {
    _connectivity = new Connectivity();
    _subscription = _connectivity.onConnectivityChanged.listen(onConnectivityChange);
    addLicenceRef.onChildAdded.listen(onChildAddedFunc);
//    addLicenceRef.onChildChanged.listen(onChildChangedFunc);
//    addLicenceRef.onChildRemoved.listen(onChildRemovedFunc);
    super.initState();
  }
  var m;
  onChildAddedFunc (Event e){
    setState(() {
      m=e.snapshot.value;
      licences.add(e.snapshot.key);
      ips.add(m["ip"]);
      print("ip "+m["ip"]);
    });
  }
  remove (int position){
    addLicenceRef.child(licences[position].toString()).set(null);
    licences.removeAt(position);
    ips.removeAt(position);
  }
  editFunc (){
    if (!canEdit){
      setState(() {
        canEdit=true;
        _editIcon=new Icon(Icons.save);
      });
    }
    else {
      setState(() {
        canEdit=false;
        _editIcon=new Icon(Icons.edit);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: snackBarKey,
      appBar: new AppBar(
        title: Text("Admin"),
        actions: <Widget>[
          IconButton (onPressed: editFunc,icon: _editIcon,),
          new IconButton(
              icon:new Image.asset("assets/icons/logout.png"),
              onPressed: (){
                mAuth.signOut();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/Login', (Route<dynamic> route) => false);
              }),
        ],
      ),
      body: new Container(

        child: Column(
          children: <Widget>[
            Padding (padding: EdgeInsets.only(top: 10),),
            Text ("My Licences & Ips",style: TextStyle(
              fontSize: 28,
              color: Color(0xff3DABB8),
            ),),
            new Flexible(child:
            new ListView.builder(itemBuilder: (BuildContext context , int position){
              return new ListTile(
                title:new Row( children: <Widget>[
                  Text(ips[position] ,style: TextStyle(
                      fontFamily:'Raleway',
                  ),),
                  Spacer(),
                  canEdit?IconButton (icon:new Icon(Icons.remove) ,onPressed:()=>{remove(position)},):Container()
                ],
                ),
                subtitle:Text(licences[position],style: TextStyle(
                    fontFamily:'Raleway',
                ),),

              );
            },itemCount:licences.length ,
            ),
            )
          ],
        )
      ),
      floatingActionButton:FloatingActionButton(
        onPressed: addFunc,
        child: Icon(Icons.add) ,
        tooltip: "add new Ip",
    )
    );
  }

}