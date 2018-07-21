// import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/LogItem.dart';
import '../models/Devices.dart';

class DeviceParser {
  List<LogItem> log;
  Devices devices;

  DeviceParser(List<LogItem> l, Devices d) {
    this.log = l;
    this.devices = d;
  }

  String getUrl(String data) {
    String url;
    RegExp regExp = new RegExp(r"LOCATION: *(.*)\s", caseSensitive: false);
    var match = regExp.firstMatch(data);
    if (match != null) {
      url = match[1];
      this.log.insert(0, new LogItem(url, type: 'upnp location'));
    }
    return url;
  }

  String isHueUrl(String url) {
    String hueUrl;
    RegExp regExp = new RegExp(r"^(.*/api)/setup.xml$", caseSensitive: false); // https?://
    var match = regExp.firstMatch(url);
    if (match != null) {
      hueUrl = match[1];
      this.log.insert(0, new LogItem(hueUrl, type: 'hue config'));
    }
    return hueUrl;
  }

  Future<String> callUrl(String url) async {
    this.log.insert(0, new LogItem(url, type: 'call url'));
    try {
      http.Response response = await http.get(url);
      this.log.insert(0, new LogItem(response.body, type: 'parse body'));
      return response.body;
    } catch (e) {
      this.log.insert(0, new LogItem(e.toString(), type: '!error'));
    }
    return null;
  }

  Future<String> parse(String data) async {
    String url = getUrl(data);
    if (url != null) {
      String hueUrl = isHueUrl(url);
      if (hueUrl != null) {
        String jsonString = await callUrl('$hueUrl/config.json');
        Map decoded = json.decode(jsonString);
        this.devices.fromJson(decoded, hueUrl);

        return jsonString;
      }
    }
    return null;
  }
}
