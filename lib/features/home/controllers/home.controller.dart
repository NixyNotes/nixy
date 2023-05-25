import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:nextcloudnotes/core/scheme/offline_queue.scheme.dart';
import 'package:nextcloudnotes/core/services/offline.service.dart';
import 'package:nextcloudnotes/core/services/toast.service.dart';
import 'package:nextcloudnotes/core/storage/note.storage.dart';
import 'package:nextcloudnotes/models/note.model.dart';
import 'package:nextcloudnotes/repositories/notes.repositories.dart';

part 'home.controller.g.dart';

disposeHomeController(HomeViewController instance) {
  instance.dispose();
}

@LazySingleton(dispose: disposeHomeController)
class HomeViewController = _HomeViewControllerBase with _$HomeViewController;

abstract class _HomeViewControllerBase with Store {
  _HomeViewControllerBase(this._noteRepositories, this._toastService,
      this._noteStorage, this._offlineService);
  final NoteRepositories _noteRepositories;
  final ToastService _toastService;
  final NoteStorage _noteStorage;
  final OfflineService _offlineService;

  @observable
  ObservableList<Note> notes = ObservableList();

  @observable
  bool syncing = false;

  @observable
  ObservableList<Note> selectedNotes = ObservableList();

  late ReactionDisposer sortAutomaticallyDisposer;

  void init() async {
    sortAutomaticallyDisposer = autorun((_) {
      notes.sort((a, b) => b.favorite ? 1 : 0);
    });

    await fetchNotes();
  }

  Future<List<Note>> _fetchRemoteNotes() async {
    final remoteNotes = await _noteRepositories.fetchNotes();

    return remoteNotes;
  }

  Future<List<Note>> _fetchLocalNotes() async {
    final localNotes = await _noteStorage.getAllNotes();

    return localNotes;
  }

  @action
  Future<void> fetchNotes() async {
    final localNotes = await _fetchLocalNotes();

    if (localNotes.isNotEmpty) {
      notes = ObservableList.of(localNotes);

      if (_offlineService.hasInternetAccess) {
        syncing = true;
        await _offlineService.runQueue();
        final remoteNotes = await _fetchRemoteNotes();
        notes = ObservableList.of(remoteNotes);
        syncing = false;

        await _noteStorage.saveAllNotes(remoteNotes);
        await _syncLocalWithRemote(localNotes, remoteNotes);
      }
    } else {
      if (_offlineService.hasInternetAccess) {
        final remoteNotes = await _fetchRemoteNotes();

        notes = ObservableList.of(remoteNotes);
        await _noteStorage.saveAllNotes(remoteNotes);
      }
    }
  }

  Future<void> _syncLocalWithRemote(
    List<Note> localNotes,
    List<Note> remoteNotes,
  ) async {
    final isNoteEquals = listEquals(remoteNotes, localNotes);

    if (!isNoteEquals) {
      _noteStorage.deleteAll();
      _noteStorage.saveAllNotes(remoteNotes);
    }
  }

  Future<void> toggleFavorite(Note note) async {
    final model = Note(
        id: note.id,
        etag: note.etag,
        readonly: note.readonly,
        modified: DateTime.now().millisecondsSinceEpoch,
        title: note.title,
        category: note.category,
        content: note.content,
        favorite: !note.favorite);

    await updateNote(model);

    final updatedList = notes
        .map((element) => element.id == note.id ? model : element)
        .toList();

    notes = ObservableList.of(updatedList);
  }

  Future<void> updateNote(Note note) async {
    final internetAccess = _offlineService.hasInternetAccess;

    if (!internetAccess) {
      _offlineService.addQueue(OfflineQueueAction.UPDATE,
          noteId: note.id, noteAsJson: jsonEncode(note));

      return;
    }

    await _noteRepositories.updateNote(note.id, note);
  }

  @action
  deleteNote(Note note) async {
    if (_offlineService.hasInternetAccess) {
      await _noteRepositories.deleteNote(note.id);
    } else {
      _offlineService.addQueue(OfflineQueueAction.DELETE, noteId: note.id);
    }

    _noteStorage.deleteNote(note);

    notes.removeWhere((element) => element.id == note.id);

    _toastService.showTextToast("Deleted ${note.title}",
        type: ToastType.success);
  }

  @action
  bunchDeleteNotes() async {
    final List<Future<bool>> futures = [];
    final internetAccess = _offlineService.hasInternetAccess;

    for (var note in selectedNotes) {
      if (internetAccess) {
        final future = _noteRepositories.deleteNote(note.id);
        futures.add(future);
      }
    }

    if (!internetAccess) {
      for (var note in selectedNotes) {
        _noteStorage.deleteNote(note);
        notes.removeWhere((element) => element.id == note.id);
        _offlineService.addQueue(OfflineQueueAction.DELETE, noteId: note.id);
      }
      _toastService.showTextToast("Deleted (${selectedNotes.length}) notes.",
          type: ToastType.success);
      selectedNotes.clear();
      return;
    }

    Future.wait<bool>(futures).then((value) {
      for (var note in selectedNotes) {
        notes.removeWhere((element) => element.id == note.id);
      }

      _toastService.showTextToast("Deleted (${selectedNotes.length}) notes.",
          type: ToastType.success);
      selectedNotes.clear();
    });
  }

  @action
  addToSelectedNote(Note note) async {
    if (selectedNotes.where((element) => element.id == note.id).isNotEmpty) {
      selectedNotes.removeWhere((element) => element.id == note.id);
      return;
    }

    selectedNotes.add(note);
  }

  dispose() {
    sortAutomaticallyDisposer();
  }
}
