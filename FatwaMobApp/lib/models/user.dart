// class User{
//   String name;
//   String lastname;
//   String email;
//   String phonenumber;
//   String description;
//   String avatar;
//   int etatcompte;
//   int usertype;

//   User(this.name,this.lastname,this.email,this.avatar,this.phonenumber,this.description,this.etatcompte,this.usertype);

//   User.fromJson(Map<String,dynamic> json)
//   : name = json['name'],
//     lastname = json['lastname'],
//     email = json['email'],
//     phonenumber = json['phonenumber'],
//     description = json['description'],
//     avatar = json['avatar'],
//     etatcompte = json['etatcompte'],
//     usertype = json['usertype'];
// }


// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

List<User> userFromJson(String str) => List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String userToJson(List<User> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
    User({
        required this.id,
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

    int id;
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