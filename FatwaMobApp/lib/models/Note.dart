// To parse this JSON data, do
//
//     final note = noteFromJson(jsonString);

import 'dart:convert';

Note noteFromJson(String str) => Note.fromJson(json.decode(str));

String noteToJson(Note data) => json.encode(data.toJson());

class Note {
    Note({
        this.id,
        required this.note,
        required this.postId,
        required this.userId,
        this.createdAt,
        this.updatedAt,
    });

    int? id;
    int note;
    int postId;
    int userId;
    DateTime? createdAt;
    DateTime? updatedAt;

    factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json["id"],
        note: json["note"],
        postId: json["post_id"],
        userId: json["user_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "note": note,
        "post_id": postId,
        "user_id": userId,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
    };
}
