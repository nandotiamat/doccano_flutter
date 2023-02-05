import 'package:doccano_flutter/models/label.dart';
import 'package:doccano_flutter/models/span.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

part '../hive models/span_to_validate.g.dart';

@HiveType(typeId: 1)
class SpanToValidate {
  SpanToValidate({
    required this.label,
    required this.span,
    required this.validated,
  });

  @HiveField(0)
  final Label label;

  @HiveField(1)
  final Span span;

  @HiveField(2)
  bool validated;
}
