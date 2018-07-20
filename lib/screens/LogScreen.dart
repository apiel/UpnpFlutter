import 'package:flutter/material.dart';

import "../Globals.dart";

// instead to use this global log we might use bloc pattern

class LogScreen extends StatelessWidget {
  List<RichText> _buildList() {
    Globals globals = new Globals();
    return globals.log == null ? []
         : globals.log.map((item) =>
              new RichText(
                text: new TextSpan(
                  style: new TextStyle(
                    color: Colors.white70,
                  ),
                  children: <TextSpan>[
                    new TextSpan(text: '${item.type} ', style: new TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.lightGreen,
                    )),
                    new TextSpan(text: item.value),
                  ],
                ),
              )
            ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Console logs'),
      ),
      body: new ListView(
        reverse: true,
        children: _buildList(),
      ),
    );
  }
}
