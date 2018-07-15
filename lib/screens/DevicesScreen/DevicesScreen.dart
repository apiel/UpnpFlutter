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
    );
  }
}
