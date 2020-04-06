import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:stamp/AppCommon.dart';
import 'package:stamp/AppCommon.dart' as prefix0;
import 'package:stamp/GlobalState.dart';
import 'package:vibration/vibration.dart';
class QRReader extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return QRReaderState ();
  }

}
class QRReaderState extends State <QRReader> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController controller;
  String placeId,offerName,userId,scanResult="";
  void analysisQRCode (String qrText){
    placeId=qrText.substring(0,28);
    offerName=qrText.substring(28);
//    print(qrText);
//    print(placeId);
//    print(offerName);

    userId=GlobalState.ourInstance.getValue("userId");
    // add offer to my offers
    AppCommon.databaseReference.child("UserData").child(userId).child("my offers")
        .child(placeId).child(offerName).once().then((snapshot){
          if (snapshot.value != null){
            AppCommon.databaseReference.child("UserData").child(userId).child("my offers")
                .child(placeId).child(offerName).set(snapshot.value+1);
          }
          else {
            AppCommon.databaseReference.child("UserData").child(userId).child("my offers")
                .child(placeId).child(offerName).set(1);
          }

    });
    //check total
    AppCommon.databaseReference.child("UserData").child(userId).child("Total offers")
        .once().then((snapshot){
          if (snapshot.value!=null && snapshot.value ==9){
            // get your offer
            AppCommon.databaseReference.child("UserData").child(userId).child("Total offers")
                .set(snapshot.value+1);
            GlobalState.ourInstance.setValue("CongratulationCode", userId+placeId+offerName);
            Navigator.pushNamed(context, '/Congratulation');
          }
          else if (snapshot.value !=null && snapshot.value<9){
            AppCommon.databaseReference.child("UserData").child(userId).child("Total offers")
                .set(snapshot.value+1);
          }
          else {
            AppCommon.databaseReference.child("UserData").child(userId).child("Total offers")
                .set(1);
          }

    });

  }
  void _onPressedBottomNavigationBar (int position){
    switch (position) {
      case 0 :Navigator.pushNamed(context, '/UserHome');break;
      case 1 :Navigator.pushNamed(context, '/MyOffers');break;
      case 3 :Navigator.pushNamed(context, '/UserProfile');break;
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(scanResult,style: TextStyle(color: Colors.green),),
            ),
          )
        ],
      ),
      bottomNavigationBar: new BottomNavigationBar(
        items: [
          new BottomNavigationBarItem(
              icon: new Icon(Icons.home,), title: new Text("Home")),
          new BottomNavigationBarItem(
              icon: new Image.asset("assets/icons/Bottom Navigation bar/1.png",width: 25,height: 25,), title: new Text("My Offers")),
          new BottomNavigationBarItem(
              icon: new Image.asset("assets/icons/Bottom Navigation bar/2.png",width: 25,height: 25,), title: new Text("Scan")),

          new BottomNavigationBarItem(
              icon: new Icon(Icons.person,), title: new Text("Profile")),
        ],
        onTap:_onPressedBottomNavigationBar,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: 2,
      ),
    );
  }
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        scanResult ="Scanned Successfully";
        Vibration.vibrate();
      });
      analysisQRCode(scanData);

    });
  }
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

}