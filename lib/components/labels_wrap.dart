import 'package:doccano_flutter/models/label.dart';
import 'package:doccano_flutter/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class LabelsWrap extends StatefulWidget {
  const LabelsWrap(this.labels, this.updateMethod,
      this.updateShowSelectedLabelAnnotations, this._scrollController,
      {super.key, this.panelController, this.clustersUpdateCallback});

  final ScrollController _scrollController;
  final void Function(Label?) updateMethod;
  final List<Label> labels;
  final PanelController? panelController;
  final Function? clustersUpdateCallback;
  final void Function(bool)? updateShowSelectedLabelAnnotations;
  @override
  State<LabelsWrap> createState() => _LabelsWrapState();
}

class _LabelsWrapState extends State<LabelsWrap> {
  Map<String, dynamic> selectedLabelData = {"label": null, "index": -1};
  bool _switchActive = false;
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
    if (widget.clustersUpdateCallback != null) {
      widget.clustersUpdateCallback!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: widget._scrollController,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 12.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 30,
              height: 5,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: const BorderRadius.all(Radius.circular(12.0))),
            ),
          ],
        ),
        const SizedBox(
          height: 18.0,
        ),
        selectedLabelData["label"] != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Selected Label: ",
                    textScaleFactor: 1.25,
                  ),
                  Chip(
                    labelStyle: TextStyle(
                        color: Color(hexStringToInt(
                            selectedLabelData["label"]!.textColor!))),
                    backgroundColor: Color(hexStringToInt(
                        selectedLabelData["label"]!.backgroundColor!)),
                    label: Text(selectedLabelData["label"]!.text!),
                  ),
                ],
              )
            : const Text(
                "Select label.",
                textScaleFactor: 2.00,
              ),
        const SizedBox(
          height: 48.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Wrap(
            spacing: 6.0,
            runSpacing: 6.0,
            children: widget.labels
                .map(
                  (label) => ActionChip(
                    avatar: selectedLabelData["index"] ==
                            widget.labels.indexOf(label)
                        ? Icon(
                            Icons.check,
                            color: Color(
                              hexStringToInt(label.textColor!),
                            ),
                          )
                        : null,
                    onPressed: () => onTap(label),
                    labelStyle: TextStyle(
                        color: Color(hexStringToInt(label.textColor!))),
                    backgroundColor:
                        Color(hexStringToInt(label.backgroundColor!)),
                    label: Text(label.text!),
                  ),
                )
                .toList()
                .cast<Widget>(),
          ),
        ),
        FittedBox(
          fit: BoxFit.contain,
          child: Row(
            children: [
              selectedLabelData["label"] != null
                  ? Text(
                      "Showing only the annotations of label ${selectedLabelData["label"].text}")
                  : const Text(
                      "Select a label and set ON to the switch to enable filtering."),
              Switch(
                value: _switchActive,
                activeColor: selectedLabelData["label"] != null
                    ? Color(
                        hexStringToInt(
                            selectedLabelData["label"].backgroundColor!),
                      )
                    : null,
                onChanged: (newValue) {
                  setState(
                    (() => _switchActive = newValue),
                  );
                  if (widget.updateShowSelectedLabelAnnotations != null) {
                    widget.updateShowSelectedLabelAnnotations!(newValue);
                  }
                  widget.clustersUpdateCallback!();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
