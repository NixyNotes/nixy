import 'package:isar/isar.dart';

part 'user.model.g.dart';

// Full encrpytion is coming soon.
@collection
class User {
  Id id = Isar.autoIncrement; // you can also use id = null to auto increment

  String? username;

  String? password;

  String? token;

  bool? isCurrent = false;
}
