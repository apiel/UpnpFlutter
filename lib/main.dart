import 'package:flutter/material.dart';
import './App.dart';
import './services/DeviceDiscoverer.dart';

void main() {
  List log = ['Upnp discovery...'];
  var disc = new DeviceDiscoverer(log);
  runApp(new App(disc, log));
}
