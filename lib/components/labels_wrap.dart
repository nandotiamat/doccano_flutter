import 'package:doccano_flutter/models/label.dart';
import 'package:doccano_flutter/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class LabelsWrap extends StatefulWidget {
  const LabelsWrap(this.labels, this.updateMethod,
      {super.key, this.panelController});

  final void Function(Label?) updateMethod;
  final List<Label> labels;
  final PanelController? panelController;
  @override
  State<LabelsWrap> createState() => _LabelsWrapState();
}

class _LabelsWrapState extends State<LabelsWrap> {
  Map<String, dynamic> selectedLabelData = {"label": null, "index": -1};
  List<bool> isSelected = [];

  void onTap(Label label) {
    if (selectedLabelData["label"] == label) {
      widget.updateMethod(null);
      setState(() {
        selectedLabelData = {"label": null, "index": -1};
      });
    } else {
      widget.updateMethod(label);
      setState(() {
        selectedLabelData = {
          "label": label,
          "index": widget.labels.indexOf(label)
        };
      });
    }
    if (widget.panelController != null) {
      widget.panelController!.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6.0,
      runSpacing: 6.0,
      children: widget.labels
          .map(
            (label) => ActionChip(
              avatar: selectedLabelData["index"] == widget.labels.indexOf(label)
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
