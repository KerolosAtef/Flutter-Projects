import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:automotion/GlobalState.dart';
import 'dart:async';

class Room4 extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new Room4State();
  }

}
class Room4State extends State<Room4> {

  List<String> lampOn =["assets/icons/lamp1_on.png","assets/icons/tv_on.png",
  "assets/icons/fan_on.png","assets/icons/air_conditioner_on.png"];
  List<String>lampOff =["assets/icons/lamp1_off.png","assets/icons/tv_off.png",
  "assets/icons/fan_off.png","assets/icons/air_conditioner_off.png"];

  List<bool> switchNum=[false,false,false,false,false,false,false,false,false];
  List<String>lampStatus =["assets/icons/lamp1_off.png","assets/icons/lamp1_off.png"
  ,"assets/icons/lamp1_off.png","assets/icons/lamp1_off.png","assets/icons/lamp1_off.png",
  "assets/icons/lamp1_off.png","assets/icons/lamp1_off.png","assets/icons/lamp1_off.png",];
  FocusNode f = new FocusNode() ;
  List <String> roomsNames =["Living Room","Bedroom 1","Bedroom 2",
  "Kitchen","Bathroom 1","Bedroom 3","Bedroom 4","Bathroom 2"];



  final flutterWebViewPlugin = new FlutterWebviewPlugin();
  sendSignal (String roomNum ,String swNum,String status){
    flutterWebViewPlugin.close();
    flutterWebViewPlugin.launch(urlRoom+roomNum,
      rect: new Rect.fromLTWH(
        0.0,
        0.0,
        MediaQuery.of(context).size.width,
        0.0,
      ),
    );
    flutterWebViewPlugin.close();
    flutterWebViewPlugin.launch(urlSW+swNum+"/"+status,
      rect: new Rect.fromLTWH(
        0.0,
        0.0,
        MediaQuery.of(context).size.width,
        0.0,
      ),
    );
  }
  int numOn=0;
  _onSwitchChanged(int swNum ,bool value){
    print("SwitchNum = "+swNum.toString()+ "value = "+value.toString());

    if (swNum==9){
      setState(() {
        switchNum[swNum-1]=value;
      });
      showDialog(context: context ,
          barrierDismissible: false,
          builder: (BuildContext context ){
            return new AlertDialog(
              content: new Row(
                children: [
                  new CircularProgressIndicator(),
                  new Padding(padding: EdgeInsets.only(left: 10)),
                  (value)?new Text("Turning on..."):new Text("Turning off..."),
                ],
              ),
            );
          }
      );
      int numOfMill=0;
      for (int i=1;i<=8;i++){
        if (switchNum[i-1]!=value) {
          _onSwitchChanged(i, value);
          numOfMill++;
        }
      }
      Future.delayed(Duration(milliseconds: numOfMill*1500)).then((_){
        Navigator.pop(context);
      });

    }
    else {
      setState(() {
        if (value) {
          for (int i=0;i<4;i++) {
            if (lampStatus[swNum - 1] == lampOff[i]) {
              lampStatus[swNum - 1] = lampOn[i];
              break;
            }
          }
          sendSignal("4", swNum.toString(), "on");
          if (++numOn==8){
            switchNum[8]=true;
          }
          print("true numOn = "+ numOn.toString());
        }
        else {
          for (int i=0;i<4;i++) {
            if (lampStatus[swNum - 1] == lampOn[i]) {
              lampStatus[swNum - 1] = lampOff[i];
              break;
            }
          }
          sendSignal("4", swNum.toString(), "off");
          if (--numOn<8){
            switchNum[8]=false;
          }
          print("false numOn = "+ numOn.toString());

        }
        switchNum[swNum - 1] = value;
      });
      roomSwitch.child("SW" + swNum.toString()).set(value);
    }
  }

  DatabaseReference roomSwitch ,readUserData;
  var mAuth,userId;
  Map <String,bool> switches ;
  String myIp,urlRoom,urlSW,myLicence;

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
    super.initState();
    switches=new Map();
    mAuth=FirebaseAuth.instance.currentUser().then((user){
      setState(() {
        userId=user.uid;
      });
      readUserData=FirebaseDatabase.instance.reference().child("Users Data").child(user.uid);
      readUserData.onChildAdded.listen(onUserDataChildAdded);
//      _onchildAdded=roomSwitch.onChildAdded.listen(_onChildAddedFunction);
//      _onchildChanged=roomSwitch.onChildChanged.listen(_onChildChangedFunction);
//      _onChildRemoved=roomSwitch.onChildRemoved.listen(_onChildRemovedFunction);
    });
    setInitialDataFromPreferences("room4Sw");
    setInitialDataFromPreferences("room4Icons");
    loadData("roomNames").then((List<String> _list){
      setState(() {
        if (_list!=null){
          roomsNames=_list;
        }
      });
    });
  }
  onUserDataChildAdded(Event e){
    if (e.snapshot.key=="ip") {
      setState(() {
        myIp = e.snapshot.value.toString();
//        print(e.snapshot.value);
        urlRoom = "http://" + myIp + "/Room/";
        urlSW = "http://" + myIp + "/SW/";
      });

    }
    else if (e.snapshot.key=="licence"){
      setState(() {
        myLicence=e.snapshot.value.toString();
        print("Licence = "+myLicence);
        roomSwitch=FirebaseDatabase.instance.reference().child("Licenses")
            .child(myLicence).child("Rooms").child("Room4");
        roomSwitch.onChildAdded.listen(_onChildAddedFunction);
        roomSwitch.onChildChanged.listen(_onChildChangedFunction);
      });
    }
  }
  _onChildAddedFunction (Event e){
    setState(() {
      switches[e.snapshot.key]=e.snapshot.value;
      for(int j=1;j<=8;j++){
        if (e.snapshot.key=="SW"+j.toString()){
          switchNum[j-1]=e.snapshot.value;
          if(e.snapshot.value){
            for (int i=0;i<4;i++) {
              if (lampStatus[j-1] == lampOff[i]) {
                lampStatus[j-1] = lampOn[i];
                break;
              }
            }
            numOn++;
          }
          else{
            for (int i=0;i<4;i++) {
              if (lampStatus[j-1] == lampOn[i]) {
                lampStatus[j-1] = lampOff[i];
                break;
              }
            }
          }
        }
      }
      if (numOn==8){
        switchNum[8]=true;
      }
      else{
        switchNum[8]=false;
      }
    });
  }
  _onChildChangedFunction(Event e){
    setState(() {
      switches[e.snapshot.key]=e.snapshot.value;
      for(int j=1;j<=8;j++){
        if (e.snapshot.key=="SW"+j.toString()){
          switchNum[j-1]=e.snapshot.value;
          if(e.snapshot.value){
            for (int i=0;i<4;i++) {
              if (lampStatus[j-1] == lampOff[i]) {
                lampStatus[j-1] = lampOn[i];
                break;
              }
            }
          }
          else{
            for (int i=0;i<4;i++) {
              if (lampStatus[j-1] == lampOn[i]) {
                lampStatus[j-1] = lampOff[i];
                break;
              }
            }
          }
        }
      }
      if (numOn==8){
        switchNum[8]=true;
      }
      else{
        switchNum[8]=false;
      }
      print(numOn);
    });
  }

//  _onChildRemovedFunction (Event e){
//    setState(() {
//      switches.remove(e.snapshot.key);
//      switch (e.snapshot.key){
//        case "SW1" :switchNum[0]=false;lampStatus[0]=lampOff;break;
//        case "SW2" :switchNum[1]=false;lampStatus[1]=lampOff;break;
//        case "SW3" :switchNum[2]=false;lampStatus[2]=lampOff;break;
//        case "SW4" :switchNum[3]=false;lampStatus[3]=lampOff;break;
//        case "SW5" :switchNum[4]=false;lampStatus[4]=lampOff;break;
//        case "SW6" :switchNum[5]=false;lampStatus[5]=lampOff;break;
//        case "SW7" :switchNum[6]=false;lampStatus[6]=lampOff;break;
//        case "SW8" :switchNum[7]=false;lampStatus[7]=lampOff;break;
//      }
//    });
//  }

  SharedPreferences preferences ;
  GlobalState intent = GlobalState.getInstance();
  TextEditingController _editController  =new TextEditingController();

  List<bool>enableSwitchEditing=[false,false,false,false,false,false,false,false];

  Future<bool> saveData(String key , List<String> value) async {
    preferences = await SharedPreferences.getInstance();
    return await preferences.setStringList(key, value);
  }
  Future<List<String>> loadData(String key) async {
    preferences= await SharedPreferences.getInstance();
    return preferences.getStringList(key);
  }
  int currentChoosenItem =0;
  editData (int position){
    setState(() {
      switchesTexts[position]=_editController.text;
//      saveData("room1Sw",switchesTexts);
      if (switchNum[position]){
        lampStatus[position]=lampOn[currentChoosenItem];
//        saveData("room1Icons",lampStatus);
      }
      else{
        lampStatus[position]=lampOff[currentChoosenItem];
//        saveData("room1Icons",lampStatus);
      }
    });
    Navigator.pop(context);
  }
  List<String>switchesTexts=["Lamp 1","Lamp 2","Lamp 3","Lamp 4","Lamp 5","Lamp 6","Lamp 7","Lamp 8"];
  setInitialDataFromPreferences (String key) async{
    if (key=="room4Sw"){
      loadData(key).then((List<String>value){
        if (value !=null) {
          setState(() {
            switchesTexts = value;
          });
        }
      });
    }
    else if(key =="room4Icons") {
      loadData(key).then((value){
        if (value !=null) {
          setState(() {
            lampStatus = value;
          });
        }
      });
    }
  }
  List<DropdownMenuItem> item =[
    new DropdownMenuItem(child: new Image.asset("assets/icons/lamp1_on.png"),value: 0,),
    new DropdownMenuItem(child: new Image.asset("assets/icons/tv_on.png"),value: 1,),
    new DropdownMenuItem(child: new Image.asset("assets/icons/fan_on.png"),value: 2,),
    new DropdownMenuItem(child: new Image.asset("assets/icons/air_conditioner_on.png"),value: 3,),
  ];
  _onLongPress(int position){
    if (canEdit){
      setState(() {
        currentChoosenItem=0;
        _editController.clear();
      });
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context){
          return new AlertDialog(
              title: new Row(
                children: <Widget>[
                  new Expanded(child: new Text("Edit item"),),
                  new IconButton(icon: new Icon(Icons.close), onPressed: ()=>Navigator.pop(context)),
                ],
              ),
              content: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      new DropdownButton(
                        items:item,
                        value: currentChoosenItem,
                        onChanged:(value){
                          setState(() {
                            currentChoosenItem=value;
                          });
//                        commitFunction();
                          FocusScope.of(context).requestFocus(f);
                        },
                      ),
                      new Expanded(
                          child:TextField(
                            controller:_editController,
                            focusNode: f,
                          )
                      ),
                    ],
                  ),
                  new FlatButton.icon(onPressed: ()=>{
                  editData(position)
                  }, icon: new Icon(Icons.save), label:new Text("Save"))
                ],
              )
          );
        },
      );
    }
  }
  commitFunction(){
    showDialog(
        context: context,
        builder: (BuildContext context)=>
        new AlertDialog(
          title: new TextField(
            autofocus: true,
          ),
        ));
    Future.delayed(Duration(milliseconds: 100)).then((_){
      Navigator.pop(context);
    });
  }
  Icon _editIcon =new Icon(Icons.edit);
  bool canEdit= false ;
  editAll(){
    if (!canEdit){
      snackBarKey.currentState.showSnackBar(
          SnackBar(
            content: new Text(
              "long press on each item to Edit",
              style: TextStyle(
                  color:Colors.amber
              ),
            ),
            duration: Duration(seconds: 2),
          )
      );
      setState(() {
        canEdit=true ;
        _editIcon=new Icon(Icons.save);
      });
    }
    else {
      setState(() {
        canEdit=false ;
        _editIcon=new Icon(Icons.edit);
        saveData("room4Sw",switchesTexts);
        saveData("room4Icons",lampStatus);
      });
    }
  }
  var snackBarKey =GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key:snackBarKey ,
        appBar: AppBar(
          title: Text(roomsNames[3]),
          actions: <Widget>[
            new IconButton(icon: _editIcon, onPressed: editAll),
            new Switch(value: switchNum[8], onChanged: (value){
              _onSwitchChanged(9, value);
            },
              activeColor: Color(0xFF5F6066),
            ),
          ],
        ),
        body:new Container(
          padding: EdgeInsets.all(10),
          child:  new Column(
            children: <Widget>[
              new ClipRRect(
                borderRadius: new BorderRadius.circular(20),
                child: Image.asset(
                  "assets/images/kitchen.png",fit: BoxFit.cover,scale: 1,
                ),
              ),
              new Flexible(child:
              new ListView.builder(itemBuilder: (BuildContext context ,int position){
                return  new Container(
                  child: new ListTile(
                      onLongPress: ()=>{
                      _onLongPress(position)
                      },
                      title:new Container(
//                      decoration: BoxDecoration(
//                          borderRadius: BorderRadius.all(Radius.circular(20)),
//                        border: Border.all(color: Color(0xff3DABB8),width: 3),
//                        color: Color(0xFFEEEEEE)
//                      ),
                        child: new Row(
                          children: <Widget>[
                            new Image.asset(lampStatus[position],width: 40,height: 40,),
                            new Padding(padding: EdgeInsets.only(left: 40)),
                            new Expanded(child:
                            new Text(
                              switchesTexts[position],
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Color(0xFF5F6066)
                              ),
                            ),
                            ),
                            new Switch(
                              value: switchNum[position],
                              onChanged: (value){
                                _onSwitchChanged(position+1,value);
                              },
                            ),

                          ],
                        ),
                      )
                  ),
                );
              },
                itemCount: lampStatus.length,),
              ),
            ],
          ),
        )
    );
  }
}
