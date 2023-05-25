import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:nextcloudnotes/core/scheme/offline_queue.scheme.dart';
import 'package:nextcloudnotes/core/storage/offline_queue.storage.dart';
import 'package:nextcloudnotes/core/utils/network_checker.dart';
import 'package:nextcloudnotes/models/note.model.dart';
import 'package:nextcloudnotes/repositories/notes.repositories.dart';

class OfflineData<T> {
  OfflineData(
      {required this.localData, this.remoteData, this.shouldMerge = false});

  final T localData;
  final T? remoteData;
  final bool? shouldMerge;
}

disposeOfflineService(OfflineService instance) {
  instance.dispose();
}

@LazySingleton(dispose: disposeOfflineService)
class OfflineService {
  OfflineService(this._offlineQueueStorage, this._noteRepositories);
  final OfflineQueueStorage _offlineQueueStorage;
  final NoteRepositories _noteRepositories;
  bool hasInternetAccess = true;

  late StreamSubscription<ConnectivityResult> subscription;
  late Timer timer;

  Future<void> checkForNetworkConditions() async {
    hasInternetAccess = await checkForInternetAccess();

    timer = Timer.periodic(const Duration(minutes: 5), (timer) async {
      hasInternetAccess = await checkForInternetAccess();
    });

    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        hasInternetAccess = false;
      } else {
        hasInternetAccess = true;
      }
    });
  }

  dispose() {
    timer.cancel();
    subscription.cancel();
  }

  Future<void> runQueue() async {
    if (hasInternetAccess) {
      final queues = await getAllQueue();

      if (queues.isNotEmpty) {
        await Future.wait(queues);
        _offlineQueueStorage.deleteAll();
      }
    }
  }

  addQueue(OfflineQueueAction action, {int? noteId, String? noteAsJson}) {
    final OfflineQueue queue = OfflineQueue();

    queue
      ..action = action
      ..noteId = noteId
      ..noteAsJson = noteAsJson;

    _offlineQueueStorage.addQueue(queue);
  }

  Future<List<OfflineQueue>> getAllRawQueue() async {
    final queues = await _offlineQueueStorage.getAllQueue();

    return queues;
  }

  Future<List<Future<void>>> getAllQueue() async {
    final queues = await _offlineQueueStorage.getAllQueue();

    return queues.map((e) => _mapQueueToHttp(e)).toList();
  }

  Future<void> _mapQueueToHttp(OfflineQueue queue) {
    switch (queue.action) {
      case OfflineQueueAction.ADD:
        final note = NewNote.fromJson(jsonDecode(queue.noteAsJson!));

        return _noteRepositories.createNewNote(note);

      case OfflineQueueAction.DELETE:
        return _noteRepositories.deleteNote(queue.noteId!);

      case OfflineQueueAction.UPDATE:
        final note = Note.fromJson(jsonDecode(queue.noteAsJson!));

        return _noteRepositories.updateNote(queue.noteId!, note);
    }
  }
}
