import 'package:dart_frog/dart_frog.dart';
import 'package:server/data/models/auth.dart';
import 'package:server/data/my_response.dart';
import 'package:server/data/repository/likes_datasource.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.post) return like(context);

  return Response.json(body: 'Error', statusCode: 403);
}

Future<Response> like(RequestContext context) async {
  if (!context.read<Auth>().isVerified) {
    return authErrorResponse();
  }
  final auth = context.read<Auth>();
  final json = await context.request.json();

  final postId = json['postId'] as int?;
  if (postId == null) {
    return errorResponse('insert postId!');
  }

  var data = await context.read<LikesDatasource>().like(postId, auth.id!);
  return successResponse({'isLiked': data});
}
