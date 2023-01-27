import 'package:doccano_flutter/components/span_to_validate.dart';
import 'package:float_column/float_column.dart';
import 'package:flutter/material.dart';

int hexStringToInt(String hexString) =>
    int.parse("0xFF${hexString.substring(1)}");

void updateTextSpan(SpanToValidate spanToValidate) {
  spanToValidate.inlineSpanList.first =
      (spanToValidate.inlineSpanList.first as TextSpan).copyWith(
          text:
              (spanToValidate.inlineSpanList.first.toPlainText().contains(" "))
                  ? spanToValidate.inlineSpanList.first
                      .toPlainText()
                      .substring(spanToValidate.inlineSpanList.first
                          .toPlainText()
                          .indexOf(" "))
                      .substring(1)
                  : spanToValidate.inlineSpanList.first.toPlainText());

  spanToValidate.inlineSpanList.last =
      (spanToValidate.inlineSpanList.last as TextSpan).copyWith(
          text: spanToValidate.inlineSpanList.last.toPlainText().substring(
              0,
              spanToValidate.inlineSpanList.last
                  .toPlainText()
                  .lastIndexOf(" ")));
}
