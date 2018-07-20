import 'package:flutter/material.dart';

// import './screens/LogScreen/LogScreen.dart';
import './screens/DevicesScreen.dart';

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My home bridge',
      // color: Colors.blue,
      // theme: new ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      theme: new ThemeData.dark(),
      home: new DevicesScreen(),
      // home: new LogScreen(),
    );
  }
}
