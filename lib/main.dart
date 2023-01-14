import 'package:doccano_flutter/constants/routes.dart';
import 'package:doccano_flutter/get_started_page.dart';
import 'package:doccano_flutter/globals.dart';
// ignore: unused_import
import 'package:doccano_flutter/homepage.dart';
import 'package:doccano_flutter/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  initGlobals();
  runApp(const DoccanoFlutter());
}

class DoccanoFlutter extends StatefulWidget {
  const DoccanoFlutter({super.key});

  @override
  State<DoccanoFlutter> createState() => _DoccanoFlutterState();
}

class _DoccanoFlutterState extends State<DoccanoFlutter> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Doccano Futter',
      initialRoute: getStartedRoute,
      routes: {
        getStartedRoute: (context) => const GetStartedPage(),
        loginRoute: (context) => const LoginPage(),
        homePageRoute: (context) => const Homepage(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GetStartedPage(),
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
        body: const Text(''));
  }
}

/*FutureBuilder(
        future: getHttp(),
        builder: (context, snapshot) => snapshot.hasData
            ? const GetStartedPage()
            : const Center(
                child: CircularProgressIndicatorWithText("LOGGING USER...")),
      ),
*/