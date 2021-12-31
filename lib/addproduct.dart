import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:grocery/addproductform.dart';
import 'package:grocery/models.dart';
class addproduct extends StatefulWidget {
  @override
  _addproductState createState() => _addproductState();
}

class _addproductState extends State<addproduct> {
  final _prod=FirebaseDatabase.instance.reference().child('products');
  var l=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _prod.onChildAdded.listen((event) {
      setState(() {
        dynamic x=event.snapshot.value;
        l.add(product1(x['productname'],x['img'],x['cat'],x['rate']));
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('add products'),
      ),
      body: ListView.builder(
          itemCount: l.length,
          itemBuilder: (context,index){
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              elevation: 2.0,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [

                        l[index].img!="None"?Image.network(l[index].img,width: 100,height: 100,):SizedBox(),

                        Flexible(
                          child: Text(l[index].name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text('₹ ${l[index].rate.toString()}',style: TextStyle(fontWeight: FontWeight.bold),)

                      ],
                    ),
                  ),


                ],
              ),
            );
      }),
      floatingActionButton: FloatingActionButton(
        child: Text('+'),
        onPressed: (){
          Navigator.push(context,MaterialPageRoute(builder: (context)=>addproductfrom()));
        },
      ),
    );
  }
}
