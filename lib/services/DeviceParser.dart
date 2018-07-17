// import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;

import '../models/LogItem.dart';

class DeviceParser {
  List<LogItem> log;

  DeviceParser(List<LogItem> l) {
    this.log = l;
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

  Future<String> callUrl(String url) async {
    http.Response response = await http.get(url).timeout(
        const Duration(seconds: 5),
        onTimeout: () => null
      );

    this.log.insert(0, new LogItem(response.body, type: 'parse body'));
    return response.body;
  }

  Future<String> parse(String data) {
    String url = getUrl(data);
    return callUrl(url);
  }
}
