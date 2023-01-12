import 'package:flutter/widgets.dart';

class ErrorPage extends StatelessWidget {
  final String error;
  const ErrorPage(this.error, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(error),);
  }
}