import 'package:flutter/material.dart';

import '../GlobalState.dart';
class Restaurant extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new RestaurantState();
  }
}
class RestaurantState extends State<Restaurant> {
  TextEditingController filterSearch = TextEditingController();
  List<String>restaurantCategories =[
    "Shawerma","Burger","Pizza","Pasta","Salad","Beverage","Breakfast","Asian"
    ,"Crep","Grills","Nuts","Mexican","International","Waffle","Indian","Seafood"
    ,"Fastfood","Healthy","Bakery","Desert"
  ];
  List<String>originalRestaurantCategories = new List();
  List<String>restaurantCategoriesIcons=[
    "assets/images/shawerma02.png","assets/images/burger03.png","assets/images/pizza04.png"
    ,"assets/images/pasta05.png","assets/images/salad06.png","assets/images/beverage07.png"
    ,"assets/images/breakfast08.png","assets/images/asian09.png","assets/images/crep10.png"
    ,"assets/images/grills11.png","assets/images/nuts12.png","assets/images/mexican13.png"
    ,"assets/images/international14.png","assets/images/waffle15.png","assets/images/indian16.png"
    ,"assets/images/seafood17.png","assets/images/fastfood18.png","assets/images/healthy19.png"
    ,"assets/images/bakery20.png","assets/images/desert21.png"
  ];
  void search (String searchText){
    setState(() {
      restaurantCategories=originalRestaurantCategories;
    });
    if (searchText.isNotEmpty){
      print(searchText);
      setState(() {
        restaurantCategories=restaurantCategories.where((s)=>s.contains(searchText)).toList();
      });
    }
  }
  void goToCategoryDetalis (int position){
    GlobalState.ourInstance.setValue("RestaurantCategory", restaurantCategories[position]);
    Navigator.pushNamed(context, '/CategoryHome');
  }
  @override
  void initState() {
    setState(() {
      originalRestaurantCategories=restaurantCategories;
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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
              padding: EdgeInsets.all(40),
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.end,
//                children: <Widget>[
//                  new Image.asset(
//                    "assets/icons/notification.png",width: 30,height: 30,
//                  ),
//                ],
//              ),
            ),
            new Container(
              margin: EdgeInsets.only(left: 10,right: 10),
              child: new Row(
                children: <Widget>[
                  Text("Restaurant",style: TextStyle(
                      fontSize: 25.0,
                      fontWeight:FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                  ),
                  ),
                  Spacer(),
                  Container(
                    width: 200,
                    height: 40,
                    child: TextField(
                      expands: false,
                      onChanged: search,
                      textCapitalization: TextCapitalization.words,
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
            new Expanded(
                child:GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,childAspectRatio: 1.4,
                  crossAxisSpacing: 2,mainAxisSpacing: 2
                  )
                  , itemBuilder: (BuildContext context ,int position){
                  return new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(top: 5),
                          color: Colors.white,
                          child: GestureDetector(
                            onTap: ()=>goToCategoryDetalis(position),
                            child: Column(
                              children: <Widget>[
                                Center(
                                  child: Image.asset(restaurantCategoriesIcons[position],
                                    width: 65,
                                    height: 65,
                                  ),
                                ),
                                new Expanded(
                                    child:new Text(restaurantCategories[position],
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },itemCount: restaurantCategories.length,
                )
            ),
          ],
        ),
      ),
    );
  }

}