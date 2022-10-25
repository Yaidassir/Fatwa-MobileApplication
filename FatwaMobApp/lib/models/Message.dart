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

List<Message> messageFromJson(String str) => List<Message>.from(json.decode(str).map((x) => Message.fromJson(x)));

String messageToJson(List<Message> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Message {
    Message({
        required this.id,
        required this.contenu,
        required this.sender_id,
        required this.receiver_id,
        required this.created_at,
        required this.updated_at,
        required this.senderavatar,
        required this.senderusername,
        required this.receiveravatar,
        required this.receiverusername,

        
    });

    int id;
    String contenu;
    int sender_id;
    int receiver_id;
    DateTime? created_at;
    DateTime? updated_at;
    String? senderavatar;
    String? senderusername;
    String? receiveravatar;
    String? receiverusername;


    factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json["id"],
        contenu: json["contenu"],
        sender_id: json["sender_id"],
        receiver_id: json["receiver_id"],
        senderavatar: json["senderavatar"],
        senderusername: json["senderusername"],
        receiveravatar: json["receiveravatar"],
        receiverusername: json["receiverusername"],
        created_at: DateTime.parse(json["created_at"]),
        updated_at: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "contenu": contenu,
        "sender_id": sender_id,
        "receiver_id": receiver_id,
        "senderavatar": senderavatar,
        "senderusername": senderusername,
        "receiveravatar": receiveravatar,
        "receiverusername": receiverusername,
        "created_at": created_at!.toIso8601String(),
        "updated_at": updated_at!.toIso8601String(),
    };
}