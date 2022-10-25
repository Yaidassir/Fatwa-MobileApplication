import 'dart:convert';

// List<User> userFromJson(String str) => List<User>.from(json.decode(str).map((x) => User.fromJson(x)));
Imam imamFromJson(String str) => Imam.fromJson(json.decode(str));
String imamToJson(Imam data) => json.encode(data.toJson());

// String userToJson(List<User> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Imam {
    Imam({
        this.id,
        required this.name,
        required this.lastname,
        this.dateofbirth,
        required this.email,
        required this.phonenumber,
        required this.usertype,
        required this.etatcompte,
        this.emailVerifiedAt,
        this.createdAt,
        this.updatedAt,
        required this.avatar,
        required this.description,
    });

    int? id;
    String name;
    String lastname;
    DateTime? dateofbirth;
    String email;
    String phonenumber;
    int usertype;
    int etatcompte;
    DateTime? emailVerifiedAt;
    DateTime? createdAt;
    DateTime? updatedAt;
    String avatar;
    String description;

    factory Imam.fromJson(Map<String, dynamic> json) => Imam(
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
    };
}