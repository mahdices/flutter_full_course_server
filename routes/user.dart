import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:server/data/models/auth.dart';
import 'package:server/data/my_response.dart';
import 'package:server/data/repository/post_datasource.dart';
import 'package:server/data/repository/user_datasource.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.put) return updateUser(context);
  if (context.request.method == HttpMethod.get) {
    if (context.request.uri.queryParameters.isEmpty) {
      return getAllUser(context);
    } else {
      return getUser(context);
    }
  }

  return Response.json(body: 'Error', statusCode: 403);
}

Future<Response> updateUser(RequestContext context) async {
  if (!context.read<Auth>().isVerified) {
    return authErrorResponse();
  }
  final auth = context.read<Auth>();
  final json = await context.request.json();
  final firstname = json['firstname'] as String?;
  final lastname = json['lastname'] as String?;
  final phoneNumber = json['phoneNumber'] as String?;
  final location = json['location'] as Map?;
  final birthday = json['birthday'] as String?;
  final gender = json['gender'] as String?;
  final avatar = json['avatar'] as String?;
  final visible = json['visibleOnProfile'] as bool?;

  final user = await context.read<UserDatasource>().getUser(auth.username!);

  await context.read<UserDatasource>().updateUser(auth.id ?? 0,
      firstname: firstname ?? user.firstname ?? '',
      lastname: lastname ?? user.lastname ?? '',
      phoneNumber: phoneNumber ?? user.mobile ?? '',
      location: location == null
          ? jsonEncode(user.location?.toJson())
          : jsonEncode(location),
      birthday: birthday ?? user.birthday ?? '',
      gender: gender ?? user.gender ?? '',
      visible: visible ?? user.visibleGender ?? false,
      avatar: avatar ?? user.avatar ?? '');
  final updatedUser =
      await context.read<UserDatasource>().getUser(auth.username!);
  return successResponse(updatedUser.toJson());
}

Future<Response> getUser(RequestContext context) async {
  final json = context.request.uri.queryParameters;
  // print(json);
  final id = int.parse(json['id'] ?? '');

  final user = await context.read<UserDatasource>().getUserById(id);
  final posts = await context.read<PostDatasource>().getPostsOfUser(id);
  return successResponse(
    {
      'user': user.toJson(),
      'posts': posts.map((e) => e.toJson()).toList(),
    },
  );
}

Future<Response> getAllUser(RequestContext context) async {
  final users = await context.read<UserDatasource>().getAllUser();
  return successResponse(
    users.map((e) => e.toJson()).toList(),
  );
}
