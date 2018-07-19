import './Device.dart';

class Devices {
  List<Device> list;

  Devices(this.list);

  Devices.fromJson(Map json) {
    this.list = [];
    json['lights'].forEach((key, value) =>
      this.list.add(new Device.fromJson(value))
    );
  }
}
