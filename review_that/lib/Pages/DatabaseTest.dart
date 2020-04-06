import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_places_dialog/flutter_places_dialog.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_webservice/places.dart';

const kGoogleApiKey = "AIzaSyD7bYaGBoXdrTKu9gRUwod-az4BKcaK-JA";

GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class DatabaseTest extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DatabaseTestState();
  }

}
class DatabaseTestState extends State<DatabaseTest> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    child: RaisedButton(
                      onPressed: () async {
                        // show input autocomplete with selected mode
                        // then get the Prediction selected
                        Prediction p = await PlacesAutocomplete.show(
                            context: context, apiKey: kGoogleApiKey);
                        displayPrediction(p);
                      },
                      child: Text('Find address'),

                    )
                ),
                PlacesAutocompleteWidget(
                    apiKey: kGoogleApiKey,
                  mode: Mode.overlay,
                ),
                RaisedButton(onPressed: koko ,child: Text("koko"),),

              ],
            )
        )
    );
  }
  Future koko () async {
//    FlutterPlacesDialog.setGoogleApiKey("AIzaSyCSOyGejogUPEjVYVRJTp6XteLaYf8Zplo");
//    var m = await FlutterPlacesDialog.getPlacesDialog();
    Geocoder.local.findAddressesFromQuery("koko").then((address){
      print(address[0].addressLine);
//      print(address[2].addressLine);

      setState(() {
        first = address.first;
      });
      print(first.addressLine);
      print("${first.featureName} : ${first.coordinates}");
      setState(() {
//          addressDetails=first.addressLine;
      });
    });

  }

  var first;
  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      print("koko");
      print(p.description);
      Geocoder.local.findAddressesFromQuery("kfc").then((address){
        print(address);
        setState(() {
          first = address.first;
        });
        print(first.addressLine);
        print("${first.featureName} : ${first.coordinates}");
        setState(() {
//          addressDetails=first.addressLine;
        });
      }).whenComplete((){
//        if (addressDetails==""||addressDetails=="Loading address from Google Map..."){
//          setState(() {
//            addressDetails="Please Enter The Exact Name in Google Map";
//          });
//        }
      });
    }
  }
}