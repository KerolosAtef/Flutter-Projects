import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppCommon {
  static var mAuth =FirebaseAuth.instance ;
  static var databaseReference=FirebaseDatabase.instance.reference();
  static var snackBarKey =GlobalKey<ScaffoldState>();

}