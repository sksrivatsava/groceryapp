import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

import 'details.dart';

class text_ml extends StatefulWidget {
  final pl;
  dynamic d;
  text_ml(this.pl,this.d);

  @override
  _text_mlState createState() => _text_mlState();
}

class _text_mlState extends State<text_ml> {
  String _text = '';
  PickedFile _image;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Take a picture',style: TextStyle(
            fontSize: 20
          ),),
          actions: [
            FlatButton(
              onPressed: scanText,
              child: Text(
                'Scan',
                style: TextStyle(color: Colors.white),
              ),
            ),
            FlatButton(
              onPressed: (){
                setState(() {
                  _image=null;
                  _text=null;
                });
              },
              child: Text(
                'clear',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
        floatingActionButton: Row(
         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            FloatingActionButton(
              onPressed: getImageFromCamera,
              child: Icon(Icons.add_a_photo),

            ),
            SizedBox(width: 10),
    FloatingActionButton(
              onPressed: getImageFromGallery,
child: Icon(FontAwesomeIcons.images),
),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: _image != null
              ? Image.file(
            File(_image.path),
            fit: BoxFit.fitWidth,
          )
              : Container(),
        ));
  }
  Future scanText() async {
    final textDetector = GoogleMlKit.vision.textDetector();
    final inputImage = InputImage.fromFile(File(_image.path));
    final RecognisedText recognisedText =
    await textDetector.processImage(inputImage);
    _text="";
    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement element in line.elements) {
          _text = _text + element.text + ' ';
        }
        _text = _text + '\n';
      }
    }

    dynamic r=await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Details(_text,widget.pl,widget.d)));
    if(r=='b'){
      Navigator.pop(context,'b');
    }
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = pickedFile;
      } else {
        print('No image selected');
      }
    });
  }
  Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = pickedFile;
      } else {
        print('No image selected');
      }
    });
  }
}

// SizedBox(width: 10),
// FloatingActionButton(
// onPressed: getImageFromGallery,
// child: Icon(FontAwesomeIcons.images),
// ),