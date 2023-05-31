// ignore_for_file: public_member_api_docs

import 'package:isar/isar.dart';

part 'user.scheme.g.dart';

// Full encrpytion is coming soon.
@collection

/// User scheme
class User {
  Id id = Isar.autoIncrement;

  late String username;

  late String password;

  late String token;

  late String server;

  late bool isCurrent = false;
}
