import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'package:vibration/vibration.dart';

import '../../AppCommon.dart';
import 'package:encrypt/encrypt.dart' as myEncrypter;

import '../../GlobalState.dart';
class QRReader extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return QRReaderState ();
  }

}
class QRReaderState extends State <QRReader> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController controller;
  String userId,scanResult="",oldScannedData="",finalResult="";
  bool isValid=false;
  void analysisQRCode (String qrText){
    final key = myEncrypter.Key.fromUtf8('mjdkdlsne20f4f5d6dyrdlshilesmfl3');
    final iv = myEncrypter.IV.fromLength(16);
    final encrypter = myEncrypter.Encrypter(myEncrypter.AES(key));
    try {
      final decrypted = encrypter.decrypt64(qrText, iv: iv);
      print(decrypted);
      setState(() {
        if (decrypted[3]=="A"){
          isValid=true;
          finalResult="Score incresed by 50";
          print("Score incresed by 50");
        }
        else if (decrypted[3]=="B"){
          isValid=true;
          finalResult="Score incresed by 100";
          print("Score incresed by 100");
        }
        else if (decrypted[3]=="C"){
          isValid=true;
          finalResult="Score incresed by 150";
          print("Score incresed by 150");
        }
        else{
          finalResult="";
          isValid=false;
        }
      });
    }
    catch (e){
      setState(() {
        finalResult="";
        isValid=false;
      });
    }

  }

//  void keroAnalysis (String qrText){
//    if (qrText.length!=101){
//      setState(() {
//        isValid=false;
//      });
//      return;
//    }
//    String kero ="";
//    for(int i=0;i<qrText.length-5;i+=5){
//      if (i>=50){
//        kero+=qrText[i+1];
//      }else {
//        kero += qrText[i];
//      }
//    }
//    print(qrText);
//    print(kero);
//    bool hasValue=false;
//    if (qrText[50]=='A' ||qrText[50]=='B'||qrText[50]=='C'){
//      hasValue=true;
//    }
//    else{
//      hasValue=false;
//    }
//    if (kero=="KirolosAtefDeveloper" && hasValue ){
//      setState(() {
//        isValid=true;
//      });
//      if (qrText[50]=='A'){
//        print("increase score by 50");
//      }
//      else if (qrText[50]=='B'){
//        print("increase score by 100");
//      }
//      else if (qrText[50]=='C'){
//        print("increase score by 150");
//      }
//    }
//  }
  void _onPressedBottomNavigationBar (int position){
    switch (position) {
      case 0 :Navigator.pushNamed(context, '/UserHome');break;
      case 1 :Navigator.pushNamed(context, '/MyOffers');break;
      case 3 :Navigator.pushNamed(context, '/UserProfile');break;
    }

  }
  @override
  void initState() {
    userId=GlobalState.ourInstance.getValue("userId");
    super.initState();
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
              child: Column(
                children: <Widget>[
                  Text(scanResult,style: TextStyle(color: (isValid)?Colors.green:Colors.red),),
                  Text(finalResult,style: TextStyle(color:Colors.green),),
                ],
              )
            ),
          )
        ],
      ),
      bottomNavigationBar: new BottomNavigationBar(
        items: [
          new BottomNavigationBarItem(
              icon: new Icon(Icons.home,), title: new Text("Home")),
          new BottomNavigationBarItem(
              icon: new Image.asset("assets/icons/Bottom Navigation bar/1.png",width: 25,height: 25,), title: new Text("Mahaba Offers")),
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
      if (scanData!=oldScannedData){
        setState(() {
          oldScannedData=scanData;
        });
        analysisQRCode(scanData);
        setState(() {
          if (isValid){
            scanResult ="Valid QR Code";
            Vibration.vibrate();
          }
          else{
            scanResult ="Invalid QR code";
            Vibration.vibrate();
          }

        });
      }
    });
  }
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

}