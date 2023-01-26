import 'package:float_column/float_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
//EXTENSIONS
// import 'package:doccano_flutter/extensions/inline_span_ext.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key, required this.example});
  final Example example;
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<Span>? fetchedSpans;
  List<Label>? fetchedLabels;
  List<InlineSpan>? _spans;
  late Future<Map<String, dynamic>> _future;
  Label? selectedLabel;

  Future<Map<String, dynamic>> getData() async {

    List<Label> labels = await getLabels();
    // List<Example?>? examples = await getExamples('false', 0);
    List<Span>? spans = await getSpans(widget.example.id!);

    spans!.sort(((a, b) => b.startOffset.compareTo(a.startOffset)));
    //order Spans by start_offset desc

    Map<String, dynamic> data = {
      // "examples": examples,
      "labels": labels,
      "fetchedSpans": spans
    };

    setState(() {
      // TODO
      _spans = [TextSpan(text: widget.example.text)];
      fetchedSpans = spans;
      fetchedLabels = labels;
    });

    buildFetchedSpans(spans, labels);

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

  void buildSpan(Span span, List<List<InlineSpan>> result1, result2) {
    LabelWidgetSpan labelWidgetSpan = LabelWidgetSpan(
      label: span,
      alignment: PlaceholderAlignment.middle,
      child: IgnoreSelectable(
        child: Chip(
          onDeleted: () async {
            int index = _spans!.indexWhere((InlineSpan inlineSpan) {
              if (inlineSpan is LabelTextSpan) {
                return inlineSpan.label.id == span.id;
              } else if (inlineSpan is LabelWidgetSpan) {
                return inlineSpan.label.id == span.id;
              }
              return false;
            });
            bool resourceDeleted = await deleteSpan(widget.example.id!, span.id)
                .then((deleted) => deleted ? true : false);
            if (!resourceDeleted) return;
            setState(() {
              LabelTextSpan oldLabelTextSpan =
                  _spans!.elementAt(index) as LabelTextSpan;
              _spans![index] = TextSpan(text: oldLabelTextSpan.text);
              _spans!.remove(oldLabelTextSpan.chip);
            });
          },
          backgroundColor:
              Color(hexStringToInt(selectedLabel!.backgroundColor!)),
          label: Text(selectedLabel!.text!),
        ),
      ),
    );

    LabelTextSpan labelTextSpan = LabelTextSpan(
      chip: labelWidgetSpan,
      label: span,
      style: TextStyle(
          backgroundColor:
              Color(hexStringToInt(selectedLabel!.backgroundColor!))),
      text:
          result2.first.fold('', (prev, curr) => '$prev${curr.toPlainText()}'),
    );
    // Update the state with the new spans.
    setState(() {
      _spans = [
        if (result1.length > 1) ...result1.first,
        labelTextSpan,
        labelWidgetSpan,
        if (result2.length > 1) ...result2.last,
      ];
    });
  }

  void buildFetchedSpans(List<Span> fetchedSpans, List<Label> labels) {
    List<InlineSpan> temporarySpans = _spans!;
    for (Span span in fetchedSpans) {
      Label spanLabel = labels.firstWhere((label) => label.id == span.label);
      final startIndex = span.startOffset;
      final endIndex = span.endOffset;
      debugPrint(
          "${fetchedSpans.indexOf(span)} $span: $startIndex - $endIndex");
      final result1 =
          temporarySpans.splitAtCharacterIndex(SplitAtIndex(startIndex));
      final result2 = result1.last
          .splitAtCharacterIndex(SplitAtIndex(endIndex - startIndex));

      LabelWidgetSpan labelWidgetSpan = LabelWidgetSpan(
        label: span,
        alignment: PlaceholderAlignment.middle,
        child: IgnoreSelectable(
          child: Chip(
            onDeleted: () async {
              int index = temporarySpans.indexWhere((InlineSpan inlineSpan) {
                if (inlineSpan is LabelTextSpan) {
                  if (inlineSpan.label.id == span.id) {
                    return inlineSpan.label.id == span.id;
                  }
                } else if (inlineSpan is LabelWidgetSpan) {
                  return inlineSpan.label.id == span.id;
                }
                return false;
              });
              // TODO REMOVED FIXED EXAMPLE ID
              bool resourceDeleted =
                  await deleteSpan(widget.example.id!, span.id)
                      .then((deleted) => deleted ? true : false);
              if (!resourceDeleted) return;
              setState(() {
                LabelTextSpan oldLabelTextSpan =
                    _spans!.elementAt(index) as LabelTextSpan;
                _spans![index] = TextSpan(text: oldLabelTextSpan.text);
                _spans!.remove(oldLabelTextSpan.chip);
              });
            },
            backgroundColor: Color(hexStringToInt(spanLabel.backgroundColor!)),
            label: Text(spanLabel.text!),
          ),
        ),
      );

      LabelTextSpan labelTextSpan = LabelTextSpan(
        chip: labelWidgetSpan,
        label: span,
        style: TextStyle(
            backgroundColor: Color(hexStringToInt(spanLabel.backgroundColor!)),
            color: Color(hexStringToInt(spanLabel.textColor!))),
        text: result2.first
            .fold('', (prev, curr) => '$prev${curr.toPlainText()}'),
      );
      // Update the state with the new spans.
      temporarySpans = [
        if (result1.length > 1) ...result1.first,
        labelTextSpan,
        labelWidgetSpan,
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
      int numberOfPreviousWidgetSpan = fetchedSpans!
          .where((element) => element.startOffset < startIndex)
          .length;
      // Split `_spans` at `startIndex`:
      final result1 = _spans!.splitAtCharacterIndex(SplitAtIndex(startIndex));

      // Split `result1.last` at `endIndex - startIndex`:
      final result2 = result1.last
          .splitAtCharacterIndex(SplitAtIndex(endIndex - startIndex));
      createSpan(widget.example.id!, startIndex - numberOfPreviousWidgetSpan,
              endIndex - numberOfPreviousWidgetSpan, selectedLabel!.id!, 0)
          ?.then((spanToBuild) {
        return buildSpan(spanToBuild!, result1, result2);
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
            // List<Example> examples = snapshot.data!["examples"];
            List<Label> labels = snapshot.data!["labels"];

            return Scaffold(
              appBar: AppBar(
                title: Text("Annotating Example ${widget.example.id}"),
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
                            handler: handlerAddSpanController,
                          ),
                        ],
                        selectWordOnDoubleTap: true,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                  ),
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
