
import './services/DeviceDiscoverer.dart';

class LogItem {
  String type = 'default';
  String value;

  LogItem(String value, { type: 'default' }) {
    this.type = type;
    this.value = value;
  }
}

class Globals {
  static final Globals _singleton = new Globals._internal();
  DeviceDiscoverer discoverer;
  List log;

  factory Globals() {
    return _singleton;
  }

  Globals._internal() {
    // this.log = [new LogItem('Upnp discovery...')];
    this.log = ['Upnp discovery...'];
    this.discoverer = new DeviceDiscoverer(this.log);
  }
}
