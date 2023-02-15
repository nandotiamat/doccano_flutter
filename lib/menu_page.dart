import 'package:doccano_flutter/views/profile_view.dart';
import 'package:doccano_flutter/views/annotation_view.dart';
import 'package:doccano_flutter/views/project_view.dart';
import 'package:doccano_flutter/views/validation_view.dart';
import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key, required this.passedStackIndex});
  final int passedStackIndex;

  @override
  State<MenuPage> createState() => _MenuPageState();

  
}

class _MenuPageState extends State<MenuPage> {
  late int _currentIndex ;
  
  @override
  void initState() {
    _currentIndex = widget.passedStackIndex;
    super.initState();
  }

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
          ProfileView()
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
              icon: Icon(Icons.new_label_outlined), 
              label: 'Annotate'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.check_circle_outline),
              label: 'Validate'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Profile'
          ),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
