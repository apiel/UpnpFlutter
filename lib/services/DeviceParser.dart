// import 'dart:io';
import 'dart:async';
import 'dart:convert';

import '../utils/rawHttp.dart';
import '../utils/extractJson.dart';

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
    String response = await rawHttp(url);
    this.log.insert(0, new LogItem(response, type: 'raw http'));
    return response;
  }

  Future<String> parse(String data) async {
    String url = getUrl(data);
    if (url != null) {
      String hueUrl = isHueUrl(url);
      if (hueUrl != null) {
        String response = await callUrl('$hueUrl/config.json');
        String jsonString = extractJson(response);
        if (jsonString != null) {
          Map decoded = json.decode(jsonString);
          this.devices.fromJson(decoded, hueUrl);
        }
        return jsonString;
      }
    }
    return null;
  }
}
