import 'package:server/error/server_exeptions.dart';

class NotFoundExeption extends ServerExeptions {
  NotFoundExeption(super.message, super.code);
}

class DatabaseExeption extends ServerExeptions {
  DatabaseExeption(super.message, super.code);
}
