import 'package:dio/dio.dart';
import 'package:doccano_flutter/components/circular_progress_indicator_with_text.dart';
import 'package:doccano_flutter/globals.dart';
import 'package:doccano_flutter/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  initGlobals();
  runApp(const MyApp());
}

Future<dynamic> getHttp() async {
  try {
    // AUTH LOGIN
    var data = {"username": dotenv.get("USERNAME"), "password": dotenv.get("PASSWORD")};
    
    var response = await dio.post("$doccanoWS/v1/auth/login/", data: data);
    
    if (response.statusCode == 200) {
      key = response.data["key"];
    }
    
    var options =
        Options(headers: {'Authorization': 'Token $key'});

    response = await dio.get("$doccanoWS/v1/projects/$projectID",
        options: options);
    return response;
  } catch (e) {
    //TODO RETURN ERROR
  }
  return "NO DATA";
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doccano Futter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Doccano Flutter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: getHttp(),
        builder: (context, snapshot) => snapshot.hasData
            ? const Homepage()
            : const Center(child: CircularProgressIndicatorWithText("LOGGING USER...")),
      ),
    );
  }
}
