import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:review_that/Pages/MenuHome.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../GlobalState.dart';

class Profile extends StatefulWidget {
  @override
  ProfileState createState() => ProfileState();
}
class ProfileState extends State<Profile> {
  String userToken ;
  List <String> unSelectedInterestedItems =[
    "assets/icons/restaurant.png","assets/icons/cafe.png","assets/icons/hotels.png"
    ,"assets/icons/hospitals_and_clinics.png",
    "assets/icons/stores.png","assets/icons/shopping_centers.png"
  ];
  List <String> selectedInterestedItems =[
    "assets/icons/selected_restaurant.png","assets/icons/selected_cafe.png","assets/icons/selected_hotels.png"
    ,"assets/icons/selected_hospitals_and_clinics.png",
    "assets/icons/selected_stores.png","assets/icons/selected_shopping_centers.png"
  ];
  List <String> actualInterestedItems =[
    "assets/icons/restaurant.png","assets/icons/cafe.png","assets/icons/hotels.png"
    ,"assets/icons/hospitals_and_clinics.png",
    "assets/icons/stores.png","assets/icons/shopping_centers.png"
  ];
  List<String> interestedNames =["Restaurant","Cafe","Hotels",
    "Medical","Stores","Shopping"];
  Future<File> userImages ;
  bool isSelectedFromGallery =false ;
  void pickImageFromGallery(ImageSource source) {
    setState(() {
      userImages = ImagePicker.pickImage(source: source,imageQuality: 85);
    });
  }
  Widget showImage() {
    return FutureBuilder<File>(
      future: userImages,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          isSelectedFromGallery=true;
          return Center(
            child: CircleAvatar(
              backgroundImage: FileImage(snapshot.data),
              backgroundColor: Colors.transparent,
              minRadius: 40,
              maxRadius: 70,
            ),
          );
        } else if (snapshot.error != null) {
          return Center(
            child: const Text(
              'Error Picking Image',
              textAlign: TextAlign.center,
            ),
          );
        } else {
          return CachedNetworkImage(
            imageUrl: personalImageUrl,
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
          );
        }
      },
    );
  }
  Future continueFun () async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context){
        return new AlertDialog(
          content: new Row(
            children: [
              new CircularProgressIndicator(),
              new Padding(padding: EdgeInsets.only(left: 10)),
              new Text("please wait ..."),
            ],
          ),
        );
      },
    );
    var ref ;
    StorageReference uploadImagesRef ;
    StorageUploadTask uploadTask ;
    uploadImagesRef= FirebaseStorage.instance.ref()
        .child("Images").child("UsersImages").child(userId);
    ref=FirebaseDatabase.instance.reference().child("UserData")
        .child(userId).child("personalImage");
    if (isSelectedFromGallery){
      print("koko");
      uploadTask=uploadImagesRef.putFile(await userImages);
      ref.set(await ((await uploadTask.onComplete).ref.getDownloadURL()));
    }
    for(int i=0;i<6;i++){
      if (actualInterestedItems[i]==selectedInterestedItems[i]){
        FirebaseDatabase.instance.reference()
            .child("UserData").child(userId).child("interested").child(interestedNames[i]).set(true);
        FirebaseDatabase.instance.reference().child("Categories")
            .child(interestedNames[i]).child("tokens").child(userToken).set(true);
      }
      else {
        FirebaseDatabase.instance.reference()
            .child("UserData").child(userId).child("interested").child(interestedNames[i]).set(null);
        FirebaseDatabase.instance.reference().child("Categories")
            .child(interestedNames[i]).child("tokens").child(userToken).set(null);
      }
    }
    Navigator.pop(context);
    Navigator.pushNamed(context, '/MenuHome');
  }
  void selectInterestedFields (int position){
    setState(() {
      if (actualInterestedItems[position]!=selectedInterestedItems[position]){
        actualInterestedItems[position]=selectedInterestedItems[position];
      }
      else{
        actualInterestedItems[position]=unSelectedInterestedItems[position];
      }
    });
  }

  void readInterestedFields (Event e){
    setState(() {
      for (int i=0;i<6;i++){
        if (interestedNames[i]==e.snapshot.key){
          setState(() {
            actualInterestedItems[i]=selectedInterestedItems[i];
          });
        }
      }
    });

  }
  String userName ="",personalImageUrl="https://firebasestorage.googleapis.com/v0/b/reviewthat-ad3eb.appspot.com/o/Images%2FUsersImages%2Fadd_new_user.png?alt=media&token=2094dc97-71ac-480c-859b-c287c99023ae";
  void readPersonalImage (Event e){
    setState(() {
      if (e.snapshot.key=="name"){
        userName=e.snapshot.value;
      }
      else if (e.snapshot.key=="personalImage") {
        personalImageUrl=e.snapshot.value;
      }
    });
  }

  var mAuth =FirebaseAuth.instance;
  String userId="";
  @override
  void initState(){
    FirebaseDatabase.instance.setPersistenceEnabled(true);
    super.initState();
    setState(() {
      userToken=GlobalState.ourInstance.getValue("userToken");
    });
    mAuth.currentUser().then((user) {
      setState(() {
        userId=user.uid;
      });
      FirebaseDatabase.instance.reference()
          .child("UserData").child(user.uid)
          .child("interested").onChildAdded.listen(readInterestedFields);
      FirebaseDatabase.instance.reference()
          .child("UserData").child(user.uid)
          .onChildAdded.listen(readPersonalImage);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/backgraound.jpg'),
              fit: BoxFit.cover
          ),
        ),
        child: Center(
          child: Container(
            padding: EdgeInsets.only(top: 30),
            margin: EdgeInsets.only(top: 20,bottom: 20,left: 20,right: 20),
            decoration: BoxDecoration(borderRadius:BorderRadius.circular(30.0),color: Colors.white),
//          padding: EdgeInsets.only(top: 5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: ()=>pickImageFromGallery(ImageSource.gallery),
                  child: showImage(),
                ),
                SizedBox(height: 10,),
                Center(
                  child: new Text("Welcome",style: TextStyle(
                    fontWeight:FontWeight.bold,
                    color: Color(0xFF6A1B9A),
                    fontFamily: 'Montserrat',
                    fontSize: 22,
                  ),
                  ),
                ),
                Center(
                  child: new Text(userName,style: TextStyle(
                    fontWeight:FontWeight.bold,
                    color: Color(0xFF6A1B9A),
                    fontFamily: 'Montserrat',
                    fontSize: 22,
                  ),
                  ),
                ),
                
                SizedBox(height: 10,),
                new Center(
                  child: new Text("A Lot Of Interesting Places Waiting You",style: TextStyle(
                    fontWeight:FontWeight.bold,
                    color: Color(0xFF6A1B9A),
                    fontFamily: 'Montserrat',
                  ),),
                ),
                SizedBox(height: 10,),
                new Center(
                  child: new Text("Choose your favourite categories",style: TextStyle(
                      fontWeight:FontWeight.bold,
                      color: Color(0xFF6A1B9A),
                      fontFamily: 'Montserrat',
                      fontSize: 18
                  ),),
                ),
                new Container(
                  margin: EdgeInsets.only(top: 10),
                  height: 240,
                  child: new GridView.builder(
                  gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
//                  mainAxisSpacing: 20,
//                  childAspectRatio: 10,
//                  crossAxisSpacing: 10,
                  ) ,
                  itemBuilder: (BuildContext context ,int position){
                    return new Column(
                      children: <Widget>[
                        GestureDetector(
                            onTap: ()=>selectInterestedFields(position),
                            child: Center(
                              child: CircleAvatar(
                                backgroundImage: ExactAssetImage(actualInterestedItems[position]),
                                backgroundColor: Colors.transparent,
                                minRadius: 20,
                                maxRadius: 30,
                              ),
                            )
                        ),
                        Expanded(
                          child: Center(
                            child: new Text(interestedNames[position],
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },itemCount: 6,padding: EdgeInsets.only(left: 20,right: 20,top: 15),
                ),
                ),

                new Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      onPressed:continueFun ,
                      icon: Icon(Icons.arrow_forward_ios),
                    ),
                    SizedBox(width: 10,),
                  ],
                ),
              ],
            ),
          ) ,
        )
      ),
    );
  }
}

