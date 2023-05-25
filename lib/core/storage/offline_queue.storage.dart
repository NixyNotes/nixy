import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import 'package:nextcloudnotes/core/scheme/offline_queue.scheme.dart';
import 'package:nextcloudnotes/core/services/init_isar.dart';

@lazySingleton
class OfflineQueueStorage {
  addQueue(OfflineQueue queue) {
    isarInstance.writeTxn(() async {
      await isarInstance.offlineQueues.put(queue);
    });
  }

  Future<List<OfflineQueue>> getAllQueue() {
    return isarInstance.offlineQueues.where().findAll();
  }

  deleteAll() {
    isarInstance.writeTxn(() async {
      await isarInstance.offlineQueues.clear();
    });
  }
}
