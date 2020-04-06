import 'package:balghsoon/Data/AppData.dart';
import 'package:flutter/material.dart';
class AboutBalghsoonClinics extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new AboutBalghsoonClinicsState ();
  }

}
class AboutBalghsoonClinicsState extends State<AboutBalghsoonClinics>{
  _onPressedBottomNavigationBar(int x) {
    switch (x) {
      case 0:
        Navigator.pushNamed(context, '/KnowYourDoctor');
        break;
      case 1:
        Navigator.pushNamed(context, '/Departments');
        break;
      case 2:
        Navigator.pushNamed(context, '/Home');
        break;
    }
  }

  List<String> drawerTitles =[
    "الرئيسية","اعرف طبيبك","الاقسام","الجدول","الاخبار",
    "العروض","اتصل بنا","عن عيادات بلغصون",
  ];
  List<String> drawerImages =[
    "assets/images/Drawer/1.png","assets/images/Drawer/2.png","assets/images/Drawer/3.png",
    "assets/images/Drawer/4.png","assets/images/Drawer/5.png","assets/images/Drawer/6.png",
    "assets/images/Drawer/7.png","assets/images/Drawer/8.png",
  ];
  List<int> nonAvailablePages =[4,5];
  List<String> navigate =[
    '/Home','/KnowYourDoctor','/Departments','/TimeTable',
    '/LastNews','/Offers','/CallUs','/AboutBalghsoonClinics',
  ];
  var snackBarKey =GlobalKey<ScaffoldState>();
  void navigateToPage (int position , BuildContext context) {
    if (nonAvailablePages.contains(position)){
      snackBarKey.currentState.showSnackBar(SnackBar(
        content: Text("Coming Soon in new updates"),
        duration: Duration(seconds: 2),
      ));
    }
    else if (position==7){
      Navigator.of(context).pop();
    }
    else {
      Navigator.pushReplacementNamed(context, navigate[position]);

    }

  }
  Widget myDrawer (){
    return ListView.builder(
      itemBuilder: (BuildContext context,int position){
        return (position==0)
            ?new Image.asset("assets/images/logo.png",height: 200,width: 200,)
            :new ListTile(
          onTap: ()=>navigateToPage(position-1,context),
          trailing: new Image.asset(drawerImages[position-1],width: 30,height: 30,),
          title: new Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment:  CrossAxisAlignment.end,
            children: <Widget>[
              Text(drawerTitles[position-1]),
            ],
          ),
        );
      },
      itemCount: drawerTitles.length+1,
    );
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      key: snackBarKey,
      appBar: AppBar(
        title: Center(child: Text("عن عيادات بلغصون",style: TextStyle(color: Colors.white),),),
      ),
      endDrawer: Drawer(
        child:myDrawer() ,
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context,int position){
          return(position==0)
              ?Center(
              child: Text("مرحبا بكم ف عيادات بلغصون",
                style: TextStyle(
                  fontSize: 25,)
                ,))
              :(position==1)
              ?Center(
            child: Text("تأسست هذه العيادات منذ عام 2002",
              style: TextStyle(
                fontSize: 25,
              ),),)
              :(position==2)
              ?Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Text("لم تكن البداية سهلة.. فقد كانت في عام 2002 م عندما تم اختيار موقع المجمع وبدا العمل فيه ومع سنوات من الجهد والتطور المتواصل بفضل الله اصبحنا مركزا متخصصا في الاسنان يضم حوالي 13 عيادة اسنان .. ومجمع طبي عام بجميع التخصصات الطبية ويعمل على مدار الساعة ( عيادات طب الاسنان العام -- عيادات تقويم الاسنان -- عيادة الباطنية والصدرية -- عيادة العيون -- عيادة النساء والولادة -- عيادة الاطفال -- عيادة العظام --عيادة الجلدية)",
              style: TextStyle(
                fontSize: 15,
              ),
              textAlign: TextAlign.end,
            ),
          )
              :(position==5)
              ?new Container(
              child: Center(
                child: Text("بعض خدماتنا",style: TextStyle(fontSize: 25),),
              )

          )
              :(position==9)
              ?Container(
              height: 50,
              decoration: BoxDecoration(color: Color(0xff45b0d4)),
              child: Center(
                child: Text("إذا كنت مريضًا يبحث عن رعاية صحية عالية الجودة بأسعار معقولة",
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold
                  ),
                ),
              )
          )
              :new ListTile(
            title: new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(AppData.aboutBalghsoonClinicsTitles[position-3],
                  textAlign: TextAlign.end,
                  style: TextStyle(fontSize: 25),
                ),
              ],
            ),
            subtitle: Column(
              children: <Widget>[
                new Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Flexible(
                      child:Text(AppData.aboutBalghsoonClinicsSubtitles[position-3],
                        textAlign: TextAlign.end,
                        style: TextStyle(fontSize: 15),),

                    ),
                  ],
                ),
              ],
            ),
            trailing: new Image.asset(AppData.aboutBalghsoonClinicsImages[position-3],width: 80,height: 80,),
          );
        },
        itemCount: AppData.aboutBalghsoonClinicsTitles.length+4,
      ),
      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
          // sets the background color of the `BottomNavigationBar`
            canvasColor: Colors.white,
            // sets the active color of the `BottomNavigationBar` if `Brightness` is light
            primaryColor: Color(0xff45b0d4),
            textTheme: Theme
                .of(context)
                .textTheme
                .copyWith(caption: new TextStyle(color: Color(0xff45b0d4)))),

        child:  new BottomNavigationBar(
          items: [
            new BottomNavigationBarItem(
                icon: new Image.asset('assets/images/bottom Navigation Bar/1.png',width: 30,height: 30,), title: new Text("اعرف طبيبك",style: TextStyle(color: Color(0xff45b0d4)),)),
            new BottomNavigationBarItem(
                icon: new Image.asset('assets/images/bottom Navigation Bar/2.png',width: 30,height: 30,), title: new Text("الاقسام")),
            new BottomNavigationBarItem(
                icon: new Image.asset('assets/images/bottom Navigation Bar/3.png',width: 30,height: 30,), title: new Text("الرئيسية")),
          ],
          onTap:_onPressedBottomNavigationBar,
        ),
      ),
    );
  }
}