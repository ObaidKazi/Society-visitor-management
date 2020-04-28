import 'package:flutter/material.dart';
import 'package:shankheshwar_pallazo/ui/Entry/manual.dart';
import 'package:shankheshwar_pallazo/ui/Entry/qrcode_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:intl/intl.dart';

class Entry extends StatefulWidget {
  Entry({Key key}) : super(key: key);

  @override
  _EntryState createState() => _EntryState();
}

class _EntryState extends State<Entry> {
  final db = Firestore.instance;

  var selectdata1="";
  var selectdata2="";
  var persondata;
  var personname="";
  var personnumber="";
  var personrno="";
  var id = "";
  TextEditingController purpose = TextEditingController();
  Widget build(BuildContext context) {
    var screenwidth = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 50, bottom: 30),
              child: Center(
                child: RaisedButton(
                  elevation: 10,
                  child: Text(
                    "Scan Qr",
                    style: TextStyle(
                      fontSize: screenwidth > 420 ? 24 : 16,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => QRViewExample()))
                        .then((value) {
                      setState(() {
                        persondata = value.split("\n");
                        personname = persondata[0];
                        personnumber = persondata[1];
                        personrno = persondata[2];
                      });
                    });
                  },
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 50, bottom: 30),
              child: Center(
                child: RaisedButton(
                  elevation: 10,
                  child: Text(
                    "Manual",
                    style: TextStyle(
                      fontSize: screenwidth > 420 ? 24 : 16,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ManualEntry())).then((value) {
                      setState(() {
                        persondata = value;
                        personname = persondata[0];
                        personnumber = persondata[1];
                        personrno = persondata[2];
                      });
                    });
                  },
                ),
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: screenwidth > 420 ? 110 : 50),
              padding: EdgeInsets.all(20),
              child: Text("Going In Or Out",
                  style: TextStyle(fontSize: screenwidth > 420 ? 14 : 10),
                  textAlign: TextAlign.left),
            ),
            Container(
              child: DropdownButton(
                iconSize: screenwidth > 420 ? 24 : 10,
                items: [
                  DropdownMenuItem<String>(
                    value: "IN",
                    child: Text(
                      "Going IN",
                    ),
                  ),
                  DropdownMenuItem<String>(
                    value: "OUT",
                    child: Text(
                      "Going OUT",
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectdata1 = value.toString();
                  });
                },
                hint:
                    selectdata1 == null ? Text("Select") : Text("$selectdata1"),
              ),
            ),
          ],
        ),
        Row(children: <Widget>[
          Container(
              margin: EdgeInsets.only(right: screenwidth > 420 ? 30 : 15),
              padding: EdgeInsets.all(20),
              child: Text(
                "Why you want to commute?",
                style: TextStyle(fontSize: screenwidth > 420 ? 14 : 10),
              )),
          Container(
            child: DropdownButton(
              iconSize: screenwidth > 420 ? 24 : 10,
              items: [
                DropdownMenuItem<String>(
                  value: "Grocery & Vegetables",
                  child: Text(
                    "Grocery & Vegetables",
                    style: TextStyle(fontSize: screenwidth > 420 ? 12 : 10),
                  ),
                ),
                DropdownMenuItem<String>(
                  value: "Medical emergency",
                  child: Text(
                    "Medical emergency",
                    style: TextStyle(fontSize: screenwidth > 420 ? 12 : 10),
                  ),
                ),
                DropdownMenuItem<String>(
                  value: "Banking",
                  child: Text(
                    "Banking",
                    style: TextStyle(fontSize: screenwidth > 420 ? 12 : 10),
                  ),
                ),
                DropdownMenuItem<String>(
                  value: "Office/Work-Essential service",
                  child: Text(
                    "Office/Work-Essential service",
                    style: TextStyle(fontSize: screenwidth > 420 ? 12 : 10),
                  ),
                ),
                DropdownMenuItem<String>(
                  value: "Other",
                  child: Text(
                    "Other",
                    style: TextStyle(fontSize: screenwidth > 420 ? 12 : 10),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectdata2 = value.toString();
                });
              },
              hint: selectdata2 == null ? Text("Select") : Text("$selectdata2"),
            ),
          ),
        ]),
        selectdata2 == "Other"
            ? Container(
                margin: EdgeInsets.only(top: 20),
                width: 300,
                child: TextField(
                  controller: purpose,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Enter Purpose',
                    border: OutlineInputBorder(),
                  ),
                ),
              )
            : Container(),
        Container(
          width: 200,
          child: RaisedButton(
            elevation: 10,
            child: Text("Submit"),
            onPressed: () async {
              if (selectdata2 == "Other") {
                if (purpose.text.length != 0) {
                  selectdata2 = purpose.text;
                  if (selectdata1.length != 0 &&
                      selectdata2.length != 0 &&
                      personname.length != 0 &&
                      personnumber.length != 0 &&
                      personrno.length != 0) {
                    var now = new DateTime.now();
                    var formatter = new DateFormat('dd-MM-yyy');
                    String formatted = formatter.format(now);
                    await db.collection('Visitor').add({
                      'name': personname.toString(),
                      'number': personnumber.toString(),
                      'room_no': personrno.toString(),
                      'purpose': selectdata2.toString(),
                      'in_out': selectdata1.toString(),
                      'date': formatted.toString(),
                    }).then((documentReference) {
                      setState(() {
                        id = documentReference.documentID;
                      });
                    });
                    if (id == "") {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: Text(
                            "Opps Someting is wrong",
                            style: TextStyle(color: Colors.red),
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("OK"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: Text(
                            "Data is submitted",
                            style: TextStyle(color: Colors.green),
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("OK"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ),
                      );
                    }
                  } 
                }
                else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: Text(
                          "Please fill all the details",
                          style: TextStyle(color: Colors.red),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("OK"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ),
                    );
                  }
              } else if (selectdata1 != null &&
                  selectdata2 != null &&
                  personname != null &&
                  personnumber != null &&
                  personrno != null) {
                var now = new DateTime.now();
                var formatter = new DateFormat('dd-MM-yyy');
                String formatted = formatter.format(now);
                await db.collection('Visitor').add({
                  'name': personname.toString(),
                  'number': personnumber.toString(),
                  'room_no': personrno.toString(),
                  'purpose': selectdata2.toString(),
                  'in_out': selectdata1.toString(),
                  'date': formatted.toString(),
                }).then((documentReference) {
                  setState(() {
                    id = documentReference.documentID;
                  });
                });
                if (id == "") {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: Text(
                        "Opps Someting is wrong",
                        style: TextStyle(color: Colors.red),
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("OK"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: Text(
                        "Data is submitted",
                        style: TextStyle(color: Colors.green),
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("OK"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                  );
                }
              } else {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: Text(
                      "Please fill all the details",
                      style: TextStyle(color: Colors.red),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("OK"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                );
              }
            },
          ),
        )
      ],
    );
  }
}
