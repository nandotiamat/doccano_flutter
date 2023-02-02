import 'dart:math';

import 'package:doccano_flutter/models/label.dart';
import 'package:doccano_flutter/models/span.dart';
import 'package:doccano_flutter/utils/utilities.dart';
import 'package:float_column/float_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LabelTextSpan extends TextSpan {
  const LabelTextSpan({
    required this.label,
    required this.doccanoLabel,
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

  final Label doccanoLabel;
  final Span label;
  final LabelWidgetSpan chip;

  int get length {
    return label.endOffset - label.startOffset;
  }
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

class SpanCluster {
  SpanCluster({required this.labelTextSpans, required this.labelWidgetSpans}) {
    startIndex = labelTextSpans.first.label.startOffset;
    endIndex = labelTextSpans.first.label.endOffset;
  }

  // final List<InlineSpan> labelWidgetSpans;
  final List<LabelWidgetSpan> labelWidgetSpans;
  final List<LabelTextSpan> labelTextSpans;
  final List<LabelTextSpan> labelTextSpansToShow = [];
  late int startIndex;
  late int endIndex;

  List<InlineSpan> build() {
    organizeLabels();
    if (labelTextSpans.length > 1) {
      debugPrint(
          "List of TextSpans of the spancluster: ${labelTextSpansToShow.toString()}");
      return [...labelTextSpansToShow, ...labelWidgetSpans];
    }
    return [...labelTextSpans, ...labelWidgetSpans];
  }

  void addLabelTextSpan(LabelTextSpan labelTextSpan) {
    return labelTextSpans.add(labelTextSpan);
  }

  bool removeLabelTextSpan(LabelTextSpan labelTextSpan) {
    return labelTextSpans.remove(labelTextSpan);
  }

  bool removeLabelViaChip(LabelWidgetSpan labelWidgetSpanToRemove) {
    int labelTextSpanToRemoveIndex = labelTextSpans
        .indexWhere((e) => labelWidgetSpanToRemove.label.id == e.label.id);
    if (labelTextSpanToRemoveIndex == -1) return false;
    labelTextSpans.removeAt(labelTextSpanToRemoveIndex);
    removeLabelWidgetSpan(labelWidgetSpanToRemove);
    return true;
  }

  void addLabelWidgetSpan(LabelWidgetSpan labelWidgetSpan) {
    labelWidgetSpans.add(labelWidgetSpan);
  }

  bool removeLabelWidgetSpan(LabelWidgetSpan labelWidgetSpan) {
    return labelWidgetSpans.remove(labelWidgetSpan);
  }

  void addLabel(LabelWidgetSpan labelWidgetSpan, LabelTextSpan labelTextSpan,
      List<InlineSpan> text) {
    addLabelWidgetSpan(labelWidgetSpan);
    addLabelTextSpan(labelTextSpan);
    calculateIndexes();
    organizeLabels();
    updateTextSpan(text);
  }

  void organizeLabels() {
    if (labelTextSpans.length <= 1) return;
    labelTextSpans.sort(((a, b) => (a.label.length).compareTo(b.label.length)));
    debugPrint("labelTextSpans after sorting: $labelTextSpans");
  }

  int get length {
    return endIndex - startIndex;
  }

  void calculateIndexes() {
    int minStartIndex = startIndex;
    int maxEndIndex = endIndex;

    for (LabelTextSpan labelTextSpan in labelTextSpans) {
      minStartIndex = min(labelTextSpan.label.startOffset, minStartIndex);
      maxEndIndex = max(labelTextSpan.label.endOffset, maxEndIndex);
    }

    startIndex = minStartIndex;
    endIndex = maxEndIndex;

    debugPrint("min index cluster: $startIndex, max : $endIndex");
  }

  void updateTextSpan(List<InlineSpan> text) {
    List<LabelTextSpan> tmpTextSpanToShow = [];
    final result1 = text.splitAtCharacterIndex(SplitAtIndex(startIndex));
    final result2 =
        result1.last.splitAtCharacterIndex(SplitAtIndex(endIndex - startIndex));

    List<InlineSpan> spanClusterTextSpan = result2.first;
    String spanClusterText = spanClusterTextSpan.first.toPlainText();
    List<Map<String, dynamic>> textSpansToShowData = [];

    for (int i = startIndex; i < endIndex; i++) {
      bool foundColor = false;
      for (LabelTextSpan labelTextSpan in labelTextSpans) {
        if (!foundColor &&
            List.generate(labelTextSpan.label.length,
                    (index) => index + labelTextSpan.label.startOffset)
                .contains(i)) {
          Map<String, dynamic> textSpanToShowData = {
            "color": Color(
                hexStringToInt(labelTextSpan.doccanoLabel.backgroundColor!)),
            "labelTextSpan": labelTextSpan,
          };

          textSpansToShowData.add(textSpanToShowData);
          foundColor = true;
        }
      }
    }

    Color? previousColor;
    int beginningIndex = 0;
    for (int i = 0; i < textSpansToShowData.length; i++) {
      Color color = textSpansToShowData.elementAt(i)["color"];
      LabelTextSpan currentLabelTextSpan =
          textSpansToShowData.elementAt(i)["labelTextSpan"];

      if (i != 0 && (color != previousColor)) {
        tmpTextSpanToShow.add(
          LabelTextSpan(
            text: spanClusterText.substring(beginningIndex, i),
            style: TextStyle(
              backgroundColor: previousColor,
              color: Color(
                hexStringToInt(currentLabelTextSpan.doccanoLabel.textColor!),
              ),
            ),
            label: currentLabelTextSpan.label,
            doccanoLabel: currentLabelTextSpan.doccanoLabel,
            chip: currentLabelTextSpan.chip,
          ),
        );
        beginningIndex = i;
      }
      if (i == textSpansToShowData.length - 1) {
        tmpTextSpanToShow.add(
          LabelTextSpan(
            text: spanClusterText.substring(beginningIndex, i + 1),
            style: TextStyle(
              backgroundColor: color,
              color: Color(
                hexStringToInt(currentLabelTextSpan.doccanoLabel.textColor!),
              ),
            ),
            label: currentLabelTextSpan.label,
            doccanoLabel: currentLabelTextSpan.doccanoLabel,
            chip: currentLabelTextSpan.chip,
          ),
        );
      }
      previousColor = color;
    }

    labelTextSpansToShow.clear();
    labelTextSpansToShow.addAll(tmpTextSpanToShow);
  }
}
