import 'package:doccano_flutter/globals.dart';
import 'package:doccano_flutter/models/projects.dart';
import 'package:doccano_flutter/menu_page.dart';
import 'package:doccano_flutter/utils/doccano_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'widget/circular_progress_indicator_with_text.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  late Future<List<Project?>?> _future;

  Future<List<Project?>?> getData() async {
    if (dotenv.get("ENV") == "development") {
      await login(dotenv.get("USERNAME"), dotenv.get("PASSWORD"));
  }
    List<Project?>? projects = await getProjects();

    return projects;
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
          List<Project?>? projects = snapshot.data;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Your Projects'),
            ),
            body: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(children: [
                Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: projects!.length,
                        itemBuilder: (context, index) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(70),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                  minHeight: 120, maxHeight: 250),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Card(
                                  shadowColor: Colors.blue[700],
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                      colors: [
                                        Colors.blue,
                                        Color.fromRGBO(32, 109, 225, 0.985)
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                              
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  flex: 4,
                                                  child: Text(
                                                    projects[index]!
                                                        .name!
                                                        .toUpperCase(),
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                const Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 5),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    'ID: ${projects[index]!.id!}',
                                                    maxLines: 1,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                const Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 5),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    'Type: ${projects[index]!.projectType}',
                                                    
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                                const Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 5),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    projects[index]!.description.toString(),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.only(top: 5),
                                                ),
                                              ]),
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 16.0),
                                              child: TextButton(
                                                onPressed: () async {
                                                  await prefs.setInt('project_id', projects[index]!.id!);

                                                  if(!mounted) return;
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          settings:
                                                              RouteSettings(
                                                            name:
                                                                '/projectMenu/',
                                                            arguments:
                                                                projects[index],
                                                          ),
                                                          builder: (context) =>
                                                              const MenuPage()));
                                                },
                                                child: const Text(
                                                  'Select',
                                                  style: TextStyle(
                                                      color: Color.fromARGB(255, 124, 229, 128),
                                                      fontSize: 20),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20.0),
                                              child: TextButton(
                                                onPressed: () async {
                                                  await showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {

                                                        return AlertDialog(
                                                          title: const Text(
                                                              'Confirm Delete'),
                                                          content: const Text(
                                                              'Are you sure you want to delete this project'),
                                                          actions: <Widget>[
                                                            TextButton(
                                                                onPressed: () async {
                                                                  await deleteProject(projects[index]!.id!);

                                                                  if(!mounted) return;
                                                                  Navigator.pop(context);

                                                                  setState(() {
                                                                    _future = getData();
                                                                  });
                                                                },
                                                                child: const Text('yes')
                                                             ),
                                                            TextButton(
                                                                onPressed: () async {
                                                                  Navigator.pop(context);
                                                                },
                                                                child: const Text('no')
                                                              ),
                                                          ],
                                                        );
                                                      }
                                                    );
                                                },
                                                child: const Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                      color: Color.fromARGB(255, 237, 56, 43),
                                                      fontSize: 20),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }))
              ]),
            ),
          );
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicatorWithText("Fetching Projects..."),
          ),
        );
      },
    );
  }
}
