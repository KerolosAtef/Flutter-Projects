import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
//shared Preferences
import 'package:shared_preferences/shared_preferences.dart';
import 'package:automotion/GlobalState.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'dart:async';

class Home extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new HomeState();
  }

}
class HomeState extends State<Home> {
  SharedPreferences preferences ;
  GlobalState intent = GlobalState.getInstance();
  var mAuth=FirebaseAuth.instance;
  TextEditingController _editController = new TextEditingController();

  List<bool>enableRoomEditing=[false,false,false,false,false,false,false,false];


  List<String> roomImages =["assets/images/living_room.png","assets/images/bedroom1.png",
  "assets/images/bedroom2.png","assets/images/kitchen.png",
  "assets/images/bathroom1.png", "assets/images/bedroom3.png",
  "assets/images/bedroom4.png","assets/images/bathroom2.png",
  ];
  List<String>roomNames =["Living Room","Bedroom 1","Bedroom 2",
  "Kitchen","Bathroom 1","Bedroom 3","Bedroom 4","Bathroom 2"];

  List<String> drawer =["Custom Rooms",
  //"My Profile","About",
  ];

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
    // TODO: implement initState
    super.initState();
    saveData("roomNames", roomNames);
    setInitialDataFromPreferences();
  }
  setInitialDataFromPreferences () async{
    loadData("roomNames").then((value){
      setState(() {
        if (value!=null){
          roomNames=value;
        }
      });
    });
  }
  Future<bool> saveData(String key , List<String> value) async {
    preferences = await SharedPreferences.getInstance();
    return await preferences.setStringList(key, value);
  }
  Future<List<String>> loadData(String key) async {
    preferences= await SharedPreferences.getInstance();
    return preferences.getStringList(key);
  }
  onRoomClicked (int x){
    switch (x){
      case 0 :Navigator.of(context).pushNamed('/Room1');break ;
      case 1 :Navigator.of(context).pushNamed('/Room2');break ;
      case 2 :Navigator.of(context).pushNamed('/Room3');break ;
      case 3 :Navigator.of(context).pushNamed('/Room4');break ;
      case 4 :Navigator.of(context).pushNamed('/Room5');break ;
      case 5 :Navigator.of(context).pushNamed('/Room6');break ;
      case 6 :Navigator.of(context).pushNamed('/Room7');break ;
      case 7 :Navigator.of(context).pushNamed('/Room8');break ;
    }
  }
  onTapDrawer (int position){
    switch (position){
      case 0 :Navigator.of(context).pushNamed('/CustomRooms');break ;
      case 1 :Navigator.of(context).pushNamed('/Room2');break ;
      case 2 :Navigator.of(context).pushNamed('/Room3');break ;
    }
  }
  Icon _editIcon =new Icon(Icons.edit);
  bool canEdit= false ;
  editBtn(){
    if (!canEdit){
      snackBarKey.currentState.showSnackBar(
          SnackBar(
            content: new Text(
              "long press on each item to edit",
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
        saveData("roomNames", roomNames);
      });
    }
  }
  saveBtn(int position) {
    setState(() {
      roomNames[position]=_editController.text;
    });
    Navigator.pop(context);
  }
  var snackBarKey =GlobalKey<ScaffoldState>();

  onLongPress (int position){
    if (canEdit){
      setState(() {
        _editController.clear();
      });
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context){
          return new AlertDialog(
              title: new Row(
                children: <Widget>[
                  new Expanded(child: new Text("Edit Name"),),
                  new IconButton(icon: new Icon(Icons.close), onPressed: ()=>Navigator.pop(context)),
                ],
              ),
              content: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new TextField(
                    controller:_editController,
                    autofocus: true,
                  ),
                  new FlatButton.icon(onPressed: ()=>{
                  saveBtn(position)
                  }, icon: new Icon(Icons.save), label:new Text("Save"))
                ],
              )
          );
        },
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      key:snackBarKey ,
      appBar: AppBar(
        title:Text("Home Page",),
        actions: <Widget>[
          new IconButton(icon:_editIcon, onPressed: editBtn),

          new IconButton(
              icon:new Image.asset("assets/icons/logout.png"),
              onPressed: (){
                mAuth.signOut();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/Login', (Route<dynamic> route) => false);
              }),
        ],
      ),
      backgroundColor: Color(0xFFEEEEEE),
      body: new Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        child: ListView.builder(
            itemBuilder:(BuildContext context ,int position){
              return new ListTile(
                onLongPress: ()=>{
                  onLongPress (position)
                },
                onTap: ()=>onRoomClicked(position),
                title: new Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 3,color: Color(0xff3DABB8)),
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xff3DABB8)
                  ),
                  child:new Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new ClipRRect(
                        borderRadius: new BorderRadius.circular(20),
                        child: Image.asset(
                          roomImages[position],fit: BoxFit.cover,scale: 1,
                          height: 180,
                          width: 370,
                        ),
                      ),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Padding(padding: EdgeInsets.only(left: 10)),
                          new Text(roomNames [position],style: TextStyle(fontSize: 25,color: Color(0xFFEEEEEE)),)

                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          itemCount:8 ,
        ),
      ),
      drawer: new Drawer(
        child: new Container(
          color: Color(0xFFEEEEEE),
          child:Column(
            children: <Widget>[
              new Padding(padding: EdgeInsets.all(10)),
              new Image.asset("assets/images/logo.png",
                width: 150,
                height: 200,
              ),
             new Flexible(
               child: ListView.builder(
                 itemBuilder: (BuildContext context , int position)=>
                 new ListTile(
                   title: new Text(drawer[position],style: TextStyle(fontSize: 18),),
                   onTap: ()=>onTapDrawer(position),
//                   leading: new Image.asset("assets/icons/rooms.png",width: 30,height: 30,),
                 ),
                 itemCount:drawer.length,
               ),
             ),
            ],
          ),
        ),
      ),
    );
  }

}