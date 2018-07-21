import 'dart:async';

import '../Globals.dart';
import '../models/LogItem.dart';
import '../models/Device.dart';
import '../utils/rawHttp.dart';

class DeviceService {
  Globals globals;
  Device device;

  DeviceService(Device d) {
    globals = new Globals();
    this.device = d;
  }

  // same as DeviceParser maybe we can put this somewhere else
  Future<String> callUrl(String url, String data) async {
    this.globals.log.insert(0, new LogItem(url, type: 'call url'));
    try {
      await rawHttp(url, method: 'POST', body: data);
    } catch (e) {
      this.globals.log.insert(0, new LogItem(e.toString(), type: '!error post'));
    }
    return null;
  }

  Future<String> send(String action) async {
    String url = '${this.device.url}/S6QJ3NqpQzsR6ZFzOBgxSRJPW58C061um8oP8uhf/lights/${this.device.uid}/state';
    // String url = '${this.device.url}/S6QJ3NqpQzsR6ZFzOBgxSRJPW58C061um8oP8uhf/lights/state';
    String newState = action == 'ON' || (action == 'TOGGLE' && this.device.on == false) ? 'true' : 'false';
    String data = '{"on": $newState}\n';
    print('callllllll (${this.device.on}): $url -> $data');
    String jsonString = await callUrl(url, data);
    // Map decoded = json.decode(jsonString);
    print('send response');
    print(jsonString);
    return null;
  }
}
