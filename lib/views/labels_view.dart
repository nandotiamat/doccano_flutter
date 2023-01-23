import 'package:doccano_flutter/models/label.dart';
import 'package:doccano_flutter/utils/doccano_api.dart';
import 'package:doccano_flutter/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../components/circular_progress_indicator_with_text.dart';

class LabelsView extends StatefulWidget {
  const LabelsView({super.key});

  @override
  State<LabelsView> createState() => _LabelsViewState();
}

class _LabelsViewState extends State<LabelsView> {
  late Future<List<Label?>?> _future;

  Future<List<Label?>?> getData() async {
    if (dotenv.get("ENV") == "development") {
      await login(dotenv.get("USERNAME"), dotenv.get("PASSWORD"));
    }

    List<Label?>? labels = await getLabels();

    return labels;
  }

  @override
  void initState() {
    super.initState();
    _future = getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Labels')),
        body: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Label?>? labels = snapshot.data;

              return Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: labels!.length,
                  itemBuilder: (context, index) {
                    return ActionChip(
                      onPressed: () => {},
                      labelStyle: TextStyle(
                          color:
                              Color(hexStringToInt(labels[index]!.textColor!))),
                      backgroundColor: Color(
                          hexStringToInt(labels[index]!.backgroundColor!)),
                      label: Text(labels[index]!.text!),
                    );
                  },
                ),
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicatorWithText("Fetching labels..."),
              ),
            );
          },
        ));
  }
}
