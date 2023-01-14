import 'package:dio/dio.dart';
import 'package:doccano_flutter/globals.dart';
import 'package:doccano_flutter/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:selectable/selectable.dart';
import 'components/circular_progress_indicator_with_text.dart';
import 'models/examples.dart';
import 'models/label.dart';
import 'package:float_column/float_column.dart';

class ValidationPage extends StatefulWidget {
  const ValidationPage({super.key});

  @override
  State<ValidationPage> createState() => _ValidationPageState();
}

class _ValidationPageState extends State<ValidationPage> {
  Future<dynamic> getLabels() async {
    var options = Options(headers: {'Authorization': 'Token $key'});

    var response = await dio.get("$doccanoWS/v1/projects/$projectID/span-types",
        options: options);

    List<Label> labels = [];
    response.data.forEach((label) => labels.add(Label.fromJson(label)));

    // ARBITRARIO
    Map<String, dynamic> params = {"confirmed": true};

    response = await dio.get("$doccanoWS/v1/projects/$projectID/examples",
        options: options, queryParameters: params);

    List<Example> confirmedExamples = [];
    response.data["results"]
        .forEach((example) => confirmedExamples.add(Example.fromJson(example)));

    Map<String, dynamic> data = {
      "examples": confirmedExamples,
      "labels": labels
    };
    // print(data);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getLabels(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Example> confirmedExamples = snapshot.data["examples"];
            List<Label> labels = snapshot.data["labels"];
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8.0),
                    itemCount: confirmedExamples.length,
                    itemBuilder: (context, index) {
                      List<InlineSpan> spans = [
                        TextSpan(
                          text: confirmedExamples[index].text!,
                        )
                      ];

                      return Selectable(
                        selectWordOnDoubleTap: true,
                        popupMenuItems: [
                          SelectableMenuItem(
                            icon: Icons.brush_outlined,
                            title: 'Color Red',
                            isEnabled: (controller) =>
                                controller!.isTextSelected,
                            handler: (controller) {
                              final selection = controller?.getSelection();
                              final startIndex = selection?.startIndex;
                              final endIndex = selection?.endIndex;
                              if (selection != null &&
                                  startIndex != null &&
                                  endIndex != null &&
                                  endIndex > startIndex) {
                                final result1 = spans.splitAtCharacterIndex(
                                    SplitAtIndex(startIndex));
                                final result2 = result1.last
                                    .splitAtCharacterIndex(
                                        SplitAtIndex(endIndex - startIndex));
                                setState(() {
                                  spans = [
                                    if (result1.length > 1) ...result1.first,
                                    TextSpan(
                                      children: result2.first,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                    if (result2.length > 1) ...result2.last,
                                  ];
                                });
                                controller!.deselect();
                              }
                              return true;
                            },
                          ),
                        ],
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          child: FloatColumn(
                              children: [TextSpan(children: spans)]),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
                Expanded(
                  child: Wrap(
                    spacing: 6.0,
                    runSpacing: 6.0,
                    children: [
                      for (var i in labels)
                        Chip(
                          labelStyle: TextStyle(
                              color: Color(hexStringToInt(i.textColor!))),
                          backgroundColor:
                              Color(hexStringToInt(i.backgroundColor!)),
                          label: Text(i.text!),
                        )
                    ],
                  ),
                ),
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicatorWithText(
                "Fetching labels and examples..."),
          );
        });
  }
}
