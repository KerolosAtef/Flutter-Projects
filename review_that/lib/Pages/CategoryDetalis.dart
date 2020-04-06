import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:device_apps/device_apps.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../GlobalState.dart';
//import 'package:flutter_launch/flutter_launch.dart';
//import 'package:flutter_share_me/flutter_share_me.dart';

import 'dart:io' show Platform;
class CategoryDetails extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new CategoryDetailsState();
  }

}
class CategoryDetailsState extends State<CategoryDetails> {
  var snackBarKey =GlobalKey<ScaffoldState>();
  void launchUrl(String link) async {
    if (link.isEmpty){
      snackBarKey.currentState.showSnackBar(
        SnackBar(
          content: Text("No Page attached"),
          duration: Duration(seconds: 2),
        ),
      );
    }
    else if (!link.contains("https://")){
      link="https://"+link;
    }
    else if (await canLaunch(link)) {
      await launch(link);
    } else {
      snackBarKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Link is Wrong and can't be Launched"),
          duration: Duration(seconds: 2),
        ),
      );
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
  Future goToUberApp() async {
//    List<Application> apps = await DeviceApps.getInstalledApplications(
//        onlyAppsWithLaunchIntent: true
//    );
//    print(await DeviceApps.getInstalledApplications(
//        onlyAppsWithLaunchIntent: true
//    ));
    bool isInstalled = await DeviceApps.isAppInstalled('com.ubercab');
    if (isInstalled){
      DeviceApps.openApp('com.ubercab');
    }
    else{
      snackBarKey.currentState.showSnackBar(
          SnackBar(
            content: Text("Uber APP Not Installed"),
            duration: Duration(seconds: 2),
          ),
      );
    }
  }
  void openMap(double latitude, double longitude) async {
    print(latitude);
    print(longitude);
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  PageController pageViewController = new PageController();
  void jumpThePageView (int position){
    pageViewController.jumpToPage(position);
  }
  ScrollController listViewController = new ScrollController();
  int selectedPageInPageView =0 ;
  void onPageViewPhotoChanged (int value){
    setState(() {
      selectedPageInPageView=value;
      listViewController.jumpTo(value*1.0);
    });
  }
  void leftArrow (){
    if(selectedPageInPageView>0)
      pageViewController.jumpToPage(selectedPageInPageView-1);
  }
  void rightArrow (){
    if (selectedPageInPageView<lengthOfImages)
      pageViewController.jumpToPage(selectedPageInPageView+1);
  }
  void share(){
//    FlutterShareMe().shareToFacebook(msg:nameOfSelectedItem +"  rate :"+myData['rating'].toString() );
  }
  TextEditingController textReview =TextEditingController();
  double reviewRating =0.0;
  void onRatingChanged (double value){
    setState(() {
      reviewRating=value;
    });
  }
  String userId ="";
  var mAuth=FirebaseAuth.instance;
  void submitReview (){
    Map<String,dynamic> data =new Map();
    data["textReview"]=textReview.text;
    data["rating"]=reviewRating;
    data["name"]=myData["name"];
    print("mmmmm");
    print(reviews);
    print(numOfPeoples);
    if ((reviews==null ||numOfPeoples==reviews.length )&& textReview.text.isNotEmpty){
      print("Length");
      setState(() {
        if (averageRating==0){
          averageRating=reviewRating;
        }
        else{
          averageRating=(averageRating+reviewRating)/numOfPeoples;
        }
        myData["rating"]=averageRating;
      });
      if (myData["rating"]> mostRated){
        print(mostRated);
        mostRatedRef.child("most rated").set(myData["rating"]);
      }
      var writeReviewRef ;
      if (mainCategory=="Restaurant") {
        writeReviewRef=FirebaseDatabase.instance.reference().child("Categories")
            .child(mainCategory).child(restaurantCategory).child(keyOfSelectedItem);
        writeReviewRef.child("Reviews").child(userId).set(data);
        writeReviewRef.child("rating").set(myData["rating"]);
      }
      else{
        writeReviewRef=FirebaseDatabase.instance.reference().child("Categories")
            .child(mainCategory).child(keyOfSelectedItem);
        writeReviewRef.child("Reviews").child(userId).set(data);
        writeReviewRef.child("rating").set(myData["rating"]);
      }
      textReview.clear();
      snackBarKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Review is submitted"),
          duration: Duration(seconds: 2),
        ),
      );
      Future.delayed(Duration(seconds: 2)).then((_){
        Navigator.pop(context);
        Navigator.pushNamed(context,'/AllReviews');
      });
    }
    else if (textReview.text.isEmpty){
      snackBarKey.currentState.showSnackBar(
        SnackBar(
          content: Text("You should write a Review before submit"),
          duration: Duration(seconds: 2),
        ),
      );
    }
    else {
      snackBarKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Waiting until calculate The average review and the Submit again"),
          duration: Duration(seconds: 2),
        ),
      );
    }

  }

  Map<String,dynamic> myData =new Map();
  var reviews ;
  int lengthOfImages=0;
  void getData (Event e){
    setState(() {
      if (e.snapshot.key=="address"){
        myData["address"]=e.snapshot.value;
      }
      else if (e.snapshot.key=="facebookPage"){
        myData["facebookPage"]=e.snapshot.value;
      }
      else if (e.snapshot.key=="instgramPage"){
        myData["instgramPage"]=e.snapshot.value;
      }
      else if (e.snapshot.key=="rating"){
        myData["rating"]=e.snapshot.value*1.0;
      }
      else if (e.snapshot.key=="twitterPage"){
        myData["twitterPage"]=e.snapshot.value;
      }
      else if (e.snapshot.key=="location"){
        myData["latitude"]=e.snapshot.value["latitude"];
        myData["longitude"]=e.snapshot.value["longitude"];
      }
      else if (e.snapshot.key=="Reviews"){
        print("koko");
        reviews=e.snapshot.value;
      }
      else {
        for (int i=0;i<20;i++){
          if (e.snapshot.key=="image"+i.toString()){
            myData["image"+i.toString()]=e.snapshot.value;
            lengthOfImages++;
          }
        }
      }
    });
  }
  void readName (Event e){
    setState(() {
      if (e.snapshot.key=="name"){
        myData["name"]=e.snapshot.value;
      }
    });
  }
  double  mostRated=0.0;
  void readMostRated (Event e){
    setState(() {
      mostRated=e.snapshot.value*1.0;
    });
  }
  double averageRating =0;
  int numOfPeoples=0;
  void readAllRatings(Event e){
    numOfPeoples++;
    if (e.snapshot.key!=userId){
      setState(() {
        averageRating+=(e.snapshot.value["rating"]*1.0);
      });
    }
  }
  String mainCategory="",restaurantCategory ="",nameOfSelectedItem="",keyOfSelectedItem="";
  var mostRatedRef ;
  @override
  void initState() {
    FirebaseDatabase.instance.setPersistenceEnabled(true);
    setState(() {
      mainCategory=GlobalState.ourInstance.getValue("MainCategory");
      restaurantCategory=(GlobalState.ourInstance.getValue("RestaurantCategory")!=null)
          ?GlobalState.ourInstance.getValue("RestaurantCategory")
          :"";
      nameOfSelectedItem=GlobalState.ourInstance.getValue("nameOfSelectedItem");
      keyOfSelectedItem=GlobalState.ourInstance.getValue("keyOfSelectedItem");

    });
    var ref,averageRate;
    mostRatedRef=FirebaseDatabase.instance.reference()
        .child("notification").child(mainCategory);
    if (mainCategory=="Restaurant") {
      ref=FirebaseDatabase.instance.reference()
          .child("Categories").child(mainCategory).child(restaurantCategory).child(keyOfSelectedItem);
      averageRate=FirebaseDatabase.instance.reference()
          .child("Categories").child(mainCategory).child(restaurantCategory)
          .child(keyOfSelectedItem).child("Reviews");
    }
    else{
      ref=FirebaseDatabase.instance.reference().child("Categories").child(mainCategory).child(keyOfSelectedItem);
      averageRate=FirebaseDatabase.instance.reference().child("Categories")
          .child(mainCategory).child(keyOfSelectedItem).child("Reviews");
    }
    ref.onChildAdded.listen(getData);
    mostRatedRef.onChildAdded.listen(readMostRated);
    mAuth.currentUser().then((user){
      setState(() {
        userId=user.uid;
      });
      FirebaseDatabase.instance.reference()
          .child("UserData").child(user.uid)
          .onChildAdded.listen(readName);
    }).whenComplete((){
      averageRate.onChildAdded.listen(readAllRatings);
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key:snackBarKey ,
      body: new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/backgraound.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                new Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.all(10),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
//                      new IconButton(icon: new Image.asset(
//                        "assets/icons/share.png",width: 35,height: 35,
//                      ),
//                        onPressed:share,
//                      ),
//                      new SizedBox(width: 10,),
//                      new Image.asset(
//                        "assets/icons/notification.png",width: 35,height: 35,
//                      ),
                      new IconButton(icon: new Image.asset(
                        "assets/icons/logout.png",width: 40,height: 40,
                      ),
                        onPressed:logout,
                      ),

                    ],
                  ),
                ),
                Container(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    height: 200,
                    child: (lengthOfImages>0)
                        ? PageView.builder(
                      itemBuilder: (BuildContext context ,int position){
                        return new Container(
                          child:new CachedNetworkImage(
                            imageUrl: myData["image"+position.toString()],
                            height: 120,
                            width: 150,
                            fit: BoxFit.contain,
                            placeholder: (context, url) => CircularProgressIndicator(),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          ),

                        );
                      },
                      itemCount: lengthOfImages,
                      controller: pageViewController,
                      onPageChanged: (changedPotion){onPageViewPhotoChanged(changedPotion);},
                    ):new Image.asset("assets/images/default_image_category.png"),
                  ),
                ),
                    (lengthOfImages>0)
                        ?Container(
//                  width: 80,
                    height: 130,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      controller:listViewController ,
                      itemBuilder: (BuildContext context ,int position){
                        return GestureDetector(
                          onTap: ()=>jumpThePageView(position),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child:new CachedNetworkImage(
                              imageUrl: myData["image"+position.toString()],
                              height: 200,
                              width: 100,
                              fit: BoxFit.contain,
                              placeholder: (context, url) => CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            )
                          ),
                        );
                      },
                      itemCount: lengthOfImages,
                    )
                ):new Container(),
                Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                        margin: EdgeInsets.only(left: 15,right: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(nameOfSelectedItem,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                            Text(myData["address"],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                            RatingBarIndicator(
                              rating: myData["rating"],
                              itemCount: 5,
                              itemSize: 15.0,
                              itemBuilder: (context, index) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                            ),
                            new Row(
                              children: <Widget>[
                                IconButton(
                                    icon: Image.asset('assets/icons/location.png',
                                      width: 30,
                                      height:30 ,
                                    ),
                                    onPressed: ()=>openMap(myData['latitude'],myData['longitude'])
                                ),
                                IconButton(
                                    icon: Image.asset('assets/icons/facebook_white.png',
                                      width: 30,
                                      height:30 ,
                                    ),
                                    onPressed:()=>launchUrl(myData["facebookPage"])
                                ),
                                IconButton(
                                    icon: Image.asset('assets/icons/instagram.png',
                                      width: 30,
                                      height:30 ,
                                    ),
                                    onPressed: ()=>launchUrl(myData["instgramPage"])
                                ),
                                IconButton(
                                    icon: Image.asset('assets/icons/twitter.png',
                                      width: 30,
                                      height:30 ,
                                    ),
                                    onPressed: ()=>launchUrl(myData["twitterPage"])
                                ),
                              ],

                            ),
                            TextField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.white)),
                                hintText: "Write your review",
                              ),
                              maxLines: 10,
                              minLines: 3,
                              controller: textReview,

                            ),
                            new SizedBox(height: 10,),
                            RatingBar(
                              onRatingUpdate: (value){onRatingChanged(value);},
                              itemCount: 5,
                              allowHalfRating: true,
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                            ),
                            new SizedBox(height: 10,),
                            new Center(
                              child: new RaisedButton(
                                onPressed: submitReview,
                                color: Colors.amber,
                                shape: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20)),borderSide: BorderSide(color: Colors.amber)),

                                child: Text("Submit My Review",style: TextStyle(color: Colors.black),),
                              ),
                            ),
                            new Center(
                              child: new RaisedButton(
                                onPressed: ()=>Navigator.pushNamed(context, '/AllReviews'),
                                color: Colors.amber,
                                shape: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20)),borderSide: BorderSide(color: Colors.amber)),

                                child: Text("All Reviews",style: TextStyle(color: Colors.black),),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
}


