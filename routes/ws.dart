import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:server/data/config.dart';
import 'package:server/data/models/chat.dart';
import 'package:server/data/models/user.dart';
import 'package:server/data/repository/user_datasource.dart';

import '../main.dart';

Future<Response> onRequest(RequestContext context) async {
  print("A request");
  final url = context.request.url.toString();
  final token = url.substring(url.indexOf('token=') + 6);

  final jwt = JWT.verify(token, SecretKey(secret));

  final handler = webSocketHandler(
    (channel, protocol) async {
      final user = await context.read<UserDatasource>().getUser(
            jwt.payload['username'] as String,
          );

      chats.add(Chat(user: user, channel: channel));

      channel.stream.listen(
        (message) {
          for (final chat in chats) {
            // if (chat.user == user) continue;
            chat.channel.sink.add(jsonEncode(
              {
                'message': message,
                'user': user.toJson(),
              },
            ));
          }
        },
        onDone: () {
          chats.removeWhere((element) => element.user.id == user.id);
        },
      );
    },
  );

  return handler(context);
}
