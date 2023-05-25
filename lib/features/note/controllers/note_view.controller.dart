import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:nextcloudnotes/core/scheme/offline_queue.scheme.dart';
import 'package:nextcloudnotes/core/services/offline.service.dart';
import 'package:nextcloudnotes/core/storage/note.storage.dart';
import 'package:nextcloudnotes/core/utils/network_checker.dart';
import 'package:nextcloudnotes/main.dart';
import 'package:nextcloudnotes/models/note.model.dart';
import 'package:nextcloudnotes/repositories/notes.repositories.dart';

part 'note_view.controller.g.dart';

disposeNoteViewController(NoteViewController instance) {
  instance.dispose();
}

@LazySingleton(dispose: disposeNoteViewController)
class NoteViewController = _NoteViewControllerBase with _$NoteViewController;

abstract class _NoteViewControllerBase with Store {
  _NoteViewControllerBase(
      this._noteRepositories, this._offlineService, this._noteStorage);
  final NoteRepositories _noteRepositories;
  final OfflineService _offlineService;
  final NoteStorage _noteStorage;

  final FocusNode focusNode = FocusNode();

  TextEditingController markdownController = TextEditingController();

  @observable
  bool isTextFieldFocused = false;

  @observable
  bool editMode = false;

  @computed
  String get prettyDate => DateFormat("yyyy-MM-dd HH:mm")
      .format(DateTime.utc(1970, 1, 1).add(Duration(seconds: note.modified)));

  late Note note;

  init(int noteId) {
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        isTextFieldFocused = true;
      }
    });
  }

  dispose() {
    focusNode.dispose();
    markdownController.dispose();
  }

  @action
  Future<Note> fetchNote(int noteId) async {
    final data = await _offlineService.fetch<Note>(
      _noteStorage.getSingleNote,
      _noteRepositories.fetchNote,
      localStorageArg: noteId,
      remoteDataArgs: noteId,
    );

    note = data.localData;

    if (data.shouldMerge != null && data.shouldMerge!) {
      if (data.remoteData != null) {
        _noteStorage.saveNote(data.remoteData!);

        note = data.remoteData!;
      }
    }

    return note;
  }

  Future<bool> deleteNote(int noteId) async {
    final checkInternetAccess = await checkForInternetAccess();

    if (!checkInternetAccess) {
      _offlineService.addQueue(OfflineQueueAction.DELETE, noteId: note.id);
      _noteStorage.deleteNote(note);

      return false;
    }

    final deleted = await _noteRepositories.deleteNote(noteId);

    if (deleted) {
      scaffolMessengerKey.currentState
          ?.showSnackBar(const SnackBar(content: Text("ok")));

      _noteStorage.deleteNote(note);

      return true;
    }

    return false;
  }

  @action
  Future<void> updateNote(int noteId, Note note) async {
    final checkInternetAccess = await checkForInternetAccess();
    final note0 = note.toJson();
    note0["content"] = markdownController.text;
    note = Note.fromJson(note0);

    if (!checkInternetAccess) {
      _offlineService.addQueue(OfflineQueueAction.UPDATE,
          noteId: note.id, noteAsJson: jsonEncode(note));
      _noteStorage.saveNote(note);

      return;
    }

    await _noteRepositories.updateNote(noteId, note);
    _noteStorage.saveNote(note);
  }

  onTapDone(int noteId, Note note) {
    focusNode.unfocus();
    toggleEditMode();
    isTextFieldFocused = false;
    updateNote(noteId, note).then((value) => fetchNote(noteId));
  }

  toggleEditMode() {
    editMode = !editMode;
  }
}
