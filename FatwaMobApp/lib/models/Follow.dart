// To parse this JSON data, do
//
//     final follow = followFromJson(jsonString);

import 'dart:convert';

List<Follow> followFromJson(String str) => List<Follow>.from(json.decode(str).map((x) => Follow.fromJson(x)));

String followToJson(List<Follow> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Follow {
    Follow({
        this.id,
        required this.simpleuserId,
        required this.imamId,
    });

    int? id;
    int simpleuserId;
    int imamId;

    factory Follow.fromJson(Map<String, dynamic> json) => Follow(
        id: json["id"],
        simpleuserId: json["simpleuser_id"],
        imamId: json["imam_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "simpleuser_id": simpleuserId,
        "imam_id": imamId,
    };
}
