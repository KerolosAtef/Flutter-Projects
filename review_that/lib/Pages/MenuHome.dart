import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:review_that/GlobalState.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
class MenuHome extends StatefulWidget {
  @override
  MenuHomeState createState() => MenuHomeState();
}
class MenuHomeState extends State<MenuHome> {
  List<String> categoriesNames =["Restaurant","Cafe","Hotels",
    "Medical","Stores","Shopping"];
  List <String> categoriesIcons =[
    "assets/icons/restaurant.png","assets/icons/cafe.png","assets/icons/hotels.png"
    ,"assets/icons/hospitals_and_clinics.png",
    "assets/icons/stores.png","assets/icons/shopping_centers.png"
  ];
  List<int > iconsIndex=[0,2,4];
  void goToLeftColumn (int position){
    if (position == 1){
      GlobalState.ourInstance.setValue("MainCategory", "Restaurant");
      Navigator.pushNamed(context, '/Restaurant');
    }
    else if (position==2){
      GlobalState.ourInstance.setValue("MainCategory", "Hotels");
      Navigator.pushNamed(context, '/CategoryHome');
    }
    else if (position==3){
      GlobalState.ourInstance.setValue("MainCategory", "Stores");
      Navigator.pushNamed(context, '/CategoryHome');
    }
  }
  void goToRightColumn (int position){
    if (position == 1){
      GlobalState.ourInstance.setValue("MainCategory", "Cafe");
      Navigator.pushNamed(context, '/CategoryHome');
    }
    else if (position==2){
      GlobalState.ourInstance.setValue("MainCategory", "Medical");
      Navigator.pushNamed(context, '/CategoryHome');
    }
    else if (position==3){
      GlobalState.ourInstance.setValue("MainCategory", "Shopping");
      Navigator.pushNamed(context, '/CategoryHome');

    }
  }
  SharedPreferences preferences ;
  Future<bool> saveData(String key , bool value) async {
    preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(key, value);
  }
  void logout (){
    saveData("rememberMe", false);
    mAuth.signOut();
    Navigator.of(context).pushNamedAndRemoveUntil(
        '/ChooseLoginAndRegister', (Route<dynamic> route) => false);
  }
  var mAuth = FirebaseAuth.instance;
  @override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:new Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/backgraound.jpg'),
                fit: BoxFit.cover
            ),
          ),
          child: Column(
            children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  new Container(
                margin: EdgeInsets.only(top: 40,right: 10),
                    child:new IconButton(
                        icon: new Image.asset(
                          "assets/icons/logout.png",
                          width: 40,
                          height: 40,
                        ),
                        onPressed: logout,
                    )
                  ),
                ],
              ),
              new Flexible(
                  child: ListView.builder(
                    itemBuilder: (BuildContext context ,int position){
                      return (position==0)
                          ? Container(
                        child:new Image.asset('assets/images/login_logo.png',
                          width: 130,height: 130,
                        ),
                      ) : Container(
                        padding: EdgeInsets.only(top: 15,bottom: 15,left: 35,right: 35),
                        margin: EdgeInsets.only(top: 20,bottom: 10),
                        decoration: BoxDecoration(color: Colors.white),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Column(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: ()=>goToLeftColumn(position),
                                  child: Column(
                                    children: <Widget>[
                                      Center(
                                        child: CircleAvatar(
                                          backgroundImage: ExactAssetImage(categoriesIcons[iconsIndex[position-1]]),
                                          backgroundColor: Colors.transparent,
                                          minRadius: 20,
                                          maxRadius: 40,
                                        ),
                                      ),
                                      new Text(categoriesNames[iconsIndex[position-1]],
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            new Column(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: ()=>goToRightColumn(position),
                                  child: Column(
                                    children: <Widget>[
                                      Center(
                                        child: CircleAvatar(
                                          backgroundImage: ExactAssetImage(categoriesIcons[iconsIndex[position-1]+1]),
                                          backgroundColor: Colors.transparent,
                                          minRadius: 20,
                                          maxRadius: 40,
                                        ),
                                      ),
                                      new Text(categoriesNames[iconsIndex[position-1]+1],
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                      ;
                    } ,itemCount: 4,
                  ),
              )
            ],
          ),
        ),

    );
  }
}
