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
    Colors.green,Colors.white,Colors.blue,Colors.red,Colors.yellow,Colors.purple
  ];
  List<String> teamsNames =[
    "Christina Ebrahim \n" +
        "Maureen Fekry \n" +
        "Donna Samir\n" +
        "David Helmy \n" +
        "Dimas Nabil \n" +
        "Andrew Maher\n" +
        "Andrew Alfy\n" +
        "John Samy\n" +
        "Andrew Sawires \n" +
        "Martin Maged\n" +
        "Abanoub Zaki\n" +
        "Mario Safwat\n",
    "Nervana Nabil\n" +
        "Salomy Boshra\n" +
        "Martina Ibrahim\n" +
        "Mira Tawfik \n" +
        "Amal Fayek\n" +
        "Mina Wagih\n" +
        "Remon Adel\n" +
        "Mina Talaat\n" +
        "Magdy Samuel\n" +
        "Karf Hany\n" +
        "Kirolos Atef\n" +
        "Emil Youhana\n" +
        "Bassem Samir\n",
    "Marina Ibrahim \n" +
        "Clara Raef\n" +
        "Monica Raafat\n" +
        "Maria Atef\n" +
        "Marianne Magdy\n" +
        "Jessica Nashaat\n" +
        "Youssab Hani\n" +
        "Mina Nagy\n" +
        "Peter Samy\n" +
        "Shady Ashraf\n" +
        "Kirolos Amin\n" +
        "Mark Fekry\n" +
        "Marcous Aiad\n" +
        "Marco Maher\n" +
        "Samer Emad\n",
    "Merna Adel\n" +
        "Merna Sabry\n" +
        "Diana Ragaie \n" +
        "Marian Magdy\n" +
        "Peter Essam\n" +
        "Bassem Gamil \n" +
        "Sameh Moris\n" +
        "Peter Sameh\n" +
        "Peter Bassem\n" +
        "Andrew Reda\n" +
        "Kirolos Ezzat\n" +
        "Andrew Adel\n" +
        "Andrew Moheb\n",
    "Monica Magdy \n" +
        "Ronica Nader\n" +
        "Christine Medhat\n" +
        "Mira Maged \n" +
        "Paula Nabil \n" +
        "Magdy Moheb\n" +
        "Paula Arsany\n" +
        "Maged Riad\n" +
        "Karam Gamil\n" +
        "Karim\n" +
        "Bishoy Samy\n" +
        "Mina Ayoub\n",
    "Marina george\n" +
        "Manny George \n" +
        "Sherry magdy \n" +
        "Sara Essam \n" +
        "Carolina Abdo\n" +
        "Sandra Samir\n" +
        "Marina Mikhail \n" +
        "Marina Maya\n" +
        "Hedra Soliman \n" +
        "Bishoy Fahmy\n" +
        "Arsany Ashraf \n" +
        "Fady George \n" +
        "Mina Gerges\n"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("Teams",style: TextStyle(color: Color.fromARGB(255, 25, 25, 25)),),
        backgroundColor: Color.fromARGB(255, 173, 129, 41),
      ),
//      backgroundColor: Color.fromARGB(255, 25, 25, 25),
      body: new Container(
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/black_background.png"),fit: BoxFit.cover)),
        child:new ListView.builder(
          itemBuilder: (BuildContext context,int position)=>
          new ListTile(
            title:new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new Stack(
                  children: <Widget>[
                    new Image.asset('assets/images/teams.png',height: 400,width: 100,fit: BoxFit.fill,),
                    new Container(
                      margin: EdgeInsets.only(top: 150),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(teamsNumbers[position],style: TextStyle(fontSize: 20,color: teamsColors[position]),),
                    ),

                  ],
                ),
//                new Image.asset('assets/images/teams.png',height: 400,width: 100,fit: BoxFit.fill,),
              ],
            ),
            leading:new Text(teamsNames[position],
              style: TextStyle(
                color:teamsColors[position],
                fontSize: 18,
              ),
            ),
          ),
          itemCount: teamsNames.length,
        ),
      ),
    );
  }
}