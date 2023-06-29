import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:server/data/config.dart';
import 'package:server/data/my_response.dart';
import 'package:server/data/repository/user_datasource.dart';

Future<Response> onRequest(RequestContext context) async {
  final body = await context.request.json();
  final username = body['username'] as String;
  final password = body['password'] as String;

  final data = context.read<UserDatasource>();
  final user = await data.getUser(username);
  final isPasswordCorrect = DBCrypt().checkpw(password, user.password ?? '');
  print('asdsasdasdasdadasd');
  if (isPasswordCorrect) {
    var json = user.toJsonLogin();
    json['token'] =
        JWT({'username': username, 'id': user.id}).sign(SecretKey(secret));
    return successResponse(json);
  }
  return errorResponse(
    'Username or password is incorrect',
    statusCode: HttpStatus.forbidden,
  );
}
