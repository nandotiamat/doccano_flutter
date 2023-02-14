import 'package:flutter/material.dart';


Future<void> nothingToClearDialog(  BuildContext context, bool mounted){
  return showDialog(
    context: context, 
    builder: ((context) {
      return AlertDialog(
      title: const Text('NOTHING TO CLEAR...'),
      content: 
           SizedBox(
            height: 100,
            child: Column(
              children: const [  
                 Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Text(
                    'There are no spans already validated',
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
    })
  );
}