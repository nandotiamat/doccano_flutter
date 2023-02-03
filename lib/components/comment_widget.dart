import 'package:flutter/material.dart';

class CommentWidget extends StatelessWidget {
  const CommentWidget({
    Key? key,
    required this.commentKey,
    required this.commentLabel,
  }) : super(key: key);

  final String commentLabel;
  final String commentKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 12.0),
        child: Text(
          "$commentKey: $commentLabel",
          style: const TextStyle(
              color: Colors.blue, fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
