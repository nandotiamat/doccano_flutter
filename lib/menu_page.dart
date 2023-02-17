import 'package:doccano_flutter/utils/doccano_api.dart';
import 'package:doccano_flutter/views/profile_view.dart';
import 'package:doccano_flutter/views/annotation_view.dart';
import 'package:doccano_flutter/views/project_view.dart';
import 'package:doccano_flutter/views/validation_view.dart';
import 'package:doccano_flutter/widget/circular_progress_indicator_with_text.dart';
import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();

  
}

class _MenuPageState extends State<MenuPage> {
  late int _currentIndex ;
  Map<String, dynamic>? loggedUserData;
  Map<String, dynamic>? loggedUserRole;
  late Future<Map<String, dynamic>> _future;

  late bool _shouldShowAnnotationView ; 
  late bool _shouldShowValidationView ; 

  Future<Map<String,dynamic>> getData() async {

    Map<String, dynamic>? userData = await getLoggedUserData();
    Map<String, dynamic>? userRole = await getLoggedUserRole();

    Map<String,dynamic> data = {
      "loggedUserData": userData,
      "loggedUserRole": userRole,
    };
    return data;
  }
  
  @override
  void initState() {
    _currentIndex = 0;
    setPermission();
     _future = getData().then((userData) {
      setState(() {
        loggedUserData = userData["loggedUserData"];
        loggedUserRole = userData["loggedUserRole"];
      });
      setPermission();
      return userData;
    },);
    
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }


  void setPermission() {
    if(loggedUserRole?["rolename"] == 'project_admin'){
      setState(() {
        _shouldShowAnnotationView = true;
        _shouldShowValidationView = true;
      });
    } else if (loggedUserRole?["rolename"] == 'annotator'){
      setState(() {
        _shouldShowAnnotationView = true;
        _shouldShowValidationView = false;
      });
    } else if ( loggedUserRole?["rolename"] == 'annotation_approver'){
      setState(() {
        _shouldShowAnnotationView = false;
        _shouldShowValidationView = true;
      });
    } else {
      setState(() {
        _shouldShowAnnotationView = false;
        _shouldShowValidationView = false;
      });
    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {

          if(snapshot.hasData){


            return IndexedStack(
          index: _currentIndex,
          children: [
            const ProjectView(),
      
            if ( _shouldShowAnnotationView) const AnnotationView(),
            if( _shouldShowValidationView) const ValidationView(),

            const ProfileView(),

          ],
        );
          } return const Scaffold(
            body: Center(
              child: CircularProgressIndicatorWithText(
                  "Fetching labels and examples..."),
                ),
            );
        },
        
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Project',
          ),
          if ( _shouldShowAnnotationView) 
            const BottomNavigationBarItem(
                icon: Icon(Icons.new_label_outlined), 
                label: 'Annotate'
            ),
          if( _shouldShowValidationView) 
            const BottomNavigationBarItem(
                icon: Icon(Icons.check_circle_outline),
                label: 'Validate'
            ),
          const BottomNavigationBarItem(
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

