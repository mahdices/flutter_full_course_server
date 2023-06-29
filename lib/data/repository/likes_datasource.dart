import 'dart:developer';

import 'package:server/data/models/post.dart';
import 'package:server/data/models/user.dart';
import 'package:server/database.dart';

class LikesDatasource {
  LikesDatasource(this._mysqlClient);
  final MySql _mysqlClient;

  Future<bool> like(
    int postId,
    int userId,
  ) async {
    final fetchResult = await _mysqlClient.execute(
      'SELECT * FROM likes WHERE postId=:postId AND userId=:userId',
      params: {
        'postId': postId,
        'userId': userId,
      },
    );
    if (fetchResult.rows.isEmpty) {
      await _mysqlClient.execute(
        'INSERT INTO likes (userId,postId) VALUES (:userId,:postId)',
        params: {
          'postId': postId,
          'userId': userId,
        },
      );
      return true;
    }
    await _mysqlClient.execute(
      'DELETE FROM likes WHERE userId=:userId AND postId=:postId',
      params: {
        'postId': postId,
        'userId': userId,
      },
    );
    // final result = await _mysqlClient.execute(
    //   'INSERT INTO likes(userId, postId) SELECT :postId ,:userId FROM likes WHERE userId = :userId AND postId = :postId HAVING COUNT(userId) = 0;',
    //   params: {
    //     'postId': postId,
    //     'userId': userId,
    //   },
    // );

    // print(result);

    return false;
  }
}
