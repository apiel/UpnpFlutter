import 'package:flutter/material.dart';

import "./LogScreenState.dart";
import "../../services/DeviceDiscoverer.dart";

class LogScreen extends StatefulWidget {
  final DeviceDiscoverer discoverer;
  final List log;
  LogScreen({Key key, this.title, this.discoverer, this.log}) : super(key: key);

  final String title;

  @override
  LogScreenState createState() => new LogScreenState();
}
