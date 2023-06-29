import 'dart:developer';
import 'dart:io';

import 'package:server/data/models/user.dart';
import 'package:server/database.dart';
import 'package:server/error/not_font_exeption.dart';

class UserDatasource {
  UserDatasource(this._mysqlClient);
  final MySql _mysqlClient;

  Future<User> getUser(String username) async {
    final result = await _mysqlClient.execute(
      'SELECT * FROM users WHERE username= :username;',
      params: {"username": username},
    );
    if (result.rows.isEmpty) throw NotFoundExeption('User not found', 404);
    final user = User.fromFields(result.rows.first.typedAssoc());
    return user;
  }

  Future<User> getUserById(int id) async {
    final result = await _mysqlClient.execute(
      'SELECT * FROM users WHERE userId= :userId;',
      params: {"userId": id},
    );
    if (result.rows.isEmpty) throw NotFoundExeption('User not found', 404);
    final user = User.fromFields(result.rows.first.typedAssoc());
    return user;
  }

  Future<List<User>> getAllUser() async {
    final result = await _mysqlClient.execute(
      'SELECT * FROM users;',
    );
    if (result.rows.isEmpty) throw NotFoundExeption('User not found', 404);

    final list = <User>[];
    for (final row in result.rows) {
      list.add(User.fromFields(row.typedAssoc()));
    }
    return list;
  }

  Future<void> updateUser(
    int id, {
    required String firstname,
    required String lastname,
    required String phoneNumber,
    required String location,
    required String birthday,
    required String gender,
    required bool visible,
    required String avatar,
  }) async {
    final result = await _mysqlClient.execute(
        'UPDATE users set firstname=:firstname,lastname=:lastname,mobile=:mobile'
        ',location=:location,birthday=:birthday,gender=:gender,visibleGender='
        ':visibleGender,avatar=:avatar WHERE userId=:id;',
        params: {
          'firstname': firstname,
          'lastname': lastname,
          'mobile': phoneNumber,
          'location': location,
          'birthday': birthday,
          'gender': gender,
          'visibleGender': visible,
          'avatar': avatar,
          'id': id,
        });
    print(result);
  }

  Future<int> addUser(
    String username,
    String password,
    String firstname,
    String lastname,
    String location,
  ) async {
    print('sttttttttttt:');
    final result = await _mysqlClient.execute(
      'INSERT INTO users(username,password,firstname,lastname,location) VALUES '
      '(:username,:password,:firstname,:lastname,:location);',
      params: {
        'username': username,
        'password': password,
        'firstname': firstname,
        'lastname': lastname,
        'location': location,
      },
    ).onError((error, stackTrace) {
      throw DatabaseExeption('Username is already taken', 403);
    });

    print('sttttttttttt:${result.toString()}');

    return result.lastInsertID.toInt();
  }
}
