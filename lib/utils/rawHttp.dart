import 'dart:io';
import 'dart:async';

Future<String> rawHttp(String url, {
  String body: '',
  String method: 'GET',
  String contentType: 'application/json',
}) async {

  Completer c = new Completer();

  Uri uri = Uri.parse(url);
  Socket socket = await Socket.connect(uri.host, uri.port);
  String data = """$method ${uri.path} HTTP/1.1
content-type: $contentType; charset=utf-8
accept-encoding: gzip
content-length: ${body.length}
host: ${uri.host}:${uri.port}

$body""";

  socket.listen((response) {
      String res = new String.fromCharCodes(response).trim();
      c.complete(res);
    },
    onDone: () {
      print("Done");
      socket.destroy();
    });
  socket.write(data);

  new Timer(new Duration(seconds: 10), () {
    socket.destroy();
    c.completeError('Request timeout');
  });

  return c.future;
}
