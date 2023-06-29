import 'dart:developer';

import 'package:server/data/models/post.dart';
import 'package:server/data/models/user.dart';
import 'package:server/database.dart';

class PostDatasource {
  PostDatasource(this._mysqlClient);
  final MySql _mysqlClient;

  Future<List<Post>> getPosts() async {
    final result = await _mysqlClient.execute(
        'SELECT * FROM posts INNER JOIN users ON users.userId=posts.owner;');
    if (result.isEmpty) return Future.error('NotFound');
    // print(result.single);

    final list = <Post>[];
    for (final row in result.rows) {
      list.add(Post.fromFields(row.typedAssoc()));
    }
    return list;
  }

  Future<List<Post>> getPostsOfUser(int id) async {
    final result = await _mysqlClient
        .execute('SELECT * FROM posts WHERE owner= :id;', params: {
      'id': id,
    });
    // print(result.rows);
    // if (result.isEmpty) return Future.error('NotFound');

    final list = <Post>[];
    for (final row in result.rows) {
      list.add(Post.fromFields(row.typedAssoc(), false));
    }
    return list;
  }

  Future<bool> addPost(
      int ownerId, String message, String date, String? image) async {
    final result = await _mysqlClient.execute(
      'INSERT INTO posts(owner, message, date,image,likes) VALUES'
      ' (:ownerId, :message, :date, :image, :likes);',
      params: {
        'ownerId': ownerId,
        'message': message,
        'date': date,
        'image': image,
        'likes': 0,
      },
    );

    return true;
  }
}
