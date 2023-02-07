// To parse this JSON data, do
//
//     final label = labelFromJson(jsonString);

import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

part '../hive models adapter/label.g.dart';

Label? labelFromJson(String str) => Label.fromJson(json.decode(str));

String labelToJson(Label? data) => json.encode(data!.toJson());

@HiveType(typeId: 2)
class Label {
  Label({
    this.id,
    this.text,
    this.prefixKey,
    this.suffixKey,
    this.backgroundColor,
    this.textColor,
  });

  @HiveField(0)
  int? id;

  @HiveField(1)
  String? text;

  @HiveField(2)
  String? prefixKey;

  @HiveField(3)
  String? suffixKey;

  @HiveField(4)
  String? backgroundColor;

  @HiveField(5)
  String? textColor;

  factory Label.fromJson(Map<String, dynamic> json) => Label(
        id: json["id"],
        text: json["text"],
        prefixKey: json["prefix_key"],
        suffixKey: json["suffix_key"],
        backgroundColor: json["background_color"],
        textColor: json["text_color"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "text": text,
        "prefix_key": prefixKey,
        "suffix_key": suffixKey,
        "background_color": backgroundColor,
        "text_color": textColor,
      };
}
