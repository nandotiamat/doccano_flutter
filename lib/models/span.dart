// To parse this JSON data, do
//
//     final span = spanFromJson(jsonString);

import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

part '../hive models adapter/span.g.dart';

Span spanFromJson(String str) => Span.fromJson(json.decode(str));

String spanToJson(Span data) => json.encode(data.toJson());

@HiveType(typeId: 3)
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

  @HiveField(0)
  int id;

  @HiveField(1)
  double prob;

  @HiveField(2)
  int user;

  @HiveField(3)
  int example;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  DateTime updatedAt;

  @HiveField(6)
  int label;

  @HiveField(7)
  int startOffset;

  @HiveField(8)
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

  int get length {
    return endOffset - startOffset;
  }
}
