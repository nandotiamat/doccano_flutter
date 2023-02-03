import 'package:hive_flutter/hive_flutter.dart';

class ExampleMetadata {
  ExampleMetadata({
    this.id,
    this.comment,
    this.comments,
  });

  int? id;

  String? comment;

  List<dynamic>? comments;

  factory ExampleMetadata.fromJson(Map<String, dynamic> json) =>
      ExampleMetadata(
        id: json["id"],
        comment: json["comment"],
        comments: json["Comments"] == null
            ? []
            : List<dynamic>.from(json["Comments"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "comment": comment,
        "Comments":
            comments == null ? [] : List<dynamic>.from(comments!.map((x) => x)),
      };
}
