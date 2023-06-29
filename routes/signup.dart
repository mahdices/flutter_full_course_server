import 'dart:convert';

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
  final firstname = body['firstname'] as String;
  final lastname = body['lastname'] as String;
  final location = body['location'];

  final data = context.read<UserDatasource>();
  final insertId = await data.addUser(
    username,
    DBCrypt().hashpw(
      password,
      DBCrypt().gensalt(),
    ),
    firstname,
    lastname,
    jsonEncode(location),
  );
  final token =
      JWT({'username': username, 'id': insertId}).sign(SecretKey(secret));
  // await data.setToken(insertId, token);

  return successResponse();
}
