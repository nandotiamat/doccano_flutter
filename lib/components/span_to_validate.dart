import 'package:doccano_flutter/models/label.dart';
import 'package:doccano_flutter/models/span.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

part '../hive models/span_to_validate.g.dart';

@HiveType(typeId: 1)
class SpanToValidate {
  const SpanToValidate({
    required this.label,
    required this.inlineSpanList,
    required this.span,
  });

  @HiveField(0)
  final List<InlineSpan> inlineSpanList;

  @HiveField(1)
  final Label label;

  @HiveField(2)
  final Span span;
}
