import 'package:doccano_flutter/constants/logo_animation.dart';
import 'package:doccano_flutter/constants/routes.dart';
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

  @override
  void initState() {
    _username = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Login Page'),
            Image.asset(
              'images/doccanologo.png',
              fit: BoxFit.contain,
              height: 32,
            )
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 40),
                  ),
                  const LogoAnimation(),
                  const Padding(
                    padding: EdgeInsets.only(top: 60),
                  ),
                  TextField(
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    controller: _username,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
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
                      hintText: 'Enter your doccano password here',
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 30),
                  ),
                  TextButton(
                    onPressed: () async {
                      final username = _username.text;
                      final password = _password.text;

                      try {
                        if (await login(username, password)) {
                          if (!mounted) return;
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            projectsRoute,
                            (route) => false,
                          );
                        }
                      } catch (e) {
                        showErrorDialog(context, 'Wrong Credential');
                      }
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 50),
                  ),
                  const Text(
                    'Remind to check the status of the doccano webserver',
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
