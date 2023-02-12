import 'package:doccano_flutter/models/examples.dart';
import 'package:doccano_flutter/widget/logo_animation.dart';
import 'package:doccano_flutter/widget/show_clear_validated_span_dialog.dart';
import 'package:flutter/material.dart';

class AllSpanValidatedWidget extends StatelessWidget {
  const AllSpanValidatedWidget({
    Key? key,
    required this.example,
    required this.mounted,
  }) : super(key: key);

  final Example example;
  final bool mounted;

  @override
  Widget build(BuildContext context) {
    return Column(
      
      children: [
       const Padding(
         padding:  EdgeInsets.all(32.0),
         child: LogoAnimation(),
       ),
        Padding(
           padding: const EdgeInsets.all(32.0),
           child: Center(
             child: ElevatedButton(
               style: ElevatedButton.styleFrom(
                     shape: RoundedRectangleBorder(
                       borderRadius:
                           BorderRadius.circular(50),
                     ),
                     fixedSize: const Size(300 ,70),
                     backgroundColor:
                         Colors.green[400],
               ),
               onPressed: () async {
                 Navigator.pop(context);
               }, 
               child: const Text('ALL SPAN ALREADY VALIDATED',
               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                           ),
             ),
           ),
         ),
         Padding(
           padding: const EdgeInsets.all(32.0),
           child: ElevatedButton(
             style: ElevatedButton.styleFrom(
                   shape: RoundedRectangleBorder(
                     borderRadius:
                         BorderRadius.circular(50),
                   ),
                   fixedSize: const Size(250 ,70),
                   backgroundColor:
                       Colors.lightBlue[400],
                 ),
             onPressed: () async {
               showClearValidatedSpanDialog(context, example, mounted);
    
             }, 
             child: const Text('CLEAR VALIDATED SPAN',
                           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    )
           ),
         ),

      ],
    );
  }
}