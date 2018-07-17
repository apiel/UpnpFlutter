
import './services/DeviceDiscoverer.dart';
import './models/LogItem.dart';


class Globals {
  static final Globals _singleton = new Globals._internal();
  DeviceDiscoverer discoverer;
  List<LogItem> log;

  factory Globals() {
    return _singleton;
  }

  Globals._internal() {
    this.log = [new LogItem('Upnp discovery...')];
    // this.log = ['Upnp discovery...'];
    this.discoverer = new DeviceDiscoverer(this.log);
  }
}
