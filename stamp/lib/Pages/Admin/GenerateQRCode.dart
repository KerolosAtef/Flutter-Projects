import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:stamp/GlobalState.dart';
class GenerateQRCode extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new GenerateQRCodeState ();
  }

}
class GenerateQRCodeState extends State <GenerateQRCode> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Center (
        child: QrImage(
          data: GlobalState.ourInstance.getValue("userId")+GlobalState.ourInstance.getValue("selected offer"),
          version: QrVersions.auto,
          size: 320,
          gapless: false,
        ),
      ),
      backgroundColor: Colors.white.withOpacity(0.85),
    );
  }


}