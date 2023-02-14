import 'package:flutter/material.dart';

Future<void> showErrorLoginDialog(
  BuildContext context,
  String title,
  String text,
) {
  return showDialog(
    context: context,
    builder: ((context) {
      return AlertDialog(
        title: Text('Login Error'),
        content: SingleChildScrollView(child: Expanded(child: Text(title))),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    }),
  );
}
