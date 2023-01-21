import 'dart:async';
import 'package:dio/dio.dart';
import 'package:doccano_flutter/globals.dart';
import 'package:doccano_flutter/models/examples.dart';
import 'package:doccano_flutter/models/label.dart';
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

Future<List<Example?>> getExamples(int? offset) async {
  // ARBITRARIO
  Map<String, dynamic> params = {
    "limit": 50,
    "confirmed": false,
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
