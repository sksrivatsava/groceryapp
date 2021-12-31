import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class addproductfrom extends StatefulWidget {
  @override
  _addproductfromState createState() => _addproductfromState();
}

class _addproductfromState extends State<addproductfrom> {
  final _formKey = GlobalKey<FormState>();
  final _prod=FirebaseDatabase.instance.reference().child('products');
  dynamic productname;
  dynamic img="None";
  dynamic cat;
  dynamic rate;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('add product form'),),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Column(
            children: [

              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    TextFormField(
                      validator: (val) => val.isEmpty ? 'Enter product name' : null,
                      onChanged: (val) {
                        setState(() => productname = val);
                      },
                      decoration: const InputDecoration(
                        labelText: 'Enter product name',
                      ),
                    ),

                    SizedBox(height: 20.0),
                    TextFormField(
                      // validator: (val) => val.isEmpty ? 'Enter Image Url' : null,
                      onChanged: (val) {
                        setState(() => img = val);
                      },
                      decoration: const InputDecoration(
                        labelText: 'Enter Image Url',
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      validator: (val) => val.isEmpty ? 'Enter category' : null,
                      onChanged: (val) {
                        setState(() => cat = val);
                      },
                      decoration: const InputDecoration(
                        labelText: 'Enter category',
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      validator: (val) => val.isEmpty ? 'rate' : null,
                      onChanged: (val) {
                        setState(() => rate = val);
                      },
                      decoration: const InputDecoration(
                        labelText: 'rate',
                      ),
                    ),
                    SizedBox(height: 20.0),



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
                            _prod.push().set({
                              'cat':cat,
                              'img':img,
                              'productname':productname,
                              'rate':int.parse(rate),
                            });
                          }
                          // _showDialog();
                          Navigator.pop(context);
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
