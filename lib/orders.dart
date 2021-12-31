import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:grocery/services.dart';
class pro{

  String name;
  dynamic qty;
  dynamic rate;
  pro(this.name,this.qty,this.rate);
}

class ord{

  List<pro> itemlist;
  int total;
  String address;
  String date;

  ord(DataSnapshot snap){
    dynamic x=snap.value;
    List l=x['items'].split(',');
    List<pro> p=[];

    for(var i=0;i<l.length;i++){
      var x=l[i].split('@');
      p.add(new pro(x[0],x[1],x[2]));


    }
    this.itemlist=p;
    this.total=x['total'];
    this.address=x['address'];
    this.date=x['date'];



  }

}
class order extends StatefulWidget {
  @override
  _orderState createState() => _orderState();
}

class _orderState extends State<order> {
  final _ord=FirebaseDatabase.instance.reference().child('order');
  final FirebaseAuth _auth= FirebaseAuth.instance;
  List<ord> ordl=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _ord.child(getUser(_auth.currentUser.email)).onChildAdded.listen((event) {

      setState(() {
        ordl.insert(0,new ord(event.snapshot));
      });
    });




  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),

      body: Container(
        child: Column(
            children: [
              ordl.isEmpty?Container(
                child: Center(
                    child: Text('No orders till now.',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize:40.0
                      ),
                    )
                ),
              ):
              Expanded(
                  child: ListView.builder(
                    itemCount: ordl.length,

                      itemBuilder: (context,index){
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Order on ${ordl[index].date}',style: TextStyle(fontWeight: FontWeight.bold),),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('items:',style: TextStyle(fontWeight: FontWeight.bold),),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                    itemCount: ordl[index].itemlist.length,

                                    itemBuilder: (context,index2){
                                      return Card(
                                        child: Row(
                                          children: [
                                            Text('name:  ',style: TextStyle(fontWeight: FontWeight.bold),),
                                            Flexible(child: Text(ordl[index].itemlist[index2].name)),
                                            SizedBox(width: 20.0,),
                                            Text('qty:  ',style: TextStyle(fontWeight: FontWeight.bold),),
                                            Text(ordl[index].itemlist[index2].qty),
                                            SizedBox(width: 20.0,),
                                            Text('rate:  ₹',style: TextStyle(fontWeight: FontWeight.bold),),
                                            Text(ordl[index].itemlist[index2].rate),
                                          ],
                                        ),
                                      );
                                    }),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Total: ₹${ordl[index].total}',style: TextStyle(fontWeight: FontWeight.bold),),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('address: ${ordl[index].address}',style: TextStyle(fontWeight: FontWeight.bold),),
                                ),

                              ],
                            ),
                          ),
                        );
                      }

                  ))
            ],
        ),
      ),
    );


  }
}
