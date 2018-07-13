import 'package:flutter/material.dart';

import './services/DeviceDiscoverer.dart';
import './screens/LogScreen/LogScreen.dart';

class App extends StatelessWidget {
  DeviceDiscoverer discoverer;
  List log;

  App(DeviceDiscoverer d, List l) {
    this.discoverer = d;
    this.log = l;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new LogScreen(
        title: 'Flutter Demo Home Screen',
        discoverer: discoverer,
        log: log,
      ),
    );
  }
}
