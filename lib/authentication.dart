import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery/services.dart';

import 'forgetpass.dart';
import 'loading.dart';

class authentication extends StatefulWidget {
  @override
  _authenticationState createState() => _authenticationState();
}

class _authenticationState extends State<authentication> {
  var log=true;
  var load=false;
  var loadr=false;
  String email="";
  String password="";
  String username="";
  String error="";
  final FirebaseAuth _auth= FirebaseAuth.instance;
  final _dref=FirebaseDatabase.instance.reference().child('CustomUser');
  final _formKey = GlobalKey<FormState>();
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
        actions: [

        ],

      ),
      body: log?login():register(),
    );
  }
  Widget login() {
    return load ? loading() : SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Column(
          children: [

            Text('LOGIN',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25.0),),

            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20.0),
                  TextFormField(
                    validator: (val) => val.isEmpty ? 'Enter an email' : null,
                    onChanged: (val) {
                      setState(() => email = val);
                    },
                    decoration: const InputDecoration(
                      labelText: 'enter the email',
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    obscureText: true,
                    validator: (val) =>
                    val.length < 6
                        ? 'Enter a password 6+ chars long'
                        : null,
                    onChanged: (val) {
                      setState(() => password = val);
                    },
                    decoration: const InputDecoration(
                      labelText: 'enter the password',
                    ),
                  ),
                  TextButton(
                    child: Text('Forget Password'),

                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => forgetpass()));
                    },),
                  SizedBox(height: 20.0),
                  RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0)
                      ),
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Sign In',
                          style: TextStyle(color: Colors.white,fontSize: 20.0,fontWeight: FontWeight.bold),
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            load = true;
                          });
                          try {
                            dynamic result = await _auth.signInWithEmailAndPassword(
                                email: email, password: password);
                            // if(result == null) {
                            //   setState(() {
                            //     error = 'Could not sign in with those credentials';
                            //   });
                            // }
                            print(result.user.email);
                            //  _dref.once('value',).then((result)=>print(result.val().type));


                          }
                          catch (err) {
                            setState(() {
                              error = err.toString();
                              load = false;
                            });
                          }
                        }
                      }
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 14.0),
                  ),


                ],

              ),


            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('New User?'),
                  RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0)
                      ),
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: Text( log?'register':'signin'),
                      onPressed: (){
                        setState(() {
                          log=!log;
                        });


                      }),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget register() {
    return loadr ? loading() : SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Column(
          children: [
            Text('REGISTER',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25.0),),

            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20.0),
                  TextFormField(
                    validator: (val) => val.isEmpty ? 'Username' : null,
                    onChanged: (val) {
                      setState(() => username = val);
                    },
                    decoration: const InputDecoration(
                      labelText: 'Username',
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    validator: (val) => val.isEmpty ? 'Enter an email' : null,
                    onChanged: (val) {
                      setState(() => email = val);
                    },
                    decoration: const InputDecoration(
                      labelText: 'enter the email',
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    obscureText: true,
                    validator: (val) =>
                    val.length < 6
                        ? 'Enter a password 6+ chars long'
                        : null,
                    onChanged: (val) {
                      setState(() => password = val);
                    },
                    decoration: const InputDecoration(
                      labelText: 'enter the password',
                    ),
                  ),

                  SizedBox(height: 20.0),
                  RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0)
                      ),
                      color: Colors.blue,

                      textColor: Colors.white,

                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Register',
                          style: TextStyle(color: Colors.white,fontSize: 20.0,fontWeight: FontWeight.bold),
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            loadr = true;
                          });
                          try {
                            dynamic result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
                            // if(result == null) {
                            //   setState(() {
                            //     error = 'Could not sign in with those credentials';
                            //   });
                            // }
                            print(result.user.email);
                            var x=getUser(email);
                            var _ddref=_dref.child(x);
                            _ddref.set({
                              'Username':username,
                              'email':email,

                            });
                            //  _dref.once('value',).then((result)=>print(result.val().type));


                          }
                          catch (err) {
                            setState(() {
                              error = err.toString();
                              loadr = false;
                            });
                          }
                        }
                      }
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 14.0),
                  ),


                ],

              ),


            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Existing User?'),
                  RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0)
                      ),
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: Text( log?'register':'signin'),
                      onPressed: (){
                        setState(() {
                          log=!log;
                        });


                      }),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }


}
