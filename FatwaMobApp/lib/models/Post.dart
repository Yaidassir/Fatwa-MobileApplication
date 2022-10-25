// To parse this JSON data, do
//
//     final post = postFromJson(jsonString);

import 'dart:convert';

List<Post> postFromJson(String str) => List<Post>.from(json.decode(str).map((x) => Post.fromJson(x)));

String postToJson(List<Post> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Post {
    Post({
        this.id,
        required this.title,
        required this.typepost,
        required this.etatpost,
        required this.imamId,
        required this.userId,
        required this.createdAt,
        required this.updatedAt,
        required this.avatar,
        required this.imam_name,
        this.note,
        this.contenuText,
        this.contenuImage,
        this.contenuVideo,
        this.contenuAudio,


    });

    int? id;
    String title;
    int typepost;
    int etatpost;
    int imamId;
    int userId;
    String avatar;
    String imam_name;
    num? note;
    String? contenuText;
    String? contenuImage;
    String? contenuVideo;
    String? contenuAudio;
    DateTime createdAt;
    DateTime updatedAt;

    factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["id"],
        title: json["title"],
        typepost: json["typepost"],
        etatpost: json["etatpost"],
        imamId: json["imam_id"],
        userId: json["user_id"],
        avatar: json["avatar"],
        imam_name: json["imam_name"],
        note: json["note"],
        contenuText: json["contenu_text"],
        contenuImage: json["contenu_image"] == null ? null : json["contenu_image"],
        contenuVideo: json["contenu_video"] == null ? null : json["contenu_video"],
        contenuAudio: json["contenu_audio"] == null ? null : json["contenu_audio"],

        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "typepost": typepost,
        "etatpost": etatpost,
        "imam_id": imamId,
        "user_id": userId,
        "avatar": avatar,
        "imam_name": imam_name,
        "note": note,
        "contenu_text": contenuText,
        "contenu_image": contenuImage == null ? null : contenuImage,
        "contenu_video": contenuVideo == null ? null : contenuVideo,
        "contenu_audio": contenuAudio == null ? null : contenuAudio,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
