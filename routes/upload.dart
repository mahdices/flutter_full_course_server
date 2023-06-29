import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import '../lib/data/my_response.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.post) {
    final request = context.request;
    final formData = await request.formData();
    final photo = formData.files['photo'];
    if (photo == null) {
      return errorResponse('images must send with photo parameter');
    }
    await File('public/images/${photo.name}')
        .writeAsBytes(await photo.readAsBytes());
    return successResponse({'url': '/images/${photo.name}'});
  }

  return errorResponse('images must send post with photo parameter');
}
