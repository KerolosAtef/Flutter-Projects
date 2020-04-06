import 'package:flutter/material.dart';
import 'package:balghsoon/Data/AppData.dart';
import 'package:balghsoon/GlobalState.dart';

class KnowYourDoctor extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new KnowYourDoctorState();
  }

}
class KnowYourDoctorState extends State<KnowYourDoctor> {
  void goToTimeDoctorInformation(int position){
    GlobalState.ourInstance.setValue("position", position);
    GlobalState.ourInstance.setValue("Gender", positions.contains(position));
    Navigator.pushNamed(context, '/DoctorsInformation');
  }
  _onPressedBottomNavigationBar(int x) {
    switch (x) {
      case 1:
        Navigator.pushNamed(context, '/Departments');
        break;
      case 2:
        Navigator.pushNamed(context, '/Home');
        break;
    }
  }
  List<int> positions =[1,4,10,12,16,17];


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
    else if (position==1){
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
      key:snackBarKey,
      appBar: AppBar(
        title: Center(child: Text("اعرف طبيبك",style: TextStyle(color: Colors.white),),),
      ),
      endDrawer: Drawer(
        child: myDrawer(),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context ,int position){
          return new ListTile(
            title: new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(AppData.knowYourDoctorTitles[position],
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
                new Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    new RaisedButton(
                      onPressed: ()=>goToTimeDoctorInformation(position),
                      child: Text("المزيد",style: TextStyle(fontSize: 18),),
                      shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),borderSide: BorderSide(color: Color(0xff45b0d4))),
                      color: Color(0xff45b0d4),textColor: Colors.white,
                    ),
                  ],
                )
              ],
            ),
            trailing: new Image.asset(
              (positions.contains(position))
                  ? AppData.knowYourDoctorImages[0]
                  :AppData.knowYourDoctorImages[1],
              width: 80,
              height: 80,
            ),
          );
        },itemCount: AppData.knowYourDoctorTitles.length,
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
          currentIndex: 0 ,
        ),
      ),

    );
  }

}