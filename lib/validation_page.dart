import 'package:doccano_flutter/components/comment_widget.dart';
import 'package:doccano_flutter/components/span_to_validate.dart';
import 'package:doccano_flutter/components/validation_card.dart';
import 'package:doccano_flutter/globals.dart';
import 'package:doccano_flutter/models/comment.dart';
import 'package:doccano_flutter/models/examples.dart';
import 'package:doccano_flutter/models/label.dart';
import 'package:doccano_flutter/models/span.dart';
import 'package:doccano_flutter/utils/doccano_api.dart';
import 'package:doccano_flutter/utils/dont_ask_dialog.dart';
import 'package:doccano_flutter/utils/utilities.dart';
import 'package:float_column/float_column.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'components/circular_progress_indicator_with_text.dart';

import 'package:flutter_card_swiper/flutter_card_swiper.dart';

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

  Future<ExampleMetadata?>? getData() async {
    if (dotenv.get("ENV") == "development") {
      await login(dotenv.get("USERNAME"), dotenv.get("PASSWORD"));
    }

    List<Label> labels = await getLabels();
    List<Span>? spans = await getSpans(widget.passedExample.id!);

    spans!.sort(((a, b) => a.startOffset.compareTo(b.startOffset)));

    ExampleMetadata? metaData = await getExampleMetaData(
        Example.fromJson(widget.passedExample.toJson()).id!);

    setState(() {
      fetchedSpans = spans;
      fetchedLabels = labels;
      _spans = [TextSpan(text: widget.passedExample.text)];
    });

    return metaData;
  }

  @override
  void initState() {
    super.initState();
    _future = getData();
  }

  int offsetTextToShow = 40;

  List<InlineSpan> getValidationText(Span span, List<InlineSpan> text) {
    List<List<InlineSpan>> result1 = text.splitAtCharacterIndex(
        SplitAtIndex(span.startOffset - offsetTextToShow));
    List<List<InlineSpan>> result2 = result1.last.splitAtCharacterIndex(
        SplitAtIndex(span.endOffset - span.startOffset + 2 * offsetTextToShow));

    return result2.first;
  }

  List<InlineSpan> buildSpan(Span span) {
    List<InlineSpan> temporarySpans = _spans!;
    Label spanLabel =
        fetchedLabels!.firstWhere((label) => label.id == span.label);

    final startIndex = span.startOffset;
    final endIndex = span.endOffset;
    final result1 =
        temporarySpans.splitAtCharacterIndex(SplitAtIndex(startIndex));
    final result2 =
        result1.last.splitAtCharacterIndex(SplitAtIndex(endIndex - startIndex));

    TextSpan labelTextSpan = TextSpan(
      style: TextStyle(
          backgroundColor: Color(hexStringToInt(spanLabel.backgroundColor!)),
          color: Color(hexStringToInt(spanLabel.textColor!))),
      text:
          result2.first.fold('', (prev, curr) => '$prev${curr.toPlainText()}'),
    );

    // Update the state with the new spans.
    temporarySpans = [
      if (result1.length > 1) ...result1.first,
      labelTextSpan,
      if (result2.length > 1) ...result2.last,
    ];

    return getValidationText(span, temporarySpans);
  }

  @override
  Widget build(BuildContext context) {
    Example example = widget.passedExample;
    bool? checkBoxdontAskValue = false;
    final CardSwiperController controller = CardSwiperController();

    List<ValidationCard> cards = [
      ...List.generate(fetchedSpans?.length ?? 0, (index) {
        SpanToValidate spanToValidate = SpanToValidate(
            inlineSpanList: buildSpan(fetchedSpans![index]),
            label: fetchedLabels!
                .firstWhere((label) => fetchedSpans![index].label == label.id));

        updateTextSpan(spanToValidate);

        return ValidationCard(spanToValidate: spanToValidate);
      })
    ];

    // ignore: no_leading_underscores_for_local_identifiers
    void _swipe(int index, CardSwiperDirection direction) async {
      //ValidationCard lastCard = cards[index];

      if (direction.name == 'top' || direction.name == 'right') {
        print("the card was swiped to the: ${direction.name} with   $index");
      }
      if (direction.name == 'bottom' || direction.name == 'left') {
        print("the card was swiped to the: ${direction.name} $index");
        print(widget.passedExample.id!);
        print(fetchedSpans![index].id);
        //deleteSpan(widget.passedExample.id!, fetchedSpans![index].id);
        //debugPrint("Span $index from example ${widget.passedExample.id} was successfully deleted.");
      }
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

              String commentString = metaData!.comment!;
              Map<String, dynamic> commentMap = {};

              commentString.split(',').forEach((element) {
                final parts = element.split(':');
                commentMap[parts[0].trim()] = parts[1].trim();
              });

              Comment comment = Comment.fromJson(commentMap);
              comment.fixData();

              controller.swipeTop();

              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                      child: CardSwiper(
                    controller: controller,
                    cards: cards,
                    onSwipe: _swipe,
                  )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //swipeRightButton(controller),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            fixedSize: const Size(80, 50),
                            backgroundColor: Colors.red),
                        onPressed: () {
                          (prefs.getBool("DELETE_SPAN")!)
                              ? controller.swipeLeft()
                              : {
                                  showDialog(
                                    context: context,
                                    builder: ((context) {
                                      return DontAskDialog(
                                        checkBoxdontAskValue:
                                            checkBoxdontAskValue,
                                        swipeController: controller,
                                      );
                                    }),
                                  ),
                                };
                        },
                        child: Wrap(children: const <Widget>[
                          Icon(
                            Icons.close,
                            color: CupertinoColors.white,
                            size: 40,
                          ),
                        ]),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            fixedSize: const Size(80, 50),
                            backgroundColor: CupertinoColors.activeGreen),
                        onPressed: () {
                          controller.swipeRight();
                        },
                        child: Wrap(children: const <Widget>[
                          Icon(
                            Icons.check,
                            color: CupertinoColors.white,
                            size: 40,
                          ),
                        ]),
                      )
                    ],
                  ),
                  CommentWidget(comment: comment),
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
