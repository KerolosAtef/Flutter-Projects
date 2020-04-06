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
    "Dimas Nabil\n" +
        "Andrew Maher\n" +
        "Andrew sawires\n" +
        "David Helmy\n" +
        "Andrew Alfy\n" +
        "Abanoub Zaki\n" +
        "Mario Safwat\n",
    "Bassem Gamil\n" +
        "Peter Essam\n" +
        "Peter Sameh\n" +
        "Maged Riad\n" +
        "Sameh mouris\n" +
        "Bishoy Magdy\n" +
        "John Samy\n",
    "Peter Bassem\n" +
        "Andrew Reda\n" +
        "Andrew Moheb\n" +
        "Andrew Adel\n" +
        "Kirolos Ezzat\n" +
        "Martin Maged\n",
    "Bishoy Fahmy \n" +
        "Arsany Ashraf \n" +
        "Fady George \n" +
        "Hedra Soliman \n" +
        "Mina Gerges \n" +
        "Samer Emad\n",
    "Talaat\n" +
        "Remon Adel\n" +
        "Karf\n" +
        "Magdy Samuel\n" +
        "Paula Nabil\n" +
        "Paula Arsany\n",
    "Kirolos Atef\n" +
        "Bishoy Samy\n" +
        "Mina Wagih \n" +
        "Mina Ayoub\n" +
        "Karim\n" +
        "Karam Gamil\n" +
        "Bassem Samir\n",
    "Marina George \n" +
        "Carolina Abdo\n" +
        "Manny\n" +
        "Shery Magdy\n" +
        "Sara Essam\n" +
        "Marina Maya\n" +
        "Marina Mekhaaeil\n",
    "Marianne Magdy \n" +
        "Clara Raef\n" +
        "Maria Atef\n" +
        "Marina Ibrahim\n" +
        "Monica Rafaat\n" +
        "Jessica Nashaat\n" +
        "Marian Magdy\n",
    "Mira Tawfik\n" +
        "Salomy Boshra\n" +
        "Ronica Nader\n" +
        "Christene Medhat\n" +
        "Nervana Nabil\n",
    "Maureen Fekry\n" +
        "Monica Magdy\n" +
        "Mira Maged\n" +
        "Merna Adel\n" +
        "Diana Ragae\n",
    "Maureen Fekry\n" +
        "Monica Magdy\n" +
        "Mira Maged\n" +
        "Merna Adel\n" +
        "Diana Ragae\n" +
        "Merna sabry\n",
    "Donna Samir \n" +
        "Christen Ibrahim\n" +
        "Sandra Samir\n" +
        "Martina Ibrahim\n",
    "Mina Nagy\n" +
        "Peter Samy\n" +
        "Kirolos Amin\n" +
        "Yousab Hani\n",
    "Shady Ashraf\n" +
        "Marcos Ayad\n" +
        "Mark Fekry\n" +
        "Marco Maher\n",
    "Amal Fayek\n" +
        "Emil Youhana\n"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("Rooms",style: TextStyle(color: Color.fromARGB(255, 25, 25, 25)),),
        backgroundColor: Color.fromARGB(255, 173, 129, 41),
      ),
      body: new Container(
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/black_background.png'),fit: BoxFit.cover)),
        child:new ListView.builder(
          itemBuilder: (BuildContext context,int position)=>
          new ListTile(
            title:new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new Stack(
                  children: <Widget>[
                    new Image.asset('assets/images/rooms.png',height: 250,width: 80,fit: BoxFit.fill,),
                    new Container(
                      margin: EdgeInsets.only(top: 125),
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(roomsNumbers[position]),
                    ),

                  ],
                ),
//                new Image.asset('assets/images/teams.png',height: 400,width: 100,fit: BoxFit.fill,),
              ],
            ),
            leading:new Text(roomsNames[position],
              style: TextStyle(
                color:Color.fromARGB(255, 173, 129, 41),
                fontSize: 18,
              ),
            ),
          ),
          itemCount: roomsNames.length,
        ),
      ),
    );
  }
}