import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'authentication.dart';
import 'home.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseAuth _auth= FirebaseAuth.instance;
  var log;
  Future isUserLoggedIn() async {
    var user = await _auth.currentUser;

    //print(user);
    setState(() {
      log=user;
    });
  }
  @override
  Widget build(BuildContext context) {
    isUserLoggedIn();
    if(log!=null){
      return home();
    }
    else{
      return authentication();
    }


  }


}


