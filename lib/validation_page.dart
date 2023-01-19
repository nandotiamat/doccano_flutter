import 'package:doccano_flutter/components/circular_progress_indicator_with_text.dart';
import 'package:doccano_flutter/models/examples.dart';
import 'package:doccano_flutter/single_example_page.dart';
import 'package:doccano_flutter/utils/doccano_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'constants/get_rows_for_page.dart';

class ValidationPage extends StatefulWidget {
  const ValidationPage({super.key});

  @override
  State<ValidationPage> createState() => _ValidationPage();
}

class _ValidationPage extends State<ValidationPage> {
  late Future<List<Example?>?> _future;

  Future<List<Example?>?> getData() async {
    if (dotenv.get("ENV") == "development") {
      await login(dotenv.get("USERNAME"), dotenv.get("PASSWORD"));
    }

    List<Example?>? examples = await getExamples();

    return examples;
  }

  @override
  void initState() {
    super.initState();
    _future = getData();
  }

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dataset')),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return LayoutBuilder(builder: (context, constraint) {
              return SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: PaginatedDataTable(
                          onPageChanged: ((value) {
                            scrollController.jumpTo(0.0);
                          }),
                          dataRowHeight: 90,
                          columnSpacing: 50,
                          horizontalMargin: 10,
                          showCheckboxColumn: false,
                          rowsPerPage: getRowsForPage(constraint),
                          sortColumnIndex: 1,
                          sortAscending: true,
                          columns: const [
                            DataColumn(
                                label: Text(
                              'ID',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            )),
                            DataColumn(
                                label: Text(
                              'Text',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            )),
                            DataColumn(
                                label: Text(
                              'Action',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            )),
                          ],
                          source: MyDataSource(snapshot.data, context),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            });
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicatorWithText(
                  "Fetching labels and examples..."),
            ),
          );
        },
      ),
    );
  }
}

class MyDataSource extends DataTableSource {
  final List<Example?>? examples;
  final BuildContext context;

  MyDataSource(this.examples, this.context);

  @override
  int get rowCount => examples!.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text(
              examples![index]!.id.toString(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: 160,
            child: ClipRect(
              child: Text(
                examples![index]!.text!,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ),
        DataCell(TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SingleTextPage(
                      passedExample: examples![index]!.toJson())),
            );
          },
          child: const Text(
            'Validate',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        )),
      ],
    );
  }
}
