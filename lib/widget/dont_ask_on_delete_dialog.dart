import 'package:doccano_flutter/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

// ignore: must_be_immutable
class DontAskOnDeleteDialog extends StatelessWidget {
  DontAskOnDeleteDialog({
    Key? key,
    required this.checkBoxdontAskValue,
    required this.swipeController,
  }) : super(key: key);

  bool? checkBoxdontAskValue;
  CardSwiperController? swipeController;
  void saveCheckBoxValue() {
    prefs.setBool("DELETE_SPAN", checkBoxdontAskValue!);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('DELETING SPAN...'),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return SizedBox(
            height: 120,
            child: Column(
              children: [
                Row(
                  children: [
                    Checkbox(
                        value: checkBoxdontAskValue,
                        onChanged: (value) {
                          setState(
                            () {
                              checkBoxdontAskValue = value!;
                              saveCheckBoxValue();
                            },
                          );
                        }),
                    const Text('Dont Ask Anymore'),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Text(
                    'You are deleting a span on this examples...are you SURE??',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
            Navigator.of(context).pop();
          },
          child: const Text('NO'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            swipeController!.swipeLeft();
          },
          child: const Text('DELETE'),
        ),
      ],
    );
  }
}
