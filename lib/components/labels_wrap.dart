import 'package:doccano_flutter/models/label.dart';
import 'package:doccano_flutter/utils/utilities.dart';
import 'package:flutter/material.dart';

class LabelsWrap extends StatelessWidget {
  const LabelsWrap({
    Key? key,
    required this.labels,
  }) : super(key: key);

  final List<Label> labels;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6.0,
      runSpacing: 6.0,
      children: labels
          .map(
            (label) => Chip(
              labelStyle: TextStyle(
                  color: Color(hexStringToInt(label.textColor!))),
              backgroundColor:
                  Color(hexStringToInt(label.backgroundColor!)),
              label: Text(label.text!),
            ),
          )
          .toList()
          .cast<Widget>(),
    );
  }
}
