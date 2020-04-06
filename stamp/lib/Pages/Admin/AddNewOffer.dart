import 'dart:ffi';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:stamp/AppCommon.dart';
import 'package:stamp/GlobalState.dart';
class AddNewOffer extends StatefulWidget {
  @override
  State<StatefulWidget> createState()=>AddNewOfferState();
}
class AddNewOfferState extends State <AddNewOffer> {

  DateTime selectedOffersDate = DateTime.now();
  DateTime selectedMealDate = DateTime.now();

  Future<File> offerGiftImage ;
  Future<File> offerMealsImage ;
  var offerMealsImageData ,offerGiftImageData ;

  bool isSelectedFromGallery =false ;
  void pickImageFromGallery(ImageSource source, bool giftImage) {
    if (giftImage){
      setState(() {
        offerGiftImage = ImagePicker.pickImage(source: source,imageQuality: 85);
      });
    }
    else {
      setState(() {
        offerMealsImage = ImagePicker.pickImage(source: source,imageQuality: 85);
      });
    }

  }
  Widget showImage(bool giftImage) {
    return FutureBuilder<File>(
      future: (giftImage)?offerGiftImage:offerMealsImage,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          isSelectedFromGallery=true;
          (giftImage)?offerGiftImageData=snapshot.data:offerMealsImageData=snapshot.data;
          return Image.file(snapshot.data,width: 100,height: 100,fit: BoxFit.cover,);
        } else if (snapshot.error != null) {
          return Center(
            child: const Text(
              'Error Picking Image',
              textAlign: TextAlign.center,
            ),
          );
        } else {
          return Image.asset("assets/images/Add new offer/defualtImage.png",height: 120,width: 120,fit: BoxFit.cover,);
        }
      },
    );
  }

  Future<Null> _selectDate(BuildContext context,bool giftDate) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: (giftDate)?selectedOffersDate:selectedMealDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedOffersDate)
      setState(() {
        (giftDate)?selectedOffersDate = picked : selectedMealDate=picked;
      });
  }

  List<Map>mealsData = new List();
  TextEditingController mealName= new TextEditingController();
  TextEditingController mealPrice= new TextEditingController();
  TextEditingController offerName= new TextEditingController();

  StorageReference uploadImagesRef ;
  StorageUploadTask uploadTask ;
  var snackBarKey =GlobalKey<ScaffoldState>();
  Future<void> addMeal () async {
    uploadImagesRef= FirebaseStorage.instance.ref()
        .child("Images").child(userId).child("offers").child(offerName.text)
        .child(mealName.text);
    snackBarKey.currentState.showSnackBar(SnackBar(
      content: Text("uploading offer meal image"),
      duration: Duration(hours: 1),
    ));
    uploadTask=uploadImagesRef.putFile(await offerMealsImage);
    Map<String,dynamic> mp = new Map();
    mp["name"]=mealName.text;
    mp["price"]=mealPrice.text;
    mp["image"]=offerMealsImageData;
//    upload image of the meal
    mp["image url"]=await ((await uploadTask.onComplete).ref.getDownloadURL());
    snackBarKey.currentState.hideCurrentSnackBar();
    snackBarKey.currentState.showSnackBar(SnackBar(
      content: Text("offer meal image is uploaded"),
    ));
    mp["vaildDate"]=selectedMealDate;
    setState(() {
      mealsData.add(mp);
      selectedOffersDate=DateTime.now();
    });
//    print(mealsData);
    mealName.clear();
    mealPrice.clear();
  }
  Future<void> saveOffer () async {
    //upload offer image
    snackBarKey.currentState.showSnackBar(SnackBar(
      content: Text("Uploading offer Gift image"),
      duration: Duration(hours: 1),
    ));
    uploadImagesRef= FirebaseStorage.instance.ref()
        .child("Images").child(userId).child("offers").child(offerName.text);
    uploadTask=uploadImagesRef.putFile(await offerGiftImage);

    var recordOfferData =AppCommon.databaseReference.child("Admins").child(userId).child("Offers")
        .child(offerName.text);
    recordOfferData.child("image url").set(await ((await uploadTask.onComplete).ref.getDownloadURL()));
    snackBarKey.currentState.hideCurrentSnackBar();
    snackBarKey.currentState.showSnackBar(SnackBar(
      content: Text("Offer Gift image is uploaded"),
    ));
    recordOfferData.child("valid date").set(selectedOffersDate.toString());
    recordOfferData=recordOfferData.child("Offer meals");
    for (int i=0;i<mealsData.length;i++){
      recordOfferData.child(mealsData[i]["name"]).child("image url").set(mealsData[i]["offerImageUrl"]);
      recordOfferData.child(mealsData[i]["name"]).child("price").set(mealsData[i]["price"]);
      recordOfferData.child(mealsData[i]["name"]).child("valid date").set(mealsData[i]["valid date"].toString());
    }
  }

  String userId ;
  @override
  void initState() {
    setState(() {
      userId=GlobalState.ourInstance.getValue("userId");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: snackBarKey,
      body: new Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
//              decoration: BoxDecoration(
//                image: DecorationImage(
//                  image: AssetImage('assets/images/backgraound.jpg'),
//                  fit: BoxFit.cover,
//                ),
//              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: <Widget>[
                  Container(
                    height:220,
                    child: Column(
                      children: <Widget>[
                        Padding(padding: EdgeInsets.only(top: 30),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.save),
                              onPressed: saveOffer,
                            ),
                          ],
                        ),
                        Text("Offer Gift"),
                        Row(
                          children: <Widget>[
                            GestureDetector(
                              onTap: ()=>pickImageFromGallery(ImageSource.gallery,true),
                              child: showImage(true),
                            ),
                            SizedBox(width: 15,),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(right: 30),
                                    child: TextField(
                                      controller: offerName,
                                      expands: false,
                                      decoration:InputDecoration(
                                        hintText: "Name",
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text("Valid untill  "+DateFormat("yyyy-MM-dd").format(selectedOffersDate).toString()),
                                      IconButton(
                                        onPressed:()=>_selectDate(context,true),
                                        icon: Icon(Icons.calendar_today),
                                      ),
                                    ],
                                  ),

                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 250,
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Text("Offer Meals"),
                        ),
                        Row(
                          children: <Widget>[
                            GestureDetector(
                              onTap: ()=>pickImageFromGallery(ImageSource.gallery,false),
                              child: showImage(false),
                            ),
                            SizedBox(width: 15,),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(right: 30),
                                    child: TextField(
                                      controller: mealName,
                                      expands: false,
                                      decoration:InputDecoration(
                                        hintText: "Name",
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 30),
                                    child: TextField(
                                      controller: mealPrice,
                                      expands: false,
                                      decoration:InputDecoration(
                                        hintText: "Price",
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text("Valid untill  "+DateFormat("yyyy-MM-dd").format(selectedMealDate).toString()),
                                      IconButton(
                                        onPressed:()=>_selectDate(context,false),
                                        icon: Icon(Icons.calendar_today),
                                      ),
                                    ],
                                  ),
                                  Center(
                                    child: RaisedButton(
                                      onPressed: ()=>addMeal(),
                                      child: Text("Add"),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(itemBuilder:(BuildContext context ,int position){
                      return Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Image.file(mealsData[position]["image"],width: 100,height: 100,),
                            Text(mealsData[position]["name"]),
                            Text(mealsData[position]["price"].toString()),
                            Text(DateFormat("yyyy-MM-dd").format(mealsData[position]["vaildDate"]).toString()),
                          ],
                        ),
                      );
                    },
                      itemCount: mealsData.length,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),

                ],
              ),
            ),
          ]
      )
    );
  }

}