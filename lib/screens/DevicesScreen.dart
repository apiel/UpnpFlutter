import 'package:flutter/material.dart';

import './../components/BarWidget.dart';
import "../Globals.dart";

class DevicesScreen extends StatefulWidget {
  DevicesScreen({Key key}) : super(key: key);

  @override
  DevicesScreenState createState() => new DevicesScreenState();
}

class DevicesScreenState extends State<DevicesScreen> {

  Globals globals;

  DevicesScreenState() {
    this.globals = new Globals();
  }

  List<Card> _buildList() {
    return this.globals.devices == null ? []
         : this.globals.devices.list.map((device) =>
              new Card(child: new Text(device.name))
            ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new BarWidget(
        title: new Text('Devices'),
        context: context,
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return new CustomScrollView(
            primary: false,
            slivers: <Widget>[
              new SliverPadding(
                padding: const EdgeInsets.all(20.0),
                sliver: new SliverGrid.count(
                  crossAxisSpacing: 10.0,
                  crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
                  children: this._buildList(),
                ),
              ),
            ],
          );
        }
      )
    );
  }
}
