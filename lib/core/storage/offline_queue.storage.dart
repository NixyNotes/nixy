import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import 'package:nextcloudnotes/core/scheme/offline_queue.scheme.dart';
import 'package:nextcloudnotes/core/services/init_isar.dart';

/// The `OfflineQueueStorage` class provides methods for adding, retrieving, and deleting offline queues
/// using Isar database.
@lazySingleton
class OfflineQueueStorage {
  /// This function adds an OfflineQueue object to an Isar database.
  ///
  /// Args:
  ///   queue (OfflineQueue): The parameter `queue` is an object of type `OfflineQueue` that is being
  /// added to a database using IsarThe `addQueue`
  /// function is responsible for writing the `queue` object to the database.
  void addQueue(OfflineQueue queue) {
    isarInstance.writeTxn(() async {
      await isarInstance.offlineQueues.put(queue);
    });
  }

  /// The function returns a Future that retrieves all OfflineQueue objects from the Isar database.
  ///
  /// Returns:
  ///   A `Future` object that will eventually contain a `List` of `OfflineQueue` objects retrieved from
  /// the `isarInstance` database.
  Future<List<OfflineQueue>> getAllQueue() {
    return isarInstance.offlineQueues.where().findAll();
  }

  /// This function deletes all items in the offlineQueues collection in Isar database.
  void deleteAll() {
    isarInstance.writeTxn(() async {
      await isarInstance.offlineQueues.clear();
    });
  }
}
