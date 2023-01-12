// To parse this JSON data, do
//
//     final label = labelFromJson(jsonString);

import 'dart:convert';

Label? labelFromJson(String str) => Label.fromJson(json.decode(str));

String labelToJson(Label? data) => json.encode(data!.toJson());

class Label {
    Label({
        this.id,
        this.text,
        this.prefixKey,
        this.suffixKey,
        this.backgroundColor,
        this.textColor,
    });

    int? id;
    String? text;
    String? prefixKey;
    String? suffixKey;
    String? backgroundColor;
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