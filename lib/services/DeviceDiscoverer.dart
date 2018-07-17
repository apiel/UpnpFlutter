import 'dart:io';

import 'dart:async';
import 'dart:convert';

import '../models/LogItem.dart';

class DeviceDiscoverer {
  RawDatagramSocket _socket;
  StreamController _clientController =
    new StreamController.broadcast();

  List<LogItem> log;

  DeviceDiscoverer(List<LogItem> l) {
    this.log = l;
  }

  Future start(void Function(String) fn) async {
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
          this.log.insert(0, new LogItem(data, type: 'upnp'));
          fn(data);

          // maybe we dont do this here
          // RegExp regExp = new RegExp(r"LOCATION: *(.*)\s", caseSensitive: false);
          // var match = regExp.firstMatch(data);
          // if (match != null) {
          //   this.log.insert(0, new LogItem(match[1], type: 'upnp location'));
          //   fn();
          // }

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
    this.log.insert(0, new LogItem('send upnp search'));
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

  Future quickDiscoverClients(void Function(String) fn) async {
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
