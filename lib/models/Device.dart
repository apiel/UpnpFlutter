class Device {
  final String name;
  final String uid;
  final bool on;
  final int level;
  final String url;

  Device(this.uid, this.name, this.on, this.level, this.url);

  Device.fromJson(Map json)
      : name = json['name'],
        uid = json['uniqueid'],
        on = json['state']['on'],
        level = json['state']['bri'],
        url = '';
}
