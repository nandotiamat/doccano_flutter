import 'package:doccano_flutter/views/span_distribution_view.dart';
import 'package:doccano_flutter/widget/circular_progress_indicator_with_text.dart';
import 'package:doccano_flutter/globals.dart';
import 'package:doccano_flutter/views/labels_view.dart';
import 'package:doccano_flutter/models/projects.dart';
import 'package:doccano_flutter/utils/doccano_api.dart';
import 'package:flutter/material.dart';

class ProjectView extends StatefulWidget {
  const ProjectView({super.key});

  @override
  State<ProjectView> createState() => _ProjectViewState();
}

class _ProjectViewState extends State<ProjectView> {
  late Future<Project?>? _future;

  Future<Project?>? getData() async {
    Project? project = await getProject();
    await prefs.setBool("allow_overlapping", project!.allowOverlapping!);
    return project;
  }

  @override
  void initState() {
    super.initState();
    _future = getData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Project? project = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              title: const Text('Welcome to Doccano'),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset(
                    'images/doccano.png',
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      color: Colors.blue,
                      elevation: 10,
                      margin: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              project!.name!.toUpperCase(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              'ID: ${project.id!.toString()}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Padding(
                            padding:const EdgeInsets.all(12.0),
                            child: Text(
                              'Project-Type: ${project.projectType!}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              'Description: ${project.description!}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              'Collaborative Annotation: ${project.collaborativeAnnotation!.toString().toUpperCase()}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          
                          Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LabelsView(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                  elevation: 3, minimumSize: const Size(250, 70),
                                  backgroundColor: Colors.lightBlue),
                              child: const Text(
                                'View Labels',
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SpanDistributionView(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                  elevation: 3, minimumSize: const Size(250, 70),
                                  backgroundColor: Colors.lightBlue),
                              child: const Text(
                                'View Span Distribution',
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicatorWithText("Fetching Project..."),
          ),
        );
      },
    );
  }
}
