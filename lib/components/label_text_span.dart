import 'package:doccano_flutter/models/span.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LabelTextSpan extends TextSpan {  

  const LabelTextSpan({
    required this.label,
    required this.chip,
    super.text,
    super.children,
    super.style,
    super.recognizer,
    super.mouseCursor,
    super.onEnter,
    super.onExit,
    super.semanticsLabel,
    super.locale,
    super.spellOut,
  });

  final Span label;
  final LabelWidgetSpan chip;
}

class LabelWidgetSpan extends WidgetSpan {
  const LabelWidgetSpan({
    required this.label,
    required super.child,
    super.alignment,
    super.baseline,
    super.style,
  });

  final Span label;
}