import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:stamp/AppCommon.dart';
import 'package:stamp/GlobalState.dart';
import 'package:stamp/Pages/Admin/GenerateQRCode.dart';
class AdminHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState()=>AdminHomeState();
}
class AdminHomeState extends State <AdminHome> {
  void show (){
    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context
            , _
            , __
            ) => GenerateQRCode(),
    ),
    );
  }
  List<Map<String,dynamic>> myData = new List();
  List<String> offerNames = new List();
  void getData (){
    print("Hi");
    AppCommon.databaseReference.child("Admins").child(userId).child("Offers").once().then((snapshot){
      setState(() {
//        myData.add(snapshot.value);
//        offerNames.add(snapshot.key);
        print("koko");
        print(snapshot.key);
        print(snapshot.value);
      });
    });
  }
  String userId ;
  var ref ;
  @override
  void initState() {
//    GlobalState.ourInstance.setValue("selected offer", "offer name");
    setState(() {
      userId=GlobalState.ourInstance.getValue("userId");
    });
    getData();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        child: ListView.builder(itemBuilder: (BuildContext context ,int position){
          return Container(
            margin: EdgeInsets.all(20),
            child: Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
              CachedNetworkImage(
              imageUrl: myData[position]["image url"],
                imageBuilder: (context, imageProvider) => Container(
                  width: 150.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
                    Text(offerNames[position]),
                    Text(myData[position]["valid date"]),
                  ],
                ),

              ],
            ),
          ) ;
        },itemCount: myData.length,)
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>Navigator.pushNamed(context, '/AddNewOffer'),
        child: Icon(Icons.add),
        tooltip: "Add new Offer",
      ),
      bottomNavigationBar: new BottomNavigationBar(
        items: [
          new BottomNavigationBarItem(
              icon: new Icon(Icons.home,), title: new Text("Offers")),
          new BottomNavigationBarItem(
              icon: new Image.asset("assets/icons/Bottom Navigation bar/2.png",width: 25,height: 25,), title: new Text("Scan Winners")),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.person,), title: new Text("Place Profile")),
        ],
        onTap:_onPressedBottomNavigationBar,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
      ),

    );
  }
  void _onPressedBottomNavigationBar (int position){
    switch (position) {
      case 0 : AppCommon.mAuth.signOut();break;
      case 1 :Navigator.pushNamed(context, '/ScanWinners');break;
      case 2 :Navigator.pushNamed(context, '/AdminProfile');break;
    }

  }

}