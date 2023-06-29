import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:server/data/config.dart';
import 'package:server/data/models/auth.dart';
import 'package:server/data/models/user.dart';
import 'package:server/data/my_response.dart';
import 'package:server/data/repository/likes_datasource.dart';
import 'package:server/data/repository/post_datasource.dart';
import 'package:server/data/repository/user_datasource.dart';
import 'package:server/database.dart';
import 'package:server/error/not_font_exeption.dart';

Handler middleware(Handler handler) {
  return handler.use(requestLogger()).use(injectionHandler()).use((handler) {
    return (context) async {
      try {
        final response = await handler(context);
        return response;
      } catch (e) {
        if (e is NotFoundExeption) {
          return Response.json(body: e.response, statusCode: e.code);
        }
        if (e is DatabaseExeption) {
          return errorResponse(e.message);
        }
        return Response.json();
      }
    };
  });
}

Middleware injectionHandler() {
  return (handler) {
    return handler
        .use(provider<Auth>((context) {
          final auth = context.request.headers['Authorization'];
          if (auth == null) return Auth.failed();
          final data = JWT.verify(auth.split(' ')[1], SecretKey(secret));
          return Auth.authorized(
            data.payload['id'] as int,
            data.payload['username'] as String,
          );
        }))
        .use(
          provider<UserDatasource>(
            (context) => UserDatasource(context.read<MySql>()),
          ),
        )
        .use(
          provider<LikesDatasource>(
            (context) => LikesDatasource(context.read<MySql>()),
          ),
        )
        .use(
          provider<PostDatasource>(
            (context) => PostDatasource(context.read<MySql>()),
          ),
        );
  };
}
