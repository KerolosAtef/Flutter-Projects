import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
class Register extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new RegisterState();
  }

}
class RegisterState extends State<Register> {

  List<TextEditingController> controllers =new List();

  bool correctLicenceAndIP=false;
  List<String> errors =new List();
  final mAuth = FirebaseAuth.instance;
  var registerRef =FirebaseDatabase.instance.reference().child("Users Data");
  var snackBarKey =GlobalKey<ScaffoldState>();
  bool undo =false ;

  undoFuc (){
    setState(() {
      undo=true ;
    });
  }

  register() {
    setState(() {
      for (int i=0;i<6;i++){
        errors[i]="";
      }
      undo=false ;
      correctLicenceAndIP=false;
    });
    if (controllers[0].text.isNotEmpty && controllers[1].text.isNotEmpty  &&
        controllers[2].text.isNotEmpty &&controllers[3].text.isNotEmpty &&
        controllers[4].text.isNotEmpty && controllers[5].text.isNotEmpty){

      if (controllers[1].text.length < 6){
        setState(() {
          errors[1]="password should be more than 6 charater";
        });
      }
      if (!controllers[2].text.contains("@") || !controllers[2].text.contains(".com")){
        setState(() {
          errors[2]="invaild email pattern";
        });
      }
      if (controllers[3].text.length != 11){
        setState(() {
          errors[3]="Your phone should be 11 number";
        });
      }
      if (licenses[controllers[4].text.trim()]==controllers[5].text.trim()){
        setState(() {
          correctLicenceAndIP=true;
        });
      }
      else{
        setState(() {
          correctLicenceAndIP=false;
          print("licence "+licenses[controllers[5].text.trim()]);
          print("Ip"+controllers[5].text.trim());

          if (!licenses.containsKey(controllers[4].text.trim())){
            errors[4]="License is wrong";
          }
          if (!ips.containsKey(controllers[5].text.trim())){
            errors[5]="Ip is Wrong";
          }
        });
      }

      if (controllers[1].text.length >= 6 &&controllers[2].text.contains("@") &&
          controllers[2].text.contains(".com")&&controllers[3].text.length == 11
          && correctLicenceAndIP){
        snackBarKey.currentState.showSnackBar(
          SnackBar(
            content: Text("Registering"),
            duration: Duration(seconds: 2),
            action: SnackBarAction(
                label: "Undo",
                onPressed: undoFuc
            ),

          ),

        );
        Future.delayed(Duration(seconds: 3)).then((_){
          print(undo);
          if (!undo){
            submitData();
          }
          else{
            snackBarKey.currentState.showSnackBar(SnackBar(content: Text("Registration process has been Stopped"),
            ));
          }
        });

      }

    }
    else {
      snackBarKey.currentState.showSnackBar(SnackBar(content: Text("please fill all Data")));
    }
  }
  Future <void> submitData () async{
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context){
        return new AlertDialog(
          content: new Row(
            children: [
              new CircularProgressIndicator(),
              new Padding(padding: EdgeInsets.only(left: 10)),
              new Text("Signing up..."),
            ],
          ),
        );
      },
    );
    await mAuth.createUserWithEmailAndPassword(
        email: controllers[2].text,
        password: controllers[1].text
    ).then((user){
      print("userId");
      registerRef=registerRef.child(user.uid);
      registerRef.child("name").set(controllers[0].text.toString());
      registerRef.child("password").set(controllers[1].text.toString());
      registerRef.child("email").set(controllers[2].text.toString());
      registerRef.child("phone").set(controllers[3].text.toString());
      registerRef.child("licence").set(controllers[4].text.toString());
      registerRef.child("ip").set(controllers[5].text.toString());
      registerRef=FirebaseDatabase.instance.reference().child("Licenses")
          .child(controllers[4].text.toString()).child("Rooms");
      for (int i=1;i<=8;i++){
        for (int j=1;j<=8;j++){
          registerRef.child("Room"+i.toString()).child("SW"+j.toString()).set(false);
        }
      }
    }).then((_){
      Navigator.pop(context); //pop dialog
      Navigator.pushReplacementNamed(context, '/Home');
    }).catchError((e){
      Navigator.pop(context); //pop dialog
      print("Auth error");
      setState(() {
        errors[0]="Authentication Error";
      });
    }
    );
  }

  DatabaseReference readRef ;
  Map <String,String> licenses,ips ;

  Connectivity _connectivity;
  StreamSubscription<ConnectivityResult> _subscription;

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
    licenses=new Map();
    ips=new Map();
    for (int i=0;i<6;i++){
      controllers.add(new TextEditingController());
      errors.add("");
    }
    readRef= FirebaseDatabase.instance.reference().child("Licenses");
    readRef.onChildAdded.listen(_onChildAddedFunction);
    readRef.onChildChanged.listen(_onChildUpdatedFunction);
    readRef.onChildRemoved.listen(_onChildRemovedFunction);

    super.initState();
  }
  var m ;
  _onChildAddedFunction(Event e){
    setState(() {
      m=e.snapshot.value;
      licenses [e.snapshot.key.toString()]=m["ip"];
      ips [m["ip"]]=e.snapshot.key.toString();
    });
  }
  _onChildUpdatedFunction(Event e){
    setState(() {
      licenses [e.snapshot.key]=e.snapshot.value;
      ips [e.snapshot.value]=e.snapshot.key;

    });
  }
  _onChildRemovedFunction(Event e){
    licenses.remove(e.snapshot.key);
    ips [e.snapshot.value]=e.snapshot.key;

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: snackBarKey,
      appBar: AppBar(
        title: new Text("Register"),
      ),
      body: new Container(
        padding: EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: new ListView(
          children: <Widget>[
            new Image.asset(
              "assets/images/logo.png",
              width: 100,
              height: 150,
            ),
            new Container(
              child: new TextField(
                style: TextStyle(

                ),
                decoration: InputDecoration(
                  labelText: "Name",
                  labelStyle: TextStyle(color: Color(0xFF5F6066)),
                  hintText: "Enter your name",
                  hintStyle: TextStyle(color: Color(0xFF5F6066)),
                  errorText: "",
                  errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF5F6066))),
                  icon: new Icon(
                    Icons.person,
                    color: Color(0xFF5F6066)),
                ),
                keyboardType: TextInputType.text,
                controller: controllers[0],
              ),
            ),
            new Container(
              child: new TextField(
                style: TextStyle(
                    color: Color(0xFF5F6066),
                  fontFamily:'Raleway',
                ),
                decoration: InputDecoration(
                  labelText: "password",
                  labelStyle: TextStyle(color: Color(0xFF5F6066)),
                  hintText: "Enter your password",
                  hintStyle: TextStyle(color: Color(0xFF5F6066)),
                  errorText: errors[1],
                  errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF5F6066))),
                  icon: new Icon(
                    Icons.lock,
                    color: Color(0xFF5F6066),),
                ),
                keyboardType: TextInputType.text,
                obscureText: true,
                controller: controllers[1],
              ),
            ),
            new Container(
              child: new TextField(
                style: TextStyle(
                    color: Color(0xFF5F6066),fontFamily:'Raleway',
                ),
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(color: Color(0xFF5F6066)),
                  hintText: "Enter your email",
                  hintStyle: TextStyle(color: Color(0xFF5F6066)),
                  errorText: errors[2],
                  errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF5F6066))),
                  icon: new Icon(
                    Icons.mail,
                    color: Color(0xFF5F6066),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                controller: controllers[2],
              ),
            ),
            new Container(
              child: new TextField(
                style: TextStyle(
                    color: Color(0xFF5F6066)
                ),
                decoration: InputDecoration(
                  labelText: "phone",
                  errorText: errors[3],
                  errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF5F6066))),
                  labelStyle: TextStyle(color: Color(0xFF5F6066)),
                  hintText: "Enter your phone number",
                  hintStyle: TextStyle(color: Color(0xFF5F6066)),
                  icon: new Icon(
                    Icons.phone,
                    color: Color(0xFF5F6066),
                  ),
                ),
                keyboardType: TextInputType.phone,
                controller: controllers[3],
              ),
            ),
            new Container(
              child: new TextField(
                style: TextStyle(
                    color: Color(0xFF5F6066),fontFamily:'Raleway'
                ),
                decoration: InputDecoration(
                  labelText: "Licence",
                  errorText: errors[4],
                  errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF5F6066))),
                  labelStyle: TextStyle(color: Color(0xFF5F6066)),
                  hintText: "Enter your Licence",
                  hintStyle: TextStyle(color:Color(0xFF5F6066)),
                  icon: new Icon(
                    Icons.library_books,
                    color: Color(0xFF5F6066),
                  ),
                ),
                keyboardType: TextInputType.text,
                controller: controllers[4],
              ),
            ),
            new Container(
              child: new TextField(
                style: TextStyle(
                    color: Color(0xFF5F6066),fontFamily:'Raleway',
                ),
                decoration: InputDecoration(
                  labelText: "Ip",
                  errorText: errors[5],
                  errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF5F6066))),
                  labelStyle: TextStyle(color: Color(0xFF5F6066)),
                  hintText: "Enter your IP",
                  hintStyle: TextStyle(color: Color(0xFF5F6066)),
                  icon: new Icon(
                    Icons.cloud,
                    color: Color(0xFF5F6066),
                  ),
                ),
                keyboardType: TextInputType.text,
                controller: controllers[5],
              ),
            ),
            new Container(
              child:new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new RaisedButton(onPressed: register ,
                    child: new Text("Register" ,
                      style:TextStyle(
                        color: Color(0xFFEEEEEE),
                      ) ,
                    ),
                    shape: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                    color: Color(0xFF5F6066),
                    padding: EdgeInsets.all(15),
                  ),
                ],
              ),

            ),
          ],
        ),
      ),
    );
  }

}