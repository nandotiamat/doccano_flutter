import 'package:doccano_flutter/components/span_to_validate.dart';
import 'package:doccano_flutter/widget/all_span_validated.dart';
import 'package:doccano_flutter/widget/recap_validation.dart';
import 'package:doccano_flutter/widget/validation_button_widget.dart';
import 'package:doccano_flutter/widget/validation_card.dart';
import 'package:doccano_flutter/models/examples.dart';
import 'package:doccano_flutter/models/label.dart';
import 'package:doccano_flutter/models/span.dart';
import 'package:doccano_flutter/utils/doccano_api.dart';
import 'package:doccano_flutter/utils/utilities.dart';
import 'package:float_column/float_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'widget/circular_progress_indicator_with_text.dart';

import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class ValidationPage extends StatefulWidget {
  const ValidationPage({Key? key, required this.passedExample})
      : super(key: key);

  final Example passedExample;

  @override
  State<ValidationPage> createState() => _ValidationPageState();
}

class _ValidationPageState extends State<ValidationPage> {
  late Future<Map<String, dynamic>> _future;
  List<Span>? fetchedSpans;
  List<Label>? fetchedLabels;
  List<InlineSpan>? _spans;
  ExampleMetadata? metaData;
  late Map<String, dynamic> commentMap;

  List<SpanToValidate>? validatedSpans;

  late bool spanAtBeginText;

  late bool endOfCards;
  late bool allSpansValidate = false;
  List<SpanToValidate>? validatingSpans = [];
  List<Span>? deletingSpans = [];
  List<Span>? ignoringSpans = [];

  List<ValidationCard?> cards = [];

  int currentIndex = 0;

  Future<Map<String, dynamic>> getData() async {
    if (dotenv.get("ENV") == "development") {
      await login(dotenv.get("USERNAME"), dotenv.get("PASSWORD"));
    }

    List<Label> labels = await getLabels();
    List<Span>? spans = await getSpans(widget.passedExample.id!);

    spans!.sort(((a, b) => a.startOffset.compareTo(b.startOffset)));

    ExampleMetadata? metaData = await getExampleMetaData(
        Example.fromJson(widget.passedExample.toJson()).id!);

    List<SpanToValidate>? valSpans;

    var boxUsers = await Hive.openBox('UTENTI');
    print('apro la box da validation page allo start "${{
      widget.passedExample.id
    }}"-> ${boxUsers.get('Examples')?.examples["${widget.passedExample.id}"] ?? []}');

    Map<String, List<SpanToValidate>?> spanMap;
    if (boxUsers.get('Examples')?.examples != null) {
      spanMap = boxUsers.get('Examples')?.examples;
    } else {
      spanMap = {"examples": []};
    }

    if (spanMap.containsKey('${widget.passedExample.id}')) {
      valSpans = spanMap["${widget.passedExample.id}"];
    } else {
      valSpans = [];
    }

    Map<String, dynamic> data = {
      "fetchedLabels": labels,
      "fetchedSpans": spans,
      "fetchedMetaData": metaData,
      "fetchedValidatedSpans": valSpans
    };

    return data;
  }

  @override
  void initState() {
    endOfCards = false;
    super.initState();
    _future = getData().then((data) {
      setState(() {
        fetchedSpans = data["fetchedSpans"];
        fetchedLabels = data["fetchedLabels"];
        _spans = [TextSpan(text: widget.passedExample.text)];
        metaData = data["fetchedMetaData"];
        commentMap = buildComments(metaData);
        validatedSpans = data["fetchedValidatedSpans"];
      });
      buildCards();
      allSpansValidate = checkNumberSpansValidated();
      return data;
    });
  }

  bool checkNumberSpansValidated() {
    if (fetchedSpans?.isNotEmpty ?? false) {
      if (validatedSpans?.isNotEmpty ?? false) {
        if (validatedSpans!.length == fetchedSpans!.length) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  void buildCards() {
    for (int i = 0; i < fetchedSpans!.length; i++) {
      List<InlineSpan> inlineSpanList = buildSpan(fetchedSpans![i]);
      SpanToValidate spanToValidate = SpanToValidate(
          span: fetchedSpans![i],
          label: fetchedLabels!
              .firstWhere((label) => fetchedSpans![i].label == label.id),
          validated: false);
      updateTextSpan(inlineSpanList, spanAtBeginText);
      if (validatedSpans!.isNotEmpty) {
        bool isValid = false;
        for (int j = 0; j < validatedSpans!.length; j++) {
          if (validatedSpans![j].span.id == spanToValidate.span.id) {
            isValid = true;
          }
        }
        if (!isValid) {
          cards.add(ValidationCard(
            spanToValidate: spanToValidate,
            inlineSpanList: inlineSpanList,
            commentMap: commentMap,
          ));
        }
      } else {
        cards.add(ValidationCard(
          spanToValidate: spanToValidate,
          inlineSpanList: inlineSpanList,
          commentMap: commentMap,
        ));
      }
    }
  }

  List<InlineSpan> getValidationText(
      Span span, List<InlineSpan> text, int offsetTextToShow) {
    if (span.startOffset < offsetTextToShow) {
      setState(() {
        spanAtBeginText = true;
      });
    } else {
      setState(() {
        spanAtBeginText = false;
      });
    }

    List<List<InlineSpan>> result1 = text.splitAtCharacterIndex(
        span.startOffset > offsetTextToShow
            ? SplitAtIndex(span.startOffset - offsetTextToShow)
            : SplitAtIndex(span.startOffset));
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

    return getValidationText(span, temporarySpans, 40);
  }

  Map<String, dynamic> buildComments(ExampleMetadata? metaData) {
    String commentString = metaData!.comment!;
    Map<String, dynamic> commentMap = {};

    commentString.split(',').forEach((element) {
      final parts = element.split(':');
      commentMap[parts[0].trim()] = parts[1].trim();
    });

    fixDataComment(commentMap);
    return commentMap;
  }

  void swipe(int index, CardSwiperDirection direction) async {
    SpanToValidate spanToValidate = cards[index]!.spanToValidate;

    if (direction.name == 'right') {
      validatingSpans?.add(spanToValidate);
    }

    if (direction.name == 'left') {
      deletingSpans?.add(cards[index]!.spanToValidate.span);
    }

    if (direction.name == 'top') {
      ignoringSpans?.add(fetchedSpans![index]);
    }

    if (direction.name == 'bottom') {
      ignoringSpans?.add(fetchedSpans![index]);
    }

    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Example example = widget.passedExample;
    bool? checkBoxdontAskValue = false;
    final CardSwiperController controller = CardSwiperController();

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('Example ID: ${example.id}'),
            leading: BackButton(
              onPressed: () async {
                Navigator.pop(context);
              },
            ),
          ),
          body: FutureBuilder(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return SafeArea(
                    child: allSpansValidate
                        ? AllSpanValidatedWidget(
                            example: example, mounted: mounted)
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                  flex: 1,
                                  child: (endOfCards
                                      ? RecapValidationAndSaveChanges(
                                          mounted: mounted,
                                          example: example,
                                          validatingSpans: validatingSpans,
                                          ignoringSpans: ignoringSpans,
                                          deletingSpans: deletingSpans,
                                          validatedSpans: validatedSpans)
                                      : CardSwiper(
                                          isDisabled: false,
                                          controller: controller,
                                          cards: cards,
                                          onSwipe: swipe,
                                          onEnd: () async {
                                            setState(() {
                                              endOfCards = true;
                                            });
                                          },
                                        ))),
                              (endOfCards
                                  ? const SizedBox()
                                  : Column(
                                    children: [
                                      Text('$currentIndex of ${cards.length}'),
                                      ValidationButtonWidget(
                                        currentIndex: currentIndex,
                                          controller: controller,
                                          checkBoxdontAskValue:
                                              checkBoxdontAskValue,
                                          validatedSpans: validatedSpans,
                                          fetchedSpans: fetchedSpans,
                                          example: example,
                                          mounted: mounted),
                                    ],
                                  )),
                            ],
                          ),
                  );
                }
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
          )),
    );
  }
}
