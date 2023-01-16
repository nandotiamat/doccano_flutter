import 'package:doccano_flutter/models/examples.dart';
import 'package:flutter/material.dart';

class SingleTextPage extends StatefulWidget {
  const SingleTextPage({Key? key, required this.passedExample})
      : super(key: key);

  final Map<String, dynamic> passedExample;

  @override
  State<SingleTextPage> createState() => _SingleTextPageState();
}

class _SingleTextPageState extends State<SingleTextPage> {
  @override
  Widget build(BuildContext context) {
    Example example = Example.fromJson(widget.passedExample);

    return Scaffold(
      appBar: AppBar(
        title: Text('Dataset ID: ${example.id}'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Text(
            '${example.text}',
            style: const TextStyle(fontSize: 25),
          ),
        ),
      ),
    );
  }
}
