import 'package:flutter/material.dart';
import 'package:esbetalia/GlobalState.dart';
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
    "أنا محتاج لمسة روحك",
    "إحسانك فاق الأوصاف",
    "ادنو اليك",
    "الظلمة لديك",
    "انا اناء اسود",
    "انا شاعر بيك",
    "بعين متحننة",
    "بقدم نفسي ذبيحة",
    "جايين يا ابانا",
    "ربي راعي و سلامي",
    "عارفك مش قادر ترتاح",
    "عايشيين معاك في الهنا",
    "غيرت حياتي",
    "قربني ليك",
    "لسه بتقبلنا",
    "لم تر عين",
    "لما تيجي يا الهنا",
    "لما يسوع بيكون موجود",
    "لمسة شفاء",
    "ليت سلامك",
    "مهما ضعفي امتلكني",
    "هل جلست في هدوء",
    "هيستجيب",
    "وحدك يا يسوع وليس سواك",
    "وفيما اظنه لا يستجيب",
    "يا خالق الأكوان والناس",
    "يا من بحضوره",
    "ياللي عديت الشعب",
    "",
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: new Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/background.png')
                ,fit: BoxFit.cover)
        ),
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              height: 130,
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
            Container(
              width: 1000,
              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
              color: Color(0xff423d2a),
              child: Text("Tranem El Mo2tmr",textAlign: TextAlign.start,style: TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),),
            ),
            Expanded(
              child:  new ListView.builder(
                itemBuilder:(BuildContext context,int position)=>
                Column(
                  children: <Widget>[
                    new ListTile(
                      onTap: ()=>onItemListViewClicked(position),
                      title: new Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          new Text(names[position],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                            ),),
                          Padding(padding: EdgeInsets.only(left: 20),),
                          new Image.asset('assets/icons/tranim.png',width: 40,height: 40,),
                        ],
                      ),

                    ),
                    Container(
                      color: Colors.white,
                      height: 1,
                      margin: EdgeInsets.symmetric(horizontal: 15),
                    ),
                  ],
                ),
                itemCount: names.length,
                padding: EdgeInsets.only(top: 0),
              ),
            ),
          ],
        )
      )
    );
  }

}