import 'package:doccano_flutter/models/label.dart';
import 'package:doccano_flutter/utils/utilities.dart';
import 'package:flutter/material.dart';

class LabelsWrap extends StatefulWidget {
  const LabelsWrap(this.labels, this.updateMethod, {super.key});

  final void Function(Label) updateMethod;
  final List<Label> labels;

  @override
  State<LabelsWrap> createState() => _LabelsWrapState();
}

class _LabelsWrapState extends State<LabelsWrap> {
  List<bool> isSelected = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.labels.length; i++) {
      isSelected.add(false);
    }
  }

  void onTap(Label label) {
    widget.updateMethod(label);
    setState(() {
      for (int i = 0; i < widget.labels.length; i++) {
        isSelected[i] = false;
      }
      isSelected[widget.labels.indexOf(label)] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6.0,
      runSpacing: 6.0,
      children: widget.labels
          .map(
            (label) => ActionChip(
              avatar: isSelected[widget.labels.indexOf(label)]
                  ? Icon(
                      Icons.check,
                      color: Color(
                        hexStringToInt(label.textColor!),
                      ),
                    )
                  : null,
              onPressed: () => onTap(label),
              labelStyle:
                  TextStyle(color: Color(hexStringToInt(label.textColor!))),
              backgroundColor: Color(hexStringToInt(label.backgroundColor!)),
              label: Text(label.text!),
            ),
          )
          .toList()
          .cast<Widget>(),
    );
  }
}
