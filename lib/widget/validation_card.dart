import 'package:doccano_flutter/widget/comment_widget.dart';
import 'package:doccano_flutter/components/span_to_validate.dart';
import 'package:doccano_flutter/utils/utilities.dart';
import 'package:flutter/material.dart';

class ValidationCard extends StatelessWidget {
  const ValidationCard({
    Key? key,
    this.commentMap,
    this.inlineSpanList,
    required this.spanToValidate,
  }) : super(key: key);

  final SpanToValidate spanToValidate;
  final Map<String, dynamic>? commentMap;
  final List<InlineSpan>? inlineSpanList;

  @override
  Widget build(BuildContext context) {
    String? spanLabel = spanToValidate.label.text!.toLowerCase();

    return Card(
      elevation: 8,
      margin: const EdgeInsets.all(12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: commentMap!.containsKey(spanLabel) ? MediaQuery.of(context).size.height*0.45 : MediaQuery.of(context).size.height*0.35,
        child: LayoutBuilder(
          builder: (BuildContext ctx, BoxConstraints constraints) {
            
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(
                        textScaleFactor: 2.0,
                        text: TextSpan(
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            children: inlineSpanList),
                      ),
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
                        label: Text(spanToValidate.label.text!),
                        backgroundColor: Color(hexStringToInt(
                            spanToValidate.label.backgroundColor!)),
                        labelStyle: TextStyle(
                            color: Color(hexStringToInt(
                                spanToValidate  .label.textColor!))),
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
            );
            
          }
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