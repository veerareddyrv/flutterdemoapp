import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'view.dart';
import 'add.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

var connectivityResult;
int con = 0;

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State {
  @override
  void initState() {
    super.initState();
    connection();
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
          title: Text("Demo App"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Add()));
                },
                child: Text(
                  "ADD",
                  style: TextStyle(color: Colors.white),
                )),
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => View()));
                },
                child: Text(
                  "VIEW",
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
              child: con == 1
                  ? Center(
                      child: Text("check your internet connection"),
                    )
                  : Padding(
                      padding: EdgeInsets.all(30),
                      child: Center(
                          child: Text(
                              "Welcome to home page Click to add or view data on top right of navigation bar")))),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                color: Colors.grey,
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: Center(child: Text("@ 2021")),
              )
            ],
          )
        ]),
      ),
    );
  }
}
