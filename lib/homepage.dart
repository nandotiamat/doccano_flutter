import 'package:doccano_flutter/components/circular_progress_indicator_with_text.dart';
import 'package:doccano_flutter/components/labels_wrap.dart';
import 'package:doccano_flutter/models/examples.dart';
import 'package:doccano_flutter/models/label.dart';
import 'package:doccano_flutter/utils/doccano_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:selectable/selectable.dart';
import 'package:float_column/float_column.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<InlineSpan>? _spans;
  late Future<Map<String, dynamic>> _future;
  Label? selectedLabel;

  Future<Map<String, dynamic>> getData() async {
    if (dotenv.get("ENV") == "development") {
      await login(dotenv.get("USERNAME"), dotenv.get("PASSWORD"));
    }
    List<Label?>? labels = await getLabels();
    List<Example?>? examples = await getExamples();
    Map<String, dynamic> data = {"examples": examples, "labels": labels};

    setState(() {
      _spans = [TextSpan(text: data["examples"][0].text!)];
    });

    return data;
  }

  @override
  void initState() {
    super.initState();
    _future = getData();
  }

  void updateSelectedLabel(Label? selectedLabel) {
    setState(() {
      this.selectedLabel = selectedLabel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Example> examples = snapshot.data!["examples"];
            List<Label> labels = snapshot.data!["labels"];

            return Scaffold(
              appBar: AppBar(
                title: const Text("Doccano Flutter"),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Selectable(
                        popupMenuItems: [
                          SelectableMenuItem(type: SelectableMenuItemType.copy),
                          SelectableMenuItem(
                            icon: Icons.add,
                            title: 'Add label',
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
                                // Split `_spans` at `startIndex`:
                                final result1 = _spans!.splitAtCharacterIndex(
                                    SplitAtIndex(startIndex));

                                // Split `result1.last` at `endIndex - startIndex`:
                                final result2 = result1.last
                                    .splitAtCharacterIndex(
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
                    child: LabelsWrap(labels, updateSelectedLabel),
                  ),
                ],
              ),
            );
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicatorWithText(
                  "Fetching labels and examples..."),
            ),
          );
        });
  }
}
