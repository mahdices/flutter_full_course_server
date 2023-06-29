import 'dart:convert';
import 'dart:math';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:server/data/config.dart';
import 'package:server/data/models/auth.dart';
import 'package:server/data/my_response.dart';
import 'package:server/data/repository/post_datasource.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.post) return createPost(context);
  if (context.request.method == HttpMethod.get) return getPosts(context);

  return Response.json(body: 'Error', statusCode: 403);
}

Future<Response> createPost(RequestContext context) async {
  if (!context.read<Auth>().isVerified) {
    return authErrorResponse();
  }
  final auth = context.read<Auth>();
  var json = await context.request.json();
  var date = DateTime.now();

  final image = (json['image'] as String?);

  var data = context.read<PostDatasource>().addPost(
        auth.id!,
        json['message'] as String,
        date.toIso8601String(),
        image,
      );
  return successResponse();
}

Future<Response> getPosts(RequestContext context) async {
  var data = await context.read<PostDatasource>().getPosts();
  return successResponse(data.map((e) => e.toJson()).toList());
}
