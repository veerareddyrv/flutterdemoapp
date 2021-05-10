import 'package:connectivity/connectivity.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';

class Add extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddState();
  }
}

var connectivityResult;
int con = 0;
String reguname, reguemail, reguphone;
TextEditingController regname = TextEditingController();
String regnameerror;
TextEditingController regemail = TextEditingController();
String regemailerror;
TextEditingController regphone = TextEditingController();
String regphoneerror;

class AddState extends State {
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
            title: Text("Add Data"),
          ),
          body: con == 1
              ? Center(
                  child: Text("check your internet connection"),
                )
              : Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Padding(padding: EdgeInsets.all(10)),
                      Padding(padding: EdgeInsets.only(top: 30)),
                      TextField(
                        controller: regname,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.black,
                          ),
                          labelText: "Name *",
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                          hintText: "Eg : John",
                          errorText: regnameerror,
                          enabledBorder: OutlineInputBorder(),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                        ),
                      ),

                      //Email
                      Padding(padding: EdgeInsets.only(top: 10)),
                      TextField(
                        controller: regemail,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.mail,
                            color: Colors.black,
                          ),
                          labelText: "Email *",
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                          hintText: "Eg : John@gmail.com",
                          errorText: regemailerror,
                          enabledBorder: OutlineInputBorder(),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),

                      //Mobile
                      Padding(padding: EdgeInsets.only(top: 10)),
                      TextField(
                        controller: regphone,
                        decoration: InputDecoration(
                          prefixIcon: Container(
                              width: 80,
                              child: Row(
                                children: [
                                  Padding(padding: EdgeInsets.only(left: 10)),
                                  Icon(
                                    Icons.phone,
                                    color: Colors.black,
                                  ),
                                  Text(" +91-",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))
                                ],
                              )),
                          labelText: "Mobile *",
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                          hintText: "Eg : 9000000000",
                          errorText: regphoneerror,
                          enabledBorder: OutlineInputBorder(),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ], // Only numbers can be entered
                        maxLength: 10,
                      ),
                      //Button
                      Padding(padding: EdgeInsets.only(top: 10)),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                                primary: Colors.green),
                            onPressed: () {
                              this.setState(() {
                                if ((regname.text).length >= 3) {
                                  regnameerror = null;
                                  reguname = regname.text;
                                } else {
                                  regnameerror = "Enter name atleast 3 letters";
                                  return;
                                }

                                bool emailValid = RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(regemail.text);

                                if ((regemail.text).isEmpty) {
                                  regemailerror = "Enter Email ID";
                                  return;
                                } else if (emailValid == false) {
                                  regemailerror = "Enter valid Email ID";
                                  return;
                                } else {
                                  reguemail = regemail.text;
                                  regemailerror = null;
                                }

                                if ((regphone.text.trim()).isEmpty) {
                                  regphoneerror = "Enter Phone Number";
                                  return;
                                } else if ((regphone.text.trim()).length < 10) {
                                  regphoneerror = "Enter valid Phone Number";
                                  return;
                                } else if (num.tryParse(regphone.text.trim()) ==
                                    null) {
                                  regphoneerror = "Enter valid Phone Number";
                                  return;
                                } else {
                                  reguphone = regphone.text;
                                  regphoneerror = null;

                                  FirebaseDatabase.instance
                                      .reference()
                                      .child("users")
                                      .child(reguemail.replaceAll(".", ","))
                                      .set({
                                        "name": reguname,
                                        "email": reguemail,
                                        "phone": reguphone
                                      })
                                      .then((value) => {
                                            Toast.show("Email Added", context,
                                                duration: Toast.LENGTH_SHORT,
                                                gravity: Toast.BOTTOM)
                                          })
                                      .catchError((e) => {
                                            Toast.show("Email exists", context,
                                                duration: Toast.LENGTH_SHORT,
                                                gravity: Toast.BOTTOM)
                                          });
                                }
                              });
                            },
                            child: Text(
                              "ADD",
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                    ],
                  ))),
    );
  }
}
