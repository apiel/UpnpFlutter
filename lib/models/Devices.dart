import './Device.dart';

class Devices {
  Map<String, Device> list = {};

  Devices();

  fromJson(Map json) {
    json['lights'].forEach((key, value) =>
      this.list[key] = new Device.fromJson(value)
    );
  }
}
