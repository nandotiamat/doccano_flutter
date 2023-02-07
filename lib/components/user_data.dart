import 'package:doccano_flutter/components/span_to_validate.dart';
import 'package:hive_flutter/hive_flutter.dart';

part '../hive models adapter/user_data.g.dart';

@HiveType(typeId: 0)
class UserData {
  const UserData({
    required this.examples,
  });

  @HiveField(0)
  final Map<String, List<SpanToValidate>?> examples;
}
