import 'package:dio/dio.dart';
import 'package:doccano_flutter/components/user_data.dart';
import 'package:doccano_flutter/utils/doccano_api.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';

late Dio dio;
late String key;
late String projectID;
late String doccanoWS;
late Options options;
late SharedPreferences prefs;
late Box<String> sessionBox;
late Box<UserData> usersBox;

Future<void> initGlobals() async {
  dio = Dio();
  prefs = await SharedPreferences.getInstance();
  if (dotenv.get("ENV") == "development") {
    await prefs.setString("doccano_webserver_path", dotenv.get("DOCCANO_WEBSERVER_PATH"));
  }
  usersBox = await Hive.openBox("users");
  sessionBox = await Hive.openBox("session");
}

Future<void> initSession() async {
  String? key = sessionBox.get("key");
  String? username = sessionBox.get("username");
  if (key != null) {
    options = Options(headers: {'Authorization': 'Token $key'});
    debugPrint("Found key.");
    var data = await getLoggedUserData().catchError((error) { 
      sessionBox.delete("key");
      options = Options();
      return null;
    });
    if (username == null || username != data?["username"]) {
      sessionBox.put("username", data?["username"]);
    }
  }
}

String? getDoccanoWebServerPath() {
  if (prefs.getString("doccano_webserver_path") == null) return null;
  return prefs.getString("doccano_webserver_path")!;
}

int? getProjectID() {
  if (prefs.getInt("project_id") == null) return null;
  return prefs.getInt("project_id");
}
