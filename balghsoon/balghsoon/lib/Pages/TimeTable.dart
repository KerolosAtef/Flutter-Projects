import 'package:balghsoon/Data/AppData.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
class TimeTable extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TimeTableState();
  }

}
class TimeTableState extends State<TimeTable> {
  List<List<String>>data =new List();
  List<String>filterBy =["جميع الاقسام",
    "قسم العظام","قسم النساء والولادة","قسم العيون","قسم الاوعية الدموية",
    "الاشعة","الطوارئ","المختبر","الصيدلية","قسم الباطنة والصدرية","قسم الجلدية والتجميل",
    "قسم الأسنان","قسم الأطفال",
  ];
  List<String> urls =[
    "",
    "http://balghsoonclinics.com/%D9%82%D8%B3%D9%85-%D8%A7%D9%84%D8%B9%D8%B8%D8%A7%D9%85/",
    "http://balghsoonclinics.com/%D9%82%D8%B3%D9%85-%D8%A7%D9%84%D9%86%D8%B3%D8%A7%D8%A1-%D9%88%D8%A7%D9%84%D9%88%D9%84%D8%A7%D8%AF%D8%A9/",
    "http://balghsoonclinics.com/%D9%82%D8%B3%D9%85-%D8%A7%D9%84%D8%B9%D9%8A%D9%88%D9%86/",
    "",
    "http://balghsoonclinics.com/%D8%A7%D9%84%D8%A3%D8%B4%D8%B9%D8%A9/",
    "",
    "http://balghsoonclinics.com/%D8%A7%D9%84%D9%85%D8%AE%D8%AA%D8%A8%D8%B1/",
    "",
    "http://balghsoonclinics.com/%D9%82%D8%B3%D9%85-%D8%A7%D9%84%D8%A8%D8%A7%D8%B7%D9%86%D9%8A%D8%A9-%D9%88%D8%A7%D9%84%D8%B5%D8%AF%D8%B1%D9%8A%D8%A9/",
    "http://balghsoonclinics.com/%D9%82%D8%B3%D9%85-%D8%A7%D9%84%D8%AC%D9%84%D8%AF%D9%8A%D8%A9-%D9%88%D8%A7%D9%84%D8%AA%D8%AC%D9%85%D9%8A%D9%84/",
    "http://balghsoonclinics.com/%D9%82%D8%B3%D9%85-%D8%A7%D9%84%D8%A7%D8%B3%D9%86%D8%A7%D9%86/",
    "http://balghsoonclinics.com/%D9%82%D8%B3%D9%85-%D8%A7%D9%84%D8%A3%D8%B7%D9%81%D8%A7%D9%84/",
  ];
  void launchUrl(String link) async {
    print(link);
    if (link.isEmpty){
      snackBarKey.currentState.showSnackBar(
        SnackBar(
          content: Text("No Page attached"),
          duration: Duration(seconds: 2),
        ),
      );
    }
    else if (await canLaunch(link)) {
      print("koko");
      await launch(link);
    } else {

      snackBarKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Link is Wrong and can't be Launched"),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
  List<Color> colors = [
    Color(0xffff0000),Color(0xff756e76),Color(0xffaaae8f),
    Color(0xff6d4c41), Color(0xffff0000), Color(0xffaec8bd),
    Color(0xffff0000),Color(0xffc4a3be), Color(0xffff0000),
    Color(0xff5b596f),Color(0xff9fa1b5),Color(0xffdba1a0),Color(0xfff48fb1),];
  Map<String,Color> mColors =new Map();
  Map<String,String> links =new Map();

  int selectedFilterItem=0;
  List<DropdownMenuItem>filterByItems =[];
  void filterByFillItems (){
    for (int i=0;i<filterBy.length;i++) {
      setState(() {
        filterByItems.add(new DropdownMenuItem(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              new Text(filterBy[i],
//                  textAlign: TextAlign.end
              )
            ],
          ), value: i,
        ),
        );
      });
    }
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
  void fillColorsMap (){
    for(int i=0;i<filterBy.length;i++){
      setState(() {
        mColors[filterBy[i]]=colors[i];
      });
    }
  }
  void fillLinksMap (){
    for(int i=0;i<filterBy.length;i++){
      setState(() {
        links[filterBy[i]]=urls[i];
      });
    }
  }
  void onSelectFilterItem (int selectedValue){
    setState(() {
      selectedFilterItem=selectedValue;
      data=AppData.timeTableData;
    });
    if (selectedValue==0){
      setState(() {
        data=AppData.timeTableData;
      });

    }else {
      setState(() {
        data=data.where((mlist){
          return mlist[1]==filterBy[selectedValue];
        }).toList();
      });
    }
  }

  @override
  void initState() {
    filterByFillItems();
    fillColorsMap();
    fillLinksMap();
    setState(() {
      data=AppData.timeTableData;
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
    else if (position==3){
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
    return Scaffold (
      key: snackBarKey,
      appBar: AppBar(
        title: Center(child: Text("جدول المواعيد",style: TextStyle(color: Colors.white),),)
      ),
      endDrawer: new Drawer(
        child: myDrawer(),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 50,vertical: 10),
//              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color:Colors.white),
              child: DropdownButton(isExpanded: true,items: filterByItems, onChanged: (value){
                onSelectFilterItem(value);
              },value: selectedFilterItem,style:
              TextStyle(color: Colors.black)),
            ),
            Flexible(
              child: ListView.builder(
                itemBuilder: (BuildContext context , int position){
                  return Column(
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          (position!=0 && data[position-1][0]==data[position][0])
                              ?Container()
                              : Container(
                            margin: EdgeInsets.symmetric(horizontal: 50),
                            child:Text(data[position][0]),),
                        ],
                      ),
                      GestureDetector(
                        onTap: ()=>launchUrl(links[data[position][1]]),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 50,vertical: 10),
                          color: mColors[data[position][1]],
                          child: Column(
                            children: <Widget>[
                              Text(data[position][1],style: TextStyle(color: Colors.white),),
                              Text(data[position][2],style: TextStyle(color: Colors.white)),
                              Text(data[position][3],style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                },
                itemCount: data.length,),
            ),
          ],
        )
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