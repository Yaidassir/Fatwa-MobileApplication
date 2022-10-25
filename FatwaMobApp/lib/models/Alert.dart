// To parse this JSON data, do
//
//     final alert = alertFromJson(jsonString);

import 'dart:convert';

List<Alert> alertFromJson(String str) => List<Alert>.from(json.decode(str).map((x) => Alert.fromJson(x)));

String alertToJson(List<Alert> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Alert {
    Alert({
        this.id,
        required this.title,
        required this.contenu,
        this.etat,
        required this.userId,
        required this.createdAt,
        this.updatedAt,
    });

    int? id;
    String title;
    String contenu;
    int? etat;
    int userId;
    DateTime createdAt;
    DateTime? updatedAt;

    factory Alert.fromJson(Map<String, dynamic> json) => Alert(
        id: json["id"],
        title: json["title"],
        contenu: json["contenu"],
        etat: json["etat"],
        userId: json["user_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "contenu": contenu,
        "etat": etat,
        "user_id": userId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
    };
}
