import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
class forgetpass extends StatefulWidget {
  @override
  _forgetpassState createState() => _forgetpassState();
}

class _forgetpassState extends State<forgetpass> {
  final FirebaseAuth _auth= FirebaseAuth.instance;
  var email="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('resetting password'),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('please provide your email for password resetting'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(onChanged: (value){
              setState(() {

                email=value;
              });


            },),
          ),

          RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0)
              ),
              color: Colors.blue,

              textColor: Colors.white,

              onPressed: (){


            _auth.sendPasswordResetEmail(email: email);
            Navigator.pop(context);

          }, child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('send request'),
          )),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('*Please check your email after sending request to reset your password*',style: TextStyle(fontWeight: FontWeight.bold),),
          )

        ],
      ),
    );
  }
}
