import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:grocery/services.dart';

class address extends StatefulWidget {
  final items;
  final total;
  address(this.items,this.total);
  @override
  _addressState createState() => _addressState();
}

class _addressState extends State<address> {
  final _ord=FirebaseDatabase.instance.reference().child('order');
  final _cart=FirebaseDatabase.instance.reference().child('cart');

  String line1="";
  String line2="";
  String city="";
  String state="";
  String country="";
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth= FirebaseAuth.instance;
  // void _showDialog() {
  //   // flutter defined function
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       // return object of type Dialog
  //       return AlertDialog(
  //         title: new Text("Order Successful"),
  //         content: new Text("Check your orders for order summary.."),
  //         actions: <Widget>[
  //           // usually buttons at the bottom of the dialog
  //           new RaisedButton(
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(18.0)
  //             ),
  //             color: Colors.blue,
  //
  //             textColor: Colors.white,
  //             child: new Text("Close"),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('please type the address'),

        ),

      body:SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('*Check your Orders after submitting..*',style: TextStyle(fontWeight: FontWeight.bold),),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    TextFormField(
                      validator: (val) => val.isEmpty ? 'Enter Line 1' : null,
                      onChanged: (val) {
                        setState(() => line1 = val);
                      },
                      decoration: const InputDecoration(
                        labelText: 'Enter Line 1',
                      ),
                    ),

                    SizedBox(height: 20.0),
                    TextFormField(
                      validator: (val) => val.isEmpty ? 'Enter Line 2' : null,
                      onChanged: (val) {
                        setState(() => line2 = val);
                      },
                      decoration: const InputDecoration(
                        labelText: 'Enter Line 2',
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      validator: (val) => val.isEmpty ? 'city' : null,
                      onChanged: (val) {
                        setState(() => city = val);
                      },
                      decoration: const InputDecoration(
                        labelText: 'city',
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      validator: (val) => val.isEmpty ? 'state' : null,
                      onChanged: (val) {
                        setState(() => state = val);
                      },
                      decoration: const InputDecoration(
                        labelText: 'state',
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      validator: (val) => val.isEmpty ? 'country' : null,
                      onChanged: (val) {
                        setState(() => country = val);
                      },
                      decoration: const InputDecoration(
                        labelText: 'country',
                      ),
                    ),


                    SizedBox(height: 20.0),
                    RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0)
                        ),
                        color: Colors.blue,
                        textColor: Colors.white,
                        child: Text(
                          'submit',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: ()  {
                          if (_formKey.currentState.validate()) {
                              var address=line1+','+line2+','+city+','+state+','+country;
                              var now=DateTime.now();
                              var date=now.day.toString()+'/'+now.month.toString()+'/'+now.year.toString();
                              _cart.child(getUser(_auth.currentUser.email)).remove();
                            _ord.child(getUser(_auth.currentUser.email)).push().set(
                              {
                                'items':widget.items,
                                'total':widget.total,
                                'address':address,
                                'date':date

                              }
                            );

                          }
                           // _showDialog();
                          Navigator.pop(context,"back");
                        }
                    ),
                    SizedBox(height: 12.0),



                  ],

                ),


              ),
            ],
          ),
        ),
      ),
    );
  }
}
