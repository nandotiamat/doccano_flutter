import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:selectable/selectable.dart';

class Test extends StatelessWidget {
  Test({super.key});

  final String text = """ 

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam feugiat nisl id erat vestibulum sagittis. Interdum et malesuada fames ac ante ipsum primis in faucibus. Duis eu tincidunt magna, ac convallis est. Nullam dapibus, justo sed accumsan ullamcorper, neque ex interdum lacus, et tempus purus nisi id ligula. Curabitur aliquet, ex ut dignissim sollicitudin, dui ante pulvinar ante, nec consectetur dui tortor in lorem. Maecenas tincidunt tristique fermentum. Nullam elementum volutpat posuere. Sed quis sapien leo.

Vestibulum auctor vulputate blandit. Mauris mollis ultricies felis, vitae imperdiet quam dapibus finibus. Mauris egestas viverra bibendum. Aenean accumsan, eros id tincidunt dictum, risus mi fermentum ligula, eget tempus elit odio in dui. In porta ullamcorper felis, eget fringilla ex sollicitudin rutrum. Nam venenatis egestas diam eget vulputate. Fusce quis felis mattis magna viverra varius in vel urna. Duis et sapien sed neque ornare sodales quis sit amet lacus. Donec dignissim vitae est et gravida. Nulla blandit odio eu odio placerat, eget egestas tellus rhoncus. Aliquam ultrices iaculis odio ac maximus. Suspendisse tempus, velit vel porta maximus, ligula quam consectetur dolor, sed pretium enim est eu velit. Etiam viverra orci vitae nibh rutrum, sed posuere elit lacinia. Mauris et diam at risus condimentum tincidunt.

Morbi ut feugiat mi. Curabitur facilisis odio urna. Suspendisse sit amet mattis velit, quis dignissim ex. Proin at ullamcorper urna. Phasellus eu dui eu ex luctus rhoncus at a lacus. Mauris tristique eros sit amet velit tincidunt tempus. Donec ultricies turpis congue diam fringilla, id tristique sapien consequat. Nunc sed magna et sapien mollis hendrerit et vel mi. Ut ultrices, mi id maximus rhoncus, ex libero mollis tellus, at mattis dolor tellus sed leo. Fusce id rhoncus libero. Integer id mollis nibh, vel tincidunt sapien. Cras finibus sit amet nulla sit amet dapibus. Morbi ligula augue, faucibus vulputate tortor non, scelerisque imperdiet justo. Mauris accumsan leo vitae pulvinar commodo. Aenean nisi massa, elementum nec hendrerit eget, laoreet quis magna.

Aliquam lobortis eros orci, vitae dignissim dolor placerat vel. Fusce elementum porttitor ornare. Sed tincidunt neque eu condimentum luctus. Nam porta, diam non bibendum pretium, dui sapien commodo lectus, vitae finibus enim turpis eget est. Proin ac imperdiet nunc, et consequat nisl. In vel ipsum massa. Curabitur sed iaculis erat. Sed laoreet, est ac iaculis feugiat, mauris est consectetur enim, sit amet lobortis nibh nulla in sapien. Nam mollis maximus mauris bibendum semper. Praesent ut elit nec arcu varius suscipit. Maecenas ullamcorper metus diam, nec pretium lectus dictum nec. Sed eu ipsum ex.

In tempor vehicula ex in facilisis. Sed ullamcorper dolor in mauris molestie, sit amet euismod nisi convallis. Quisque tortor libero, mattis nec orci at, aliquam ultrices erat. Fusce ut interdum ex. Sed ac lacus ac lorem hendrerit cursus in id ex. Suspendisse vitae enim ut leo ullamcorper accumsan. Morbi nec porta augue. Etiam luctus odio sapien, eget malesuada dolor aliquet et. Sed placerat eros nibh, et convallis lorem aliquam ut. Sed eget neque et urna dictum efficitur. Curabitur sodales nibh sit amet magna lacinia, eget eleifend tellus laoreet. Sed a laoreet nibh, eleifend scelerisque odio. Vivamus tincidunt lorem sit amet nibh facilisis dapibus. In velit ipsum, malesuada non ultrices et, gravida in enim. Suspendisse potenti. Aliquam sit amet scelerisque nisi.  """;

  final List<InlineSpan> _spans = [
    const TextSpan(text: "Ciao"),
    const WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: Chip(
        label: Text("daje"),
      ),
    ),
    const TextSpan(
        text:
            "Lorem ipsum porca la maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo "),
    const TextSpan(
        text:
            "Lorem ipsum porca la maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo "),
    const TextSpan(
        text:
            "Lorem ipsum porca la maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo "),
    const TextSpan(
        text:
            "Lorem ipsum porca la maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo "),
    const TextSpan(
        text:
            "Lorem ipsum porca la maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo "),
    const TextSpan(
        text:
            "Lorem ipsum porca la maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo "),
    const TextSpan(
        text:
            "Lorem ipsum porca la maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo "),
    const TextSpan(
        text:
            "Lorem ipsum porca la maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo "),
    const TextSpan(
        text:
            "Lorem ipsum porca la maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo "),
    const TextSpan(
        text:
            "Lorem ipsum porca la maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo "),
    const TextSpan(
        text:
            "Lorem ipsum porca la maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo "),
    const TextSpan(
        text:
            "Lorem ipsum porca la maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo "),
    const TextSpan(
        text:
            "Lorem ipsum porca la maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo "),
    const TextSpan(
        text:
            "Lorem ipsum porca la maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo "),
    const TextSpan(
        text:
            "Lorem ipsum porca la maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo "),
    const TextSpan(
        text:
            "Lorem ipsum porca la maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo "),
    const TextSpan(
        text:
            "Lorem ipsum porca la maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo "),
    const TextSpan(
        text:
            "Lorem ipsum porca la maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo "),
    const TextSpan(
        text:
            "Lorem ipsum porca la maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo "),
    const TextSpan(
        text:
            "Lorem ipsum porca la maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo "),
    const TextSpan(
        text:
            "Lorem ipsum porca la maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo "),
    const TextSpan(
        text:
            "Lorem ipsum porca la maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo "),
    const TextSpan(
        text:
            "Lorem ipsum porca la maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo "),
    const TextSpan(
        text:
            "Lorem ipsum porca la maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo "),
    const TextSpan(
        text:
            "Lorem ipsum porca la maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo "),
    const TextSpan(
        text:
            "Lorem ipsum porca la maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo "),
    const TextSpan(
        text:
            "Lorem ipsum porca la maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo "),
    const TextSpan(
        text:
            "Lorem ipsum porca la maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo "),
    const TextSpan(
        text:
            "Lorem ipsum porca la maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo "),
    const TextSpan(
        text:
            "Lorem ipsum porca la maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo "),
    const TextSpan(
        text:
            "Lorem ipsum porca la maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo "),
    const TextSpan(
        text:
            "Lorem ipsum porca la maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo "),
    const TextSpan(
        text:
            "Lorem ipsum porca la maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo "),
    const TextSpan(
        text:
            "Lorem ipsum porca la maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo "),
    const TextSpan(
        text:
            "Lorem ipsum porca la maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo "),
    const TextSpan(
        text:
            "Lorem ipsum porca la maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo "),
    const TextSpan(
        text:
            "Lorem ipsum porca la maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo "),
    const TextSpan(
        text:
            "Lorem ipsum porca la maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo "),
    const TextSpan(
        text:
            "Lorem ipsum porca la maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo "),
    const TextSpan(
        text:
            "Lorem ipsum porca la maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo "),
    const TextSpan(
        text:
            "Lorem ipsum porca la maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo "),
    const TextSpan(
        text:
            "Lorem ipsum porca la maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo "),
    const TextSpan(
        text:
            "Lorem ipsum porca la maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo "),
    const TextSpan(
        text:
            "Lorem ipsum porca la maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo "),
    const TextSpan(
        text:
            "Lorem ipsum porca la maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo "),
    const TextSpan(
        text:
            "Lorem ipsum porca la maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo maddaodaoddoodo "),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Selectable(
        child: RichText(
          textScaleFactor: 1.25,
          text: TextSpan(
            children: _spans,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
