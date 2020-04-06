import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import '../GlobalState.dart';
class WebView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WebViewState();
  }

}
class WebViewState extends State<WebView> {
  var mAuth =FirebaseAuth.instance;
  String link ="";
  @override
  void initState() {
    link=GlobalState.ourInstance.getValue("link");
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return new WebviewScaffold(
      url:link ,
      allowFileURLs: true,
      geolocationEnabled: true,
      appBar: new AppBar(
        title: new Text("Admin3DPage"),
        actions: <Widget>[
          new IconButton(
              icon:new Image.asset("assets/icons/logout.png"),
              onPressed: (){
                mAuth.signOut();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/Login', (Route<dynamic> route) => false);
              }),
        ],
      ),
      hidden: true,
      withJavascript: true,
      withLocalStorage: true,
      withZoom: true,
    );
  }

}