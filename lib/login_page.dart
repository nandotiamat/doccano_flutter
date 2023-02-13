import 'package:doccano_flutter/error_page.dart';
import 'package:doccano_flutter/widget/logo_animation.dart';
import 'package:doccano_flutter/constants/routes.dart';
import 'package:doccano_flutter/globals.dart';
import 'package:doccano_flutter/utils/doccano_api.dart';
import 'package:doccano_flutter/utils/show_error_dialog.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _username;
  late final TextEditingController _password;
  late final TextEditingController _webServerPath;

  @override
  void initState() {
    _username = TextEditingController();
    _password = TextEditingController();
    _webServerPath = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    _webServerPath.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  width: MediaQuery.of(context).size.width * 3 / 4,
                  child: const LogoAnimation(),
                ),
                TextField(
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  controller: _webServerPath,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Doccano Server Path",
                    hintText: 'Example: 192.168.1.2:8000',
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 30),
                ),
                TextField(
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  controller: _username,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Username",
                    hintText: 'Enter your doccano username here',
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 30),
                ),
                TextField(
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  controller: _password,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Password",
                    hintText: 'Enter your doccano password here',
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 30),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final username = _username.text;
                      final password = _password.text;
                      final webserverPath = _webServerPath.text;

                      try {
                        await prefs.setString("doccano_webserver_path", "http://$webserverPath");

                        if (await login(username, password)) {
                          prefs.setString("doccano_webserver_path","http://$webserverPath").then((value) => {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                projectsRoute,
                                (route) => false,
                              )
                            }
                          );
                        }
                      } catch (e) {
                        //Navigator.push(context,MaterialPageRoute(builder: (context) =>  ErrorPage(error: e.toString())));
                        showErrorLoginDialog(context, e.toString(), 'error occured');
                      }
                    },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.all(16.0),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
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
    );
  }
}
