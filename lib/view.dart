import 'package:connectivity/connectivity.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class View extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ViewState();
  }
}

var connectivityResult;
int con = 0;
Map<dynamic, dynamic> map;
List data = [];

class ViewState extends State {
  @override
  void initState() {
    super.initState();
    connection();
    fetch();
  }

  Future<void> fetch() async {
    data.clear();
    await FirebaseDatabase.instance
        .reference()
        .child("users")
        .once()
        .then((DataSnapshot snapshot) => {
              map = snapshot.value,
              map.forEach((key, value) {
                data.add(value);

                this.setState(() {});
              })
            });

    print(data);
  }

  Future<void> connection() async {
    connectivityResult = await Connectivity().checkConnectivity();
    print(connectivityResult);
    if (connectivityResult == ConnectivityResult.none) {
      this.setState(() {
        con = 1;
      });
    } else {
      this.setState(() {
        con = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            title: Text("View Data"),
          ),
          body: con == 1
              ? Center(
                  child: Text("check your internet connection"),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      for (int i = 0; i < data.length; i++)
                        (Padding(
                          padding: EdgeInsets.all(10),
                          child: Container(
                              child: Card(
                                  child: Row(
                            children: [
                              Container(
                                  child: Column(
                                children: [
                                  Text("NAME : " + data[i]["name"]),
                                  Text("EMAIL : " + data[i]["email"]),
                                  Text("PHONE : " + data[i]["phone"]),
                                ],
                              )),
                              IconButton(
                                  icon: Icon(
                                    Icons.delete_forever,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    FirebaseDatabase.instance
                                        .reference()
                                        .child("users")
                                        .child(data[i]["email"]
                                            .replaceAll(".", ","))
                                        .remove()
                                        .then((value) => {
                                              Toast.show(
                                                  "Data Deleted", context,
                                                  duration: Toast.LENGTH_SHORT,
                                                  gravity: Toast.BOTTOM),
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          View()))
                                            });
                                  })
                            ],
                          ))),
                        ))
                    ],
                  ),
                )),
    );
  }
}
