import 'dart:async';

import 'package:doccano_flutter/globals.dart';
import 'package:doccano_flutter/utils/show_error_dialog.dart';
import 'package:flutter/material.dart';

Future<dynamic> doccanoLogin(
    String username, String password, BuildContext context) async {
  try {
    // AUTH LOGIN

    var dataLogin = {"username": username, "password": password};

    var response = await dio
        .post("$doccanoWS/v1/auth/login/", data: dataLogin)
        .timeout(const Duration(seconds: 3));

    if (response.statusCode == 200) {
      key = response.data["key"];
      return true;
    } else {
      return false;
    }

    //var options = Options(headers: {'Authorization': 'Token $key'});
    //response = await dio.get("$doccanoWS/v1/projects/$projectID", options: options);
  } on TimeoutException {
    await showErrorDialog(context, 'Check Webserver Status');
  }
  return false;
}
