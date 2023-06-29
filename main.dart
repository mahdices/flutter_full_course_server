import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:server/data/models/chat.dart';
import 'package:server/data/models/user.dart';
import 'package:server/database.dart';

final mySql = MySql();
final chats = <Chat>[];

Future<HttpServer> run(Handler handler, InternetAddress ip, int port) {
  return serve(handler.use(databaseHandler()), ip, port);
}

Middleware databaseHandler() {
  return (handler) => handler.use(
        provider<MySql>(
          (context) => mySql,
        ),
      );
}
