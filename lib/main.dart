import 'package:doccano_flutter/views/annotation_view.dart';
import 'package:doccano_flutter/constants/routes.dart';
import 'package:doccano_flutter/get_started_page.dart';
import 'package:doccano_flutter/globals.dart';
import 'package:doccano_flutter/login_page.dart';
import 'package:doccano_flutter/projects_selection_page.dart';
import 'package:doccano_flutter/views/validation_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await initGlobals();
  runApp(const DoccanoFlutter());
}

class DoccanoFlutter extends StatefulWidget {
  const DoccanoFlutter({super.key});

  @override
  State<DoccanoFlutter> createState() => _DoccanoFlutterState();
}

class _DoccanoFlutterState extends State<DoccanoFlutter> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Doccano Futter',
        initialRoute: dotenv.get("ENV") == "development"
            ? projectsRoute
            : getStartedRoute,
        routes: {
          getStartedRoute: (context) => const GetStartedPage(),
          loginRoute: (context) => const LoginPage(),
          annotationRoute: (context) => const AnnotationView(),
          validationRoute: (context) => const ValidationView(),
          projectsRoute: (context) => const ProjectsPage(),
        },
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ));
  }
}
