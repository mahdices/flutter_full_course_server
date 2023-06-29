import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

class Success {}

Response successResponse([dynamic data]) {
  final body = <String, dynamic>{'message': 'success!'};
  if (data != null) {
    body['data'] = data;
  }
  return Response.json(
    body: body,
  );
}

Response errorResponse(
  String message, {
  dynamic data,
  int statusCode = HttpStatus.badRequest,
}) {
  final body = <String, dynamic>{'message': message};
  if (data != null) {
    body['data'] = data;
  }
  return Response.json(
    body: body,
    statusCode: statusCode,
  );
}

Response authErrorResponse() => errorResponse('Auth error!', statusCode: 403);
