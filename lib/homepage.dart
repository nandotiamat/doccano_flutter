import 'package:dio/dio.dart';
import 'package:doccano_flutter/components/circular_progress_indicator_with_text.dart';
import 'package:doccano_flutter/models/examples.dart';
import 'package:doccano_flutter/models/label.dart';
import 'package:doccano_flutter/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:doccano_flutter/globals.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Future<dynamic> getLabels() async {
    var options = Options(headers: {'Authorization': 'Token $key'});

    var response = await dio.get("$doccanoWS/v1/projects/$projectID/span-types",
        options: options);

    List<Label> labels = [];
    response.data.forEach((label) => labels.add(Label.fromJson(label)));

    // ARBITRARIO
    Map<String, dynamic> params = {"limit": 100};

    response = await dio.get("$doccanoWS/v1/projects/$projectID/examples",
        options: options, queryParameters: params);

    List<Example> examples = [];
    response.data["results"]
        .forEach((example) => examples.add(Example.fromJson(example)));

    Map<String, dynamic> data = {"examples": examples, "labels": labels};
    // print(data);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getLabels(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Example> examples = snapshot.data["examples"];
            List<Label> labels = snapshot.data["labels"];
            return Center(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(8.0),
                      itemCount: examples.length,
                      itemBuilder: (context, index) {
                        return Text(examples[index].filename!);
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(8),
                        itemCount: labels.length,
                        itemBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            height: 50,
                            child: Center(
                              child: Chip(
                                labelStyle: TextStyle(
                                    color: Color(hexStringToInt(
                                        labels[index].textColor!))),
                                backgroundColor: Color(hexStringToInt(
                                    labels[index].backgroundColor!)),
                                label: Text(labels[index].text!),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicatorWithText(
                "Fetching labels and examples..."),
          );
        });
  }
}
