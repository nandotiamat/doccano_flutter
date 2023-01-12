import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

late Dio dio;
late String key;
late String projectID;
late String doccanoWS;

void initGlobals() {
  
  projectID = dotenv.get("PROJECT_ID");
  doccanoWS = dotenv.get("DOCCANO_WEBSERVER_PATH");
  dio = Dio();
}