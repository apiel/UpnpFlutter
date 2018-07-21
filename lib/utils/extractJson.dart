
String extractJson(String data) {
  RegExp regExp = new RegExp(r"({.*\:\{.*\:.*\}\})");
  var match = regExp.firstMatch(data);
  if (match != null) {
    return match[1];
  }
  return null;
}
