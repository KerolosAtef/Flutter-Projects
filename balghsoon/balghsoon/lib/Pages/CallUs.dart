import 'package:balghsoon/Data/AppData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CallUs extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CallUsState();
  }

}
class CallUsState extends State <CallUs> {
  GoogleMapController mapController;
  Set<Marker> myMarkers =new Set();
  List<TextEditingController> _listControllers =[
    new TextEditingController(),new TextEditingController(),new TextEditingController(),
    new TextEditingController(),
  ];
  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
      myMarkers.add(Marker(markerId:MarkerId("1"),position: LatLng(21.4981887,39.2125601),infoWindow: InfoWindow(title: "عيادات بلغصون")));
    });
  }
  Future submit () async {
    final Email email = Email(
      body:_listControllers[3].text,
      subject: _listControllers[2].text,
      recipients: ['info@balghsoonclinics.com'],
//      cc: ['cc@example.com'],
//      bcc: ['bcc@example.com'],
    );

    await FlutterEmailSender.send(email);
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
    else if (position==6){
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
    return new Scaffold(
      key:snackBarKey,
      appBar: AppBar(
        title: Center(child: Text("اتصل بنا",style: TextStyle(color: Colors.white),),),
      ),
      endDrawer: Drawer(
        child:myDrawer(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 250,
              margin: EdgeInsets.only(left: 20,right: 20,top: 10),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(target: LatLng(21.4981887, 39.2125601),zoom: 15.0),
                onMapCreated:onMapCreated ,
                myLocationEnabled: true,
                compassEnabled: true,
                zoomGesturesEnabled: true,
                rotateGesturesEnabled: true,
                myLocationButtonEnabled: true,
                markers: myMarkers,
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(25),
              decoration: BoxDecoration(
//                  borderRadius: BorderRadius.circular(20),
                  border:Border.all(color: Colors.black,width: 2)),
              child: Column(
                children: <Widget>[
                  Text("تواصل معنا",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10,top: 10),
                    height: 40,
                    child: TextField(
                      controller: _listControllers[0],
                      textAlign: TextAlign.end,
                      decoration: InputDecoration(
                          hintText: "الاسم",
                          border: OutlineInputBorder(borderSide: BorderSide(width: 1,))
                      ),
                    ),
                  ),
//                  Container(
//                    margin: EdgeInsets.only(bottom: 10),
//                    height: 40,
//                    child: TextField(
//                      controller: _listControllers[1],
//                      textAlign: TextAlign.end,
//                      decoration: InputDecoration(
//                          hintText: "بريدك الالكتروني",
//                          border: OutlineInputBorder(borderSide: BorderSide(width: 1,))
//                      ),
//                    ),
//                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    height: 40,
                    child: TextField(
                      controller: _listControllers[2],
                      textAlign: TextAlign.end,
                      decoration: InputDecoration(
                          hintText: "الموضوع",
                          border: OutlineInputBorder(borderSide: BorderSide(width: 1,))
                      ),
                    ),
                  ),
                  Container(
                    child: TextField(
                      controller: _listControllers[3],
                      textAlign: TextAlign.end,
                      decoration: InputDecoration(
                          hintText: "... اكتب رسالتك ",
                          border: OutlineInputBorder(borderSide: BorderSide(width: 1,)),
                      ),
                      maxLines: 10,
                      minLines: 5,
                    ),
                  ),
                  Container(
                    width: 400,
                    child: RaisedButton(
                      onPressed: submit,
                      child: Text("submit"),
                      color: Color(0xff45b0d4),
                      textColor: Colors.white,
                    ),
                  )

                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 15,bottom: 20),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      new Text("العنوان"),
                      Icon(Icons.location_on,color: Color(0xff5a8698),),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      new Text("جدة / حي الفيحاء – خلف قاعة الملكة",style: TextStyle(color: Color(0xff469abc)),),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      new Text("الجوال"),
                      Icon(Icons.phone,color: Color(0xff5a8698),),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      new Text("920012865 – 0562010200",style: TextStyle(color: Color(0xff469abc)),),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      new Text("البريد الالكتروني"),
                      Icon(Icons.email,color: Color(0xff5a8698),),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      new Text("info@balghsoonclinics.com",style: TextStyle(color: Color(0xff469abc)),),
                    ],
                  ),

                ],
              ),
            ),
          ],
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