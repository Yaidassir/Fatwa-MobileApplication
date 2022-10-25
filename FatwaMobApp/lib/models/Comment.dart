// To parse this JSON data, do
//
//     final comment = commentFromJson(jsonString);

import 'dart:convert';

List<Comment> commentFromJson(String str) => List<Comment>.from(json.decode(str).map((x) => Comment.fromJson(x)));

String commentToJson(List<Comment> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Comment {
    Comment({
        this.id,
        required this.contenu,
        required this.postId,
        required this.userId,
        required this.createdAt,
        this.updatedAt,
        required this.avatar,
        required this.username,
    });

    int? id;
    String contenu;
    int postId;
    int userId;
    DateTime createdAt;
    DateTime? updatedAt;
    String avatar;
    String username;
    factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["id"],
        contenu: json["contenu"],
        postId: json["post_id"],
        userId: json["user_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        avatar: json["avatar"],
        username: json["username"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "contenu": contenu,
        "post_id": postId,
        "user_id": userId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "avatar": avatar,
        "username":username,
    };
}

