import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sentiment_dart/sentiment_dart.dart';
class check_analytics extends StatefulWidget {
  @override
  _check_analyticsState createState() => _check_analyticsState();
}
class tile{
  String text;
  Color c;
  dynamic s;
  tile(this.text,this.c,this.s);
}
class _check_analyticsState extends State<check_analytics> {
  final _rev=FirebaseDatabase.instance.reference().child('reviews');
  final sen=Sentiment();
  var t=0;
  List<tile> l=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _rev.onChildAdded.listen((event) {
      setState(() {
        dynamic x1=event.snapshot.value;
        var x=sen.analysis(x1['review']);
        t=t+x['score'];
        if(x['score']<0){
          l.add(tile(x1['review'], Colors.red,x['score']));
        }
        else{
          l.add(tile(x1['review'], Colors.green,x['score']));
        }
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            title: Text('analysis'),
          ),
          body: Column(
            children: [
              Card(
                color: t>0?Colors.green:Colors.red,
                child: Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Text('Total Score: '+t.toString(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                  ),
                ),

              ),
              Divider(
                color: Colors.black,
                thickness: 3,
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: l.length,
                    itemBuilder: (context,i){

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: l[i].c,
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Center(child: Column(
                          children: [
                            Text(l[i].text),
                            SizedBox(height: 2,),
                            Text(l[i].s.toString(),style: TextStyle(
                              fontWeight: FontWeight.bold
                            ),)
                          ],
                        )),
                      ),
                    ),
                  );


                }),
              ),
            ],
          ),
    );
  }
}

// void main() {
//   final sentiment = Sentiment();
//   print(sentiment.analysis('i hate you piece of shit 💩'));
//
//   print(sentiment.analysis('i hate you piece of shit 💩',emoji: true));
// }