// To parse this JSON data, do
//
//     final span = spanFromJson(jsonString);

import 'dart:convert';

Span spanFromJson(String str) => Span.fromJson(json.decode(str));

String spanToJson(Span data) => json.encode(data.toJson());

class Span {
    Span({
        required this.id,
        required this.prob,
        required this.user,
        required this.example,
        required this.createdAt,
        required this.updatedAt,
        required this.label,
        required this.startOffset,
        required this.endOffset,
    });

    int id;
    double prob;
    int user;
    int example;
    DateTime createdAt;
    DateTime updatedAt;
    int label;
    int startOffset;
    int endOffset;

    factory Span.fromJson(Map<String, dynamic> json) => Span(
        id: json["id"],
        prob: json["prob"],
        user: json["user"],
        example: json["example"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        label: json["label"],
        startOffset: json["start_offset"],
        endOffset: json["end_offset"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "prob": prob,
        "user": user,
        "example": example,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "label": label,
        "start_offset": startOffset,
        "end_offset": endOffset,
    };
}
