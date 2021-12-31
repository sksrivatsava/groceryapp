import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:grocery/services.dart';
class review extends StatefulWidget {
  final items;
  final total;
  final address1;
  final date;
  review(this.items,this.total,this.address1,this.date);
  @override
  _reviewState createState() => _reviewState();
}

class _reviewState extends State<review> {
  var review="";
  final _ord=FirebaseDatabase.instance.reference().child('order');
  final _cart=FirebaseDatabase.instance.reference().child('cart');
  final _rev=FirebaseDatabase.instance.reference().child('reviews');
  final FirebaseAuth _auth= FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review_feedback'),
      ),

      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 23.0),
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(

                  maxLines: 8,
                  decoration: InputDecoration(
                    labelText: 'Review'
                  ),
                  onChanged: (val){
                    setState(() {
                      review=val;
                    });
                  },
                ),
              ),
              SizedBox(height: 20,),
              RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0)
                  ),
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Text('Submit'),
                  onPressed: (){

                    _cart.child(getUser(_auth.currentUser.email)).remove();
                    _ord.child(getUser(_auth.currentUser.email)).push().set(
                        {
                          'items':widget.items,
                          'total':widget.total,
                          'address':widget.address1,
                          'date':widget.date

                        }
                    );
                    _rev.push().set({
                      'review':review
                    });
                    Navigator.pop(context,'b');

              })
            ],
          ),
        ),
      ),
    );
  }
}
