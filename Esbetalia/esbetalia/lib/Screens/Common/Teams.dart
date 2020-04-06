import 'package:flutter/material.dart';
class Teams extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new TeamsState();
  }

}
class TeamsState extends State<Teams> {
  List<String>teamsNumbers= ["Team 1","Team 2","Team 3","Team 4","Team 5","Team 6",];
  List<dynamic>teamsColors =[
    Color(0xff2bd8ff),Color(0xff00b61e),Color(0xff2c2c2c),
    Color(0xff000cb8), Color(0xffc00000),Color(0xffd1d100)
  ];
  List<String> teamsNames =[
    "Manny George\nMarina Mekhaeil\nMarina Gorge \nMarina Maya\nSandra Samir\nSara Essam\nSherry Magdy\nMonica Nabil\nBishoy fahmy\nArsany ashraf\nMikhail ghaleb\nFady George\nFady shawky\nMina Gerges\n",
    "Marian Magdy\nMarina Wageh\nRanda Ramsy\nLydia Sameh\nRemon Makram\nKirolos Wassef\nAndrew Adel\nFady Wagdy\nRamez Heshmat\nBishoy Saed\nBishoy Raafat\nPeter Bassem\nGeorge Mansour\nPhilo Amir\n",
    "Demiana Samir\nDolagy Wagdy\nMarina Ibrahim\nMonika Raafat\nMarianne Magdy\nHaidy Khairy\nMarcos Ayad\nShady Ashraf\nMark Fekry\nMarco Maher\nArsani Botros\nGorge Mamdouh\nYousef Nazer\nAdrew Rizk\nMina Nagi\nAbanoub Magdy\nMichael Nabil\nEng Emil\nMark Magdy\nPeter Sami\nSamer Emad\n",
    "Nervana Issac\nChristina Ihab\nMarina Farid\nEng Aml\nArsani Ramzi\nMark Raouf\nMina milad\nPoula Louis\nMax Makram\nMina Girgis\nMina Hold\nMina Farid\nMilad William\nOsama Mored\nSerolos Saead\nIbraam Amir\n",
    "Donna Samir\nNervana Nabil\nChristina samy\nMonika Hani\nBatreca Nabil\nChristina Ebrahim\nMartina Ibrahim\nAndrew Maher\nDimas Nabil\nJohn Samy\nJohn Farag\nDavid Helmy\nAbanoub zaki\nMario safwat\n",
    "Monica Abouna\nMaureen Fekry\nDiana Ragai\nMira magdy\nPaula nabil\nBishoy abouna\nMaged Raid\nMina Tal3at\nMicheal Maged\nBishoy Samy\nKirolos Atef\nMina Latif\nPaula aboud\nMicheal Rizk\nMina Wagih\neng / bassem\n"
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
                padding: EdgeInsets.only(left: 15,right: 15),
                gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  childAspectRatio: .3,//change the height of each element
                  crossAxisSpacing: 15,
                ) ,
                itemBuilder: (BuildContext context,int position)=>
                new Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: teamsColors[position],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,

                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset("assets/icons/teams.png",width: 22,height: 22,),
                          Padding(padding: EdgeInsets.only(left: 7),),
                          Stack(
                            children: <Widget>[
                              Text(teamsNumbers[position],
                                style: TextStyle(
                                    fontSize: 25,
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 2
                                    ..color = Color(0xff707072),
                                ),
                              ),
                              Text(teamsNumbers[position],
                                style: TextStyle(color: Color(0xfffff5cc),
                                  fontSize: 25,
                                ),
                              )
                            ],
                          ),

                        ],
                      ),
                      Expanded(
                        child: Text(teamsNames[position],
                          style: TextStyle(color: Color(0xffffffff),

                              fontSize: 20,
//                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                itemCount: teamsNames.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}