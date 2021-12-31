import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocery/cart.dart';
import 'package:grocery/model1.dart';
import 'package:grocery/models.dart';
import 'package:grocery/orders.dart';
import 'package:grocery/services.dart';
import 'package:grocery/text_ml.dart';
class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  final FirebaseAuth _auth= FirebaseAuth.instance;
  final _dref=FirebaseDatabase.instance.reference().child('CustomUser');
  final _prod=FirebaseDatabase.instance.reference().child('products');
  final _cart=FirebaseDatabase.instance.reference().child('cart');
  var user="";
  var catdict={
    'All':List.from(prolist),
    'Oil':List.from(oil),
    'Atta and other flours':List.from(attaandotherflours),
    'Rice and other Grains':List.from(riceandothergrains),
    'Pulses':List.from(pulses),
    'Salt,suggar and jaggery':List.from(saltsugarandjaggery),
    'Spices':List.from(spices),
    'Householditems':List.from(householditems),
    'Beverages':List.from(beverages),
    'Healthdrinks':List.from(healthdrinks),
    'Milk products':List.from(milkproducts),
    'Snacks':List.from(snacks),

  };

  var listop="All";
  var dictops;
  List<product1> l=[];
  List<product1> pl=[];
  List<product1> pl2=[];
  var d={};
  var st=false;
  var si=false;
  var sy=false;
  var sn=false;

  // void putdata(){
  //   for(var i=0;i<prolist.length;i++){
  //     _prod.push().set(
  //       {
  //         'productname':prolist[i].name,
  //         'img':prolist[i].img,
  //         'cat':prolist[i].cat,
  //         'rate':prolist[i].rate
  //       }
  //
  //     );
  //   }
  // }
  void pr(){
    // l=[];
    // _prod.onChildAdded.listen((event) {
    //
    //   setState(() {
    //     l.add(new product.fromSnapShot(event.snapshot));
    //   });
    // });

    d={};
    _cart.child(getUser(_auth.currentUser.email)).onChildAdded.listen((event) {
      setState(() {
        dynamic x=event.snapshot.value;
        d[event.snapshot.key]=x['qty'];
      });

    });
    // _dref.child
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      l=List.from(catdict['All']);
      pl=List.from(catdict['All']);
      dictops=catdict.keys;
    });

    _cart.child(getUser(_auth.currentUser.email)).onChildAdded.listen((event) {
      setState(() {
        dynamic x=event.snapshot.value;
        d[event.snapshot.key]=x['qty'];
      });

    });

    _dref.child(getUser(_auth.currentUser.email)).onValue.listen((event) {
      setState(() {
        dynamic x=event.snapshot.value;
        user=x['Username'];
      });
    });

    _prod.onChildAdded.listen((event) {


      setState(() {
        dynamic x=event.snapshot.value;
        if(catdict.containsKey(x['cat']) && !catdict[x['cat']].contains(product1(x['productname'],x['img'],x['cat'],x['rate']))){
          print('again');
          catdict[x['cat']].add(product1(x['productname'],x['img'],x['cat'],x['rate']));
        }
        else{

          catdict[x['cat']]=List.from([product1(x['productname'],x['img'],x['cat'],x['rate'])]);
        }
        if(!catdict['All'].contains(product1(x['productname'],x['img'],x['cat'],x['rate']))){
        catdict['All'].add(product1(x['productname'],x['img'],x['cat'],x['rate']));}
        l=List.from(catdict['All']);
        pl=List.from(catdict['All']);
        pl2=List.from(catdict['All']);
      });
    });
    // putdata();
  }
  @override
  Widget build(BuildContext context) {
    // pr();
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
          Stack(
            children: [

              Container(
                height: 15.0,
                  width: 15.0,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10.0),

                  ),

                  child: Center(child: Text(d.length.toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),))),
              IconButton(icon: Icon(Icons.shopping_cart), onPressed: ()async{

              dynamic r=await Navigator.push(context, MaterialPageRoute(builder: (context)=>cart()));
              if(r=='back1') {
                pr();
              }
            }),

            ]
          )
        ],
      ),
      drawer: Drawer(
        child: Column(

          children: [
            SizedBox(
              width: 100,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(



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
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(FontAwesomeIcons.shoppingBag),
                  SizedBox(width: 20.0,),
                  Text('Your orders'),

                ],
              ),
              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder: (context)=>order()));
              },
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
            ),
            ListTile(
            title: Row(
              children: [
                Icon(FontAwesomeIcons.camera),
                SizedBox(width: 20.0,),
                Text('Order using camera'),
              ],
            ),

              onTap: () async{
                    dynamic r=await Navigator.push(context, MaterialPageRoute(builder: (context)=>text_ml(pl2, d)));
                    if(r=='b'){
                      pr();
                    }
              },
            )
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text('Shop by category: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    ),
                  ),
                  DropdownButton<String>(
                    value: listop,
                    dropdownColor: Colors.white,
                    // focusColor: Colors.blue,
                    icon: const Icon(FontAwesomeIcons.caretSquareDown,color: Colors.blue,),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 15),
                    underline: Container(
                      height: 2,
                      color: Colors.blue,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        l=List.from(catdict[newValue]);
                        pl=List.from(catdict[newValue]);
                        listop=newValue;
                      });

                    },
                    items: catdict.keys
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),

                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [




                  !st?Text('all products '):new Expanded(
                    child: new TextField(
                      onChanged: (value){
                        setState(() {

                          // ftvl=tvl.where((obj)=>obj.key.toLowerCase().contains(value.toLowerCase())).toList();
                          l=pl.where((obj)=>obj.name.toLowerCase().contains(value.toLowerCase())||obj.cat.toLowerCase().contains(value.toLowerCase())||obj.rate.toString().toLowerCase().contains(value.toLowerCase())).toList();
                        });
                      },
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                          hintText: "Search products Here",
                          hintStyle: TextStyle(color: Colors.black)),



                    ),
                  ),

                  st?IconButton(icon: Icon(Icons.cancel), onPressed: (){

                    setState(() {

                       st=false;
                        l=List.from(pl);
                    });
                  }):IconButton(icon: Icon(Icons.search), onPressed: (){

                    setState(() {

                      st=true;
                    });
                  }),

                  // Expanded(child: SizedBox()),

                  IconButton(icon: Icon(FontAwesomeIcons.sortAmountUpAlt), onPressed: (){

                    setState(() {
                      l.sort((a,b)=>a.rate.compareTo(b.rate));
                    });
                  }),
                  IconButton(icon: Icon(FontAwesomeIcons.sortAmountUp), onPressed: (){

                    setState(() {
                      // ftvl.sort((b,a)=>a.hrate.compareTo(b.hrate));
                      l.sort((b,a)=>a.rate.compareTo(b.rate));
                    });
                  }),
                ],

              ),
            ),
            l.isEmpty?Container(
              child: Center(

                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('No products found',style: TextStyle(fontSize: 30),),
                ),
              ),
            ):Expanded(

                child:ListView.builder(
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
                })
            ),
          ],
        ),
      ),
    );
  }
}
