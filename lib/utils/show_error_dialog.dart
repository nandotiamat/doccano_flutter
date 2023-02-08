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
        title: Text(title.toUpperCase()),
        content: Text(text),
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
