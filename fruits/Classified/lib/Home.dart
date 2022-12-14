import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
// import "package:images_picker/images_picker.dart";

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading = true;
  File _image;
  List _output;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 5,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _output = output;
      _loading = false;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
        model: 'assets/model.tflite', labels: 'assets/labels.txt');
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  // pickImage() async {
  //   var image = await ImagesPicker.pick(
  //     count: 1,
  //     pickType: PickType.image,
  //   );
  //   if (image == null) return print('ERROR IN YOUR CODE');
  //   setState(() {
  //     _image = image as File;
  //   });
  //   classifyImage(_image);
  // }
  pickImage() async {
    var image = await picker.getImage(source: ImageSource.camera);

    if (image == null) return print('ERROR IN YOUR CODE');

    setState(() {
      _image = File(image.path);
    });
    classifyImage(_image);
  }

  pickGalleryImage() async {
    var image = await picker.getImage(source: ImageSource.gallery);

    if (image == null) return print('ERROR IN YOUR CODE');

    setState(() {
      _image = File(image.path);
    });
    classifyImage(_image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.004, 1],
            colors: [
              Color(0xFFa8e063),
              Color(0xFF56ab2f),
            ],
          ),
        ),
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 30),
                Text(
                  'Detect',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 28),
                ),
                Text(
                  'Fruits',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 28),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7)
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Center(
                          child: _loading
                              ? Container(
                                  width: 300,
                                  height:
                                      MediaQuery.of(context).size.height / 2,
                                  child: Column(
                                    children: <Widget>[
                                      Image.asset('assets/fruit.svg'),
                                      SizedBox(
                                        height: 20,
                                      )
                                    ],
                                  ),
                                )
                              : Container(
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        width: 280,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                2,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.file(_image),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      _output != null
                                          ? Text(
                                              'prediction is : ${_output[0]['label']}',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20),
                                            )
                                          : Container(),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: pickImage,
                              child: Container(
                                width: MediaQuery.of(context).size.width - 180,
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                decoration: BoxDecoration(
                                    color: Color(0xFF56ab2f),
                                    borderRadius: BorderRadius.circular(6)),
                                child: Text(
                                  'Take a photo',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            GestureDetector(
                              onTap: pickGalleryImage,
                              child: Container(
                                width: MediaQuery.of(context).size.width - 180,
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 27, vertical: 12),
                                decoration: BoxDecoration(
                                    color: Color(0xFF56ab2f),
                                    borderRadius: BorderRadius.circular(6)),
                                child: Text(
                                  'Gallery',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}
