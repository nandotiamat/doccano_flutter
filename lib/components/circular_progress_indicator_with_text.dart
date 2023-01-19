import 'package:flutter/material.dart';

class CircularProgressIndicatorWithText extends StatelessWidget {
  final String text;

  const CircularProgressIndicatorWithText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Column(
        children: [
          const CircularProgressIndicator(),
          const Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          Text(text)
        ],
      ),
    );
  }
}
