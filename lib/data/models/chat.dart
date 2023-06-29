import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:server/data/models/user.dart';

class Chat {
  Chat({required this.user, required this.channel});

  final User user;
  final WebSocketChannel channel;
}
