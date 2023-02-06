import 'package:doccano_flutter/globals.dart';
import 'package:float_column/float_column.dart';
import 'package:flutter/material.dart';
import 'package:selectable/selectable.dart';
//COMPONENTS
import 'package:doccano_flutter/components/circular_progress_indicator_with_text.dart';
import 'package:doccano_flutter/components/label_text_span.dart';
import 'package:doccano_flutter/components/labels_wrap.dart';
//MODELS
import 'package:doccano_flutter/models/examples.dart';
import 'package:doccano_flutter/models/label.dart';
import 'package:doccano_flutter/models/span.dart';
//UTILS
import 'package:doccano_flutter/utils/doccano_api.dart';
import 'package:doccano_flutter/utils/utilities.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
//EXTENSIONS
// import 'package:doccano_flutter/extensions/inline_span_ext.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key, required this.exampleID});
  // final Example example;
  final int exampleID;
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  PanelController panelController = PanelController();
  List<SpanCluster> spanClusters = [];
  List<Span>? fetchedSpans;
  List<Label>? fetchedLabels;
  List<InlineSpan>? _spans;
  List<InlineSpan>? _vanillaTextSpans;
  late Future<Map<String, dynamic>> _future;
  late bool isExampleConfirmed;
  late Example example;
  bool? allowOverlapping = prefs.getBool("allow_overlapping");
  bool showSelectedLabelAnnotations = false;
  Label? selectedLabel;

  Future<Map<String, dynamic>> getData() async {
    List<Label> labels = await getLabels();
    List<Span>? spans = await getSpans(widget.exampleID);
    Example? example = await getExample(widget.exampleID);
    spans!.sort((a, b) => b.length.compareTo(a.length));
    // order Spans by length desc

    Map<String, dynamic> data = {
      "fetchedLabels": labels,
      "fetchedSpans": spans,
      "example": example,
    };
    return data;
  }

  @override
  void initState() {
    super.initState();
    _future = getData().then((data) {
      setState(() {
        _spans = [TextSpan(text: data["example"].text)];
        _vanillaTextSpans = _spans;
        fetchedSpans = data["fetchedSpans"];
        fetchedLabels = data["fetchedLabels"];
        example = data["example"];
        isExampleConfirmed = data["example"].isConfirmed!;
      });

      createClusters(data["fetchedSpans"], data["fetchedLabels"]);
      buildClusters();
      return data;
    });
  }

  void updateClusters() {
    createClusters(fetchedSpans!, fetchedLabels!);
    buildClusters();
  }

  void updateSelectedLabel(Label? selectedLabel) {
    setState(() {
      this.selectedLabel = selectedLabel;
    });
  }

  void updateShowSelectedLabelAnnotations(bool value) {
    setState(() {
      showSelectedLabelAnnotations = value;
    });
  }

  void createClusters(List<Span> fetchedSpans, List<Label> labels) {
    // creating spanClusters from zero and splitting the annotated text from the example without any annotation.
    spanClusters.clear();
    _spans = _vanillaTextSpans;
    for (Span span in showSelectedLabelAnnotations && selectedLabel != null
        ? fetchedSpans.where((span) => span.label == selectedLabel!.id)
        : fetchedSpans) {
      Label spanLabel = labels.firstWhere((label) => label.id == span.label);
      final startIndex = span.startOffset;
      final endIndex = span.endOffset;

      final result1 =
          _vanillaTextSpans!.splitAtCharacterIndex(SplitAtIndex(startIndex));
      final result2 = result1.last
          .splitAtCharacterIndex(SplitAtIndex(endIndex - startIndex));

      LabelWidgetSpan labelWidgetSpan = LabelWidgetSpan(
        label: span,
        alignment: PlaceholderAlignment.middle,
        child: IgnoreSelectable(
          child: Chip(
            onDeleted: () async {
              bool resourceDeleted = await deleteSpan(example.id!, span.id)
                  .then((deleted) => deleted ? true : false);
              if (!resourceDeleted) return;
              setState(() {
                fetchedSpans.remove(span);
              });
              createClusters(fetchedSpans, labels);
              return buildClusters();
            },
            backgroundColor: Color(hexStringToInt(spanLabel.backgroundColor!)),
            label: Text(spanLabel.text!),
          ),
        ),
      );

      LabelTextSpan labelTextSpan = LabelTextSpan(
        doccanoLabel: spanLabel,
        chip: labelWidgetSpan,
        label: span,
        style: TextStyle(
            backgroundColor: Color(hexStringToInt(spanLabel.backgroundColor!)),
            color: Color(hexStringToInt(spanLabel.textColor!))),
        text: result2.first
            .fold('', (prev, curr) => '$prev${curr.toPlainText()}'),
      );

      if (spanClusters.isEmpty) {
        spanClusters.add(SpanCluster(
            labelTextSpans: [labelTextSpan],
            labelWidgetSpans: [labelWidgetSpan]));
      } else {
        int indexSpanClusterToAdd = spanClusters.indexWhere((cluster) {
          return ((cluster.startIndex <= span.startOffset &&
                  span.startOffset <= cluster.endIndex) ||
              (cluster.startIndex <= span.endOffset &&
                  span.startOffset <= cluster.endIndex) ||
              (span.startOffset <= cluster.startIndex &&
                  span.endOffset >= cluster.endIndex));
        });

        if (indexSpanClusterToAdd == -1) {
          spanClusters.add(SpanCluster(
              labelTextSpans: [labelTextSpan],
              labelWidgetSpans: [labelWidgetSpan]));
        } else {
          spanClusters[indexSpanClusterToAdd]
              .addLabel(labelWidgetSpan, labelTextSpan, _spans!);
        }
      }
    }
  }

  void buildClusters() {
    List<InlineSpan> temporarySpans = _vanillaTextSpans!;
    for (SpanCluster spanCluster in spanClusters) {
      final startIndex = spanCluster.startIndex;
      final endIndex = spanCluster.endIndex;
      int numberOfPreviousWidgetSpan = temporarySpans.where((element) {
        if (element.runtimeType == LabelWidgetSpan) {
          return (element as LabelWidgetSpan).label.endOffset < startIndex;
        }
        return false;
      }).length;

      final result1 = temporarySpans.splitAtCharacterIndex(
          SplitAtIndex(startIndex + numberOfPreviousWidgetSpan));
      final result2 = result1.last
          .splitAtCharacterIndex(SplitAtIndex(endIndex - startIndex));

      temporarySpans = [
        if (result1.length > 1) ...result1.first,
        ...spanCluster.build(),
        if (result2.length > 1) ...result2.last,
      ];
    }

    setState(() {
      _spans = temporarySpans;
    });
  }

  bool handlerAddSpanController(SelectableController? controller) {
    if (selectedLabel == null) {
      debugPrint("Non sono selezionate label.");
      return false;
    }
    final selection = controller?.getSelection();
    final startIndex = selection?.startIndex;
    final endIndex = selection?.endIndex;
    if (selection != null &&
        startIndex != null &&
        endIndex != null &&
        endIndex > startIndex) {
      int numberOfPreviousWidgetSpan = _spans!.where((element) {
        if (element.runtimeType == LabelWidgetSpan) {
          return (element as LabelWidgetSpan).label.endOffset < startIndex;
        }
        return false;
      }).length;
      createSpan(example.id!, startIndex - numberOfPreviousWidgetSpan,
              endIndex - numberOfPreviousWidgetSpan, selectedLabel!.id!, 0)
          ?.then((spanToBuild) {
        if (spanToBuild != null) {
          setState(() {
            fetchedSpans!.add(spanToBuild);
            fetchedSpans!.sort((a, b) => b.length.compareTo(a.length));
          });
          createClusters(fetchedSpans!, fetchedLabels!);
          return buildClusters();
        }
        return;
      });
      controller!.deselect();
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Label> labels = snapshot.data!["fetchedLabels"];

            return Scaffold(
              appBar: AppBar(
                title: Text("Annotating Example ${example.id}"),
                actions: [
                  IconButton(
                    onPressed: () async {
                      await unCheckExample(example.id!);
                      setState(() {
                        isExampleConfirmed = !isExampleConfirmed;
                      });
                    },
                    icon: isExampleConfirmed
                        ? const Tooltip(
                            message: "Checked",
                            child: Icon(Icons.check_circle_outline),
                          )
                        : const Tooltip(
                            message: "Not checked",
                            child: Icon(Icons.cancel_outlined),
                          ),
                  ),
                ],
              ),
              body: SlidingUpPanel(
                parallaxEnabled: true,
                panelBuilder: (sc) => LabelsWrap(
                  labels,
                  updateSelectedLabel,
                  updateShowSelectedLabelAnnotations,
                  sc,
                  panelController: panelController,
                  clustersUpdateCallback: updateClusters,
                ),
                body: SingleChildScrollView(
                  child: Selectable(
                    popupMenuItems: [
                      SelectableMenuItem(type: SelectableMenuItemType.copy),
                      SelectableMenuItem(
                        icon: Icons.add,
                        title: 'Add label',
                        isEnabled: (controller) {
                          if (!allowOverlapping!) {
                            final selection = controller?.getSelection();
                            final startIndex = selection?.startIndex;
                            final endIndex = selection?.endIndex;
                            if (selection != null &&
                                startIndex != null &&
                                endIndex != null &&
                                endIndex > startIndex) {
                              for (SpanCluster cluster in spanClusters) {
                                int numberOfPreviousWidgetSpan =
                                    _spans!.where((element) {
                                  if (element.runtimeType == LabelWidgetSpan) {
                                    return (element as LabelWidgetSpan)
                                            .label
                                            .endOffset <
                                        startIndex;
                                  }
                                  return false;
                                }).length;
                                int newStartIndex =
                                    startIndex - numberOfPreviousWidgetSpan;
                                int newEndIndex =
                                    endIndex - numberOfPreviousWidgetSpan;

                                bool overlap =
                                    ((cluster.startIndex < newStartIndex &&
                                            newStartIndex < cluster.endIndex) ||
                                        (cluster.startIndex < newEndIndex &&
                                            newStartIndex < cluster.endIndex) ||
                                        (newStartIndex < cluster.startIndex &&
                                            newEndIndex > cluster.endIndex));

                                if (overlap) {
                                  return false;
                                }
                              }
                            }
                          }

                          return controller!.isTextSelected;
                        },
                        handler: handlerAddSpanController,
                      ),
                    ],
                    selectWordOnDoubleTap: true,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: RichText(
                        textScaleFactor: 1.50,
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
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0),
                ),
                controller: panelController,
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
