import 'package:doccano_flutter/components/span_to_validate.dart';
import 'package:doccano_flutter/components/user_data.dart';
import 'package:doccano_flutter/menu_page.dart';
import 'package:doccano_flutter/models/examples.dart';
import 'package:doccano_flutter/models/span.dart';
import 'package:doccano_flutter/utils/doccano_api.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class RecapValidationAndSaveChanges extends StatelessWidget {

  const RecapValidationAndSaveChanges({
    Key? key,
    required this.mounted,
    required this.example,
    required this.validatingSpans,
    required this.ignoringSpans,
    required this.deletingSpans,
    required this.validatedSpans,
  }) : super(key: key);

    final bool mounted;
    final Example example;
    final List<SpanToValidate>? validatingSpans ;
    final List<Span>? deletingSpans ;
    final List<Span>? ignoringSpans ;
    final List<SpanToValidate>? validatedSpans;

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 100,
                  child: Card(
                    elevation: 8,
                    color: Colors.red,
                    child: Column(
                      children: [
                        const Padding(
                          padding:
                              EdgeInsets.all(8.0),
                          child: Text(
                            'DELETE',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight:
                                    FontWeight
                                        .bold),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.all(
                                  8.0),
                          child: Text(
                            'You are deleting ${deletingSpans?.length} Span',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 100,
                  child: Card(
                    elevation: 8,
                    color: Colors.grey,
                    child: Column(
                      children: [
                        const Padding(
                          padding:
                              EdgeInsets.all(8.0),
                          child: Text(
                            'IGNORE',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight:
                                    FontWeight
                                        .bold),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.all(
                                  8.0),
                          child: Text(
                            'You are ignoring ${ignoringSpans?.length} Span',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 100,
                  child: Card(
                    elevation: 8,
                    color: Colors.green,
                    child: Column(
                      children: [
                        const Padding(
                          padding:
                              EdgeInsets.all(8.0),
                          child: Text(
                            'VALIDATE',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight:
                                    FontWeight
                                        .bold),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.all(
                                  8.0),
                          child: Text(
                            'You are validating ${validatingSpans?.length} Span',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 80.0),
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(50),
                    ),
                    fixedSize: const Size(150, 70),
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                                'ANNULLA VALIDAZIONE...'),
                            content:
                                StatefulBuilder(
                              builder: (BuildContext
                                      context,
                                  StateSetter
                                      setState) {
                                return const SizedBox(
                                  height: 60,
                                  child: Padding(
                                    padding: EdgeInsets
                                        .only(
                                            top:
                                                16.0),
                                    child: Text(
                                      'Stai annullando la validazione...sei sicuro??',
                                      style: TextStyle(
                                          fontSize:
                                              18,
                                          fontWeight:
                                              FontWeight
                                                  .bold),
                                    ),
                                  ),
                                );
                              },
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(
                                          context)
                                      .pop();
                                },
                                child: const Text(
                                    'NO'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(
                                          context)
                                      .pop();

                                  Navigator.pop(
                                      context);
                                  Navigator.pop(
                                      context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder:
                                              (context) =>
                                                  const MenuPage()));
                                },
                                child: const Text(
                                    'OK'),
                              ),
                            ],
                          );
                        });
                  },
                  child: const Text(
                    'ANNULLA',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 80.0),
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(50),
                    ),
                    fixedSize: const Size(150, 70),
                    backgroundColor:
                        Colors.green[400],
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                                'CONFERMA VALIDAZIONE...'),
                            content:
                                StatefulBuilder(
                              builder: (BuildContext
                                      context,
                                  StateSetter
                                      setState) {
                                return const SizedBox(
                                  height: 60,
                                  child: Padding(
                                    padding: EdgeInsets
                                        .only(
                                            top:
                                                16.0),
                                    child: Text(
                                      'Stai sincronizzando la validazione con il webserver...sei sicuro??',
                                      style: TextStyle(
                                          fontSize:
                                              18,
                                          fontWeight:
                                              FontWeight
                                                  .bold),
                                    ),
                                  ),
                                );
                              },
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(
                                          context)
                                      .pop();
                                },
                                child: const Text(
                                    'NO'),
                              ),
                              TextButton(
                                //conferma e sync col webserver
                                onPressed:() async {

                                  if(deletingSpans?.isNotEmpty ?? false){
                                    for(int i = 0; i < deletingSpans!.length; i++){
                                      deleteSpan(example.id!, deletingSpans![i].id);
                                    }
                                    debugPrint("Spans $deletingSpans from example ${example.id}  successfully deleted.");
                                  }
                                    
                                  validatingSpans?.forEach((span) {span.validated =true;});

                                  if (validatedSpans?.isNotEmpty ??false) {
                                    validatingSpans?.addAll(validatedSpans!);
                                  }

                                  var boxUsers =await Hive.openBox('UTENTI');

                                  boxUsers.put('Examples',UserData(examples: {example.id.toString(): validatingSpans}));

                                  print('apro la box da validation page sync server-> ${boxUsers.get('Examples').examples}');

                                  if(!mounted) return;
                                  Navigator.of(context).pop();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.push(context,MaterialPageRoute(builder:(context) =>const MenuPage()));
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        });
                  },
                  child: const Text(
                    'CONFERMA',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
        
      ],
    );
  }
}