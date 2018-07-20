import 'package:flutter/material.dart';
import 'dart:async';

import './../components/BarWidget.dart';
import "../Globals.dart";

class DevicesScreen extends StatefulWidget {
  DevicesScreen({Key key}) : super(key: key);

  @override
  DevicesScreenState createState() => new DevicesScreenState();
}

class DevicesScreenState extends State<DevicesScreen> {

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  Globals globals;

  DevicesScreenState() {
    this.globals = new Globals();
  }

  List<Card> _buildList() {
    return this.globals.devices == null ? []
         : this.globals.devices.list.values.map((device) =>
              new Card(child: new Text(device.name))
            ).toList();
  }

  Future<Null> _handleRefresh() {
    return this.globals.discoverer.quickDiscoverClients((data) async {
      await this.globals.parser.parse(data);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new BarWidget(
        title: new Text('Devices'),
        context: context,
      ),
      body: new OrientationBuilder(
        builder: (context, orientation) {
          return  new RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _handleRefresh,
            child: new CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
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
            ),
          );
        }
      )
    );
  }
}
