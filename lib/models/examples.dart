// To parse this JSON data, do
//
//     final examplesResponse = examplesResponseFromJson(jsonString);

import 'dart:convert';

ExamplesResponse? examplesResponseFromJson(String str) => ExamplesResponse.fromJson(json.decode(str));

String examplesResponseToJson(ExamplesResponse? data) => json.encode(data!.toJson());

class ExamplesResponse {
    ExamplesResponse({
        this.count,
        this.next,
        this.previous,
        this.results,
    });

    int? count;
    String? next;
    dynamic previous;
    List<Example?>? results;

    factory ExamplesResponse.fromJson(Map<String, dynamic> json) => ExamplesResponse(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: json["results"] == null ? [] : List<Example?>.from(json["results"]!.map((x) => Example.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": results == null ? [] : List<dynamic>.from(results!.map((x) => x!.toJson())),
    };
}

class Example {
    Example({
        this.id,
        this.filename,
        this.meta,
        this.annotationApprover,
        this.commentCount,
        this.text,
        this.isConfirmed,
        this.uploadName,
        this.score,
    });

    int? id;
    String? filename;
    ExampleMetadata? meta;
    dynamic annotationApprover;
    int? commentCount;
    String? text;
    bool? isConfirmed;
    String? uploadName;
    double? score;

    factory Example.fromJson(Map<String, dynamic> json) => Example(
        id: json["id"],
        filename: json["filename"],
        meta: ExampleMetadata.fromJson(json["meta"]),
        annotationApprover: json["annotation_approver"],
        commentCount: json["comment_count"],
        text: json["text"],
        isConfirmed: json["is_confirmed"],
        uploadName: json["upload_name"],
        score: json["score"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "filename": filename,
        "meta": meta!.toJson(),
        "annotation_approver": annotationApprover,
        "comment_count": commentCount,
        "text": text,
        "is_confirmed": isConfirmed,
        "upload_name": uploadName,
        "score": score,
    };
}

class ExampleMetadata {
    ExampleMetadata({
        this.id,
        this.comment,
        this.comments,
    });

    int? id;
    String? comment;
    List<dynamic>? comments;

    factory ExampleMetadata.fromJson(Map<String, dynamic> json) => ExampleMetadata(
        id: json["id"],
        comment: json["comment"],
        comments: json["Comments"] == null ? [] : List<dynamic>.from(json["Comments"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "comment": comment,
        "Comments": comments == null ? [] : List<dynamic>.from(comments!.map((x) => x)),
    };
}
