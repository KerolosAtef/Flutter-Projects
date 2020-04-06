import 'package:flutter/material.dart';
import 'package:sh3lbony_app/GlobalState.dart';
class Tranem extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new TranemState();
  }

}
class TranemState extends State<Tranem> {
  GlobalState intent =GlobalState.getInstance();
  onItemListViewClicked (int position){
    intent.setValue("tarnemaName", names[position]);
    Navigator.pushNamed(context, '/TranemContent');
  }
  List<String> names =[
    "أحبك يا رب في خلوتي",
    "اني لرافع عيني",
    "الرب قريب لمن يدعوه",
    "الظلمة لديك لا تظلم",
    "انت تعلم كربتى",
    "بعين متحننة",
    "ربي راعي وسلامي",
    "انا شاعر بيك",
    "لا تخف لأني معك",
    "لا يكون ظلام",
    "مين أحن منك ألتجئ إليه",
    "نسجد لاسم الثالوث",
    "يا إلهي أعمق الحب هواك",
    "يا صاحب الحنان",
    "يا من بحضوره نفسي تطيب",
    "يارويني يايسوع بحنانك",
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        title: new Text("Tranem",style: TextStyle(color: Color.fromARGB(255, 25, 25, 25)),),
        backgroundColor: Color.fromARGB(255, 173, 129, 41),
      ),
      body: new Container(
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/black_background.png'),fit: BoxFit.cover)),
        padding: EdgeInsets.symmetric(vertical: 10),
        child: new ListView.builder(
            itemBuilder:(BuildContext context,int position)=> new ListTile(
              title: new Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  new Text(names[position],
                  style: TextStyle(
                    color: Color.fromARGB(255, 173, 129, 41),
                    fontSize: 18,
                  ),),
                ],
              ),
              leading: new Image.asset('assets/icons/music_icon.png',width: 40,height: 40,),
              onTap: ()=>onItemListViewClicked(position),
            ),
          itemCount: names.length,
        ),
      ),
    );
  }

}