import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../chat/components/chat.dart';
import '../global/global.dart' as global;

class ChatList extends StatefulWidget {
  @override
  _ChatList createState() => new _ChatList();
}

class _ChatList extends State<ChatList> {
  List<dynamic> users = new List();
  String domain = global.domain;
  bool loader = true;

  @override
  void initState() {
    fetchAllUsers();
  }

  fetchAllUsers() async {
    var isUserExists = '$domain/v1/chats';
    var response = await http.get(isUserExists);
    setState(() {
      users = json.decode(response.body);
      loader = false;
    });
  }

  splitName(index) {
    String name = users[index][0];
    return Text(
      name.toUpperCase(),
      style: TextStyle(color: Colors.black),
    );
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
              Navigator.pop(context);
            },
          ),
          title: new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Text(
                "Messages",
                style: new TextStyle(
                  fontSize: 18.0,
                  letterSpacing: 1.5,
                  color: Color.fromRGBO(85, 130, 173, 1),
                ),
              ),
            ],
          ),
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
            : users.length > 0
                ? SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 15.0,
                        ),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: users.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: <Widget>[
                                Container(
                                  decoration: new BoxDecoration(
                                    border: new Border(
                                      top: BorderSide(
                                          color: Colors.grey[200], width: 1),
                                      bottom: users.length - 1 == index
                                          ? BorderSide(
                                              color: Colors.grey[200], width: 1)
                                          : BorderSide(
                                              color: Colors.transparent,
                                              width: 1),
                                    ),
                                  ),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 15.0, vertical: 15.0),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              Chat(users[index]),
                                        ),
                                      );
                                    },
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.grey[200],
                                      radius: 30.0,
                                      child: splitName(index),
                                    ),
                                    title: Text(
                                      users[index],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.phonelink_erase,
                          size: 150,
                          color: Color.fromRGBO(242, 242, 242, 1),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'No chat!',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 30.0,
                            color: Color.fromRGBO(85, 130, 173, 1),
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
