import 'dart:io';
import 'dart:async';

Future time(int time) async {

  Completer c = new Completer();
  new Timer(new Duration(seconds: time), (){
    c.complete('done with time out');
  });

  return c.future;
}
