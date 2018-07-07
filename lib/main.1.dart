import 'package:flutter/material.dart';
import 'dart:io';
// import "../../upnp/lib/upnp.dart";

import 'dart:async';
import 'dart:convert';

final InternetAddress _v4_Multicast = new InternetAddress("239.255.255.250");

class DeviceDiscoverer {
  RawDatagramSocket _socket;
  StreamController/*<DiscoveredClient>*/ _clientController =
    new StreamController.broadcast();

  List<NetworkInterface> _interfaces;

  Future start() async {
    _socket = await RawDatagramSocket.bind(InternetAddress.ANY_IP_V4.address, 0);

    _socket.broadcastEnabled = true;
    _socket.multicastHops = 50;

    _socket.listen((event) {
      switch (event) {
        case RawSocketEvent.READ:
          var packet = _socket.receive();
          _socket.writeEventsEnabled = true;

          if (packet == null) {
            return;
          }

          var data = UTF8.decode(packet.data);
          print(data);

          break;
        case RawSocketEvent.WRITE:
          break;
      }
    });

    _interfaces = await NetworkInterface.list();
    var joinMulticastFunction = _socket.joinMulticast;
    for (var interface in _interfaces) {
      withAddress(InternetAddress address) {
        try {
          Function.apply(joinMulticastFunction, [
            address
          ], {
            #interface: interface
          });
        } on NoSuchMethodError {
          Function.apply(joinMulticastFunction, [
            address,
            interface
          ]);
        }
      }

      try {
        withAddress(_v4_Multicast);
      } catch (_) {}
    }
  }

  void stop() {
    if (_discoverySearchTimer != null) {
      _discoverySearchTimer.cancel();
      _discoverySearchTimer = null;
    }

    _socket.close();

    if (!_clientController.isClosed) {
      _clientController.close();
      _clientController = new StreamController/*<DiscoveredClient>*/.broadcast();
    }
  }

  Stream/*<DiscoveredClient>*/ get clients => _clientController.stream;

  void search([String searchTarget]) {
    print('send search');
    if (searchTarget == null) {
      searchTarget = "upnp:rootdevice";
    }

    var buff = new StringBuffer();

    buff.write("M-SEARCH * HTTP/1.1\r\n");
    buff.write("HOST:239.255.255.250:1900\r\n");
    buff.write('MAN:"ssdp:discover"\r\n');
    buff.write("MX:1\r\n");
    buff.write("ST:${searchTarget}\r\n");
    buff.write("USER-AGENT:unix/5.1 UPnP/1.1 crash/1.0\r\n\r\n");
    var data = UTF8.encode(buff.toString());

    _socket.send(data, _v4_Multicast, 1900);
  }

  Timer _discoverySearchTimer;

  Stream quickDiscoverClients() async* {
    if (_socket == null) {
      await start();
      await new Future.delayed(const Duration(seconds: 1));
    }

    search("upnp:rootdevice");
    new Future.delayed(new Duration(seconds: 10), () {
      stop();
    });

    yield* clients;
  }
}

// main() async {
//   var disc = new DeviceDiscoverer();
//   disc.quickDiscoverClients().listen((client) async {
//     print('client');
//     print(client);
//   });
// }



void main() async {
  print('helllloooo');
    // RawDatagramSocket.bind(new InternetAddress("239.255.255.250"), 1900).then((RawDatagramSocket socket){
    //     // socket.listen((RawSocketEvent event) {
    //     //   print('recevied something again');
    //     //   if(event == RawSocketEvent.read) {
    //     //     // Datagram dg = socket.receive();
    //     //     // dg.data.forEach((x) => print(x));

    //     //     print('--> read');
    //     //     var packet = socket.receive();
    //     //     // var data = UTF8.decode(packet.data);
    //     //     print(packet.data);
    //     //   } else if (event == RawSocketEvent.write) {
    //     //     print('--> write');
    //     //   } else if (event == RawSocketEvent.closed) {
    //     //     print('--> closed');
    //     //   } else if (event == RawSocketEvent.readClosed) {
    //     //     print('--> readClosed');
    //     //   }
    //     // });

    //     print('Datagram socket ready to receive');
    //     print('${socket.address.address}:${socket.port}');
    //     socket.listen((RawSocketEvent e){
    //       Datagram d = socket.receive();
    //       if (d == null) return;

    //       String message = new String.fromCharCodes(d.data).trim();
    //       print('Datagram from ${d.address.address}:${d.port}: ${message}');
    //     });
    // });

  // RawDatagramSocket socket = await RawDatagramSocket.bind(new InternetAddress("239.255.255.250"), 1900, reuseAddress: true);

  // socket.listen((RawSocketEvent e){
  //         print('recevied something again');
  //         if(e == RawSocketEvent.read) {
  //           print('--> read');
  //           Datagram d = socket.receive();
  //           if (d == null) return;

  //           String message = new String.fromCharCodes(d.data).trim();
  //           print('Datagram from ${d.address.address}:${d.port}: ${message}');

  //         } else if (e == RawSocketEvent.write) {
  //           print('--> write');
  //         } else if (e == RawSocketEvent.closed) {
  //           print('--> closed');
  //         } else if (e == RawSocketEvent.readClosed) {
  //           print('--> readClosed');
  //         }
  // });

  var disc = new DeviceDiscoverer();
  disc.quickDiscoverClients().listen((client) async {
    print('client');
    print(client);
  });

  runApp(new MyApp(null));
}

class MyApp extends StatelessWidget {
  RawDatagramSocket socket;

  MyApp(RawDatagramSocket s) {
    this.socket = s;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(
        title: 'Flutter Demo Home Page',
        channel: socket,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final RawDatagramSocket channel;
  MyHomePage({Key key, this.title, this.channel}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    // NTP.getNtpTime();

    int port = 1900;
    widget.channel.send('Hello from UDP land!\n'.codeUnits,
      new InternetAddress("239.255.255.250"), port);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
      ),
      body: new Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: new Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug paint" (press "p" in the console where you ran
          // "flutter run", or select "Toggle Debug Paint" from the Flutter tool
          // window in IntelliJ) to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'You have pushed yo the button this many times:',
            ),
            new Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
            // StreamBuilder(
            //   stream: widget.channel.receive(),
            //   builder: (context, snapshot) {
                
            //   },
            // )
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

// class NTP{
//   static getNtpTime() async {
//     RawDatagramSocket socket = await RawDatagramSocket.bind(new InternetAddress("239.255.255.250"), 1900);

//     socket.listen((RawSocketEvent e){
//       Datagram d = socket.receive();
//       if (d == null) return;

//       String message = new String.fromCharCodes(d.data).trim();
//       print('Datagram from ${d.address.address}:${d.port}: ${message}');
//     });

//     print('Sending from ${socket.address.address}:${socket.port}');
//     int port = 1900;
//     socket.send('Hello from UDP land!\n'.codeUnits,
//       new InternetAddress("239.255.255.250"), port);
//   }
// }
