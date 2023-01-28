import 'dart:async';
import 'package:dio/dio.dart';
import 'package:doccano_flutter/globals.dart';
import 'package:doccano_flutter/models/examples.dart';
import 'package:doccano_flutter/models/label.dart';
import 'package:doccano_flutter/models/span.dart';
import 'package:doccano_flutter/models/projects.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<bool> login(String username, String password) async {
  var dataLogin = {"username": username, "password": password};

  var response = await dio
      .post("$doccanoWS/v1/auth/login/", data: dataLogin)
      .timeout(const Duration(seconds: 20));

  if (response.statusCode == 200) {
    key = response.data["key"];
    options = Options(headers: {'Authorization': 'Token $key'});
    debugPrint("User Logged");
    return true;
  }

  return false;
}

Future<List<Label>> getLabels() async {
  var projectId = prefs.getInt("PROJECT_ID");

  var response = await dio.get("$doccanoWS/v1/projects/$projectId/span-types",
      options: options);
  List<Label> labels = [];

  response.data.forEach((label) => labels.add(Label.fromJson(label)));
  return labels;
}

Future<List<Example?>> getExamples(String confirmed, int offset) async {
  // ARBITRARIO
  Map<String, dynamic> params = {
    "limit": 50,
    "confirmed": confirmed,
    "offset": offset
  };
  var projectId = prefs.getInt("PROJECT_ID");
  List<Example>? examples = [];

  if (dotenv.get("ENV") == "development") {
    var response = await dio.get("$doccanoWS/v1/projects/$projectID/examples",
        options: options, queryParameters: params);
    response.data["results"]
        .forEach((example) => examples.add(Example.fromJson(example)));
    return examples;
  } else {
    var response = await dio.get("$doccanoWS/v1/projects/$projectId/examples",
        options: options, queryParameters: params);
    response.data["results"]
        .forEach((example) => examples.add(Example.fromJson(example)));
    return examples;
  }
}

Future<ExampleMetadata?>? getExampleMetaData(int exampleId) async {
  int? projectId = prefs.getInt("PROJECT_ID");

  var response = await dio.get(
      "$doccanoWS/v1/projects/$projectId/examples/$exampleId",
      options: options);
  Example? example = Example.fromJson(response.data);
  ExampleMetadata? metaData = example.meta!;

  return metaData;
}

Future<List<Project?>?> getProjects() async {
  String filter = 'created_at';
  Map<String, dynamic> params = {"ordering": filter};
  var response = await dio.get("$doccanoWS/v1/projects",
      options: options, queryParameters: params);

  List<Project?>? projects = [];
  response.data["results"]
      .forEach((project) => projects.add(Project.fromJson(project)));

  return projects;
}

Future<Project?>? getProject() async {
  int projectId = prefs.getInt("PROJECT_ID")!;
  var response =
      await dio.get("$doccanoWS/v1/projects/$projectId", options: options);
  if (response.statusCode == 200) {
    return Project.fromJson(response.data);
  }
  return null;
}

Future<void> deleteProject(int projectId) async {
  try {
    await dio
        .delete("$doccanoWS/v1/projects/$projectId", options: options)
        .timeout(const Duration(seconds: 5));
  } catch (e) {
    debugPrint(e.toString());
  }
}

Future<List<Span>?> getSpans(int exampleID) async {
  Response<List<dynamic>> response = await dio.get(
      "$doccanoWS/v1/projects/$projectID/examples/$exampleID/spans",
      options: options);
  List<Span>? fetchedSpans = [];
  if (response.data == null) return null;
  if (response.data == []) return [];
  for (var span in response.data!) {
    fetchedSpans.add(Span.fromJson(span));
  }
  return fetchedSpans;
}

Future<Span?>? createSpan(int exampleID, int startOffset, int endOffset,
    int labelId, int userId) async {
  Map<String, dynamic> payload = {
    "end_offset": endOffset,
    "start_offset": startOffset,
    "user": userId,
    "label": labelId
  };
  Response<dynamic> response = await dio.post(
      "$doccanoWS/v1/projects/$projectID/examples/$exampleID/spans",
      options: options,
      data: payload);
  if (response.data == null) return null;
  if (response.statusCode == 201) {
    Span createdSpan = Span.fromJson(response.data);
    // RESOURCE CREATED
    debugPrint("Span ${createdSpan.id} was successfully created");
    return createdSpan;
  }
  return null;
}

Future<bool> deleteSpan(int exampleID, int spanID) async {
  Response<dynamic> response = await dio.delete(
      "$doccanoWS/v1/projects/$projectID/examples/$exampleID/spans/$spanID",
      options: options);

  if (response.data == null) return false;
  if (response.statusCode == 204) {
    debugPrint(
        "Span $spanID from example $exampleID was successfully deleted.");
    // RESOURCE DELETED
    return true;
  }
  return false;
}

Future<void> unCheckExample(int exampleID) async {
  int projectId = prefs.getInt("PROJECT_ID")!;

  var response = await dio.post(
      "$doccanoWS/v1/projects/$projectId/examples/$exampleID/states",
      options: options,
      data: {});
  debugPrint(response.statusCode.toString());
}
