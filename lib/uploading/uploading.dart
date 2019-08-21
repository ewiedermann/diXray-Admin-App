import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import '../gallery/index.dart';
import '../quiz/index.dart';
import 'dart:io';
import '../global/global.dart' as global;

class Uploading extends StatefulWidget {
  Map<String, String> images;
  String operation = "";

  Uploading(images, operation) {
    this.images = images;
    this.operation = operation;
  }

  @override
  _Uploading createState() => new _Uploading(images, operation);
}

class _Uploading extends State<Uploading> {
  Map<dynamic, dynamic> images;
  String operation = "";
  int totalImages = 0, currentImageNumber = 0;
  String domain = global.domain;

  _Uploading(images, operation) {
    this.images = images;
    this.operation = operation;
    totalImages = this.images.length;
    this.images.forEach((imageName, path) {
      uploadImage(imageName, path, this.operation);
    });
  }

  Future<String> uploadImage(imageName, path, operation) async {
    File file = new File(path);
    StorageReference ref =
        FirebaseStorage.instance.ref().child(operation + "/" + imageName);
    StorageUploadTask uploadTask = ref.putFile(file);

    var url = await (await uploadTask.onComplete).ref.getDownloadURL();
    print(url.toString());

    // var uploadImage = await '$domain/v1/images';

    var uploadImage = '$domain/v1/images';
    var response = await http.post(uploadImage, headers: {
      'operation': operation
    }, body: {
      "ImageName": imageName.toString(),
      "Status": "?",
      "URL": url.toString()
    });
    print(response.body);
    setState(() {
      currentImageNumber++;
    });
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          titleSpacing: 5.0,
          elevation: 0.0,
          backgroundColor: Color.fromRGBO(242, 242, 242, 1),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Color.fromRGBO(85, 130, 173, 1),
              size: 25,
            ),
            onPressed: () {
              operation == "Images"
                  ? Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => Gallery(),
                      ),
                    )
                  : Navigator.pop(context);
            },
          ),
          title: new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Text(
                "Upload Images",
                style: new TextStyle(
                  fontSize: 18.0,
                  letterSpacing: 1.5,
                  color: Color.fromRGBO(85, 130, 173, 1),
                ),
              ),
            ],
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Icon(
                Icons.cloud_upload,
                size: 270,
                color: Color.fromRGBO(242, 242, 242, 1),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                currentImageNumber == totalImages
                    ? "Uploaded"
                    : "Uploading....",
                style: new TextStyle(
                  color: Color.fromRGBO(85, 130, 173, 1),
                  fontSize: 30.0,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                currentImageNumber.toString() + " / " + totalImages.toString(),
                style: new TextStyle(
                  color: Color.fromRGBO(85, 130, 173, 1),
                  fontSize: 25.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
