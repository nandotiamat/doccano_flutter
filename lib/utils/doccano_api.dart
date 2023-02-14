import 'dart:async';
import 'package:dio/dio.dart';
import 'package:doccano_flutter/globals.dart';
import 'package:doccano_flutter/models/examples.dart';
import 'package:doccano_flutter/models/label.dart';
import 'package:doccano_flutter/models/span.dart';
import 'package:doccano_flutter/models/projects.dart';
import 'package:flutter/rendering.dart';

Future<Map<String, dynamic>?> getLoggedUserData() async {
  // probabilmente non serve questa prima parte o forse serve per initSession;
  String? key = sessionBox.get("key");
  if (key == null) {
    //TODO implement throw error
    return null;
  }
  var response =
      await dio.get("${getDoccanoWebServerPath()!}/v1/me", options: options);
  return response.data;
}

Future<Map<String, dynamic>?> getLoggedUserRole() async {
  var response = await dio.get(
      "${getDoccanoWebServerPath()!}/v1/projects/${getProjectID()}/my-role",
      options: options);
  return response.data;
}

Future<bool> login(String username, String password) async {

  print(getDoccanoWebServerPath());

  var dataLogin = {"username": username, "password": password};
  var response = await dio
      .post("${getDoccanoWebServerPath()!}/v1/auth/login/", data: dataLogin)
      .timeout(
        const Duration(seconds: 10),
      );

  if (response.statusCode == 200) {
    key = response.data["key"];
    options = Options(headers: {'Authorization': 'Token $key'});
    debugPrint("User Logged");
    sessionBox.put("key", key);
    return true;
  }

  return false;
}

Future<List<Label>> getLabels() async {
  var response = await dio.get(
      "${getDoccanoWebServerPath()}/v1/projects/${getProjectID()}/span-types",
      options: options);
  List<Label> labels = [];

  response.data.forEach((label) => labels.add(Label.fromJson(label)));
  return labels;
}

Future<Example?> getExample(int exampleID) async {
  var response = await dio.get(
    "${getDoccanoWebServerPath()}/v1/projects/${getProjectID()}/examples/$exampleID",
    options: options,
  );
  if (response.data != null) return Example.fromJson(response.data);
  return null;
}

Future<List<Example?>> getExamples(String confirmed, int offset) async {
  // ARBITRARIO
  Map<String, dynamic> params = {
    "limit": 50,
    "confirmed": confirmed,
    "offset": offset
  };

  List<Example>? examples = [];
  var response = await dio.get(
      "${getDoccanoWebServerPath()}/v1/projects/${getProjectID()}/examples",
      options: options,
      queryParameters: params);
  response.data["results"]
      .forEach((example) => examples.add(Example.fromJson(example)));
  return examples;
}

Future<ExampleMetadata?>? getExampleMetaData(int exampleId) async {
  var response = await dio.get(
      "${getDoccanoWebServerPath()}/v1/projects/${getProjectID()}/examples/$exampleId",
      options: options);
  Example? example = Example.fromJson(response.data);
  ExampleMetadata? metaData = example.meta!;

  return metaData;
}

Future<List<Project?>?> getProjects() async {
  String filter = 'created_at';
  Map<String, dynamic> params = {"ordering": filter};
  var response = await dio.get("${getDoccanoWebServerPath()}/v1/projects",
      options: options, queryParameters: params);

  List<Project?>? projects = [];
  response.data["results"]
      .forEach((project) => projects.add(Project.fromJson(project)));

  return projects;
}

Future<Project?>? getProject() async {
  var response = await dio.get(
      "${getDoccanoWebServerPath()}/v1/projects/${getProjectID()}",
      options: options);
  if (response.statusCode == 200) {
    return Project.fromJson(response.data);
  }
  return null;
}

Future<void> deleteProject(int projectId) async {
  try {
    await dio
        .delete("${getDoccanoWebServerPath()}/v1/projects/$projectID",
            options: options)
        .timeout(const Duration(seconds: 5));
  } catch (e) {
    debugPrint(e.toString());
  }
}

Future<List<Span>?> getSpans(int exampleID) async {
  Response<List<dynamic>> response = await dio.get(
      "${getDoccanoWebServerPath()}/v1/projects/${getProjectID()}/examples/$exampleID/spans",
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
      "${getDoccanoWebServerPath()}/v1/projects/${getProjectID()}/examples/$exampleID/spans",
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
      "${getDoccanoWebServerPath()}/v1/projects/${getProjectID()}/examples/$exampleID/spans/$spanID",
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
  var response = await dio.post(
      "${getDoccanoWebServerPath()}/v1/projects/${getProjectID()}/examples/$exampleID/states",
      options: options,
      data: {});
  debugPrint(response.statusCode.toString());
}
