// ignore_for_file: public_member_api_docs, constant_identifier_names

import 'package:isar/isar.dart';

part 'offline_queue.scheme.g.dart';

/// `enum OfflineQueueAction { ADD, UPDATE, DELETE }` is defining an enumeration type called
/// `OfflineQueueAction` with three possible values: `ADD`, `UPDATE`, and `DELETE`. This enumeration
/// will be used to indicate the type of action to be performed on a note in the `OfflineQueue`
/// collection.
enum OfflineQueueAction { ADD, UPDATE, DELETE }

@collection

/// Offline queue scheme
class OfflineQueue {
  late Id id = Isar.autoIncrement;

  @enumerated
  late OfflineQueueAction action;

  late int? noteId;

  late String? noteAsJson;
}
