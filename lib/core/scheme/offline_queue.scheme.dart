import 'package:isar/isar.dart';

part 'offline_queue.scheme.g.dart';

enum OfflineQueueAction { ADD, UPDATE, DELETE }

@collection
class OfflineQueue {
  late Id id = Isar.autoIncrement;

  @enumerated
  late OfflineQueueAction action;

  late int? noteId;

  late String? noteAsJson;
}
