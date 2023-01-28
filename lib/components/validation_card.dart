import 'package:doccano_flutter/components/comment_widget.dart';
import 'package:doccano_flutter/components/span_to_validate.dart';
import 'package:doccano_flutter/utils/utilities.dart';
import 'package:flutter/material.dart';

class ValidationCard extends StatelessWidget {
  const ValidationCard({
    Key? key,
    required SpanToValidate? spanToValidate,
    required this.commentMap,
  })  : _spanToValidate = spanToValidate,
        super(key: key);

  final SpanToValidate? _spanToValidate;
  final Map<String, dynamic>? commentMap;

  @override
  Widget build(BuildContext context) {
    String? spanLabel = _spanToValidate!.label.text!.toLowerCase();

    return Card(
      elevation: 8,
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RichText(
                      textScaleFactor: 2.0,
                      text: TextSpan(
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                          children: _spanToValidate?.inlineSpanList),
                    ),
                    SizedBox(
                      child: Transform(
                        transform: Matrix4.identity()..scale(1.4, 1.4),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 32.0, top: 15, bottom: 15),
                          child: Chip(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            label: Text(_spanToValidate!.label.text!),
                            backgroundColor: Color(hexStringToInt(
                                _spanToValidate!.label.backgroundColor!)),
                            labelStyle: TextStyle(
                                color: Color(hexStringToInt(
                                    _spanToValidate!.label.textColor!))),
                          ),
                        ),
                      ),
                    ),
                    commentMap!.containsKey(spanLabel)
                        ? Flexible(
                            child: CommentWidget(
                              commentLabel: commentMap![spanLabel],
                              commentKey: spanLabel,
                            ),
                          )
                        : const Text(''),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// commentMap.toJson().containsKey(spanLabel)
                    //     ? CommentWidget(
                    //         commentLabel: spanLabel,
                    //       )
                    //     : const SizedBox(),