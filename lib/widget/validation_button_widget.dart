import 'package:doccano_flutter/components/span_to_validate.dart';
import 'package:doccano_flutter/globals.dart';
import 'package:doccano_flutter/models/examples.dart';
import 'package:doccano_flutter/models/span.dart';
import 'package:doccano_flutter/utils/utilities.dart';
import 'package:doccano_flutter/widget/dont_ask_on_delete_dialog.dart';
import 'package:doccano_flutter/widget/nothing_to_clear_dialog.dart';
import 'package:doccano_flutter/widget/show_clear_validated_span_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class ValidationButtonWidget extends StatelessWidget {
  const ValidationButtonWidget({
    Key? key,
    required this.controller,
    required this.checkBoxdontAskValue,
    required this.validatedSpans,
    required this.fetchedSpans,
    required this.example,
    required this.mounted,
  }) : super(key: key);

  final CardSwiperController controller;
  final bool? checkBoxdontAskValue;
  final List<SpanToValidate>? validatedSpans;
  final List<Span>? fetchedSpans;
  final Example example;
  final bool mounted;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.red,
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  (prefs.getBool("DELETE_SPAN")!)
                      ? controller.swipeLeft()
                      : {
                          showDialog(
                            context: context,
                            builder: ((context) {
                              return DontAskOnDeleteDialog(
                                checkBoxdontAskValue:
                                    checkBoxdontAskValue,
                                swipeController:
                                    controller,
                              );
                            }),
                          ),
                        };
                },
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
                    
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey,
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  controllerRandomTopBottom(controller);
                },
                icon: const Icon(
                  
                  Icons.swap_vert,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
                    
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.green[300],
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  controller.swipeRight();
                },
                icon: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
          ],
        ),
        Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Already Validated:  ${validatedSpans?.length ?? 0} of ${fetchedSpans?.length ?? 0}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(50),
                          ),
                          fixedSize: const Size(300 ,70),
                          backgroundColor:
                              Colors.lightBlue[400],
                        ),
                    onPressed: () async {
                      (validatedSpans?.length ?? 0 ) > 0 ? showClearValidatedSpanDialog(context, example, mounted) 
                      : nothingToClearDialog(context, mounted) ;
                    }, 
                    child: const Text('CLEAR VALIDATED SPAN',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                                )
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}