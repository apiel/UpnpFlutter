import './Device.dart';

class Devices {
  List<Device> list = [];

  Devices();

  fromJson(Map json) {
    json['lights'].forEach((key, value) =>
      this.list.add(new Device.fromJson(value))
    );
  }
}
