import 'package:doccano_flutter/models/comment.dart';
import 'package:flutter/material.dart';

class CommentWidget extends StatelessWidget {
  const CommentWidget({
    Key? key,
    required this.comment,
  }) : super(key: key);

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: Colors.blue[500],
          elevation: 8,
          shadowColor: Colors.green[200],
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
                        padding: const EdgeInsets.only(left: 16.0, top: 12.0),
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
    );
  }
}
