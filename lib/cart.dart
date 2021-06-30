import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:grocery/addressform.dart';
import 'package:grocery/services.dart';


class carto{
  String key;
  String name;
  int qty;
  String img;
  int rate;

  carto.fromSnapShot(DataSnapshot snap):
      key=snap.key,
      name=snap.value['pname'],
      qty=snap.value['qty'],
      img=snap.value['image'],
      rate=snap.value['rate'];

}
class cart extends StatefulWidget {
  @override
  _cartState createState() => _cartState();
}

class _cartState extends State<cart> {

  List<dynamic> cl=[];
  final FirebaseAuth _auth= FirebaseAuth.instance;
  final _cart=FirebaseDatabase.instance.reference().child('cart');
  final _ord=FirebaseDatabase.instance.reference().child('order');






  var total=0;
  var content=[];
  var items="";
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cart.child(getUser(_auth.currentUser.email)).onChildAdded.listen((event) {
      setState(() {
        cl.add(new carto.fromSnapShot(event.snapshot));
        total=total+event.snapshot.value['rate'];
        String c=event.snapshot.value['pname']+'@'+event.snapshot.value['qty'].toString()+'@'+event.snapshot.value['rate'].toString();
        content.add(c);

      });

    });
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('your cart'),
      ),






      body: total==0?Container(
        child: Center(
          child: Text('Cart is Empty',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize:50.0
          ),
          )
        ),
      ):Container(
        child: Column(
          children: [
            Flexible(
                
                child:ListView.builder(
                    itemCount: cl.length,
                    itemBuilder: (context,index){
                      
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          elevation: 2.0,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(

                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.network(cl[index].img,width: 50*1.5,height: 50*1.5,),
                                Flexible(child: Text(cl[index].name,style: TextStyle(fontWeight: FontWeight.bold,),)),
                                SizedBox(width: 10.0,),
                                Text('qty: ${cl[index].qty.toString()}',style: TextStyle(fontWeight: FontWeight.bold,),),
                                SizedBox(width: 10.0,),
                                Text('rate: ₹${cl[index].rate.toString()}',style: TextStyle(fontWeight: FontWeight.bold,),),

                              ],
                            ),
                          ),
                        ),
                      );
                  
                  
                }) ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0,right: 15.0),
              child: Row(
                children: [
                  Expanded(child: SizedBox()),

                  Text('Total ₹$total',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25.0),),

                ],
              ),
            ),
            RaisedButton(
                child: Text('procced to checkout'),
                onPressed: () async{
                  items=content.join(',');
                  dynamic result = await Navigator.push(context, MaterialPageRoute(builder: (context)=>address(items,total)));

                  if(result=="back"){
                    Navigator.pop(context,"back1");
                  }
            },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0)
              ),
              color: Colors.blue,
              textColor: Colors.white,

            )
          ],
        ),
      )

    );
  }
}
