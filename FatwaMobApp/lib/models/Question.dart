// To parse this JSON data, do
//
//     final question = questionFromJson(jsonString);

import 'dart:convert';

List<Question> questionFromJson(String str) => List<Question>.from(json.decode(str).map((x) => Question.fromJson(x)));

String questionToJson(List<Question> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Question {
    Question({
        this.id,
        required this.title,
        required this.typeqst,
        required this.contenu,
        required this.userId,
        required this.categoryId,
        required this.createdAt,
        this.updatedAt,
        required this.nbVus,
    });

    int? id;
    String title;
    int typeqst;
    String contenu;
    int userId;
    int categoryId;
    DateTime createdAt;
    DateTime? updatedAt;
    int nbVus;

    factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: json["id"],
        title: json["title"],
        typeqst: json["typeqst"],
        contenu: json["contenu"],
        userId: json["user_id"],
        categoryId: json["category_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        nbVus: json["nb_vus"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "typeqst": typeqst,
        "contenu": contenu,
        "user_id": userId,
        "category_id": categoryId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "nb_vus": nbVus,
    };
}
