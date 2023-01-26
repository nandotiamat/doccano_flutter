import 'dart:convert';

import 'package:doccano_flutter/models/examples.dart';
import 'package:doccano_flutter/utils/doccano_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'components/circular_progress_indicator_with_text.dart';

class ValidationPage extends StatefulWidget {
  const ValidationPage({Key? key, required this.passedExample})
      : super(key: key);

  final Map<String, dynamic> passedExample;

  @override
  State<ValidationPage> createState() => _ValidationPageState();
}

class _ValidationPageState extends State<ValidationPage> {
  late Future<ExampleMetadata?>? _future;

  Future<ExampleMetadata?>? getData() async {
    ExampleMetadata? metaData =
        await getExampleMetaData(Example.fromJson(widget.passedExample).id!);
    return metaData;
  }

  @override
  void initState() {
    super.initState();
    _future = getData();
  }

  @override
  Widget build(BuildContext context) {
    Example example = Example.fromJson(widget.passedExample);

    return Scaffold(
        appBar: AppBar(
          title: Text('Dataset ID: ${example.id}'),
        ),
        body: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              ExampleMetadata? metaData = snapshot.data;

              String stringToParse = metaData!.comment!;
              final RegExp _regex = RegExp(r"(\w+): (\w+),");

              Map<String, dynamic> parseString(String string) {
                var match = _regex.allMatches(string);
                Map<String, dynamic> map = {};
                for (var m in match) {
                  String key = m.group(1)!;
                  String value = m.group(2)!;
                  value = value + ' ' + m.group(3)!;
                  map[key] = value;
                }
                return map;
              }

              Map<String, dynamic> commentMap = parseString(stringToParse);
              print(commentMap);

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      color: Colors.blue[500],
                      elevation: 8,
                      shadowColor: Colors.green,
                      margin: const EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SizedBox(
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  metaData.comment!,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicatorWithText(
                    "Fetching labels and examples..."),
              ),
            );
          },
        ));
  }
}
