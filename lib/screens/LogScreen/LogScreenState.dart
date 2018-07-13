import 'package:flutter/material.dart';
import 'dart:async';

import "./LogScreen.dart";

class LogScreenState extends State<LogScreen> {

  Future _discover() async {
    await widget.discoverer.quickDiscoverClients(() {
      setState(() {});
    });
    setState(() {});
  }

  List<Text> _buildList() {
    return widget.log == null ? []
         : widget.log.map((value) => new Text(value)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new ListView(
        reverse: true,
        children: _buildList(),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _discover,
        tooltip: 'Discover',
        child: new Icon(Icons.search),
      ),
    );
  }
}
