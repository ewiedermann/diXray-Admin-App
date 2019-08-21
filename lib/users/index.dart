import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../global/global.dart' as global;

class Users extends StatefulWidget {
  @override
  _Users createState() => new _Users();
}

class _Users extends State<Users> {
  List<dynamic> users = new List();
  String serverResponse = 'Server response';
  String domain = global.domain;
  bool loader = true;

  @override
  void initState() {
    super.initState();
    fetchAllUsers();
  }

  fetchAllUsers() async {
    var isUserExists = '$domain/v1/users';
    var response = await http.get(isUserExists);
    setState(() {
      users = json.decode(response.body);
      loader = false;
    });
    print(users[0].values.elementAt(0));
  }

  changeStatus(email, status) async {
    var isUserExists = '$domain/v1/users/$email';
    var response = await http.patch(isUserExists, body: status);

    var isUserExistss = '$domain/v1/users';
    var responses = await http.get(isUserExistss);
    setState(() {
      users = json.decode(responses.body);
      loader = false;
    });
    print(users[0].values.elementAt(0));
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
                "Users",
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
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: users.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: <Widget>[
                      Divider(),
                      ListTile(
                        onTap: () {},
                        title: Text(
                          users[index].values.elementAt(0)['Name'],
                        ),
                        subtitle: Text(
                          users[index].keys.toList()[0],
                        ),
                        trailing: Container(
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              users[index]
                                  .values
                                  .elementAt(0)['Status'] ==
                                  "Unblock"
                                  ? IconButton(
                                icon: Icon(
                                  Icons.check_box,
                                  color: Color.fromRGBO(
                                      190, 190, 190, 1),
                                ),
                                onPressed: () {},
                              )
                                  : IconButton(
                                icon: Icon(
                                  Icons.check_box,
                                  color: Color.fromRGBO(
                                      85, 130, 173, 1),
                                ),
                                onPressed: () {
                                  setState(() {
                                    users[index].values.elementAt(0)['Status'] = "Unblock";
                                  });
                                  changeStatus(
                                      users[index]
                                          .keys
                                          .toList()[0],
                                      {'status': 'Unblock'});
                                },
                              ),
                              users[index]
                                  .values
                                  .elementAt(0)['Status'] ==
                                  "Block"
                                  ? IconButton(
                                icon: Icon(
                                  Icons.block,
                                  color: Color.fromRGBO(
                                      190, 190, 190, 1),
                                ),
                                onPressed: () {},
                              )
                                  : IconButton(
                                icon: Icon(
                                  Icons.block,
                                  color: Color.fromRGBO(
                                      85, 130, 173, 1),
                                ),
                                onPressed: () {
                                  setState(() {
                                    users[index].values.elementAt(0)['Status'] = "Block";
                                  });
                                  changeStatus(
                                      users[index]
                                          .keys
                                          .toList()[0],
                                      {'status': 'Block'});
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(),
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
                        Text(
                          'No user registered!',
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
