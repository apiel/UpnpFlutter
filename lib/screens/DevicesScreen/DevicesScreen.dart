import 'package:flutter/material.dart';

import './../LogScreen/LogScreen.dart';

class DevicesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('First Screen'),
        actions: <Widget>[
          // action button
          new IconButton(
            icon: new Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (context) => new LogScreen()),
              );
            },
          ),
          new PopupMenuButton<FlatButton>(
            // onSelected: _select,
            itemBuilder: (BuildContext context) {
              return [
                new PopupMenuItem<FlatButton>(
                  // value: 'yo',
                  child: new FlatButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(builder: (context) => new LogScreen()),
                      );
                    },
                    child: new Text('Log'),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
    );
  }
}
