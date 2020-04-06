import 'package:flutter/material.dart';
import 'package:stamp/AppCommon.dart';
class AdminRegister extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AdminRegisterState();
  }

}
class AdminRegisterState extends State <AdminRegister> {
  List <String> hints = [
    'Name','Email','Password','Confirm Password',
  ] ;
  List <String> errors =[
    '','','','',
  ];
  List<TextEditingController> controllers = [
    TextEditingController(),TextEditingController(),
    TextEditingController(), TextEditingController(),
  ];

  void register () {
    AppCommon.mAuth.createUserWithEmailAndPassword(
        email: controllers[1].text.toString(),
        password: controllers[2].text.toString()
    ).then((adminUser){
      var store = AppCommon.databaseReference.child("Admins").child(adminUser.user.uid);
      store.child("name").set(controllers[0].text.toString());
      store.child("email").set(controllers[1].text.toString());
      store.child("password").set(controllers[2].text.toString());

    });

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: Container (
          child: Column(
            children: <Widget>[
              new Image.asset("",height: 100,width: 100,),
              new Container(
                height: 300,
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: new ListView.builder(itemBuilder:(BuildContext context , int position ) {
                  return Column(
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
                },itemCount: 4,),
              ),
              RaisedButton(onPressed: register,child: Text("Register"),)

            ],
          )
      ),
    );
  }

}