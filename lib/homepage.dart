import 'package:dio/dio.dart';
import 'package:doccano_flutter/components/circular_progress_indicator_with_text.dart';
import 'package:doccano_flutter/components/labels_wrap.dart';
import 'package:doccano_flutter/models/examples.dart';
import 'package:doccano_flutter/models/label.dart';
import 'package:doccano_flutter/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:doccano_flutter/globals.dart';
import 'package:selectable/selectable.dart';
import 'package:float_column/float_column.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Future<Map<String, dynamic>> getLabels() async {
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

    setState(() {
      _spans = [TextSpan(text: data["examples"][0].text!)];
    });
    return data;
  }

  List<InlineSpan>? _spans;
  late Future<Map<String, dynamic>> _future;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _future = getLabels();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Example> examples = snapshot.data!["examples"];
            List<Label> labels = snapshot.data!["labels"];

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Selectable(
                      popupMenuItems: [
                        SelectableMenuItem(type: SelectableMenuItemType.copy),
                        SelectableMenuItem(
                          icon: Icons.add,
                          title: 'Add label',
                          isEnabled: (controller) => controller!.isTextSelected,
                          handler: (controller) {
                            final selection = controller?.getSelection();
                            final startIndex = selection?.startIndex;
                            final endIndex = selection?.endIndex;
                            if (selection != null &&
                                startIndex != null &&
                                endIndex != null &&
                                endIndex > startIndex) {
                              // Split `_spans` at `startIndex`:
                              final result1 = _spans!.splitAtCharacterIndex(
                                  SplitAtIndex(startIndex));
                  
                              // Split `result1.last` at `endIndex - startIndex`:
                              final result2 = result1.last.splitAtCharacterIndex(
                                  SplitAtIndex(endIndex - startIndex));
                  
                              // Update the state with the new spans.
                              setState(() {
                                _spans = [
                                  if (result1.length > 1) ...result1.first,
                  
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: IgnoreSelectable(
                                      child: Chip(
                                        label: Text(
                                          result2.first.fold(
                                              '',
                                              (prev, curr) =>
                                                  '$prev ${curr.toPlainText()}'),
                                        ),
                                      ),
                                    ),
                                  ),
                  
                                  // TextSpan(
                                  //   children: result2.first,
                                  //   style: const TextStyle(color: Colors.red),
                                  // ),
                                  if (result2.length > 1) ...result2.last,
                                ];
                              });
                  
                              controller!.deselect();
                            }
                  
                            return true;
                          },
                        ),
                      ],
                      selectWordOnDoubleTap: true,
                      child: RichText(
                        textScaleFactor: 1.25,
                        text: TextSpan(
                          children: _spans,
                          style: const TextStyle(
                            height: 2,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Expanded(
                //   child: ListView.builder(
                //     shrinkWrap: true,
                //     padding: const EdgeInsets.all(8.0),
                //     itemCount: examples.length,
                //     itemBuilder: (context, index) {
                //       return Selectable(
                //         popupMenuItems: [
                //           SelectableMenuItem(type: SelectableMenuItemType.copy),
                //           SelectableMenuItem(
                //             icon: Icons.brush_outlined,
                //             title: 'Color Red',
                //             isEnabled: (controller) =>
                //                 controller!.isTextSelected,
                //             handler: (controller) {
                //               final selection = controller?.getSelection();
                //               final startIndex = selection?.startIndex;
                //               final endIndex = selection?.endIndex;
                //               if (selection != null &&
                //                   startIndex != null &&
                //                   endIndex != null &&
                //                   endIndex > startIndex) {
                //                 // Split `_spans` at `startIndex`:
                //                 final result1 = _spans!.splitAtCharacterIndex(
                //                     SplitAtIndex(startIndex));

                //                 // Split `result1.last` at `endIndex - startIndex`:
                //                 final result2 = result1.last
                //                     .splitAtCharacterIndex(
                //                         SplitAtIndex(endIndex - startIndex));

                //                 // Update the state with the new spans.
                //                 setState(() {
                //                   _spans = [
                //                     if (result1.length > 1) ...result1.first,
                //                     TextSpan(
                //                       children: result2.first,
                //                       style: const TextStyle(color: Colors.red),
                //                     ),
                //                     if (result2.length > 1) ...result2.last,
                //                   ];
                //                 });

                //                 controller!.deselect();
                //               }

                //               return true;
                //             },
                //           ),
                //         ],
                //         selectWordOnDoubleTap: true,
                //         child: Padding(
                //           padding: const EdgeInsets.all(16.0),
                //           child: Text(examples[index].filename!),
                //         ),
                //       );
                //     },
                //   ),
                // ),
                Expanded(
                  child: LabelsWrap(labels: labels),
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
