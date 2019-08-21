import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import '../chat/index.dart';
import '../users/index.dart';
import '../uploading/uploading.dart';
import '../quiz/index.dart';
import '../global/global.dart' as global;

class Gallery extends StatefulWidget {
  @override
  _Gallery createState() => new _Gallery();
}

class _Gallery extends State<Gallery> {
  Map<String, String> _paths;
  List<dynamic> data = new List();
  List selection = [];
  String status = "?";
  bool scrolling = false;
  String domain = global.domain;
  bool loader = true;

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  fetchImages() async {
    var url = '$domain/v1/images';
    var response = await http.get(url, headers: {'operation': 'Images'});
    setState(() {
      data = json.decode(response.body);
      loader = false;
    });
  }

  fetchProvidedDateImages(dates) async {
    var url = '$domain/v1/images/date';
    var response =
        await http.get(url, headers: {'date': dates, 'operation': 'Images'});
    int index = 0;
    data.forEach((date) {
      if (dates == date.keys.toList().elementAt(0).toString()) {
        date = json.decode(response.body)[0];
        setState(() {
          data[index] = date;
        });
      }
      index++;
    });
  }

  void imageStatus(date, imageName, status) async {
    var url = '$domain/v1/images/status';
    var response = await http.patch(url, body: {
      "Date": date,
      "ImageName": imageName,
      "Status": status,
    }, headers: {
      'operation': 'Images'
    });
    print(response.body);

    fetchProvidedDateImages(date);
    print(date + imageName + status);
  }

  void _openFileExplorer() async {
    _paths = await FilePicker.getMultiFilePath(type: FileType.IMAGE);
    if (!mounted) return;
    setState(() {
      _paths.keys.toString();
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Uploading(_paths, 'Images'),
      ),
    );
  }

  popup(BuildContext context, listOfSelection) {
    var alertDialog = AlertDialog(
      contentPadding: EdgeInsets.all(0),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Change Status',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 40.0, top: 10.0, bottom: 10.0),
            child: Text(
              'Select an single option',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: RaisedButton(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  onPressed: () {
                    Navigator.pop(context);
                    data.forEach((date) {
                      List<dynamic> listOfImages =
                          date[date.keys.toList().elementAt(0).toString()];
                      listOfImages.forEach((image) {
                        Map<dynamic, dynamic> imageValues =
                            image[image.keys.toList().elementAt(0)];
                        if (imageValues["Selected"]) {
                          setState(() {
                            imageValues["Selected"] = false;
                            selection = [];
                          });
                          imageStatus(
                              date.keys.toList().elementAt(0).toString(),
                              image.keys.toList().elementAt(0),
                              "OK");
                        }
                      });
                    });
                  },
                  child: Text(
                    "OK",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromRGBO(85, 130, 173, 1),
                    ),
                  ),
                  color: Colors.grey[100],
                ),
              ),
              Expanded(
                child: RaisedButton(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  onPressed: () {
                    Navigator.pop(context);
                    data.forEach((date) {
                      List<dynamic> listOfImages =
                          date[date.keys.toList().elementAt(0).toString()];
                      listOfImages.forEach((image) {
                        Map<dynamic, dynamic> imageValues =
                            image[image.keys.toList().elementAt(0)];
                        if (imageValues["Selected"]) {
                          setState(() {
                            imageValues["Selected"] = false;
                            selection = [];
                          });
                          imageStatus(
                              date.keys.toList().elementAt(0).toString(),
                              image.keys.toList().elementAt(0),
                              "NOT OK");
                        }
                      });
                    });
                  },
                  child: Text(
                    "NOT OK",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromRGBO(85, 130, 173, 1),
                    ),
                  ),
                  color: Colors.grey[100],
                ),
              ),
            ],
          ),
        ],
      ),
    );

    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        titleSpacing: 10.0,
        elevation: 0.0,
        backgroundColor: Color.fromRGBO(242, 242, 242, 1),
        actionsIconTheme: IconThemeData(color: Colors.blue),
        centerTitle: true,
        title: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              "Admin",
              style: new TextStyle(
                fontSize: 18.0,
                letterSpacing: 1.5,
                color: Color.fromRGBO(85, 130, 173, 1),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: <Widget>[
//                  selection.isEmpty
//                      ? Container()
//                      : IconButton(
//                          icon: Icon(
//                            Icons.edit,
//                            color: Color.fromRGBO(85, 130, 173, 1),
//                          ),
//                          onPressed: () {
//                            popup(context, selection);
//                          },
//                        ),
                IconButton(
                  icon: Icon(
                    Icons.content_paste,
                    color: Color.fromRGBO(85, 130, 173, 1),
                    size: 25,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Quiz()),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.group,
                    color: Color.fromRGBO(85, 130, 173, 1),
                    size: 25,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Users()),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.message,
                    color: Color.fromRGBO(85, 130, 173, 1),
                    size: 25,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatList(),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.image,
                    color: Color.fromRGBO(85, 130, 173, 1),
                    size: 25,
                  ),
                  onPressed: () => _openFileExplorer(),
                ),
              ],
            ),
          )
        ],
      ),
      body: loader
          ? Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'diXray',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 60.0,
                color: Color.fromRGBO(85, 130, 173, 1),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(
                  Color.fromRGBO(85, 130, 173, 1)),
              backgroundColor: Color.fromRGBO(242, 242, 242, 1),
            ),
          ],
        ),
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.all(15),
              itemCount: data.length,
              itemBuilder: (BuildContext context, int indexForDates) {
                Map<dynamic, dynamic> date = data[indexForDates];
                List<dynamic> listOfImages =
                date[date.keys.toList().elementAt(0).toString()];
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          date.keys.toList().elementAt(0).toString(),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color.fromRGBO(85, 130, 173, 1),
                          ),
                        ),
                        Container(
                          height: 50,
                          width: 50,
                          decoration: new BoxDecoration(
                            color: Color.fromRGBO(242, 242, 242, 1),
                            borderRadius: new BorderRadius.only(
                              topLeft: const Radius.circular(50.0),
                              topRight: const Radius.circular(50.0),
                              bottomLeft: const Radius.circular(50.0),
                              bottomRight: const Radius.circular(50.0),
                            ),
                          ),
                          child: IconButton(
                            highlightColor:
                            Color.fromRGBO(242, 242, 242, 1),
                            icon: Icon(
                              Icons.cloud_download,
                              size: 22,
                              color: Color.fromRGBO(85, 130, 173, 1),
                            ),
                            onPressed: () {
                              fetchProvidedDateImages(date.keys
                                  .toList()
                                  .elementAt(0)
                                  .toString());
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    listOfImages.length > 0
                        ? Container(
                      child: GridView.count(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        childAspectRatio: 0.9,
                        children: List.generate(
                          listOfImages.length,
                              (index) {
                            Map<dynamic, dynamic> image =
                            listOfImages[index];
                            Map<dynamic, dynamic> imageValues =
                            image[image.keys
                                .toList()
                                .elementAt(0)];
                            print("");
                            return GestureDetector(
                              onTap: () {
                                print(index);
                                if (!imageValues['Selected']) {
                                  setState(() {
                                    imageValues['Selected'] =
                                    true;
                                    selection.add(index);
                                  });
                                } else {
                                  setState(() {
                                    imageValues['Selected'] =
                                    false;
                                    selection.remove(index);
                                  });
                                }
                              },
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    decoration: new BoxDecoration(
                                      border: new Border.all(
                                          color: Color.fromRGBO(
                                              242, 242, 242, 1),
                                          width: 2),
                                      borderRadius:
                                      new BorderRadius.only(
                                        topLeft:
                                        const Radius.circular(
                                            30.0),
                                        topRight:
                                        const Radius.circular(
                                            30.0),
                                        bottomLeft:
                                        const Radius.circular(
                                            30.0),
                                        bottomRight:
                                        const Radius.circular(
                                            30.0),
                                      ),
                                      image: DecorationImage(
                                        image: new NetworkImage(
                                          imageValues['URL'],
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
//                                          Column(
//                                            mainAxisAlignment:
//                                                MainAxisAlignment.end,
//                                            children: <Widget>[
//                                              Row(
//                                                mainAxisAlignment:
//                                                    MainAxisAlignment.end,
//                                                crossAxisAlignment:
//                                                    CrossAxisAlignment.end,
//                                                children: <Widget>[
//                                                  Container(
//                                                    height: 40,
//                                                    width: 40,
//                                                    decoration:
//                                                        new BoxDecoration(
//                                                      color: Colors.red,
//                                                      borderRadius:
//                                                          new BorderRadius.only(
//                                                        topLeft: const Radius
//                                                            .circular(10.0),
//                                                        bottomRight:
//                                                            const Radius
//                                                                .circular(30.0),
//                                                      ),
//                                                    ),
//                                                    child: Center(
//                                                        child: imageValues[
//                                                                    'Status'] ==
//                                                                "?"
//                                                            ? Text(
//                                                                "?",
//                                                                style:
//                                                                    TextStyle(
//                                                                  color: Colors
//                                                                      .white,
//                                                                  fontSize: 18,
//                                                                  fontWeight:
//                                                                      FontWeight
//                                                                          .w600,
//                                                                ),
//                                                              )
//                                                            : imageValues[
//                                                                        'Status'] ==
//                                                                    "OK"
//                                                                ? Icon(
//                                                                    Icons
//                                                                        .check_circle,
//                                                                    color: Colors
//                                                                        .white,
//                                                                    size: 17,
//                                                                  )
//                                                                : imageValues[
//                                                                            'Status'] ==
//                                                                        "NOT OK"
//                                                                    ? Icon(
//                                                                        Icons
//                                                                            .clear,
//                                                                        color: Colors
//                                                                            .white,
//                                                                        size:
//                                                                            17,
//                                                                      )
//                                                                    : Container()),
//                                                  ),
//                                                ],
//                                              ),
//                                            ],
//                                          ),
//                                          imageValues['Selected']
//                                              ? Container(
//                                                  decoration: BoxDecoration(
//                                                    color: Colors.black
//                                                        .withOpacity(0.3),
//                                                    borderRadius:
//                                                        new BorderRadius.only(
//                                                      topLeft:
//                                                          const Radius.circular(
//                                                              30.0),
//                                                      topRight:
//                                                          const Radius.circular(
//                                                              30.0),
//                                                      bottomLeft:
//                                                          const Radius.circular(
//                                                              30.0),
//                                                      bottomRight:
//                                                          const Radius.circular(
//                                                              30.0),
//                                                    ),
//                                                  ),
//                                                  child: Center(
//                                                    child: Icon(
//                                                      Icons.check_circle,
//                                                      size: 50,
//                                                      color: Colors.white,
//                                                    ),
//                                                  ),
//                                                )
//                                              : Container()
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    )
                        : Container(
                      child: GridView.count(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        childAspectRatio: 0.9,
                        children: List.generate(
                          3,
                              (index) {
                            return Container(
                              decoration: new BoxDecoration(
                                border: new Border.all(
                                    color: Colors.transparent,
                                    width: 1),
                                borderRadius:
                                new BorderRadius.only(
                                  topLeft:
                                  const Radius.circular(30.0),
                                  topRight:
                                  const Radius.circular(30.0),
                                  bottomLeft:
                                  const Radius.circular(30.0),
                                  bottomRight:
                                  const Radius.circular(30.0),
                                ),
                                color: Color.fromRGBO(
                                    242, 242, 242, 1),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
