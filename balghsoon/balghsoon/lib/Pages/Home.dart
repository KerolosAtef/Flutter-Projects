import 'package:flutter/material.dart';
class Home extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }

}
class HomeState extends State<Home> {
  List<String> homeImages =[
    "assets/images/Home images/about_balghsoon_clinics.png","assets/images/Home images/know_your_doctor.png",
    "assets/images/Home images/departments.png", "assets/images/Home images/photos_gallery.png",
    "assets/images/Home images/last_news.png","assets/images/Home images/time_tables.png",
    "assets/images/Home images/call_us.png","assets/images/Home images/articles.png",];
  List<Color>backgroundColors =[
    Color(0xff00bbe8),Color(0xff00abd5),Color(0xff009ad8),
    Color(0xff0094c2),Color(0xff0078aa),Color(0xff007ea1),
    Color(0xff00688f),Color(0xff006c86),
  ];
  List<String>names=[
    "عن عيادات بلغصون","اعرف طبيبك","الاقسام","معرض الصور",
    "اخر الاخبار","جدول المواعيد","اتصل بنا","مقالات",
  ];
  List<String> navigate =[
    '/AboutBalghsoonClinics','/KnowYourDoctor','/Departments','/PhotosGallery',
    '/LastNews','/TimeTable','/CallUs','Articles',
  ];
  _onPressedBottomNavigationBar(int x) {
    switch (x) {
      case 0:
        Navigator.pushNamed(context, '/KnowYourDoctor');
        break;
      case 1:
        Navigator.pushNamed(context, '/Departments');
        break;
    }
  }
  List<int> nonAvailablePages =[3,4,7];
  var snackBarKey =GlobalKey<ScaffoldState>();
  void goTo (int position){
    if (nonAvailablePages.contains(position)){
      snackBarKey.currentState.showSnackBar(SnackBar(
        content: Text("Coming Soon in new updates"),
        duration: Duration(seconds: 2),
      ));
    }else {
      Navigator.pushNamed(context, navigate[position]);
    }

  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: snackBarKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(left: 15,right: 15,top: 30),
          child: Column(
            children: <Widget>[
              new Image.asset("assets/images/logo.png",height: 100,width: 100,),
              new Text("عيادات بلغصون",style: TextStyle(
                  fontSize: 25
              ),),
              new Text("Balghsoon's Polyclinics",style: TextStyle(
                  fontSize: 25
              ),),
              new Flexible(
                child: new GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                      crossAxisCount: 2,
                      childAspectRatio: 1.7
                  ),
                  itemBuilder: (BuildContext context ,int position){
                    return GestureDetector(
                        onTap: ()=>goTo(position),
                        child: Container(
                          decoration: BoxDecoration(
                              color: backgroundColors[position],
                              borderRadius: (position==0)?BorderRadius.only(
                                topLeft: Radius.circular(40),
                              ):(position==1)?BorderRadius.only(
                                topRight: Radius.circular(40),
                              ):(position==6)?BorderRadius.only(
                                bottomLeft:Radius.circular(40),
                              ):(position==7)?BorderRadius.only(
                                bottomRight: Radius.circular(40),
                              ):BorderRadius.only(
                              )

                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              new Image.asset(homeImages[position],height: 60,),
                              new Text(
                                names[position],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,

                                ),
                              ),
                            ],
                          ),
                        )
                    );
                  },
                  itemCount: homeImages.length,padding: EdgeInsets.only(top: 10),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
          // sets the background color of the `BottomNavigationBar`
            canvasColor: Colors.white,
            // sets the active color of the `BottomNavigationBar` if `Brightness` is light
            primaryColor: Color.fromARGB(255, 173, 129, 41),
            textTheme: Theme
                .of(context)
                .textTheme
                .copyWith(caption: new TextStyle(color: Color(0xff45b0d4)))),

        child:  new BottomNavigationBar(
          items: [
            new BottomNavigationBarItem(
                icon: new Image.asset('assets/images/bottom Navigation Bar/1.png',width: 30,height: 30,), title: new Text("اعرف طبيبك")),
            new BottomNavigationBarItem(
                icon: new Image.asset('assets/images/bottom Navigation Bar/2.png',width: 30,height: 30,), title: new Text("الاقسام")),
            new BottomNavigationBarItem(
                icon: new Image.asset('assets/images/bottom Navigation Bar/3.png',width: 30,height: 30,), title: new Text("الرئيسية")),
          ],
          onTap:_onPressedBottomNavigationBar,
          currentIndex: 2 ,
        ),
      ),
    );
  }
}