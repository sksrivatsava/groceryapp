import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:grocery/admin.dart';
import 'package:grocery/services.dart';

import 'authentication.dart';
import 'home.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _dref=FirebaseDatabase.instance.reference().child('CustomUser');
  final FirebaseAuth _auth= FirebaseAuth.instance;
  var log;
  dynamic type;
  Future isUserLoggedIn() async {
    var user = await _auth.currentUser;

    // print(user);
    // var c=_dref.child(getUser(user)).child('type').onValue;
    // print(c);

    if(user!=null) {
      _dref
          .child(getUser(user.email))
          .onValue
          .listen((event) {
        setState(() {
          dynamic x=event.snapshot.value;
          type = x['type'];

        });
      });
    }
    setState(() {
      log=user;
    });
  }
  @override
  Widget build(BuildContext context) {

    isUserLoggedIn();
    if(log!=null){
      if(type=='admin'){
        return admin();
      }
      else {
        return home();
      }
    }
    else{
      return authentication();
    }




  }


}


