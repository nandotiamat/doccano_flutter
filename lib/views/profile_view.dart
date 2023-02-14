import 'package:doccano_flutter/constants/routes.dart';
import 'package:doccano_flutter/globals.dart';
import 'package:doccano_flutter/utils/doccano_api.dart';
import 'package:doccano_flutter/widget/circular_progress_indicator_with_text.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  Map<String, dynamic>? loggedUserData;
  Map<String, dynamic>? loggedUserRole;
  late Future<Map<String, dynamic>> _future;

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
    //todo add futurebuilder
    _future = getData().then((userData) {
      setState(() {
        loggedUserData = userData["loggedUserData"];
        loggedUserRole = userData["loggedUserRole"];
      });

      return userData;
    },);
    super.initState();
  }

  void _logout() {
    sessionBox.delete("key");
    Navigator.of(context)
        .pushNamedAndRemoveUntil(loginRoute, (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Page"),
      ),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          
          if(snapshot.hasData){

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Card(
                  elevation: 10,
                  margin: const EdgeInsets.all(30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Text(
                                'Username ->  ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${loggedUserData?['username']}',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Text(
                                'Role ->  ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${loggedUserRole?["rolename"]}',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Text(
                                'Staff -> ',
                                style:  TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              loggedUserData?["is_staff"]
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  )
                                : const Icon(
                                    Icons.close,
                                    color: Colors.red,
                                  )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Text(
                                'Superuser -> ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              loggedUserData?['is_superuser'] ? const Icon(
                                Icons.check,
                                color: Colors.green,
                              ) :  const Icon(
                                      Icons.close,
                                      color: Colors.red,
                                    )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: ElevatedButton(
                            onPressed: _logout,
                            child: const SizedBox(
                              child: Text("Logout"),
                              ),
                            ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                ],
              ),
            );
          } return const Scaffold(
            body: Center(
              child: CircularProgressIndicatorWithText(
                  "Fetching labels and examples..."),
                ),
            );
        },
        
      ),
    );
  }
}
