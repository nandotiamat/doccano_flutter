import 'package:doccano_flutter/constants/routes.dart';
import 'package:doccano_flutter/globals.dart';
import 'package:doccano_flutter/utils/doccano_api.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? loggedUserData;
  Map<String, dynamic>? loggedUserRole;

  @override
  void initState() {
    //todo add futurebuilder
    getLoggedUserData().then(
      (userData) => {
        setState(() => {loggedUserData = userData}),
      },
    );
    getLoggedUserRole().then((userRole) => {
          setState(() => {loggedUserRole = userRole}),
        });
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
        title: const Text("profile page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Table(
              children: [
                TableRow(
                  children: [
                    const Text("Username:"),
                    Text(
                      loggedUserData?["username"],
                    )
                  ],
                ),
                TableRow(children: [
                  const Text("Role:"),
                  Text(loggedUserRole?["rolename"])
                ]),
                TableRow(children: [
                  const Text("Staff:"),
                  loggedUserData?["is_staff"]
                      ? const Icon(
                          Icons.check,
                          color: Colors.green,
                        )
                      : const Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
                ]),
                TableRow(children: [
                  const Text("SuperUser:"),
                  loggedUserData?["is_superuser"]
                      ? const Icon(
                          Icons.check,
                          color: Colors.green,
                        )
                      : const Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
                ]),
              ],
            ),
            ElevatedButton(
              onPressed: _logout,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: const Text("Logout"),
                ),
              ),
            ],
          ),
        ),
      // body: Center(
      //   child: Column(
      //     children: [
      //       Text(
      //         "LoggedUserRole : $loggedUserRole",
      //         textScaleFactor: 2.00,
      //       ),
      //       Text("ID: ${loggedUserData?["id"]}"),
      //       Text("username: ${loggedUserData?["username"]}"),
      //       Text("is_staff: ${loggedUserData?["is_staff"]}"),
      //       Text("is_superuser: ${loggedUserData?["is_superuser"]}"),
      //
      //     ],
      //   ),
      // ),
    );
  }
}
