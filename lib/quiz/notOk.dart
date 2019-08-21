import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import '../uploading/uploading.dart';
import '../global/global.dart' as global;

class NOTOK extends StatefulWidget {
  @override
  _Quiz createState() => new _Quiz();
}

class _Quiz extends State<NOTOK> {
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
    var response = await http.get(url, headers: {'operation': 'NOT OK'});
    setState(() {
      data = json.decode(response.body);
      loader = false;
    });
  }

  fetchProvidedDateImages(dates) async {
    var url = '$domain/v1/images/date';
    var response =
        await http.get(url, headers: {'date': dates, 'operation': 'Quiz'});
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
      'operation': 'Quiz'
    });
    fetchProvidedDateImages(date);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
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
                                                        color:
                                                            Colors.transparent,
                                                        width: 1),
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
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: <Widget>[
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: <Widget>[
                                                        Container(
                                                          height: 40,
                                                          width: 40,
                                                          decoration:
                                                              new BoxDecoration(
                                                            color: Colors.red,
                                                            borderRadius:
                                                                new BorderRadius
                                                                    .only(
                                                              topLeft: const Radius
                                                                      .circular(
                                                                  10.0),
                                                              bottomRight:
                                                                  const Radius
                                                                          .circular(
                                                                      30.0),
                                                            ),
                                                          ),
                                                          child: Center(
                                                              child: imageValues[
                                                                          'Status'] ==
                                                                      "?"
                                                                  ? Text(
                                                                      "?",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                    )
                                                                  : imageValues[
                                                                              'Status'] ==
                                                                          "OK"
                                                                      ? Icon(
                                                                          Icons
                                                                              .check_circle,
                                                                          color:
                                                                              Colors.white,
                                                                          size:
                                                                              17,
                                                                        )
                                                                      : imageValues['Status'] ==
                                                                              "NOT OK"
                                                                          ? Icon(
                                                                              Icons.clear,
                                                                              color: Colors.white,
                                                                              size: 17,
                                                                            )
                                                                          : Container()),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                imageValues['Selected']
                                                    ? Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.black
                                                              .withOpacity(0.3),
                                                          borderRadius:
                                                              new BorderRadius
                                                                  .only(
                                                            topLeft: const Radius
                                                                .circular(30.0),
                                                            topRight: const Radius
                                                                .circular(30.0),
                                                            bottomLeft:
                                                                const Radius
                                                                        .circular(
                                                                    30.0),
                                                            bottomRight:
                                                                const Radius
                                                                        .circular(
                                                                    30.0),
                                                          ),
                                                        ),
                                                        child: Center(
                                                          child: Icon(
                                                            Icons.check_circle,
                                                            size: 50,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      )
                                                    : Container()
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
      ),
    );
  }
}
