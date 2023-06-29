import 'package:mysql_client/mysql_client.dart';
import 'package:server/error/not_font_exeption.dart';

class MySql {
  factory MySql() {
    return _inst;
  }
  MySql._internal() {
    _connect();
  }
  MySQLConnection? _connection;
  static final MySql _inst = MySql._internal();

  Future<void> _connect() async {
    _connection = await MySQLConnection.createConnection(
      host: '127.0.0.1',
      port: 3306,
      userName: 'root',
      password: '12345678',
      databaseName: 'test',
    );
    await _connection?.connect();
  }

  Future<IResultSet> execute(
    String query, {
    Map<String, dynamic>? params,
  }) async {
    if (_connection == null) {
      await _connect();
    }
    try {
      final result = await _connection!.execute(query, params);
      return result;
    } catch (e) {
      print(e);
      throw DatabaseExeption(e.toString(), 400);
    }
  }
}
