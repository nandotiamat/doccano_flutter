// To parse this JSON data, do
//
//     final project = projectFromJson(jsonString);

import 'dart:convert';

List<Project?>? projectFromJson(String str) => json.decode(str) == null
    ? []
    : List<Project?>.from(json.decode(str)!.map((x) => Project.fromJson(x)));

String projectToJson(List<Project?>? data) => json.encode(
    data == null ? [] : List<dynamic>.from(data.map((x) => x!.toJson())));

class Project {
  Project({
    this.id,
    this.name,
    this.description,
    this.guideline,
    this.projectType,
    this.createdAt,
    this.updatedAt,
    this.randomOrder,
    this.author,
    this.collaborativeAnnotation,
    this.singleClassClassification,
    this.isTextProject,
    this.canDefineLabel,
    this.canDefineRelation,
    this.canDefineCategory,
    this.canDefineSpan,
    this.tags,
    this.allowOverlapping,
    this.graphemeMode,
    this.useRelation,
    this.resourcetype,
  });

  int? id;
  String? name;
  String? description;
  String? guideline;
  String? projectType;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? randomOrder;
  String? author;
  bool? collaborativeAnnotation;
  bool? singleClassClassification;
  bool? isTextProject;
  bool? canDefineLabel;
  bool? canDefineRelation;
  bool? canDefineCategory;
  bool? canDefineSpan;
  List<dynamic>? tags;
  bool? allowOverlapping;
  bool? graphemeMode;
  bool? useRelation;
  String? resourcetype;

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        guideline: json["guideline"],
        projectType: json["project_type"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        randomOrder: json["random_order"],
        author: json["author"],
        collaborativeAnnotation: json["collaborative_annotation"],
        singleClassClassification: json["single_class_classification"],
        isTextProject: json["is_text_project"],
        canDefineLabel: json["can_define_label"],
        canDefineRelation: json["can_define_relation"],
        canDefineCategory: json["can_define_category"],
        canDefineSpan: json["can_define_span"],
        tags: json["tags"] == null
            ? []
            : List<dynamic>.from(json["tags"]!.map((x) => x)),
        allowOverlapping: json["allow_overlapping"],
        graphemeMode: json["grapheme_mode"],
        useRelation: json["use_relation"],
        resourcetype: json["resourcetype"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "guideline": guideline,
        "project_type": projectType,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "random_order": randomOrder,
        "author": author,
        "collaborative_annotation": collaborativeAnnotation,
        "single_class_classification": singleClassClassification,
        "is_text_project": isTextProject,
        "can_define_label": canDefineLabel,
        "can_define_relation": canDefineRelation,
        "can_define_category": canDefineCategory,
        "can_define_span": canDefineSpan,
        "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x)),
        "allow_overlapping": allowOverlapping,
        "grapheme_mode": graphemeMode,
        "use_relation": useRelation,
        "resourcetype": resourcetype,
      };
}
