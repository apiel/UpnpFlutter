
import './services/DeviceDiscoverer.dart';

class Globals {
  static final Globals _singleton = new Globals._internal();
  DeviceDiscoverer discoverer;
  List log;

  factory Globals() {
    return _singleton;
  }

  Globals._internal() {
    this.log = ['Upnp discovery...'];
    this.discoverer = new DeviceDiscoverer(this.log);
  }
}
