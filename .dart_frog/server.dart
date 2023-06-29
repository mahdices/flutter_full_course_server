// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, implicit_dynamic_list_literal

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../main.dart' as entrypoint;
import '../routes/ws.dart' as ws;
import '../routes/user.dart' as user;
import '../routes/upload.dart' as upload;
import '../routes/signup.dart' as signup;
import '../routes/post.dart' as post;
import '../routes/login.dart' as login;
import '../routes/like.dart' as like;
import '../routes/index.dart' as index;

import '../routes/_middleware.dart' as middleware;

void main() async {
  final address = InternetAddress.anyIPv6;
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  hotReload(() => createServer(address, port));
}

Future<HttpServer> createServer(InternetAddress address, int port) {
  final handler = Cascade().add(createStaticFileHandler()).add(buildRootHandler()).handler;
  return entrypoint.run(handler, address, port);
}

Handler buildRootHandler() {
  final pipeline = const Pipeline().addMiddleware(middleware.middleware);
  final router = Router()
    ..mount('/', (context) => buildHandler()(context));
  return pipeline.addHandler(router);
}

Handler buildHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/ws', (context) => ws.onRequest(context,))..all('/user', (context) => user.onRequest(context,))..all('/upload', (context) => upload.onRequest(context,))..all('/signup', (context) => signup.onRequest(context,))..all('/post', (context) => post.onRequest(context,))..all('/login', (context) => login.onRequest(context,))..all('/like', (context) => like.onRequest(context,))..all('/', (context) => index.onRequest(context,));
  return pipeline.addHandler(router);
}
