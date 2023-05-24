import 'package:isar/isar.dart';

part 'user.scheme.g.dart';

// Full encrpytion is coming soon.
@collection
class User {
  Id id = Isar.autoIncrement; // you can also use id = null to auto increment

  String? username;

  String? password;

  String? token;

  String? server;

  bool? isCurrent = false;
}
