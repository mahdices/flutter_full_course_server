abstract class ServerExeptions implements Exception {
  const ServerExeptions(this.message, this.code);

  final String message;
  final int code;

  Map<String, dynamic> get response => {
        'message': message,
      };
}
