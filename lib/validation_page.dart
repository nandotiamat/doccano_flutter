import 'package:dio/dio.dart';
import 'package:doccano_flutter/components/circular_progress_indicator_with_text.dart';
import 'package:doccano_flutter/models/examples.dart';
import 'package:doccano_flutter/models/label.dart';
import 'package:doccano_flutter/single_example_page.dart';
import 'package:flutter/material.dart';
import 'package:doccano_flutter/globals.dart';

class ValidationPage extends StatefulWidget {
  const ValidationPage({super.key});

  @override
  State<ValidationPage> createState() => _ValidationPage();
}

class _ValidationPage extends State<ValidationPage> {
  Future<Map<String, dynamic>> getLabels() async {
    //var options = Options(headers: {'Authorization': 'Token $key'});

    Response response;

    List<Label> labels = [];

    // ARBITRARIO
    Map<String, dynamic> params = {"confirmed": false};

    response = await dio.get("$doccanoWS/v1/projects/$projectID/examples",
        options: options, queryParameters: params);

    List<Example> examples = [];
    response.data["results"]
        .forEach((example) => examples.add(Example.fromJson(example)));

    Map<String, dynamic> data = {"examples": examples, "labels": labels};

    return data;
  }

  late Future<Map<String, dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = getLabels();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //print(snapshot.data);
            List<Example> examples = snapshot.data!["examples"];

            return Scaffold(
              appBar: AppBar(
                title: const Text("Dataset"),
              ),
              body: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                      children: const [
                        Text(
                          'ID',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Text(
                          'Text',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Text(
                          'Action',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 15,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                        child: ListView.separated(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: examples.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            SizedBox(
                              height: 60,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    width: 50,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              examples[index].id.toString()),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 12.0),
                                      child: SizedBox(
                                          width: double.infinity,
                                          child: ClipRect(
                                            child: Text(
                                              examples[index].text!,
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  const TextStyle(fontSize: 15),
                                            ),
                                          )),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 3.0),
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SingleTextPage(
                                                      passedExample:
                                                          examples[index]
                                                              .toJson())),
                                        );
                                      },
                                      child: const Text('Validate'),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            )
                          ],
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(
                        height: 20,
                      ),
                    )),
                  ),
                ],
              ),
            );
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicatorWithText(
                  "Fetching labels and examples..."),
            ),
          );
        });
  }
}
