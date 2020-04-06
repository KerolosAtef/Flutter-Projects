import 'package:esbetalia/GlobalState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';

class PdfContent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PdfContentState();
  }

}
class PdfContentState extends State<PdfContent> {
  PDFDocument doc ;
  @override
  void initState() {
    doc=GlobalState.ourInstance.getValue("doc");

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
        PDFViewer(document: doc,)) ,
    );
  }

}