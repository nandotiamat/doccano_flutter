// To parse this JSON data, do
//
//     final comment = commentFromJson(jsonString);

import 'dart:convert';

Comment commentFromJson(String str) => Comment.fromJson(json.decode(str));

String commentToJson(Comment data) => json.encode(data.toJson());

class Comment {
  Comment({
    required this.parte,
    required this.controparte,
    required this.giudice,
    required this.sender,
    required this.dataSentenza,
  });

  String parte;
  String controparte;
  String giudice;
  String sender;
  String dataSentenza;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        parte: json["parte"],
        controparte: json["controparte"],
        giudice: json["giudice"],
        sender: json["sender"],
        dataSentenza: json["data sentenza"],
      );

  Map<String, dynamic> toJson() => {
        "parte": parte,
        "controparte": controparte,
        "giudice": giudice,
        "sender": sender,
        "data sentenza": dataSentenza,
      };

  void fixData() {
    if (dataSentenza.length >= 3) {
      dataSentenza = dataSentenza.substring(0, dataSentenza.length - 3);
    }
  }
}
