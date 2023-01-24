import 'package:doccano_flutter/models/label.dart';
import 'package:flutter/material.dart';

class SpanToValidate {
  const SpanToValidate({
    required this.label,
    required this.inlineSpanList,
  });

  final List<InlineSpan> inlineSpanList;
  final Label label;
}
