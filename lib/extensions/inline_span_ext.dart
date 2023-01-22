import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui show Locale;

import 'package:flutter/widgets.dart';

extension ListOfInlineSpanExt on List<InlineSpan> {
  /// Splits this list of spans at the given character [index] and returns one
  /// or two lists. If [index] is zero, or if [index] is greater than the
  /// number of characters in these spans, a list containing just this list is
  /// returned. If this list was split, an array of two lists is returned,
  /// containing the two new lists.
  List<List<InlineSpan>> splitAtCharacterIndex(SplitAtIndex index) {
    if (index.value == 0) return [this];

    var i = 0;
    for (final span in this) {
      final result = span.defaultSplitSpanAtIndex(index,
          copyWithTextSpan: (span, text, children) => span.copyWith(
              text: text,
              children: children,
              noText: text == null,
              noChildren: children == null));

      if (index.value == 0) {
        if (result.length == 2) {
          return [
            [...take(i), result.first],
            [result.last, ...skip(i + 1)],
          ];
        } else if (result.length == 1) {
          return [
            [...take(i), result.first],
            if (i + 1 < length) [...skip(i + 1)],
          ];
        } else {
          assert(false);
          break;
        }
      }

      i++;
    }

    return [this];
  }
}

///
/// Mutable wrapper of an integer index that can be passed by reference.
///
class SplitAtIndex {
  SplitAtIndex(this.value);
  int value = 0;
}

extension InlineSpanExt on InlineSpan {
  /// Splits this span at the given character [index] and returns a list of one
  /// or two spans. If [index] is zero, or if [index] is greater than the
  /// number of characters in this span, a list containing just this span is
  /// returned. If this span was split, a list of two spans is returned,
  /// containing the two new spans.
  List<InlineSpan> splitAtCharacterIndex(int index) =>
      defaultSplitSpanAtIndex(SplitAtIndex(index),
          copyWithTextSpan: (span, text, children) => span.copyWith(
              text: text,
              children: children,
              noText: text == null,
              noChildren: children == null));

  List<InlineSpan> defaultSplitSpanAtIndex(
    SplitAtIndex index, {
    required TextSpan Function(
            TextSpan span, String? text, List<InlineSpan>? children)
        copyWithTextSpan,
  }) {
    if (index.value == 0) return [this];

    final span = this;
    if (span is TextSpan) {
      final text = span.text;
      if (text != null && text.isNotEmpty) {
        if (index.value >= text.length) {
          index.value -= text.length;
        } else {
          final result = [
            copyWithTextSpan(span, text.substring(0, index.value), null),
            copyWithTextSpan(span, text.substring(index.value), span.children),
          ];
          index.value = 0;
          return result;
        }
      }

      final children = span.children;
      if (children != null && children.isNotEmpty) {
        // If the text.length was equal to index.value, split the text and
        // children.
        if (index.value == 0) {
          return [
            copyWithTextSpan(span, text, null),
            copyWithTextSpan(span, null, span.children),
          ];
        }

        final result = children.splitAtCharacterIndex(index);

        if (index.value == 0) {
          if (result.length == 2) {
            return [
              copyWithTextSpan(span, text, result.first),
              copyWithTextSpan(span, null, result.last),
            ];
          } else if (result.length == 1) {
            // Only true if the number of characters in all the children was
            // equal to index.value.
            assert(listEquals<InlineSpan>(result.first, children));
          } else {
            assert(false);
          }
        }
      }
    } else if (span is WidgetSpan) {
      // index.value =- 1;
    }
    else {
      assert(false);
    }

    return [this];
  }
}

extension TextSpanExt on TextSpan {
  TextSpan copyWith({
    String? text,
    List<InlineSpan>? children,
    TextStyle? style,
    GestureRecognizer? recognizer,
    MouseCursor? mouseCursor,
    PointerEnterEventListener? onEnter,
    PointerExitEventListener? onExit,
    String? semanticsLabel,
    ui.Locale? locale,
    bool? spellOut,
    bool noText = false,
    bool noChildren = false,
  }) =>
      TextSpan(
        text: text ?? (noText ? null : this.text),
        children: children ?? (noChildren ? null : this.children),
        style: style ?? this.style,
        recognizer: recognizer ?? this.recognizer,
        mouseCursor: mouseCursor ?? this.mouseCursor,
        onEnter: onEnter ?? this.onEnter,
        onExit: onExit ?? this.onExit,
        semanticsLabel: semanticsLabel ?? this.semanticsLabel,
        locale: locale ?? this.locale,
        spellOut: spellOut ?? this.spellOut,
      );
}
