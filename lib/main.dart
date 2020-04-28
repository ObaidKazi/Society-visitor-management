import 'package:flutter/material.dart';
import 'package:shankheshwar_pallazo/ui/Show_Details/showdetail.dart';
import 'ui/Entry/entrypage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shankheshwar Pallazo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Shankheshwar Pallazo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _selectedpage = 0;
  final _pageoption = [
    Entry(
      key: PageStorageKey('Page1'),
    ),
    ShowDetails(
      key: PageStorageKey('Page2'),
    ),
  ];
  final PageStorageBucket bucket = PageStorageBucket();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _pageoption[_selectedpage],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        elevation:10 ,
        selectedFontSize: 12,
        unselectedItemColor: Colors.black,
        currentIndex: _selectedpage, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(        
            icon: new Icon(Icons.edit),
            title: new Text('Entry'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.storage),
            title: new Text('Show Details'),
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedpage = index;
          });
        },
      ),
    );
  }
}
