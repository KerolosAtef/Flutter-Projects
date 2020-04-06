import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:review_that/GlobalState.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
class CategoryHome extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new CategoryHomeState();
  }
}
class CategoryHomeState extends State<CategoryHome> {
  TextEditingController searchTextField = TextEditingController();
  List<String>sortBy =["None",
    "Most Rated","Ascending","Descending"
  ];
  List<String>filterBy =["None",
    "One Star","Two Star","Three Star","Four Star","Five Star"
  ];
  List<String> namesOfThePlaces =[];
  int selectedFilterItem=0,selectedSortItem =0;
  void onSelectFilterItem (int selectedValue){
    setState(() {
      selectedFilterItem=selectedValue;
      myData=orginalMyData;
    });
    if (selectedValue==0){
      setState(() {
        myData=orginalMyData;
      });
      
    }else if (selectedValue==1){
      setState(() {
        myData=myData.where((m) => m['rating']>0 && m["rating"]<=1).toList();
      });

    }else if (selectedValue==2){
      setState(() {
        myData=myData.where((m) => m['rating']>1 && m["rating"]<=2).toList();
      });

    }else if (selectedValue==3){
      setState(() {
        myData=myData.where((m) => m['rating']>2 && m["rating"]<=3).toList();
      });

    }else if (selectedValue==4){
      setState(() {
        myData=myData.where((m) => m['rating']>3 && m["rating"]<=4).toList();
      });

    }else if (selectedValue==5){
      setState(() {
        myData=myData.where((m) => m['rating']>4 && m["rating"]<=5).toList();
      });
    }

  }
  void onSelectSortItem (int selectedValue){
    setState(() {
      selectedSortItem=selectedValue;
      myData=orginalMyData;
    });
    if (selectedValue==0){
      setState(() {
        myData=orginalMyData;
      });
    }else if (selectedValue==1){
      myData.sort((m1,m2){
        int r = m1["rating"].compareTo(m2["rating"]);
        if (r>0)return 0;
        else return 1;
      });
    }
    else if (selectedValue==2){
      myData.sort((m1,m2){
        int r = m1["name"].compareTo(m2["name"]);
        if (r != 0) return r;
        return 0;
      });
    }
    else if (selectedValue==3){
      myData.sort((m1,m2){
        int r = m1["name"].compareTo(m2["name"]);
        if (r > 0) return 0;
        return 1;
      });
    }

  }
  void search (String searchText){
    setState(() {
      myData=orginalMyData;
    });
    if (searchText.isNotEmpty){
      print(searchText);
      setState(() {
        myData=myData.where((mp)=>mp["name"].contains(searchText)).toList();
      });
    }
  }
  List<Map> myData =new List();
  List<Map> orginalMyData =new List();

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
  List<DropdownMenuItem>sortByItems=[],filterByItems =[];
  void sortByFillItems (){
    for (int i=0;i<sortBy.length;i++) {
      setState(() {
        sortByItems.add(new DropdownMenuItem(child: new Text(sortBy[i]), value: i,));
      });
    }
  }
  void filterByFillItems (){
    for (int i=0;i<filterBy.length;i++) {
      setState(() {
        filterByItems.add(new DropdownMenuItem(child: new Text(filterBy[i]), value: i,),);
      });
    }
  }
  void addNewHotelDetails (){
    GlobalState.ourInstance.setValue("namesOfThePlaces", namesOfThePlaces);
    Navigator.pushNamed(context, '/AddNewCategory');
  }
  void goToCategoryDetalis (int position){
    // update topRated 
//    if (topRated!= mostRated){
//      mostRatedRef.child("most rated").set(topRated);
//    }
    GlobalState.ourInstance.setValue("nameOfSelectedItem", myData[position]["name"]);
    GlobalState.ourInstance.setValue("keyOfSelectedItem", myData[position]["key"]);
    Navigator.pushNamed(context, '/CategoryDetalis');
  }
  double  mostRated=0.0;
  void readMostRated (Event e){
    setState(() {
      mostRated=e.snapshot.value*1.0;
    });
  }
  double topRated =0;
  void getData (Event e){
    Map<String,dynamic> mp =new Map();
    for (int i=0;i<e.snapshot.value.length-5;i++){
      mp["image"+i.toString()]=e.snapshot.value["image0"];
    }
    mp["key"]=e.snapshot.key;
    mp["name"]=e.snapshot.value["name"];
    namesOfThePlaces.add(mp["name"]);
    mp["address"]=e.snapshot.value["address"];
    mp["facebookPage"]=e.snapshot.value["facebookPage"];
    mp["instgramPage"]=e.snapshot.value["instgramPage"];
    mp["rating"]=e.snapshot.value["rating"]*1.0;
    if (mp["rating"]> topRated){
      setState(() {
        topRated=mp["rating"];
      });
    }
    mp["twitterPage"]=e.snapshot.value["twitterPage"];
    setState(() {
      myData.add(mp);
      orginalMyData.add(mp);
    });
  }
  String mainCategory;
  String restaurantCategory ="";
  var mAuth =FirebaseAuth.instance ;
  var mostRatedRef ;
  @override
  void initState() {
    FirebaseDatabase.instance.setPersistenceEnabled(true);
    sortByFillItems();
    filterByFillItems();
    setState(() {
      mainCategory=GlobalState.ourInstance.getValue("MainCategory");
      restaurantCategory=(GlobalState.ourInstance.getValue("RestaurantCategory")!=null)
          ?GlobalState.ourInstance.getValue("RestaurantCategory")
          :"";
    });
    var ref ;
    if (mainCategory=="Restaurant") {
      ref=FirebaseDatabase.instance.reference()
          .child("Categories").child(mainCategory).child(restaurantCategory);
    }
    else{
      ref=FirebaseDatabase.instance.reference().child("Categories").child(mainCategory);
    }
    mostRatedRef=FirebaseDatabase.instance.reference()
        .child("notification").child(mainCategory);
    mostRatedRef.onChildAdded.listen(readMostRated);
    ref.onChildAdded.listen(getData);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: addNewHotelDetails,
        child: Icon(Icons.add),
        tooltip: "Add new Place",
      ),
      body: new Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/backgraound.jpg'),
              fit: BoxFit.cover
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 10,top: 40,bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
//                  new Image.asset(
//                    "assets/icons/notification.png",width: 40,height: 40,
//                  ),
                  new IconButton(icon: new Image.asset(
                    "assets/icons/logout.png",width: 40,height: 40,
                  ),
                    onPressed:logout,
                  ),

                ],
              ),
            ),
            new Container(
              margin: EdgeInsets.only(left: 20),
              child: new Row(
                children: <Widget>[
                  Text(mainCategory,style: TextStyle(
                    fontSize: 20.0,
                    fontWeight:FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                  ),
                  ),
                  Spacer(),
                  Container(
                    width: 180,
                    height: 40,
                    margin: EdgeInsets.only(right: 20),
                    child: TextField(
                      expands: false,
                      controller: searchTextField,
                      onChanged: search,
                      style: TextStyle(
                          color: Colors.white
                      ),
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.white),
                        suffixIcon: Icon(Icons.search,color: Colors.white,),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(30)),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30),borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(30)),
//                        hintText: "Search",
                      ),
                    ),
                  ),

                ],
              ),
            ),
            new SizedBox(height: 10,),
            new Container(
              margin: EdgeInsets.only(top: 20,left: 20,right: 20),
              child: new Row(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text("Sort By",style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),),
                      ),
                      Container(
                        height: 30,
                        width: 140,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color:Colors.white),
                        child: DropdownButton(isExpanded: true,items: sortByItems, onChanged: (value){
                          onSelectSortItem(value);
                        },
                          value: selectedSortItem,style: TextStyle(color: Colors.black),),
                      ),
                    ],
                  ),
                  Spacer(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Filter By",style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),),
                      Container(
                        height: 30,
                        width: 140,
                        margin: EdgeInsets.only(top: 10),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color:Colors.white),
                        child: DropdownButton(isExpanded: true,items: filterByItems, onChanged: (value){
                          onSelectFilterItem(value);
                        },value: selectedFilterItem,style: TextStyle(color: Colors.black),),
                      ),
                    ],
                  ),

                ],
              ),
            ),
            new Expanded(
                child:GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 2,mainAxisSpacing: 2,childAspectRatio: .9
                  )
                  , itemBuilder: (BuildContext context ,int position){
                  return new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          onTap: ()=>goToCategoryDetalis(position),
                          child: Column(
                            children: <Widget>[
                              (myData[position]["image0"]!=null)
                                  ?new CachedNetworkImage(
                                    imageUrl: myData[position]["image0"],
                                    height: 110,
                                    fit: BoxFit.contain,
                                    placeholder: (context, url) => CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                    )
                                  :new Image.asset("assets/images/default_image_category.png",width: 200,height: 110,),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child:  new Text((myData[position]["name"]!=null)
                                    ?myData[position]["name"]
                                    :"No name",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              RatingBarIndicator(
                                rating: (myData[position]["rating"]!=null)
                                    ?myData[position]["rating"]
                                    : 0.001,
                                itemCount: 5,
                                itemSize: 15.0,
                                itemBuilder: (context, index) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },itemCount: myData.length,
                )
            ),
          ],
        ),
      ),
    );
  }
}

