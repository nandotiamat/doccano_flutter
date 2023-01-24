import 'package:doccano_flutter/globals.dart';
import 'package:flutter/material.dart';

Future<void> showDeleteSpanDialog(
  BuildContext context,
) {
  bool? checkBoxdontAskValue = false;

  void saveCheckBoxValue() {
    prefs.setBool("DELETE_SPAN", checkBoxdontAskValue!);
  }

  return showDialog(
    context: context,
    builder: ((context) {
      return AlertDialog(
        title: const Text('DELETING SPAN...'),
        content: SizedBox(
          height: 120,
          child: Column(
            children: [
              Row(
                children: [
                  Checkbox(
                    value: checkBoxdontAskValue,
                    onChanged: (bool? value) {
                      checkBoxdontAskValue = value!;
                      saveCheckBoxValue();
                      print(checkBoxdontAskValue);
                    },
                  ),
                  const Text('Dont Ask Anymore'),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Text(
                  'Are you sure to delete this Span???',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
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
