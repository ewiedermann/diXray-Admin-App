import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'dart:convert';
import './bubble.dart';

class Chat extends StatefulWidget {
  String user = '';

  Chat(user) {
    this.user = user;
  }

  @override
  _Chat createState() => new _Chat(user);
}

class _Chat extends State<Chat> {
  TextEditingController _chatController = TextEditingController();
  String user = '';
  List<dynamic> messages = new List();

  _Chat(user) {
    this.user = user;
  }

  sendMessage(body) async {
    Map<dynamic, dynamic> temp = body;
    print(temp.keys.elementAt(0).toString());
    print(temp.values.elementAt(0));
    Firestore.instance
        .collection("Messages")
        .document(temp.keys.elementAt(0).toString())
        .updateData({"messages": temp.values.elementAt(0)}).then((snap) {
      print("Document successfully updated!");
    });
  }

  @override
  Widget build(BuildContext context) {
    final FocusNode _weightFocus = FocusNode();
    return Scaffold(
      appBar: AppBar(
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
            Navigator.pop(context);
          },
        ),
        title: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Text(
              user,
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
        children: <Widget>[
          Flexible(
            child: StreamBuilder(
                stream: Firestore.instance
                    .collection('Messages')
                    .document(user)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return new Container();
                  }
                  var userDocument = snapshot.data;
                  List<dynamic> chats = userDocument.data.values.toList()[0];
                  messages = chats.toList();
                  List<dynamic> temp = chats.reversed.toList();
                  return new ListView.builder(
                    padding: new EdgeInsets.all(8.0),
                    reverse: true,
                    itemBuilder: (_, int index) {
                      Map<dynamic, dynamic> key = temp[index];
                      return Container(
                        child: Bubble(
                            isMe:
                                key.keys.elementAt(0) == "admin" ? true : false,
                            message: key.values.elementAt(0)),
                      );
                    },
                    itemCount: temp.length,
                  );
                }),
          ),
          Container(
            child: IconTheme(
              data: new IconThemeData(color: Colors.blue),
              child: new Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  boxShadow: [
                    BoxShadow(
                        blurRadius: .5,
                        spreadRadius: 1.0,
                        color: Colors.black.withOpacity(.12))
                  ],
                ),
                child: Container(
                  child: Row(
                    children: <Widget>[
                      new Flexible(
                        child: new TextField(
                          focusNode: _weightFocus,
                          style: new TextStyle(
                            fontSize: 18.0,
                            height: 1.0,
                          ),
                          decoration: new InputDecoration.collapsed(
                            hintText: "Start typing ...",
                            fillColor: Colors.white,
                          ),
                          controller: _chatController,
                          onChanged: (text) {
                            print("First text field: $text");
                          },
                        ),
                      ),
                      new Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: new IconButton(
                          icon: new Icon(
                            Icons.send,
                            color: Color.fromRGBO(85, 130, 173, 1),
                          ),
                          onPressed: () {
                            if (_chatController.text.length > 0) {
                              messages.add({"admin": _chatController.text});
                              sendMessage({
                                user: messages,
                              });
                              setState(() {
                                _chatController.text = "";
                              });
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
