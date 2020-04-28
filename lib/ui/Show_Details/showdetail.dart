import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:intl/intl.dart';

class ShowDetails extends StatefulWidget {
  ShowDetails({Key key}) : super(key: key);

  @override
  _ShowDetailsState createState() => _ShowDetailsState();
}

class _ShowDetailsState extends State<ShowDetails> {
  Firestore db = Firestore.instance;

  var date = "dd-mm-yyy";
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
        margin: EdgeInsets.only(top: 20),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                "Select Date",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
              ),
              Container(
                child: FlatButton(
                  color: Colors.grey[200],
                  child: Text(
                    "$date",
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () async {
                    DateTime newDateTime = await showRoundedDatePicker(
                        context: context,
                        customWeekDays: [
                          "SUN",
                          "MON",
                          "TUE",
                          "WED",
                          "THU",
                          "FRI",
                          "SAT"
                        ],
                        theme: ThemeData(primarySwatch: Colors.green));
                    if (newDateTime != null) {
                      var formatter = new DateFormat('dd-MM-yyy');
                      String formatted = formatter.format(newDateTime);
                      setState(() => date = formatted.toString());
                    }
                  },
                ),
              )
            ]),
      ),
      date != "dd-mm-yyy"
          ? StreamBuilder(
              stream: db
                  .collection('Visitor')
                  .where("date", isEqualTo: date)
                  .snapshots(),
              builder: (context, snapshot) {
                print(snapshot.data);
                if (!snapshot.hasData) {
                  return Container();
                } else {
                  return ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.all(10),
                      itemBuilder: (BuildContext context, index) {
                        return Column(children: <Widget>[
                          Divider(),
                          Row(children: <Widget>[
                            Container(
                                width: MediaQuery.of(context).size.width / 6,
                                padding: EdgeInsets.all(5),
                                child: Text(
                                    "${snapshot.data.documents[index]['name']}")),
                            Container(
                                width: MediaQuery.of(context).size.width / 5.3,
                                padding: EdgeInsets.all(5),
                                child: Text(
                                    "${snapshot.data.documents[index]['number']}")),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              width: MediaQuery.of(context).size.width / 7,
                              padding: EdgeInsets.all(5),
                              child: Text(
                                  "${snapshot.data.documents[index]['room_no']}"),
                            ),
                            Container(
                                margin: EdgeInsets.only(left: 10),
                                width: MediaQuery.of(context).size.width / 4,
                                child: Text(
                                    "${snapshot.data.documents[index]['purpose']}")),
                            Container(
                                margin: EdgeInsets.only(left: 5),
                                width: MediaQuery.of(context).size.width / 12,
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  "${snapshot.data.documents[index]['in_out']}",
                                  textAlign: TextAlign.right,
                                )),
                            Spacer()
                          ]),
                          Divider(),
                        ]);
                      });
                }
              },
            )
          : Container()
    ]);
  }
}
