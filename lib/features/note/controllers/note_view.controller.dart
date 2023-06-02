import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:nextcloudnotes/core/scheme/offline_queue.scheme.dart';
import 'package:nextcloudnotes/core/services/offline.service.dart';
import 'package:nextcloudnotes/core/storage/note.storage.dart';
import 'package:nextcloudnotes/main.dart';
import 'package:nextcloudnotes/models/note.model.dart';
import 'package:nextcloudnotes/repositories/notes.repositories.dart';

part 'note_view.controller.g.dart';

/// The function disposes a NoteViewController instance.
///
/// Args:
///   instance (NoteViewController): The parameter "instance" is an object of the class
/// NoteViewController that needs to be disposed of. The disposeNoteViewController function is
/// responsible for calling the dispose method of the instance object to release any resources that it
/// may be holding.
void disposeNoteViewController(NoteViewController instance) {
  instance.dispose();
}

@LazySingleton(dispose: disposeNoteViewController)

/// Note view controller
class NoteViewController = _NoteViewControllerBase with _$NoteViewController;

abstract class _NoteViewControllerBase with Store {
  _NoteViewControllerBase(
    this._noteRepositories,
    this._offlineService,
    this._noteStorage,
  );
  final NoteRepositories _noteRepositories;
  final OfflineService _offlineService;
  final NoteStorage _noteStorage;

  final FocusNode focusNode = FocusNode();
  final UndoHistoryController undoHistoryController = UndoHistoryController();

  TextEditingController markdownController = TextEditingController();

  @observable
  bool isTextFieldFocused = false;

  @observable
  bool editMode = false;

  @computed
  String get prettyDate => DateFormat('yyyy-MM-dd HH:mm')
      .format(DateTime.utc(1970).add(Duration(seconds: note.modified)));

  late Note note;

  void init(int noteId) {
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        isTextFieldFocused = true;
      }
    });
  }

  void dispose() {
    focusNode.dispose();
    markdownController.dispose();
    undoHistoryController.dispose();
  }

  @action
  Future<Note> fetchNote(int noteId) async {
    final data = await _noteStorage.getSingleNote(noteId);

    note = data;

    return data;
  }

  Future<bool> deleteNote(int noteId) async {
    final checkInternetAccess = _offlineService.hasInternetAccess;

    if (!checkInternetAccess) {
      _offlineService.addQueue(OfflineQueueAction.DELETE, noteId: note.id);
      _noteStorage.deleteNote(note);

      return false;
    }

    final deleted = await _noteRepositories.deleteNote(noteId);

    if (deleted) {
      scaffolMessengerKey.currentState
          ?.showSnackBar(const SnackBar(content: Text('ok')));

      _noteStorage.deleteNote(note);

      return true;
    }

    return false;
  }

  @action
  Future<void> updateNote(int noteId, Note newNote) async {
    final checkInternetAccess = _offlineService.hasInternetAccess;
    final note0 = note.toJson();
    note0['content'] = markdownController.text;
    note = Note.fromJson(note0);

    if (!checkInternetAccess) {
      _offlineService.addQueue(
        OfflineQueueAction.UPDATE,
        noteId: note.id,
        noteAsJson: jsonEncode(note),
      );
      _noteStorage.saveNote(note);

      return;
    }

    await _noteRepositories.updateNote(noteId, note);
    _noteStorage.saveNote(note);
  }

  void onTapDone(int noteId, Note note) {
    focusNode.unfocus();
    toggleEditMode();
    isTextFieldFocused = false;
    updateNote(noteId, note).then((value) => fetchNote(noteId));
  }

  void toggleEditMode() {
    editMode = !editMode;
  }
}
