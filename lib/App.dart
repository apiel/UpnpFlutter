import 'package:flutter/material.dart';

// import './screens/LogScreen/LogScreen.dart';
import './screens/DevicesScreen/DevicesScreen.dart';

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new DevicesScreen(),
      // home: new LogScreen(),
    );
  }
}
