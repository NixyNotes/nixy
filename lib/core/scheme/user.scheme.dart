// ignore_for_file: public_member_api_docs

import 'package:isar/isar.dart';
import 'package:nextcloudnotes/core/adapters/init_adapters.dart';

part 'user.scheme.g.dart';

/// Full encryption support is coming with Isar 4.0
/// User scheme
@collection
class User {
  Id id = Isar.autoIncrement;

  late String username;

  late String token;

  late String server;

  late bool isCurrent = false;

  @enumerated
  late AdapterType adapter;
}
