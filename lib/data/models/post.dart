import 'dart:convert';
import 'package:server/data/models/user.dart';

class Post {
  Post(
      this.id, this.owner, this.message, this.dateTime, this.image, this.likes);
  factory Post.fromFields(Map<String, dynamic> json, [bool hasUser = true]) {
    return Post(
      json['postId'] as int,
      hasUser ? User.fromFields(json) : null,
      json['message'] as String,
      DateTime.parse((json['date'] as String)).toIso8601String(),
      json['image'] as String?,
      json['likes'] as int?,
    );
  }

  // factory Post.fromJson(Map<String, dynamic> json) => Post(json['id'], User.fromJson(), message, dateTime, image, likes)

  Map<String, dynamic> toJson() {
    final data = {
      'id': id,
      'message': message,
      'date': dateTime,
      'image': image,
      'likes': likes,
    };
    if (owner != null) {
      data['owner'] = owner!.toJson();
    }
    return data;
  }

  final int id;
  final User? owner;
  final String message;
  final String dateTime;
  final String? image;
  final int? likes;
}
