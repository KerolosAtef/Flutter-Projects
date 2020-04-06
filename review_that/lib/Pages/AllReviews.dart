import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../GlobalState.dart';
class AllReviews extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AllReviewsState();
  }

}
class AllReviewsState extends State<AllReviews>{
  List<Map<String,dynamic>> myData =new List();
//  double averageRating =1000.00;
  void getData (Event e){
    Map<String,dynamic> mp = new Map();
    mp["name"]=e.snapshot.value["name"];
    mp["rating"]=e.snapshot.value["rating"];
//    if (averageRating==1000.00){
//      setState(() {
//        averageRating=e.snapshot.value["rating"]*1.0;
//      });
//    }
//    else{
//      setState(() {
//        averageRating=(averageRating+e.snapshot.value["rating"])/2;
//      });
//    }
//    ref2.set(averageRating);
    mp["textReview"]=e.snapshot.value["textReview"];
    setState(() {
      myData.add(mp);
    });
  }
  String mainCategory,restaurantCategory ="",nameOfSelectedItem="",keyOfSelectedItem="";
  var ref,ref2 ;

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
    if (mainCategory=="Restaurant") {
      ref=FirebaseDatabase.instance.reference()
          .child("Categories").child(mainCategory).child(restaurantCategory)
          .child(keyOfSelectedItem).child("Reviews");
      ref2=FirebaseDatabase.instance.reference()
          .child("Categories").child(mainCategory).child(restaurantCategory)
          .child(keyOfSelectedItem).child("rating");
    }
    else{
      ref=FirebaseDatabase.instance.reference().child("Categories")
          .child(mainCategory).child(keyOfSelectedItem).child("Reviews");
      ref2=FirebaseDatabase.instance.reference().child("Categories")
          .child(mainCategory).child(keyOfSelectedItem).child("rating");
    }


    ref.onChildAdded.listen(getData);

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        child: new Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/backgraound.jpg'),
                  fit: BoxFit.cover
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 50,bottom: 20,left: 10,right: 10),
                    child: Text(nameOfSelectedItem,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemBuilder: (BuildContext context ,int position){
                      return new Container(
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            border: Border.all(width: 3,color: Color(0xffaaa4be)),
                            borderRadius: BorderRadius.circular(20),
                            color: Color(0xffaaa4be),
                          ),
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                title: Text(myData[position]["name"],
                                  style: TextStyle(fontSize: 20),
                                ),
                                subtitle: RatingBarIndicator(
                                  itemCount:5 ,
                                  itemSize: 10,
                                  rating: myData[position]["rating"]*1.0,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Flexible(
                                      child:Container(
                                        padding: EdgeInsets.all(12),
                                        child: Text(myData[position]["textReview"],
                                          style: TextStyle(
                                              fontSize: 20
                                          ),
                                          softWrap: true,
                                        ),
                                      )
                                  ),
                                ],
                              ),
                            ],
                          )
                      );
                    },itemCount: myData.length,
                  ),
                ),
              ],
            ),
          ),
        ),
        onWillPop: onBackButtonPressed,
    );
  }
   Future <bool> onBackButtonPressed(){
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pushNamed(context, '/CategoryDetalis');
  }

}