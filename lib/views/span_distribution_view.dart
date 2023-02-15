import 'package:doccano_flutter/models/label.dart';
import 'package:doccano_flutter/utils/doccano_api.dart';
import 'package:doccano_flutter/widget/circular_progress_indicator_with_text.dart';
import 'package:doccano_flutter/widget/data_chart.dart';
import 'package:flutter/material.dart';


class SpanDistributionView extends StatefulWidget {
  const SpanDistributionView({super.key});

  @override
  State<SpanDistributionView> createState() => _SpanDistributionViewState();
}

class _SpanDistributionViewState extends State<SpanDistributionView> {

  late Future<Map<String,dynamic>?> _future;
  Map<String, dynamic>? loggedUserData;
  Map<String,dynamic>? spanDistribution;
  List<Label>? fetchedLabels;


  Future<Map<String,dynamic>?> getData() async{
    Map<String, dynamic>? userData = await getLoggedUserData();
    List<Label>? labels = await getLabels();
    Map<String,dynamic>? spanDistrib = await getSpanDistribution(userData?['username'] ?? '');

    Map<String,dynamic> data = {
      "labels": labels,
      "spanDistribution": spanDistrib,
    };
    return data;
  }



  @override
  void initState() {
    _future = getData().then((data) {
      setState(() {
        spanDistribution = data?["spanDistribution"];
        fetchedLabels = data?["labels"];
      });

      return data;
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('SPAN DISTRUBUTION')),
        body: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.hasData) {

              return Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: DataChart(spanDistribution,fetchedLabels,),
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