
import 'package:clipboard/clipboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery/models.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:grocery/services.dart';
class Details extends StatefulWidget {
  final String text;
  final pl;
  dynamic d1;
  Details(this.text,this.pl,this.d1);
  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  final GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth= FirebaseAuth.instance;
  final _cart=FirebaseDatabase.instance.reference().child('cart');

  var d={};
  List<product1> l=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    l=[];
    print(widget.pl);

    var s=widget.text;
    print(s);
    s=s.trim();
    List<String> el=s.split('\n');

      d=widget.d1;

    print(d);
    for(var i in el){

      print("asjgs $i-sss");
      dynamic p_name=null;
      var maxi=0;
      for(var k in widget.pl){
        i=i.trim();
        List<String> sp=i.split(' ');

        var c=0;
        for(var j in sp){
          if(k.name.toLowerCase().contains(j.toLowerCase())){
            c=c+1;
          }
        }
        if(c>maxi){
          maxi=c;
          p_name=k;
        }
      }
      if(p_name!=null){
          print(p_name.name);
          setState(() {
            if(!l.contains(p_name)) {
              l.add(p_name);
            }
            if(!d.containsKey(p_name.name)){
              d[p_name.name]=1;
              _cart.child(getUser(_auth.currentUser.email)).child(p_name.name).set({
                'pname':p_name.name,
                'image':p_name.img,
                'qty':d[p_name.name],
                'rate':p_name.rate,


              });
            }
          });
      }
      else{
        print("none");
      }
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text('your scanned items',style: TextStyle(fontSize: 20),),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              Navigator.pop(context,'b');
            },
          )
        ],
      ),
      body: l.isEmpty?Container(
        child: Center(

          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('No products found',style: TextStyle(fontSize: 30),),
          ),
        ),
      ):ListView.builder(
          itemCount: l.length,
          itemBuilder: (context,index){

            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: Card(
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
                    d.containsKey(l[index].name)?Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          child: Text('-', style: TextStyle(fontSize: 25),),
                          onPressed: () {
                            setState(() {
                              d[l[index].name]=d[l[index].name]-1;
                            });

                            if(d[l[index].name]==0){
                              _cart.child(getUser(_auth.currentUser.email)).child(l[index].name).remove();
                              setState(() {
                                d.remove(l[index].name);
                              });
                              // print("ggg");
                            }
                            else {
                              _cart.child(
                                  getUser(_auth.currentUser.email)).child(
                                  l[index].name).update({
                                'pname': l[index].name,
                                'qty': d[l[index].name],
                                'rate': d[l[index].name] * l[index].rate,

                              });
                            }




                          },
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                          ),
                        ),
                        Text(d[l[index].name].toString()),
                        ElevatedButton(
                          child: Text('+', style: TextStyle(fontSize: 25),),
                          onPressed: () {
                            setState(() {
                              d[l[index].name]=d[l[index].name]+1;
                            });

                            _cart.child(getUser(_auth.currentUser.email)).child(l[index].name).update({
                              'pname':l[index].name,

                              'qty':d[l[index].name],
                              'rate':d[l[index].name]*l[index].rate,

                            });


                          },
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                          ),
                        ),
                      ],
                    ):RaisedButton(

                      child: Text('add to cart'),
                      onPressed: (){
                        setState(() {
                          d[l[index].name]=1;
                        });
                        _cart.child(getUser(_auth.currentUser.email)).child(l[index].name).set({
                          'pname':l[index].name,
                          'image':l[index].img,
                          'qty':d[l[index].name],
                          'rate':l[index].rate,


                        });



                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0)
                      ),
                      color: Colors.blue,
                      textColor: Colors.white,

                    ),

                  ],
                ),
              ),
            );
          }),
    );

  }
}
