import 'dart:convert';
import 'dart:math';

import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:encrypt/encrypt.dart' as myEncrypter;

import '../../GlobalState.dart';
class GenerateQRCode extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new GenerateQRCodeState ();
  }

}
class GenerateQRCodeState extends State <GenerateQRCode> {
  String encryptedText ="";
  Random random = new Random.secure();
  String randomText = "";
  String getRandomText (String value) {
    randomText = "";
    for(int i=0;i<6;i++){
      randomText+=String.fromCharCode(random.nextInt(123-48)+48);
    }
    randomText=StringUtils.addCharAtPosition(randomText, value, 3);
    return randomText;
  }
   String encryptionWithAES (String plainText){
    final key = myEncrypter.Key.fromUtf8('mjdkdlsne20f4f5d6dyrdlshilesmfl3');
    final iv = myEncrypter.IV.fromLength(16);
    final encrypter = myEncrypter.Encrypter(myEncrypter.AES(key));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    print(encrypted.base64);
    return encrypted.base64;
  }

//  String keroEncrypt (String plainText){
//    setState(() {
//      myencrypted="";
//    });
//     String kero ="KirolosAtefDeveloper";
//     String confusion = "";
//
//     for(int i=0;i<80;i++){
//       confusion+=String.fromCharCode(random.nextInt(123-48)+48);
//     }
//     for (int i=0 ,k=0;i <20 ;i++,k+=4){
//       setState(() {
//         myencrypted+=kero[i];
//         for(int j=0;j<4;j++){
//           myencrypted+=confusion[k+j];
//         }
//       });
//     }
//     setState(() {
//       myencrypted=StringUtils.addCharAtPosition(myencrypted, plainText, 50);
//     });
//     print(kero);
//     print(confusion);
//     print(myencrypted);
//     return kero;
//  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Center (
              child: QrImage(
                data: encryptedText,
                version: QrVersions.auto,
                size: 320,
                gapless: false,
              ),
            ),
            SelectableText(encryptedText),
          ],
        ),
      ),
      backgroundColor: Colors.white.withOpacity(0.85),
      bottomNavigationBar: new BottomNavigationBar(
        items: [
          new BottomNavigationBarItem(
              icon: new Icon(Icons.home,), title: new Text("50")),
          new BottomNavigationBarItem(
              icon: new Image.asset("assets/icons/Bottom Navigation bar/1.png",width: 25,height: 25,), title: new Text("100")),
          new BottomNavigationBarItem(
              icon: new Image.asset("assets/icons/Bottom Navigation bar/2.png",width: 25,height: 25,), title: new Text("150")),
        ],
        onTap:_onPressedBottomNavigationBar,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
      ),
    );
  }
   void _onPressedBottomNavigationBar (int position) {
     switch (position) {
       case 0 :
//         keroEncrypt("A");
         setState(() {
           encryptedText=encryptionWithAES(getRandomText("A"));
         });
         break;
       case 1 :
         setState(() {
           encryptedText=encryptionWithAES(getRandomText("B"));
         });
         break;
       case 2 :
         setState(() {
           encryptedText=encryptionWithAES(getRandomText("B"));
         });
         break;
     }
   }

}