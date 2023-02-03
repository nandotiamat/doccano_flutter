import 'dart:convert';
import 'package:doccano_flutter/components/span_to_validate.dart';
import 'package:doccano_flutter/components/user_data.dart';
import 'package:doccano_flutter/components/validation_card.dart';
import 'package:doccano_flutter/globals.dart';
import 'package:doccano_flutter/menu_page.dart';
import 'package:doccano_flutter/models/examples.dart';
import 'package:doccano_flutter/models/label.dart';
import 'package:doccano_flutter/models/span.dart';
import 'package:doccano_flutter/utils/doccano_api.dart';
import 'package:doccano_flutter/utils/dont_ask_dialog.dart';
import 'package:doccano_flutter/utils/utilities.dart';
import 'package:float_column/float_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
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

  List<SpanToValidate>? spansToValidate = [];

  late bool endOfCards;

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
    endOfCards = false;
    getValidatedSpans();
    super.initState();
    _future = getData();
  }

  List<Span>? validatedSpan;

  getValidatedSpans() async {
    validatedSpan = json.decode(prefs.get('validatedSpan').toString()) ?? [];
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

    List<Span> validatingSpans = [];
    List<Span> deletingSpans = [];

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('Example ID: ${example.id}'),
            leading: BackButton(
              onPressed: () async {
                var boxUsers = await Hive.openBox('UTENTI');

                boxUsers.put(
                    'Examples',
                    UserData(examples: {
                      widget.passedExample.id.toString(): spansToValidate
                    }));

                print(
                    'apro la box da validation page -> ${boxUsers.get('Examples')}');

                // ignore: use_build_context_synchronously
                Navigator.pop(context);
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
                // ignore: use_build_context_synchronously
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const MenuPage()));
              },
            ),
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

                fixData(commentMap);

                List<ValidationCard> cards = [
                  ...List.generate(fetchedSpans?.length ?? 0, (index) {
                    SpanToValidate spanToValidate = SpanToValidate(
                        inlineSpanList: buildSpan(fetchedSpans![index]),
                        span: fetchedSpans![index],
                        label: fetchedLabels!.firstWhere(
                            (label) => fetchedSpans![index].label == label.id));

                    updateTextSpan(spanToValidate);
                    spansToValidate!.add(spanToValidate);

                    return ValidationCard(
                      spanToValidate: spanToValidate,
                      commentMap: commentMap,
                    );
                  })
                ];

                void swipe(int index, CardSwiperDirection direction) async {
                  //NON INSERIRE SET STATE QUI SENO MUORE LO SWIPE COI BOTTONI

                  if (direction.name == 'right') {
                    print(
                        "the card was swiped to the: ${direction.name} with   $index");

                    validatingSpans.add(fetchedSpans![index]);
                  }
                  if (direction.name == 'left') {
                    print(
                        "the card was swiped to the: ${direction.name} $index");
                    print(widget.passedExample.id!);
                    print(fetchedSpans![index].id);

                    deletingSpans.add(fetchedSpans![index]);
                    //deleteSpan(widget.passedExample.id!, fetchedSpans![index].id);
                    //debugPrint("Span $index from example ${widget.passedExample.id} was successfully deleted.");
                    if (widget.passedExample.isConfirmed == true) {
                      //await unCheckExample(widget.passedExample.id!);
                    }
                  }

                  if (direction.name == 'top') {}

                  if (direction.name == 'bottom') {}
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                        flex: 1,
                        child: (endOfCards
                            ? Column(
                                children: [
                                  Image.asset('images/exoticdoccano.png'),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 80.0),
                                    child: Center(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          fixedSize: const Size(150, 70),
                                          backgroundColor: Colors.green[400],
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const MenuPage()));
                                        },
                                        child: const Text(
                                          'FINE',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : CardSwiper(
                                isDisabled: false,
                                controller: controller,
                                cards: cards,
                                onSwipe: swipe,
                                onEnd: () {
                                  setState(() {
                                    endOfCards = true;

                                    //validatedSpan = validatingSpans;prefs.setString("validatedSpan",json.encode(validatedSpan));
                                  });
                                },
                              ))),

                    (endOfCards
                        ? const SizedBox()
                        : Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                //swipeRightButton(controller),

                                CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.red,
                                  child: IconButton(
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
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),

                                CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.grey,
                                  child: IconButton(
                                    onPressed: () {
                                      controllerRandomTopBottom(controller);
                                    },
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),

                                CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.green[300],
                                  child: IconButton(
                                    onPressed: () {
                                      controller.swipeRight();
                                    },
                                    icon: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    //CommentWidget(comment: comment),
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
          )),
    );
  }
}
