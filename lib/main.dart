import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tp6/DBHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool loading = true;
  List<String> words = [];
  DatabaseHelper db = DatabaseHelper.instance;
  TextEditingController c2 = new TextEditingController();
  TextEditingController c3 = new TextEditingController();
  String c1;
  String c4;
  int score = 0;
  int idx = 0;

  @override
  void initState() {
    super.initState();
    bool loading = true;
    _query();
    sleep(Duration(seconds: 4));
  }

  void _insert() async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: 'Hello',
    };
    final id = await db.insert(row);
    print('inserted row id: $id');
  }

  void _query() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getInt("idx")==null) { idx=0;} else idx=prefs.getInt("idx");
    if(prefs.getInt("score")==null) { score=0;} else score=prefs.getInt("score");
    print(idx);
    print("index");
    print(score);
    print("score");
    final allRows = await db.queryAllRows();
    print('query all rows:');
    allRows.forEach((element) {
      print(element);
    });
    allRows.forEach((row) {
      String s = row["WORD"].toString().toUpperCase();
      words.add(s);
    });
    c1 = words.elementAt(idx).substring(0, 1);
    c4 = words.elementAt(idx).substring(3, 4);
    print(words);
    setState(() {
      loading = false;
    });
  }
  void finish(){
    print("finsh has called");
      showDialog(context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: new Text("Congratulation !!! "),
              content: new Text("You have completed the game successfully"),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new ElevatedButton(
                  child: new Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
  }
  void check(String word) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("idx", idx);
    prefs.setInt("score",score);
    print(word);
    if (words.contains(word)) {
      Fluttertoast.showToast(
          msg: "Corrent :)",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
      );
      print("adding");
      setState(() {
        idx++;if(idx>=words.length){idx=0;}
        score++;if(score>=5){ finish(); score=0;}
        prefs.setInt("idx", idx);
        prefs.setInt("score",score);
        c1 = words.elementAt(idx).substring(0, 1);
        c4 = words.elementAt(idx).substring(3, 4);
        c2.clear();
        c3.clear();
      });
    } else Fluttertoast.showToast(
        msg: "Incorrect try again :(",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "QUIZ",
          textAlign: TextAlign.center,
        ),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Container(
                      height: 200,
                      width: 200,
                      child: Image.asset(
                        "assets/img.png",
                        filterQuality: FilterQuality.high,
                      ),
                      margin: EdgeInsets.all(20),
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Score : ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 26, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "$score/5",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 26),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              width: 40,
                              child: Text(
                                c1,
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              )),
                          Container(
                              width: 40,
                              child: TextField(
                                textInputAction: TextInputAction.next,
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  hintText: "?",
                                ),
                                buildCounter: (BuildContext context,
                                        {int currentLength,
                                        int maxLength,
                                        bool isFocused}) =>
                                    null,
                                maxLength: 1,
                                controller: c2,
                              )),
                          Container(
                              width: 40,
                              child: TextField(
                                
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                                decoration: InputDecoration(
                                    hintStyle: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                    hintText: "?"),
                                buildCounter: (BuildContext context,
                                        {int currentLength,
                                        int maxLength,
                                        bool isFocused}) =>
                                    null,
                                maxLength: 1,
                                controller: c3,
                              )),
                          Container(
                              width: 40,
                              child: Text(c4,
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold))),
                          Container(
                              width: 120,
                              child: ElevatedButton(
                                  child: Icon(Icons.arrow_forward),
                                  onPressed: () {
                                    String w = c1 + c2.text + c3.text + c4;
                                    w = w.toUpperCase();
                                    check(w);
                                  }))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
