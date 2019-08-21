import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import '../uploading/uploading.dart';
import '../global/global.dart' as global;
import './ok.dart';
import './notOk.dart';
import './notOkM.dart';

class Quiz extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Index();
  }
}

class _Index extends State<Quiz> with SingleTickerProviderStateMixin {
  TabController _tabController;
  Map<String, String> _paths;
  List<dynamic> data = new List();
  List selection = [];
  String status = "?";
  bool scrolling = false;
  String domain = global.domain;
  bool loader = true;

  @override
  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this);
    super.initState();
  }

  void _openFileExplorer(operation) async {
    _paths = await FilePicker.getMultiFilePath(type: FileType.IMAGE);
    if (!mounted) return;
    setState(() {
      _paths.keys.toString();
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Uploading(_paths, operation),
      ),
    );
  }

  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 10.0,
          elevation: 0.0,
          backgroundColor: Color.fromRGBO(242, 242, 242, 1),
          actionsIconTheme: IconThemeData(color: Colors.blue),
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
                "Quiz",
                style: new TextStyle(
                  fontSize: 18.0,
                  letterSpacing: 1.5,
                  color: Color.fromRGBO(85, 130, 173, 1),
                ),
              ),
            ],
          ),
          bottom: PreferredSize(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                TabBar(
                  controller: _tabController,
                  indicatorColor: Color.fromRGBO(85, 130, 173, 1),
                  labelColor: Color.fromRGBO(85, 130, 173, 1),
                  indicatorPadding: EdgeInsets.all(0.0),
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    Container(
                      width: 100,
                      child: InkWell(
                        onTap: () {
                          _openFileExplorer("OK");
                        },
                        child: Tab(
                          text: "OK",
                        ),
                      ),
                    ),
                    Container(
                      width: 100,
                      child: InkWell(
                        onTap: () {
                          _openFileExplorer("NOT OK");
                        },
                        child: Tab(
                          text: "NOT OK",
                        ),
                      ),
                    ),
                    Container(
                      width: 100,
                      child: InkWell(
                        onTap: () {
                          _openFileExplorer("NOT OK M");
                        },
                        child: Tab(
                          text: "NOT OK M",
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            preferredSize: Size.square(50),
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              Center(
                child: OK(),
              ),
              Center(
                child: NOTOK(),
              ),
              Center(
                child: NOTOKM(),
              ),
            ],
            controller: _tabController,
          ),
        ),
      ),
    );
  }
}

class MyTabbedPage extends StatefulWidget {
  const MyTabbedPage({Key key}) : super(key: key);

  @override
  _MyTabbedPageState createState() => _MyTabbedPageState();
}

class _MyTabbedPageState extends State<MyTabbedPage>
    with SingleTickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'LEFT'),
    Tab(text: 'RIGHT'),
  ];

  TabController _tabController;
  List selection = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          tabs: myTabs,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: myTabs.map((Tab tab) {
          final String label = tab.text.toLowerCase();
          return Center(
            child: Text(
              'This is the $label tab',
              style: const TextStyle(fontSize: 36),
            ),
          );
        }).toList(),
      ),
    );
  }
}
