import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocery/addproduct.dart';
import 'package:grocery/check_analytics.dart';
import 'package:grocery/services.dart';

class admin extends StatefulWidget {
  @override
  _adminState createState() => _adminState();
}

class _adminState extends State<admin> {
  final FirebaseAuth _auth= FirebaseAuth.instance;
  final _dref=FirebaseDatabase.instance.reference().child('CustomUser');
  var user="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(_auth.currentUser!=null){
      _dref.child(getUser(_auth.currentUser.email)).onValue.listen((event) {
        dynamic x=event.snapshot.value;
        user=x['Username'];
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/grocery.png',
              fit: BoxFit.contain,
              height: 50,
            ),
            Container(
                padding: const EdgeInsets.all(8.0), child: Text('Intellimart',style: TextStyle(fontWeight: FontWeight.bold),))
          ],

        ),
      ),
      drawer: Drawer(
        child: Column(

          children: [
            SizedBox(
              width: 100,
            ),
            Container(



              height: 250,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/grocery.jpg'),
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter,

                    colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),

                  )
              ),
              // color: Colors.blue,
              child: Center(
                child: Text('Welcome ${user}',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 35.0),),
              ),
            ),

            ListTile(
              title: Row(
                children: [
                  Icon(FontAwesomeIcons.signOutAlt),
                  SizedBox(width: 20.0,),
                  Text('signout'),
                ],
              ),
              onTap: (){
                try {
                  _auth.signOut();
                } on Exception catch (e) {
                  // TODO
                }
              },
            )
          ],
        ),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              color: Colors.white,

                child: Text('add Products'),
                onPressed:(){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>addproduct()));
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
                color: Colors.white,
                child: Text('check analytics'),
                onPressed:(){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>check_analytics()));
                }),
          ),

        ],

      ),
    );
  }
}
