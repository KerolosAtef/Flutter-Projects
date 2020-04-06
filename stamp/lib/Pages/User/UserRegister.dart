import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../AppCommon.dart';
import '../../GlobalState.dart';
class UserRegister extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new UserRegisterState() ;
  }

}
class UserRegisterState extends State <UserRegister> {
  List <String> hints = [
    'Name','Email','Password','Confirm Password','Age'
  ] ;
  List <String> errors =[
    '','','','',''
  ];
  List<TextEditingController> controllers = [
    TextEditingController(),TextEditingController(),
    TextEditingController(), TextEditingController(),TextEditingController()
  ];
  void register () {
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
    AppCommon.mAuth.createUserWithEmailAndPassword(
        email: controllers[1].text.toString(),
        password: controllers[2].text.toString()
    ).then((user){
      GlobalState.ourInstance.setValue("userId", user.user.uid);
      var store = AppCommon.databaseReference.child("UsersData").child(user.user.uid);
      store.child("name").set(controllers[0].text);
      store.child("email").set(controllers[1].text);
      store.child("password").set(controllers[2].text);
    }).then((_){
      Navigator.pop(context); //pop dialog
      Navigator.pushReplacementNamed(context, '/UserHome');
    }).catchError((e){
      Navigator.pop(context); //pop dialog

      print(e);
    });
  }
  bool isSmokedPerson =false ;
  void onSmokingChanged (bool value){
    setState(() {
      isSmokedPerson=value;
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: SingleChildScrollView(
        child: Container (
            child: Column(
              children: <Widget>[
                new Image.asset("",height: 100,width: 100,),
                new Container(
                  height: 400,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: new ListView.builder(itemBuilder:(BuildContext context , int position ) {
                    return
                      (position==5)
                          ?CheckboxListTile(
                        onChanged: (value)=>onSmokingChanged(value),
                        value: isSmokedPerson,
                        title: Text("Smoking"),
                      ) :
                    Column(
                      children: <Widget>[
                        TextField(
                          decoration: InputDecoration(
                            hintText: hints[position],
                          ),
                          controller: controllers[position],
                        )
                        ,Text(errors[position]),
                      ],
                    );
                  },itemCount: 6,),
                ),
                RaisedButton(onPressed: register,child: Text("Register"),)

              ],
            )
        ),
      ),
    );
  }

}