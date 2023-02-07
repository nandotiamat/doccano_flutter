import 'package:doccano_flutter/components/user_data.dart';
import 'package:doccano_flutter/menu_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/examples.dart';

Future<void> ShowClearValidatedSpanDialog(  BuildContext context, Example passedExample){
  return showDialog(
    context: context, 
    builder: ((context) {
      return AlertDialog(
      title: const Text('CLEARING VALIDATED SPAN...'),
      content: 
           SizedBox(
            height: 150,
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

            var boxUsers = await Hive.openBox('UTENTI');

            boxUsers.put('Examples',UserData( examples: {passedExample.id.toString(): []}));
            print('apro la box da validation page clear spans-> ${boxUsers.get('Examples').examples["${passedExample.id}"]}');

            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.push(context,MaterialPageRoute(builder: (context) => const MenuPage()));
          },
          child: const Text('CLEAR'),
        ),
      ],
        
      );
    })
  );
}