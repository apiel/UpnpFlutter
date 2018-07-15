import 'package:flutter/material.dart';

import './../../components/BarWidget.dart';

class DevicesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new BarWidget(
        title: new Text('Devices'),
        context: context,
      ),
      body: new CustomScrollView(
        primary: false,
        slivers: <Widget>[
          new SliverPadding(
            padding: const EdgeInsets.all(20.0),
            sliver: new SliverGrid.count(
              crossAxisSpacing: 10.0,
              crossAxisCount: 2,
              children: <Widget>[
                new Card(child: new Text('He\'d have you all unravel at the')),
                new Card(child: new Text('Heed not the rabble')),
                new Card(child: new Text('Sound of screams but the')),
                new Card(child: new Text('Who scream')),
                new Card(child: new Text('Revolution is coming...')),
                new Card(child: new Text('Revolution, they...')),
              ],
            ),
          ),
        ],
      )
    );
  }
}
