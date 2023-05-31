import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:nextcloudnotes/core/scheme/offline_queue.scheme.dart';
import 'package:nextcloudnotes/core/storage/offline_queue.storage.dart';
import 'package:nextcloudnotes/core/utils/network_checker.dart';
import 'package:nextcloudnotes/models/note.model.dart';
import 'package:nextcloudnotes/repositories/notes.repositories.dart';

/// Dispose `OfflineService` instance
void disposeOfflineService(OfflineService instance) {
  instance.dispose();
}

@LazySingleton(dispose: disposeOfflineService)

/// `OfflineService` includes sets of utils when using app without any network
/// connections
class OfflineService {
  /// `OfflineService` includes sets of utils when using app without any network
  /// connections
  OfflineService(this._offlineQueueStorage, this._noteRepositories);
  final OfflineQueueStorage _offlineQueueStorage;
  final NoteRepositories _noteRepositories;

  /// `bool hasInternetAccess = true;` is initializing a boolean variable `hasInternetAccess` with a
  /// value of `true`. This variable is used to keep track of whether the device has internet access or
  /// not. It is updated based on the device's connectivity status and is used to determine whether to
  /// run certain operations or add them to an offline queue.
  bool hasInternetAccess = true;

  late StreamSubscription<ConnectivityResult> _subscription;
  late Timer _timer;

  /// This function checks for network conditions and updates the internet access status periodically and
  /// when the connectivity changes.
  Future<void> checkForNetworkConditions() async {
    hasInternetAccess = await checkForInternetAccess();

    _timer = Timer.periodic(const Duration(minutes: 5), (timer) async {
      hasInternetAccess = await checkForInternetAccess();
    });

    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        hasInternetAccess = false;
      } else {
        hasInternetAccess = true;
      }
    });
  }

  /// The dispose function cancels a timer and a subscription.
  void dispose() {
    _timer.cancel();
    _subscription.cancel();
  }

  /// This function runs a queue of tasks if there is internet access and deletes the tasks from offline
  /// storage once they are completed.
  Future<void> runQueue() async {
    if (hasInternetAccess) {
      final queues = await getAllQueue();

      if (queues.isNotEmpty) {
        await Future.wait(queues);
        _offlineQueueStorage.deleteAll();
      }
    }
  }

  /// This function adds an action, note ID, and note as JSON to an offline queue.
  ///
  /// Args:
  ///   action (OfflineQueueAction): The action parameter is of type OfflineQueueAction, which is an enum
  /// that represents the type of action to be performed on the note. It could be adding a new note,
  /// updating an existing note, or deleting a note.
  ///   noteId (int): The noteId parameter is an optional integer value that represents the ID of a note.
  /// It is used in conjunction with the action parameter to determine what action should be taken on the
  /// note in the offline queue.
  ///   noteAsJson (String): noteAsJson is a String parameter that represents a JSON string of a note
  /// object. It is used to store the note data in the offline queue for later processing.
  void addQueue(OfflineQueueAction action, {int? noteId, String? noteAsJson}) {
    final queue = OfflineQueue()
      ..action = action
      ..noteId = noteId
      ..noteAsJson = noteAsJson;

    _offlineQueueStorage.addQueue(queue);
  }

  /// This function retrieves all offline queues from storage and returns them as a list.
  ///
  /// Returns:
  ///   A `Future` that resolves to a `List` of `OfflineQueue` objects.
  Future<List<OfflineQueue>> getAllRawQueue() async {
    final queues = await _offlineQueueStorage.getAllQueue();

    return queues;
  }

  /// This function retrieves all offline queues and maps them to HTTP requests.
  ///
  /// Returns:
  ///   A `Future` that resolves to a `List` of `Future<void>` objects. The `getAllQueue` method retrieves
  /// a list of queues from `_offlineQueueStorage` and maps each queue to an HTTP request using the
  /// `_mapQueueToHttp` method. The resulting list of HTTP requests is then returned as a list of
  /// `Future<void>` objects.
  Future<List<Future<void>>> getAllQueue() async {
    final queues = await _offlineQueueStorage.getAllQueue();

    return queues.map(_mapQueueToHttp).toList();
  }

  Future<void> _mapQueueToHttp(OfflineQueue queue) {
    switch (queue.action) {
      case OfflineQueueAction.ADD:
        final note = NewNote.fromJson(
          jsonDecode(queue.noteAsJson!) as Map<String, dynamic>,
        );

        return _noteRepositories.createNewNote(note);

      case OfflineQueueAction.DELETE:
        return _noteRepositories.deleteNote(queue.noteId!);

      case OfflineQueueAction.UPDATE:
        final note = Note.fromJson(
          jsonDecode(queue.noteAsJson!) as Map<String, dynamic>,
        );

        return _noteRepositories.updateNote(queue.noteId!, note);
    }
  }
}
