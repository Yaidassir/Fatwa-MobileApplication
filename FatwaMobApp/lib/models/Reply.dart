// To parse this JSON data, do
//
//     final reply = replyFromJson(jsonString);

import 'dart:convert';

List<Reply> replyFromJson(String str) => List<Reply>.from(json.decode(str).map((x) => Reply.fromJson(x)));

String replyToJson(List<Reply> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Reply {
    Reply({
        this.id,
        required this.contenu,
        required this.questionId,
        this.userId,
        required this.createdAt,
        this.updatedAt,
        required this.imamName,
        required this.imamAvatar,
        this.user,
    });

    int? id;
    String contenu;
    int questionId;
    int? userId;
    DateTime createdAt;
    DateTime? updatedAt;
    String imamName;
    String imamAvatar;
    User? user;

    factory Reply.fromJson(Map<String, dynamic> json) => Reply(
        id: json["id"],
        contenu: json["contenu"],
        questionId: json["question_id"],
        userId: json["user_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        imamName: json["imam_name"],
        imamAvatar: json["imam_avatar"],
        user: User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "contenu": contenu,
        "question_id": questionId,
        "user_id": userId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "imam_name": imamName,
        "imam_avatar": imamAvatar,
        "user": user!.toJson(),
    };
}

class User {
    User({
        this.id,
        this.name,
        this.lastname,
        this.dateofbirth,
        this.email,
        this.phonenumber,
        this.usertype,
        this.etatcompte,
        this.emailVerifiedAt,
        this.createdAt,
        this.updatedAt,
        this.avatar,
        this.description,
        this.imam,
    });

    int? id;
    String? name;
    String? lastname;
    DateTime? dateofbirth;
    String? email;
    String? phonenumber;
    int? usertype;
    int? etatcompte;
    DateTime? emailVerifiedAt;
    DateTime? createdAt;
    DateTime? updatedAt;
    String? avatar;
    String? description;
    Imam? imam;

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        lastname: json["lastname"],
        dateofbirth: DateTime.parse(json["dateofbirth"]),
        email: json["email"],
        phonenumber: json["phonenumber"],
        usertype: json["usertype"],
        etatcompte: json["etatcompte"],
        emailVerifiedAt: DateTime.parse(json["email_verified_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        avatar: json["avatar"],
        description: json["description"],
        imam: Imam.fromJson(json["imam"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "lastname": lastname,
        "dateofbirth": "${dateofbirth!.year.toString().padLeft(4, '0')}-${dateofbirth!.month.toString().padLeft(2, '0')}-${dateofbirth!.day.toString().padLeft(2, '0')}",
        "email": email,
        "phonenumber": phonenumber,
        "usertype": usertype,
        "etatcompte": etatcompte,
        "email_verified_at": emailVerifiedAt!.toIso8601String(),
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "avatar": avatar,
        "description": description,
        "imam": imam!.toJson(),
    };
}

class Imam {
    Imam({
        this.id,
        this.profilPicture,
        this.description,
        this.justificatif,
        this.userImam,
        this.createdAt,
        this.updatedAt,
    });

    int? id;
    String? profilPicture;
    String? description;
    String? justificatif;
    int? userImam;
    DateTime? createdAt;
    DateTime? updatedAt;

    factory Imam.fromJson(Map<String, dynamic> json) => Imam(
        id: json["id"],
        profilPicture: json["profil_picture"],
        description: json["description"] == null ? null : json["description"],
        justificatif: json["justificatif"],
        userImam: json["user_imam"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "profil_picture": profilPicture,
        "description": description == null ? null : description,
        "justificatif": justificatif,
        "user_imam": userImam,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
    };
}
