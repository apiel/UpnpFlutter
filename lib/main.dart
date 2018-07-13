import 'package:flutter/material.dart';
import 'dart:io';
// import "../../upnp/lib/upnp.dart";

import 'dart:async';
import 'dart:convert';

class DeviceDiscoverer {
  RawDatagramSocket _socket;
  StreamController _clientController =
    new StreamController.broadcast();

  List log;

  DeviceDiscoverer(List l) {
    this.log = l;
  }

  Future start(VoidCallback fn) async {
    _socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4.address, 0);

    _socket.broadcastEnabled = true;
    _socket.multicastHops = 50;

    _socket.listen((event) {
      switch (event) {
        case RawSocketEvent.read:
          var packet = _socket.receive();
          _socket.writeEventsEnabled = true;

          if (packet == null) {
            return;
          }

          var data = utf8.decode(packet.data);
          print(data);
          this.log.insert(0, data);
          fn();

          break;
      }
    });
  }

  void stop() {
    if (_discoverySearchTimer != null) {
      _discoverySearchTimer.cancel();
      _discoverySearchTimer = null;
    }

    _socket.close();

    if (!_clientController.isClosed) {
      _clientController.close();
      _clientController = new StreamController.broadcast();
    }
  }

  Stream get clients => _clientController.stream;

  void search([String searchTarget]) {
    this.log.insert(0, '#### send search');
    print('send search');
    if (searchTarget == null) {
      searchTarget = "upnp:rootdevice";
    }

    var buff = new StringBuffer();

    buff.write("M-SEARCH * HTTP/1.1\r\n");
    buff.write("HOST:239.255.255.250:1900\r\n");
    buff.write('MAN:"ssdp:discover"\r\n');
    buff.write("MX:1\r\n");
    buff.write("ST:$searchTarget\r\n");
    buff.write("USER-AGENT:unix/5.1 UPnP/1.1 crash/1.0\r\n\r\n");
    var data = utf8.encode(buff.toString());

    _socket.send(data, new InternetAddress("239.255.255.250"), 1900);
  }

  Timer _discoverySearchTimer;

  Future quickDiscoverClients(VoidCallback fn) async {
    if (_socket == null) {
      await start(fn);
      await new Future.delayed(const Duration(seconds: 1));
    }

    search("upnp:rootdevice");
    new Future.delayed(new Duration(seconds: 10), () {
      stop();
    });
  }
}

void main() {
  print('helllloooo');
  List log = ['Upnp discovery...'];
  var disc = new DeviceDiscoverer(log);
  runApp(new MyApp(disc, log));
}

class MyApp extends StatelessWidget {
  DeviceDiscoverer discoverer;
  List log;

  MyApp(DeviceDiscoverer d, List l) {
    this.discoverer = d;
    this.log = l;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(
        title: 'Flutter Demo Home Page',
        discoverer: discoverer,
        log: log,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final DeviceDiscoverer discoverer;
  final List log;
  MyHomePage({Key key, this.title, this.discoverer, this.log}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

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
