import 'package:balghsoon/Data/AppData.dart';
import 'package:flutter/material.dart';

import '../GlobalState.dart';
class DoctorsInformation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DoctorsInformationState();
  }

}
class DoctorsInformationState extends State<DoctorsInformation> {
  int position ;
  bool female ;
  void goToTimeTable (){
    Navigator.pushNamed(context, '/TimeTable');
  }
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
  @override
  void initState() {
    setState(() {
      position=GlobalState.ourInstance.getValue("position");
      female=GlobalState.ourInstance.getValue("Gender");
    });
    super.initState();
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
        title: Center(
          child: Text(
            AppData.knowYourDoctorTitles[position],
            style: TextStyle(color: Colors.white),
          ),
        )
      ),
      endDrawer: new Drawer(
        child: myDrawer(),
      ),
      body: SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.only(left: 20,right: 20,top: 20,),
            child: Column(
              children: <Widget>[
                new Image.asset(
                  (female)
                      ? AppData.knowYourDoctorImages[0]
                      :AppData.knowYourDoctorImages[1],
                  width: 150,
                  height: 150,
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child:  new Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Flexible(
                        child: Text(AppData.increaseInformationAboutDoctors[position],
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(AppData.knowYourDoctorDepartments[position],
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 15,),),
                        Row(
                          children: <Widget>[
                            Text(AppData.knowYourDoctorSpecialists[position],
                              textAlign: TextAlign.end,
                              style: TextStyle(fontSize: 15),),
                            Text(": التخصص ",
                              textAlign: TextAlign.end,
                              style: TextStyle(fontSize: 15,color: Color(0xff45b0d4)),),

                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      child:Text(AppData.knowYourDoctorDegree[position],
                        textAlign: TextAlign.end,
                        style: TextStyle(fontSize: 15),),

                    ),
                    Text(": الدرجة ",
                      textAlign: TextAlign.end,
                      style: TextStyle(fontSize: 15,color: Color(0xff45b0d4)),),
                  ],
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      child:Text(AppData.knowYourDoctorWorkDays[position],
                        textAlign: TextAlign.end,
                        style: TextStyle(fontSize: 15),),

                    ),
                    Text(": ايام العمل ",
                      textAlign: TextAlign.end,
                      style: TextStyle(fontSize: 15,color: Color(0xff45b0d4)),),
                  ],
                ),

                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    child: new RaisedButton(
                      onPressed: goToTimeTable,
                      child: Text("الجدول",style: TextStyle(fontSize: 18),),
                      shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),borderSide: BorderSide(color: Color(0xff45b0d4))),
                      color: Color(0xff45b0d4),textColor: Colors.white,
                    ),
                  )
                ),

              ],
            )
        ),
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
                icon: new Image.asset('assets/images/bottom Navigation Bar/1.png',width: 30,height: 30,), title: new Text("اعرف طبيبك",style: TextStyle(color: Color(0xff45b0d4),))),
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