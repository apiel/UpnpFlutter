import 'dart:async';
import 'dart:convert';

import '../Globals.dart';
import '../models/LogItem.dart';
import '../models/Device.dart';
import '../utils/rawHttp.dart';
import '../utils/extractJson.dart';

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
    String response = await rawHttp(url, method: 'POST', body: data);
    this.globals.log.insert(0, new LogItem(response, type: 'raw http'));
    return response;
  }

  Future<String> send(String action) async {
    String url = '${this.device.url}/S6QJ3NqpQzsR6ZFzOBgxSRJPW58C061um8oP8uhf/lights/${this.device.uid}/state';
    // String url = '${this.device.url}/S6QJ3NqpQzsR6ZFzOBgxSRJPW58C061um8oP8uhf/lights/state';
    String newState = action == 'ON' || (action == 'TOGGLE' && this.device.on == false) ? 'true' : 'false';
    String data = '{"on": $newState}\n';
    // print('callllllll (${this.device.on}): $url -> $data');
    String response = await callUrl(url, data);
    String jsonString = extractJson(response);
    if (jsonString != null) {
      Map decoded = json.decode(jsonString);
      Map success = decoded['success'];
      if (success != null) {
        this.device = new Device(
          this.device.uid,
          this.device.name,
          success['/lights/${this.device.uid}/state/on'],
          this.device.level,
          this.device.url);
      }
    }
    return null;
  }
}
