import 'package:dart_frog/dart_frog.dart';
import 'package:server/data/repository/post_datasource.dart';
import 'package:server/database.dart';

Future<Response> onRequest(RequestContext context) async {
  var data = await context.read<PostDatasource>().getPosts();
  return Response(body: "lkjlask;jd");
}
