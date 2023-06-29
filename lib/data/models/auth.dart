import 'package:server/data/models/user.dart';

class Auth {
  Auth(this.id, this.username, this.isVerified);

  final int? id;
  final String? username;
  final bool isVerified;

  factory Auth.authorized(int id, String username) {
    return Auth(id, username, true);
  }
  factory Auth.failed() {
    return Auth(null, null, false);
  }
}
