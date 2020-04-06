import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../GlobalState.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder/geocoder.dart';

class AddNewCategory extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new AddNewCategoryState();
  }

}
class AddNewCategoryState extends State<AddNewCategory> {

  List<TextEditingController>infoControllersList= [
    new TextEditingController(),new TextEditingController(),new TextEditingController(),
    new TextEditingController(),
  ];
  final kGoogleApiKey = "AIzaSyD7bYaGBoXdrTKu9gRUwod-az4BKcaK-JA";
  GoogleMapsPlaces _places ;


  List<String>errorsInfoList =["","",""];
  List<String> infoList =[
    "Name of the Place","Facebook Page Link","Twitter Page Link"
    ,"Instgram Page Link",
  ];
  var snackBarKey =GlobalKey<ScaffoldState>();

  List<Future<File>> photosList =new List();
  void pickImageFromGallery(ImageSource source) {
    setState((){
      photosList.insert(0, ImagePicker.pickImage(source: source,imageQuality: 85));
    });
  }
  Widget showImage(int position) {
    return FutureBuilder<File>(
      future: photosList[position],
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          return Image.file(snapshot.data,fit: BoxFit.contain,);
        } else if (snapshot.error != null) {
          return Center(
            child: const Text(
              'Error Picking Image',
              textAlign: TextAlign.center,
            ),
          );
        }
        else if (snapshot.connectionState == ConnectionState.done && snapshot.data==null){
          print("koko");
          print(photosList.length);
          photosList.removeAt(position);
          print(photosList.length);
          return Center(
            child: const Text(
              "You didn't select a photo",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white,fontSize: 20),
            ),
          );
        }else {
//          print(snapshot);
          return Center(
            child: Text(
              'Going to Gallaery',
              textAlign: TextAlign.center,
            )
          );
        }
      },
    );
  }
  void deleteThisPhoto (){
    setState(() {
      photosList.removeAt(selectedPageInPageView);
    });
  }
  var ref ,first;
  String addressDetails ="";
  bool c1,c2,c3,c4;
  void submit () async {
    //todo put some validations
    for(int i=0;i<3;i++){
      setState(() {
        errorsInfoList[i]="";
      });
    }
    if (infoControllersList[0].text.isNotEmpty
//        &&infoControllersList[1].text.isNotEmpty
        && photosList.isNotEmpty){
      c1=true;c2=true;c3=true;c4=true;
      if (infoControllersList[1].text.isNotEmpty
          &&!infoControllersList[1].text.contains("www.facebook.com")){
        c1=false;
        setState(() {
          errorsInfoList[0]="Invalid facebook Page pattern";
        });
      }

      if (infoControllersList[2].text.isNotEmpty &&
          !infoControllersList[2].text.contains("www.twitter.com")){
        c2=false;
        setState(() {
          errorsInfoList[1]="Invalid twitter Page pattern";
        });
      }
      if (infoControllersList[3].text.isNotEmpty &&
          !infoControllersList[3].text.contains("www.instgram.com")){
        c3=false;
        setState(() {
          errorsInfoList[2]="Invalid instgram Page pattern";
        });
      } if (addressDetails=="Loading address from Google Map..."){
        c4=false;
        snackBarKey.currentState.showSnackBar(
            SnackBar(
              content: Text("Wait untill Loading is Finished Or try to Be More acurate in Name Field"),
            )
        );

      }
      if (addressDetails!="Please Enter The Exact Name in Google Map"
          &&c1&&c2&&c3&&c4
      ){
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context){
            return new AlertDialog(
              content: new Row(
                children: [
                  new CircularProgressIndicator(),
                  new Padding(padding: EdgeInsets.only(left: 10)),
                  new Text("Please wait..."),
                ],
              ),
            );
          },
        );
        Map<String,dynamic> uploadedData =new Map() ;
        uploadedData["name"]=infoControllersList[0].text.toString();
        uploadedData["address"]=addressDetails;
        uploadedData["facebookPage"]=infoControllersList[1].text.toString();
        uploadedData["twitterPage"]=infoControllersList[2].text.toString();
        uploadedData["instgramPage"]=infoControllersList[3].text.toString();
        uploadedData["rating"]=0.0001;

        StorageReference uploadImagesRef ;
        StorageUploadTask uploadTask ;

        if (mainCategory=="Restaurant") {
          uploadImagesRef= FirebaseStorage.instance.ref()
              .child("Images").child(mainCategory).child(restaurantCategory);
          ref=FirebaseDatabase.instance.reference().child("Categories")
              .child(mainCategory).child(restaurantCategory).push();
        }
        else {
          uploadImagesRef = FirebaseStorage.instance.ref()
              .child("Images").child(mainCategory);
          ref =FirebaseDatabase.instance.reference().child("Categories")
              .child(mainCategory).push();
        }
        ref.set(uploadedData);
        ref.child("location").child("latitude").set(first.coordinates.latitude);
        ref.child("location").child("longitude").set(first.coordinates.longitude);
        for (int i=0;i<photosList.length;i++){
          uploadTask = uploadImagesRef.child(infoControllersList[0].text.toString())
              .child("image"+i.toString()).putFile(await photosList[i]);
          ref.child("image"+i.toString())
              .set(await ((await uploadTask.onComplete).ref.getDownloadURL()));
        }
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pushNamed(context,'/CategoryHome');
        print("submitted");
      }
    }
    else if (photosList.isEmpty){
      snackBarKey.currentState.showSnackBar(SnackBar(content: Text("Please Add at Least one Photo"),));
    }
    else{
      snackBarKey.currentState.showSnackBar(SnackBar(content: Text("Name of the Place is required"),));
    }
  }
  PageController pageViewController =new PageController();
  int selectedPageInPageView =0;
  void onPageChanged (int changedPage){
    setState(() {
      selectedPageInPageView=changedPage;
    });
  }
  void leftArrow (){
    if(selectedPageInPageView>0)
      pageViewController.jumpToPage(selectedPageInPageView-1);
  }
  void rightArrow (){
    if (selectedPageInPageView<photosList.length-1)
      pageViewController.jumpToPage(selectedPageInPageView+1);
  }
  String mainCategory ="Main Category";
  String restaurantCategory ="";
  List<String>namesOfThePlaces=new List();
  @override
  void initState() {
    _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

    setState(() {
      mainCategory=GlobalState.ourInstance.getValue("MainCategory");
      restaurantCategory=(GlobalState.ourInstance.getValue("RestaurantCategory")!=null)
          ?GlobalState.ourInstance.getValue("RestaurantCategory")
          :"";

    });
    namesOfThePlaces=GlobalState.ourInstance.getValue("namesOfThePlaces");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: snackBarKey,
      body: new Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/backgraound.jpg'),
                  fit: BoxFit.cover
              ),
            ),
          ),
          Center(
              child: Container(
                margin: EdgeInsets.only(right: 20,left: 20,top: 50),
                child: new SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Center(
                          child: new Text(
                            "Add New "+mainCategory,
                            style:TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ) ,
                          ),
                        ),
                      ),
                      new Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(top: 25),
                              child: GestureDetector(
                                onTap: leftArrow,
                                child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: new Icon(Icons.arrow_back_ios,color: Colors.white)
                                ),
                              )
                          ),
                          new Container(
                            width: 230,
                            height: 160,
                            child: (photosList.isEmpty)
                                ?new Container(
                              child: Center(
                                child: new Image.asset("assets/images/default_image_category.png"),
                              ),
                            )
                                :PageView.builder(
                              itemBuilder: (BuildContext context ,int position){
                                return showImage(position);
                              },itemCount: photosList.length,
                              controller:pageViewController ,
                              onPageChanged: (int changedPage)=> onPageChanged(changedPage),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 25),
                            child: GestureDetector(
                              onTap: rightArrow,
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: new Icon(Icons.arrow_forward_ios,color: Colors.white)
                              ),
                            )
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10,bottom: 10),
                        height: 50,
                        padding: EdgeInsets.symmetric( horizontal: 100),
                        child: new RaisedButton(
                          onPressed: ()=>pickImageFromGallery(ImageSource.gallery),
                          shape: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                          child: Text("Add photos",style: TextStyle(
                            color: Color(0xFF6A1B9A),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          ),
                        ),
                      ),
                      (photosList.isEmpty)
                      ?Container()
                      :Container(
                          margin: EdgeInsets.only(bottom: 10),
                          height: 50,
                          padding: EdgeInsets.symmetric( horizontal: 80),
                          child: new RaisedButton(
                          onPressed: deleteThisPhoto,
                          shape: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                          child: Text("Delete this photo",style: TextStyle(
                            color: Color(0xFF6A1B9A),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          ),
                        ),
                      ),
                      Container(
                        width: 300,
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 70,
                              margin: EdgeInsets.only(bottom: 7),
                              child: 
                              TextField(
                                onTap: lolo,
//                                onSubmitted: onNameSubmitted,
                                controller: infoControllersList[0],
                                decoration: InputDecoration(
                                    filled: true,
                                    focusColor: Colors.white,
                                    focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                                    fillColor: Colors.white,
                                    labelText: infoList[0],
                                    labelStyle: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color:Color(0xFF6A1B9A)))),
                              ),

                            ),
                            Text(addressDetails,
                              style: TextStyle(
                                  color: (addressDetails=="Please Enter The Exact Name in Google Map")?Colors.red:Colors.white),
                            ),
                            Container(
                              height: 50,
                              margin: EdgeInsets.only(top: 10),
                              child: TextField(
//                                onTap: (addressDetails=="")?()=>onNameSubmitted(infoControllersList[0].text):(){},
                                controller: infoControllersList[1],
                                decoration: InputDecoration(
                                    filled: true,
                                    focusColor: Colors.white,
                                    focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                                    fillColor: Colors.white,
                                    labelText: infoList[1],
                                    labelStyle: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color:Color(0xFF6A1B9A)))),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(errorsInfoList[0],style: TextStyle(color: Colors.red,fontSize: 10),),
                              ],
                            ),

                            Container(
                              height: 50,
                              child: TextField(
//                                onTap: (addressDetails=="")?()=>onNameSubmitted(infoControllersList[0].text):(){},
                                controller: infoControllersList[2],
                                decoration: InputDecoration(
                                    filled: true,
                                    focusColor: Colors.white,
                                    focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                                    fillColor: Colors.white,
                                    labelText: infoList[2],
                                    labelStyle: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54)
                                    ,
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color:Color(0xFF6A1B9A)))),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(errorsInfoList[1],style: TextStyle(color: Colors.red,fontSize: 10),),
                              ],
                            ),
                            Container(
                              height: 50,
                              child: TextField(
//                                onTap: (addressDetails=="")?()=>onNameSubmitted(infoControllersList[0].text):(){},
                                controller: infoControllersList[3],
                                decoration: InputDecoration(
                                    filled: true,
                                    focusColor: Colors.white,
                                    focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                                    fillColor: Colors.white,
                                    labelText: infoList[3],
                                    labelStyle: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color:Color(0xFF6A1B9A)))),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(errorsInfoList[2],style: TextStyle(color: Colors.red,fontSize: 10),),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              height: 50,
                              padding: EdgeInsets.symmetric( horizontal: 100),
                              child: new RaisedButton(
                                onPressed: submit,
                                shape: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                                child: Text("Submit",style: TextStyle(
                                    color: Color(0xFF6A1B9A),
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat'
                                ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              )
          ),
        ],
      ),
    );
  }
  Future lolo () async {
    Prediction p = await PlacesAutocomplete.show(
        context: context, apiKey: kGoogleApiKey,mode: Mode.overlay, language: "fr",
        components: [new Component(Component.country, "fr")]);
    displayPrediction(p);
  }
  void onNameSubmitted (String m){
    setState(() {
      addressDetails="Loading address from Google Map...";
      first=null;
    });
    Geocoder.local.findAddressesFromQuery(m).then((address){
      setState(() {
        first = address.first;
      });
      print(first.addressLine);
      print("${first.featureName} : ${first.coordinates}");
      setState(() {
        addressDetails=first.addressLine;
      });
    }).whenComplete((){
      if (addressDetails==""||addressDetails=="Loading address from Google Map..."){
        setState(() {
          addressDetails="Please Enter The Exact Name in Google Map";
        });
      }
    });
  }
  Future<Null> displayPrediction(Prediction p) async {
//    print(p.description);
    if (p!=null&&namesOfThePlaces.contains(p.description)){
      snackBarKey.currentState.showSnackBar(SnackBar(
        content: Text("This Place is already exist"),
      ));
    }
    else if (p != null) {
      setState(() {
        infoControllersList[0].text=p.description;
        addressDetails="Loading address from Google Map...";
      });
      Geocoder.local.findAddressesFromQuery(p.description).then((address){
        setState(() {
          first = address.first;
        });
        print(first.addressLine);
        print("${first.featureName} : ${first.coordinates}");
        setState(() {
          addressDetails=first.addressLine;
        });
      }).whenComplete((){
        if (addressDetails==""||addressDetails=="Loading address from Google Map..."){
          setState(() {
            addressDetails="Please Enter The Exact Name in Google Map";
          });
        }
      });
    }
  }
}
