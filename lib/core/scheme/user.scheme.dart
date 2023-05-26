import 'package:isar/isar.dart';

part 'user.scheme.g.dart';

// Full encrpytion is coming soon.
@collection
class User {
  Id id = Isar.autoIncrement; // you can also use id = null to auto increment

  late String username;

  late String password;

  late String token;

  late String server;

  late bool isCurrent = false;
}
