import 'dart:async';
import 'package:dio/dio.dart';
import 'package:doccano_flutter/globals.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<bool> login() async {
  try {
    // AUTH LOGIN
    var data = {
      "username": dotenv.get("USERNAME"),
      "password": dotenv.get("PASSWORD")
    };
    var response = await dio
        .post("$doccanoWS/v1/auth/login/", data: data)
        .timeout(const Duration(seconds: 3));

    if (response.statusCode == 200) {
      key = response.data["key"];
      options = Options(headers: {'Authorization': 'Token $key'});
      return true;
    }
  } catch (e) {

    //TODO ERROR PAGE
  }

  return false;
}
