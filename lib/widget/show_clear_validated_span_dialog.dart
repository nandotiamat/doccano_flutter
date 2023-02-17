import 'package:doccano_flutter/components/user_data.dart';
import 'package:doccano_flutter/globals.dart';
import 'package:flutter/material.dart';

import '../models/examples.dart';

Future<void> showClearValidatedSpanDialog(
    BuildContext context, Example passedExample, bool mounted) {
  return showDialog(
      context: context,
      builder: ((context) {
        return AlertDialog(
          title: const Text('CLEARING VALIDATED SPAN...'),
          content: SizedBox(
            height: 200,
            child: Column(
              children: const [
                Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Text(
                    'You are clearing all the validated span for this examples...if you delete them then you will have to validate them all over again...are you SURE??',
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
              child: const Text('NO'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();

                var username = sessionBox.get("username");
                usersBox.put('$username',
                    UserData(examples: {passedExample.id.toString(): []}));
                debugPrint(
                    'apro la box da validation page clear spans-> ${usersBox.get('$username')?.examples["${passedExample.id}"]}');

                if (!mounted) return;
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('CLEAR'),
            ),
          ],
        );
      }));
}
