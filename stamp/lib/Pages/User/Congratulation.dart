import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:stamp/AppCommon.dart';
import 'package:stamp/GlobalState.dart';
class Congratulation extends StatefulWidget {
  @override
  State<StatefulWidget> createState()=>CongratulationState();
}
class CongratulationState extends State <Congratulation> {

  @override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Center (
        child: QrImage(
          data: GlobalState.ourInstance.getValue("CongratulationCode"),
          version: QrVersions.auto,
          size: 320,
          gapless: false,
        ),
      ),
    );
  }

}