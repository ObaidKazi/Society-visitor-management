import 'package:flutter/material.dart';

class ManualEntry extends StatefulWidget {
  ManualEntry({Key key}) : super(key: key);

  @override
  _ManualEntryState createState() => _ManualEntryState();
}

class _ManualEntryState extends State<ManualEntry> {
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  TextEditingController t3 = TextEditingController();
  Widget build(BuildContext context) {
    return Material(
      child: ListView(padding: EdgeInsets.all(30), children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.width > 420 ? 120 : 80,
        ),
        TextField(
          controller: t1,
          keyboardType: TextInputType.text,
          maxLength: 35,
          decoration: InputDecoration(
              border: OutlineInputBorder(), labelText: 'Enter Person Name'),
        ),
        TextField(
          controller: t2,
          keyboardType: TextInputType.number,
          maxLength: 12,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter Person Mobile No'),
        ),
        TextField(
          controller: t3,
          maxLength: 6,
          decoration: InputDecoration(
              border: OutlineInputBorder(), labelText: 'Enter Room No'),
        ),
        RaisedButton(
            child: Text("Submit"),
            onPressed: () {
              if (t1.text.length != 0 &&
                  t2.text.length != 0 &&
                  t3.text.length != 0) {
                var persondata = [t1.text, t2.text, t3.text];
                Navigator.pop(context, persondata);
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
            })
      ]),
    );
  }
}
