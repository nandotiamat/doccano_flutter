import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

late Dio dio;
late String key;
late String projectID;
late String doccanoWS;
late Options options;
late SharedPreferences prefs;

void initGlobals() async {
  // ignore: invalid_use_of_visible_for_testing_member
  SharedPreferences.setMockInitialValues({});

  prefs = await SharedPreferences.getInstance();

  projectID = dotenv.get("PROJECT_ID");
  doccanoWS = dotenv.get("DOCCANO_WEBSERVER_PATH");

  dio = Dio();
}
