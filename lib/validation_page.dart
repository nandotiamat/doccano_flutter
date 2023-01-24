import 'package:doccano_flutter/components/span_to_validate.dart';
import 'package:doccano_flutter/globals.dart';
import 'package:doccano_flutter/models/comment.dart';
import 'package:doccano_flutter/models/examples.dart';
import 'package:doccano_flutter/models/label.dart';
import 'package:doccano_flutter/models/span.dart';
import 'package:doccano_flutter/utils/doccano_api.dart';
import 'package:doccano_flutter/utils/show_delete_span_dialog.dart';
import 'package:doccano_flutter/utils/utilities.dart';
import 'package:float_column/float_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'components/circular_progress_indicator_with_text.dart';

class ValidationPage extends StatefulWidget {
  const ValidationPage({Key? key, required this.passedExample})
      : super(key: key);

  final Example passedExample;

  @override
  State<ValidationPage> createState() => _ValidationPageState();
}

class _ValidationPageState extends State<ValidationPage> {
  late Future<ExampleMetadata?>? _future;
  List<Span>? fetchedSpans;
  List<Label>? fetchedLabels;
  List<InlineSpan>? _spans;
  List<SpanToValidate>? _spansToValidate;

  Future<ExampleMetadata?>? getData() async {
    if (dotenv.get("ENV") == "development") {
      await login(dotenv.get("USERNAME"), dotenv.get("PASSWORD"));
    }

    List<Label> labels = await getLabels();
    List<Span>? spans = await getSpans(widget.passedExample.id!);

    ExampleMetadata? metaData = await getExampleMetaData(
        Example.fromJson(widget.passedExample.toJson()).id!);

    setState(() {
      fetchedSpans = spans;
      fetchedLabels = labels;
      _spans = [TextSpan(text: widget.passedExample.text)];
    });

    buildFetchedSpans(spans!, labels);
    getSpanToValidate();

    return metaData;
  }

  @override
  void initState() {
    super.initState();
    _future = getData();
  }

  int offsetTextToShow = 40;

  List<InlineSpan> getValidationText(Span span) {
    List<List<InlineSpan>> result1 = _spans!.splitAtCharacterIndex(
        SplitAtIndex(span.startOffset - offsetTextToShow));
    List<List<InlineSpan>> result2 = result1.last.splitAtCharacterIndex(
        SplitAtIndex(span.endOffset - span.startOffset + 2 * offsetTextToShow));

    return result2.first;
  }

  void getSpanToValidate() {
    List<SpanToValidate> list = [];
    for (Span span in fetchedSpans!) {
      Label label =
          fetchedLabels!.firstWhere((label) => label.id == span.label);
      List<InlineSpan> validationInlineSpan = getValidationText(span);

      list.add(SpanToValidate(
        inlineSpanList: validationInlineSpan,
        label: label,
      ));
    }

    updateTextSpan(list);

    setState(() {
      _spansToValidate = list;
    });
  }

  void buildFetchedSpans(List<Span> fetchedSpans, List<Label> labels) {
    List<InlineSpan> temporarySpans = _spans!;
    for (Span span in fetchedSpans) {
      Label spanLabel = labels.firstWhere((label) => label.id == span.label);
      final startIndex = span.startOffset;
      final endIndex = span.endOffset;
      //debugPrint(
      //    "${fetcexOf(span)} $span: $startIndex - $endIndex");
      final result1 =
          temporarySpans.splitAtCharacterIndex(SplitAtIndex(startIndex));
      final result2 = result1.last
          .splitAtCharacterIndex(SplitAtIndex(endIndex - startIndex));

      TextSpan labelTextSpan = TextSpan(
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
        if (result2.length > 1) ...result2.last,
      ];
    }
    setState(() {
      _spans = temporarySpans;
    });
  }

  @override
  Widget build(BuildContext context) {
    Example example = widget.passedExample;
    bool? checkBoxdontAskValue = false;

    void saveCheckBoxValue() {
      prefs.setBool("DELETE_SPAN", checkBoxdontAskValue!);
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Dataset ID: ${example.id}'),
        ),
        body: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              ExampleMetadata? metaData = snapshot.data;
              List<Label>? labels = fetchedLabels;
              List<Span>? spans = fetchedSpans;

              String commentString = metaData!.comment!;
              Map<String, dynamic> commentMap = {};

              commentString.split(',').forEach((element) {
                final parts = element.split(':');
                commentMap[parts[0].trim()] = parts[1].trim();
              });

              Comment comment = Comment.fromJson(commentMap);
              comment.fixData();

              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        elevation: 8,
                        margin: const EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    children: [
                                      RichText(
                                        textScaleFactor: 2.0,
                                        text: TextSpan(
                                            style: const TextStyle(
                                                color: Colors.black),
                                            children: _spansToValidate![0]
                                                .inlineSpanList),
                                      ),
                                      Transform(
                                        transform: Matrix4.identity()
                                          ..scale(1.4, 1.4),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 32.0, top: 15, bottom: 15),
                                          child: Chip(
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                            label: Text(_spansToValidate![0]
                                                .label
                                                .text!),
                                            backgroundColor: Color(
                                                hexStringToInt(
                                                    _spansToValidate![0]
                                                        .label
                                                        .backgroundColor!)),
                                            labelStyle: TextStyle(
                                                color: Color(hexStringToInt(
                                                    _spansToValidate![9]
                                                        .label
                                                        .textColor!))),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 30.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50)),
                                                  fixedSize: const Size(80, 50),
                                                  backgroundColor: Colors.red),
                                              onPressed: () {
                                                (prefs.getBool("DELETE_SPAN")!)
                                                    ? print(
                                                        'non ti verra chiesto piu')
                                                    : showDialog(
                                                        context: context,
                                                        builder: ((context) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                                'DELETING SPAN...'),
                                                            content:
                                                                StatefulBuilder(
                                                              builder: (BuildContext
                                                                      context,
                                                                  StateSetter
                                                                      setState) {
                                                                return SizedBox(
                                                                  height: 120,
                                                                  child: Column(
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Checkbox(
                                                                            value:
                                                                                checkBoxdontAskValue,
                                                                            onChanged:
                                                                                (value) {
                                                                              setState(() {
                                                                                checkBoxdontAskValue = value!;
                                                                                saveCheckBoxValue();
                                                                              });
                                                                            },
                                                                          ),
                                                                          const Text(
                                                                              'Dont Ask Anymore'),
                                                                        ],
                                                                      ),
                                                                      const Padding(
                                                                        padding:
                                                                            EdgeInsets.only(top: 16.0),
                                                                        child:
                                                                            Text(
                                                                          'You are deleting a span on this examples...are you SURE??',
                                                                          style: TextStyle(
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                      ),
                                                                    ],
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
                                                                child:
                                                                    const Text(
                                                                        'OK'),
                                                              ),
                                                            ],
                                                          );
                                                        }),
                                                      );
                                              },
                                              child: const Text('NO'),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50)),
                                                  fixedSize: const Size(80, 50),
                                                  backgroundColor:
                                                      Colors.green[300]),
                                              onPressed: () {
                                                ;
                                              },
                                              child: const Text('SI'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

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
                          children: comment
                              .toJson()
                              .entries
                              .map((property) {
                                return Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0, top: 12.0),
                                    child: Text(
                                      '${property.key}: ${property.value}',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                );
                              })
                              .toList()
                              .cast<Widget>(),
                        ),
                      ),
                    ),
                  ),

                  //Expanded(
                  //  child: SingleChildScrollView(
                  //    child: ListView.builder(
                  //        itemCount: _validationInlineSpans!.length,
                  //        itemBuilder: (context, index) {
                  //          return RichText(
                  //            text: TextSpan(
                  //              style: TextStyle(color: Colors.black),
                  //              children:
                  //                  _validationInlineSpans!.elementAt(index),
                  //            ),
                  //          );
                  //        }),
                  //  ),
                  //),
                  //Expanded(
                  //  child: SingleChildScrollView(
                  //    child: RichText(
                  //      textScaleFactor: 1.25,
                  //      text: TextSpan(
                  //          children: _spans,
                  //          style: TextStyle(color: Colors.black)),
                  //    ),
                  //  ),
                  //),
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
