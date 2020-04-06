import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

import 'package:connectivity/connectivity.dart';
class CustomRooms extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new CustomRoomsState();
  }

}
class CustomRoomsState extends State<CustomRooms> {
  List <String> customTexts =[];
  List<bool> switchesStatus =[false,false,false,false,false,false,false,false];
  TextEditingController _nameController =new TextEditingController();
  TextEditingController _editListItemController =new TextEditingController();
  List <String> roomsNames =["Room1","Room2","Room3","Room4",
    "Room5","Room6","Room7","Room8"];
  List <String> mySwitches =["Lamp 1","Lamp 2","Lamp 3","Lamp 4",
    "Lamp 5","Lamp 6","Lamp 7","Lamp 8"];
  List<List<String>> roomSwitches =[];
  List<DropdownMenuItem> roomsMenu =[],tempMenu=new List();
  List<List<DropdownMenuItem>> switchesMenu =[];
  List<dynamic> customFunctions = [];
  List<List<int>> choosedFunctions = [];
  List<String>choosedItems =[];
  int selectedRoomsMenuItem =0,selectedSwitchesMenuItem=0;
  DatabaseReference setSwitchStates , functionList,readUserData;
  var mAuth,userId ,myLicence;
  myDialog dialogObject;
  addButton (){
    setState(() {
      choosedFunctions.clear();
      _nameController.clear();
      choosedItems.clear();
      selectedSwitchesMenuItem=0;
      selectedRoomsMenuItem=0;
    });
    showDialog(
        barrierDismissible: false,
        context:context,
        builder: (BuildContext context)=>
        new AlertDialog(
          title: new Row(
            children: <Widget>[
              new Expanded(child: new Text("Choose custom buttons"),),
              new IconButton(icon: new Icon(Icons.close), onPressed: ()=>Navigator.pop(context)),
            ],
          ),
          content: new Container(
            child:
            new SingleChildScrollView(
                child:dialogObject=new myDialog(
                  choosedFunctions: choosedFunctions,
                  choosedItems: choosedItems,
                  nameController: _nameController,
                  roomsMenu: roomsMenu,
                  roomsNames: roomsNames,
                  roomSwitches: roomSwitches,
                  selectedRoomsMenuItem: selectedRoomsMenuItem,
                  selectedSwitchesMenuItem: selectedSwitchesMenuItem,
                  switchesMenu: switchesMenu,
                )
            ),

          ),
          actions: <Widget>[
            new FlatButton(onPressed: finish, child: new Text("Finish")),
          ],
        )
    );
  }

  finish(){
    setState(() {
      //
      choosedFunctions=dialogObject.choosedFunctions;
      choosedItems=choosedItems;
      _nameController=dialogObject.nameController;
      roomsMenu=dialogObject.roomsMenu;
      roomsNames=dialogObject.roomsNames;
      roomSwitches=dialogObject.roomSwitches;
      selectedRoomsMenuItem=dialogObject.selectedRoomsMenuItem;
      selectedSwitchesMenuItem=dialogObject.selectedSwitchesMenuItem;
      switchesMenu=dialogObject.switchesMenu;
      //
      customTexts.add(_nameController.text);
      customFunctions.add(choosedFunctions);
    });
    Navigator.pop(context);
  }
  _onChildAddedFunction (Event e){
    setState(() {
      customFunctions.add(e.snapshot.value);
    });
  }

  removeButton (int index){
    if (canEdit) {
      setState(() {
        customTexts.removeAt(index);
        customFunctions.removeAt(index);
      });
    }
  }
  final flutterWebViewPlugin = new FlutterWebviewPlugin();
  String myIp,urlRoom,urlSW;
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
  _onSwitchChanged (int position , bool value){
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
    setState(() {
      switchesStatus[position]=value;
    });
    Future.delayed(Duration(milliseconds: 500)).then((_){
      for (int i=0;i<customFunctions[position].length;i++){
//      print(customFunctions[position][i][0].toString());
//      print(customFunctions[position][i][1].toString());
        sendSignal(customFunctions[position][i][0].toString(),
            customFunctions[position][i][1].toString(), (value)?"on":"off");
        setSwitchStates.child("Room"+customFunctions[position][i][0].toString())
            .child("SW"+customFunctions[position][i][1].toString()).set(value);
        sleep(Duration(seconds: 1));
      }
      Navigator.pop(context);
    });
  }
  SharedPreferences preferences ;

  Future<bool> saveData(String key , List<String> value) async {
    preferences = await SharedPreferences.getInstance();
    return await preferences.setStringList(key, value);
  }
  Future<List<String>> loadData(String key) async {
    preferences= await SharedPreferences.getInstance();
    return preferences.getStringList(key);
  }
  Future<List<List<String>>>setInitialDataFromPreferences (String key) async{
    for (int i=1;i<=8;i++){
      await loadData(key+i.toString()+"Sw").then((List<String>value){
        if (value!=null){
          setState(() {
            roomSwitches.add(value);
          });
        }
        else {
          roomSwitches.add(mySwitches);
        }
      });
    }
    return roomSwitches;
  }
  onUserDataChildAdded(Event e){
    if (e.snapshot.key=="ip") {
      setState(() {
        myIp = e.snapshot.value.toString();
        urlRoom = "http://" + myIp + "/Room/";
        urlSW = "http://" + myIp + "/SW/";
      });
    }
    else if (e.snapshot.key=="licence"){
      setState(() {
        myLicence=e.snapshot.value.toString();
        setSwitchStates=FirebaseDatabase.instance.reference().child("Licenses")
            .child(myLicence).child("Rooms");
      });
    }
  }
  void fillMenus() {
    for (int i=0;i<8;i++){
      switchesMenu.add(new List());
    }
    for (int i=0;i<8;i++){
      for (int j=0;j<8;j++){
        switchesMenu[i].add(new DropdownMenuItem(child: Text(roomSwitches[i][j]),value: j,));
      }
    }
  }
  Icon _editIcon =new Icon(Icons.edit);
  Icon _removeIcon=new Icon(Icons.remove);
  bool canEdit= false ;
  var snackBarKey =GlobalKey<ScaffoldState>();
  void editCustomButtons (){
    if (!canEdit){
      setState(() {
        canEdit=true ;
        _editIcon=new Icon(Icons.save);
      });
    }
    else {
      setState(() {
        canEdit=false ;
        _editIcon=new Icon(Icons.edit);

      });
    }
  }
  void saveNewName(int position){
    setState(() {
      customTexts[position]=_editListItemController.text.toString();
    });
    Navigator.pop(context);
  }
  void onLongPressTapped (int position){
    if (canEdit){
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context){
            return new AlertDialog(
              title: new Row(
                children: <Widget>[
                  new Expanded(child: new Text("Edit Button Name"),),
                  new IconButton(icon: new Icon(Icons.close), onPressed: ()=>Navigator.pop(context)),
                ],
              ),
              content: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new TextField(controller: _editListItemController,
                    decoration: InputDecoration(
                      labelText: "Enter New name",
                    ),
                  ),
                  new FlatButton.icon(onPressed: ()=>saveNewName(position), icon: Icon(Icons.save), label: Text("Save"))
                ],
              ),
            );
          }
      );
    }
    else {
      //show button functions
      showDialog(
          context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
            return new AlertDialog(
              title: Text("Button Functions"),
              actions: <Widget>[
                FlatButton(onPressed: ()=>Navigator.pop(context), child: Text("OK"))
              ],
              content:  Container(
              height: 200.0, // Change as per your requirement
              width: 200.0, // Change as per your requirement
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: customFunctions[position].length,
                itemBuilder: (BuildContext context, int i) {
                  return ListTile(
                    title: new Row (
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        new Text(roomsNames[customFunctions[position][i][0]-1]),
                        new Spacer(),
                        new Text(roomSwitches[customFunctions[position][i][0]-1][customFunctions[position][i][1]-1]),
                      ],
                    ),
                  );
                },
              ),
            )
            );
        }
      );
    }
  }


  Connectivity _connectivity;
  StreamSubscription<ConnectivityResult> _subscription;

  void onConnectivityChange(ConnectivityResult result) {
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
    loadData("customButtons").then((List <String> s){
      if (s!=null){
        setState(() {
          customTexts=s;
        });
      }
    });
    mAuth=FirebaseAuth.instance.currentUser().then((user){
      setState(() {
        userId=user.uid;
        functionList=FirebaseDatabase.instance.reference().child("Users Data").child(user.uid).child("Customs");
        functionList.onChildAdded.listen(_onChildAddedFunction);
        readUserData=FirebaseDatabase.instance.reference().child("Users Data").child(user.uid);
        readUserData.onChildAdded.listen(onUserDataChildAdded);
      });
    });
    setInitialDataFromPreferences("room").then((myList){
      setState(() {
        roomSwitches=myList;
      });
    }).then((_){
      fillMenus();
    });
    loadData("roomNames").then((List<String> _list){
      setState(() {
        roomsNames=_list;
      });
    }).then((_){
      for (int i=0;i<8;i++) {
        setState(() {
          roomsMenu.add(new DropdownMenuItem(child: new Text(roomsNames[i]), value: i,));
        });
      }
    });

    super.initState();
  }
  @override
  void dispose() {
    functionList.set(customFunctions);
    saveData("customButtons", customTexts);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      key:snackBarKey ,
      floatingActionButton: FloatingActionButton(
        onPressed: addButton,
        child: Icon(Icons.add,color: Color(0xFFEEEEEE),),
        tooltip: "Add new custom Button",
      ),
      appBar: AppBar(
        title: new Text("Custom Rooms"),
        actions: <Widget>[
          new IconButton(icon: _editIcon, onPressed: editCustomButtons),
        ],
      ),
      body: new Container(
        padding: EdgeInsets.all(10),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new ClipRRect(
              borderRadius: new BorderRadius.circular(20),
              child: Image.asset(
                "assets/images/logo.png",fit: BoxFit.cover,scale: 1,
                height: 200,
                width: 200,
              ),
            ),
            new Flexible(
              child:new ListView.builder( itemBuilder: (BuildContext context ,int position)=>
              new ListTile(
                onLongPress: ()=>onLongPressTapped(position),
                title:new Row(
                  children: <Widget>[
                    new Expanded(child: new Text(customTexts[position],style: TextStyle(fontSize: 20),)),
                    canEdit ? new IconButton(icon: _removeIcon, onPressed: ()=>{removeButton(position)}):new Container(),
                    new Switch(value: switchesStatus[position],
                        onChanged: (value)=>{
                        _onSwitchChanged(position, value)
                        }
                    ),
                  ],
                ),
              ),

                itemCount: customTexts.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
class myDialog extends StatefulWidget {
  myDialog({
    Key key,
    this.nameController,
    this.choosedFunctions,
    this.choosedItems,
    this.roomsMenu,
    this.roomsNames,
    this.roomSwitches,
    this.selectedRoomsMenuItem,
    this.selectedSwitchesMenuItem,
    this.switchesMenu,
  }): super(key: key);
  TextEditingController nameController = new TextEditingController();
  List<DropdownMenuItem> roomsMenu =[] ;
  int selectedRoomsMenuItem =0,selectedSwitchesMenuItem=0;
  List<List<DropdownMenuItem>> switchesMenu =[];
  List<String>choosedItems =[];
  List<List<int>> choosedFunctions = [];
  List <String> roomsNames =["Room1","Room2","Room3","Room4",
    "Room5","Room6","Room7","Room8"];
  List<List<String>> roomSwitches =[];

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new myDialogState();
  }

}
class myDialogState extends State<myDialog> {
  addNewItem (){
    setState(() {
      widget.choosedFunctions.add([widget.selectedRoomsMenuItem+1,widget.selectedSwitchesMenuItem+1]);
      widget.choosedItems.add(
          widget.roomsNames[widget.selectedRoomsMenuItem]+"  "+widget.roomSwitches[widget.selectedRoomsMenuItem][widget.selectedSwitchesMenuItem]);
    });
  }
  removeItem(int index){
    setState(() {
      widget.choosedFunctions.removeAt(index);
      widget.choosedItems.removeAt(index);
    });
  }
  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[

        new TextField(
          controller: widget.nameController,
          decoration: InputDecoration(
            labelText: "Name",
            hintText: "Enter the Name",
          ),
        ),
        new DropdownButton(
          items:widget.roomsMenu,
          value: widget.selectedRoomsMenuItem,
          onChanged:(value){
            setState(() {
              widget.selectedRoomsMenuItem=value;
            });
          },
        ),
        new DropdownButton(
          items:widget.switchesMenu[widget.selectedRoomsMenuItem],
          value: widget.selectedSwitchesMenuItem,
          onChanged:(value){
            setState(() {
              widget.selectedSwitchesMenuItem=value;
            });
          },
        ),

        new RaisedButton(onPressed: ()=>{addNewItem()},child: new Text("Add"),),
        new Container(
          height: 250,
          width: 300,
          child:new ListView.builder( itemBuilder: (BuildContext context ,int position)=>
          new ListTile(
            title:new Row(
              children: <Widget>[
                new Expanded(child: new Text(widget.choosedItems[position])),
                IconButton(icon: new Icon (Icons.remove), onPressed: ()=>{removeItem(position)}),
              ],
            ),
          ),
            itemCount: widget.choosedItems.length,
          ),
        ),
      ],
    );
  }
}
