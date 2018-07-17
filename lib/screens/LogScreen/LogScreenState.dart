import 'package:flutter/material.dart';
import 'dart:async';

import "./LogScreen.dart";
import "../../Globals.dart";

class LogScreenState extends State<LogScreen> {

  Globals globals;

  LogScreenState() {
    this.globals = new Globals();
  }

  Future _discover() async {
    await this.globals.discoverer.quickDiscoverClients(() {
      setState(() {});
    });
    setState(() {});
  }

  List<RichText> _buildList() {
    return this.globals.log == null ? []
         : this.globals.log.map((item) =>


              new RichText(
                text: new TextSpan(
                  style: new TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    new TextSpan(text: '${item.type} ', style: new TextStyle(fontWeight: FontWeight.bold)),
                    new TextSpan(text: item.value),
                  ],
                ),
              )



              // new RichText(
              //   children: <TextSpan>[
              //   new TextSpan(text: item.type, style: new TextStyle(fontWeight: FontWeight.bold)),
              //   new TextSpan(text: item.value),
              // ])
            ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Flutter Demo Home Screen'),
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
