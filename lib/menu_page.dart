import 'package:doccano_flutter/views/annotation_view.dart';
import 'package:doccano_flutter/views/project_view.dart';
import 'package:doccano_flutter/views/validation_view.dart';
import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          ProjectView(),
          AnnotationView(),
          ValidationView(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Project',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.new_label_outlined), label: 'Annotate'),
          BottomNavigationBarItem(
              icon: Icon(Icons.check_circle_outline), label: 'Validate'),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
