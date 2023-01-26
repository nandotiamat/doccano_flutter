import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

late Dio dio;
late String key;
late String projectID;
late String doccanoWS;
late Options options;
late SharedPreferences prefs;

Future<void> initGlobals() async {
  dio = Dio();
  prefs = await SharedPreferences.getInstance();
  if (dotenv.get("ENV") == "development") {
    await prefs.setString("doccano_webserver_path", dotenv.get("DOCCANO_WEBSERVER_PATH"));
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