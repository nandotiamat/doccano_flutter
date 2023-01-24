import 'package:doccano_flutter/components/span_to_validate.dart';
import 'package:float_column/float_column.dart';
import 'package:flutter/material.dart';

int hexStringToInt(String hexString) =>
    int.parse("0xFF${hexString.substring(1)}");

void updateTextSpan(List<SpanToValidate> list) {
  list.first.inlineSpanList.first =
      (list.first.inlineSpanList.first as TextSpan).copyWith(
          text: list.first.inlineSpanList.first
              .toPlainText()
              .substring(
                  list.first.inlineSpanList.first.toPlainText().indexOf(" "))
              .substring(1));
  list.first.inlineSpanList.last = (list.first.inlineSpanList.last as TextSpan)
      .copyWith(
          text: list.first.inlineSpanList.last.toPlainText().substring(0,
              list.first.inlineSpanList.last.toPlainText().lastIndexOf(" ")));
}
