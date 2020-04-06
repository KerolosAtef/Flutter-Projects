import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class Rooms extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new RoomsState();
  }

}
class RoomsState extends State<Rooms> {
  List<String>roomsNumbers= ["Room 1","Room 2","Room 3","Room 4","Room 5","Room 6",
    "Room 7","Room 8","Room 9","Room 10","Room 11","Room 12","Room 13","Room 14","Room 15"
  ];
  List<String> roomsNames =[
    "Kirolos Atef\nBishoy Samy\nMina Latif\nPoula Abod\nMichael Rezk\nMina Wagih",
    "Manny George\nSara Essam\nMarina George\nMarina Maya\nSandra Samir\nMarina Mekhaeil\nSherry Magdy\nMonica Nabil\n",
    "Donna Samir\nNervana Nabil\nChristina Samy\nMonika Hani\nBeatrice Nabil\nChristina Ebrahim\nMartina Ibrahim\n",
    "Demiana Samir\nDolagy Wagdy\nMarina Ibrahim\nMonika Raafat\nMarianne Magdy\nJessica Nashaat\nHaidy Khairy\n",
    "Nervana Issac\nChristina Ihab\nMarina Farid\nMarina Wageh\nRanda Rasmy\nMarian Magdy\nLydia Sameh\n",
    "Monica Abouna\nMaureen Fekry\nEng Aml\nDiana Ragai\n",
    "Bishoy Fahmy\nArsany Ashrf\nMikhail Ghaleb\nFady George\nMina Gerges\nFady Shawky\nMina Tal3at\nPaula nabil\n",
    "Peter Sami\nAndrew Rizk\nMicheal Nabil\nAbanoub Magdy\nMina Nagi\nYoussef Nazer\n",
    "Maged Raid\nBishoy Abouna\nMichael Maged\nEng Bassem\nEng Emil\n",
    "Marcos Ayad\nShady Ashraf\nMark Fekry\nMarco Maher\nArsani Botros\nGeorge Mamdouh\n",
    "Andrew Maher\nDimas Nabil\nAbanoub Zaki\nMario Safwat\nJohn Samy\nJohn Farag\nDavid Helmy\n",
    "Arsani Ramzi\nMark Raouf\nMina Milad\nPoula Louis\nMax Makram\nMina Girgis\nMina Hold\n",
    "Mina Farid\nMilad William\nSamer Emad\nKerolos Saead\nOsama Mored\nMark Magdy\nIbraam Amir\n",
    "Ramez Heshmat\nBishoy Saeed\nBishoy Raafat\nFady Wagdy\nRemon Makram\nGeorge Mansour\n",
    " Andrew adel\nKirolos Wassef\nPeter Bassem\nPhilo Amir\n",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/background.png')
                ,fit: BoxFit.cover)
        ),
        child:Column(
          children: <Widget>[
            Container(
              height: 150,
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: new Row(
                children: <Widget>[
                  GestureDetector(
                    child: new Image.asset("assets/images/back_arrow.png",width: 40,height: 40,),
                    onTap: ()=>Navigator.pop(context),
                  ),
                  Spacer(),
                  new Image.asset("assets/images/logo.png",height: 85,width: 85,),

                ],
              ),
            ),
            Expanded(
              child: new GridView.builder(
                padding: EdgeInsets.only(left: 30,right: 30),
                gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  childAspectRatio: .6,//change the height of each element
                  crossAxisSpacing: 22,
                ) ,
                itemBuilder: (BuildContext context,int position)=>
                new Container(
                  decoration: BoxDecoration(
                    color: Color(0xff928457),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,

                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset("assets/icons/rooms.png",width: 20,height: 20,),
                          Padding(padding:EdgeInsets.only(left: 7),),
                          Text(roomsNumbers[position],
                          style: TextStyle(color: Color(0xfffff5cc),fontSize: 25),)
                        ],
                      ),
                      Expanded(
                        child: Text(roomsNames[position],
                          style: TextStyle(color: Color(0xffffffff),
                              fontFamily: 'Stylus_Bt',
                              fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
                itemCount: roomsNames.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}