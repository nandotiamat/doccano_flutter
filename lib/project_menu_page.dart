import 'package:doccano_flutter/labels_view.dart';
import 'package:doccano_flutter/models/projects.dart';
import 'package:flutter/material.dart';

class ProjectMenuPage extends StatefulWidget {
  const ProjectMenuPage({super.key, required this.passedProject});

  final Project? passedProject;

  @override
  State<ProjectMenuPage> createState() => _ProjectMenuPageState();
}

class _ProjectMenuPageState extends State<ProjectMenuPage> {
  ImageProvider myImage = const AssetImage('images/doccano.png');

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage('images/doccano.png'), context);

    Project? project = widget.passedProject;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Welcome to Doccano!'),
      ),
      body: Column(
        children: [
          Image.asset(
            'images/doccano.png',
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              color: Colors.blue[500],
              elevation: 8,
              shadowColor: Colors.green,
              margin: const EdgeInsets.all(20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: SizedBox(
                height: 300,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          project!.name!.toUpperCase(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          'ID: ${project.id!.toString()}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          'Project-Type: ${project.projectType!}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          'Description: ${project.description!}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                elevation: 3, minimumSize: const Size(250, 70)),
            child: const Text(
              'View Examples',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25.0),
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
                  elevation: 3, minimumSize: const Size(250, 70)),
              child: const Text(
                'View Labels',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Project',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.new_label_outlined), label: 'Annotate'),
          BottomNavigationBarItem(
              icon: Icon(Icons.check_circle_outline), label: 'Validate'),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.blue,
        onTap: (int inted) {},
      ),
    );
  }
}
