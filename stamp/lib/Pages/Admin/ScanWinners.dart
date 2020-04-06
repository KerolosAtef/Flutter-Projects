import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:vibration/vibration.dart';

import '../../AppCommon.dart';
import '../../GlobalState.dart';
class ScanWinners extends StatefulWidget {
  @override
  State<StatefulWidget> createState()=>ScanWinnersState();
}
class ScanWinnersState extends State <ScanWinners> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController controller;
  String placeId,offerName,scannedUserId,userId,scanResult="";

  void analysisQRCode (String qrText){
    scannedUserId=qrText.substring(0,28);
    placeId=qrText.substring(28,56);
    offerName=qrText.substring(56);
    userId=GlobalState.ourInstance.getValue("userId");
    if (userId==placeId){
      print("we should delete this offer from this user");
      AppCommon.databaseReference.child("UserData").child(scannedUserId).child("my offers")
          .child(placeId).child(offerName).set(null);
    }
    else {
      print("This QR code not belongs to this Place");
    }
  }
  void _onPressedBottomNavigationBar (int position){
    switch (position) {
      case 0 : Navigator.pushNamed(context, '/AdminHome');break;
      case 2 :Navigator.pushNamed(context, '/AdminProfile');break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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
              icon: new Image.asset("assets/icons/Bottom Navigation bar/2.png",width: 25,height: 25,), title: new Text("Scan Winners")),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.person,), title: new Text("Place Profile")),
        ],
        onTap:_onPressedBottomNavigationBar,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: 1,
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