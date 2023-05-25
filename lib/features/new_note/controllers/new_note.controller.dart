import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:nextcloudnotes/core/scheme/offline_queue.scheme.dart';
import 'package:nextcloudnotes/core/services/offline.service.dart';
import 'package:nextcloudnotes/core/services/toast.service.dart';
import 'package:nextcloudnotes/core/storage/note.storage.dart';
import 'package:nextcloudnotes/features/home/controllers/home.controller.dart';
import 'package:nextcloudnotes/models/note.model.dart';
import 'package:nextcloudnotes/repositories/notes.repositories.dart';
part 'new_note.controller.g.dart';

disposeNewNoteController(NewNoteController instance) {
  instance.dispose();
}

@LazySingleton(dispose: disposeNewNoteController)
class NewNoteController = _NewNoteControllerBase with _$NewNoteController;

abstract class _NewNoteControllerBase with Store {
  _NewNoteControllerBase(this._noteRepositories, this._notesStorage,
      this._offlineService, this._homeViewController, this._toastService);
  final NoteRepositories _noteRepositories;
  final NoteStorage _notesStorage;
  final OfflineService _offlineService;
  final HomeViewController _homeViewController;
  final ToastService _toastService;

  final FocusNode focusNode = FocusNode();
  final TextEditingController markdownController =
      TextEditingController(text: "# New Note");

  @observable
  bool previewMode = false;

  @observable
  bool textFieldHasFocus = false;

  @observable
  String? title;

  @observable
  bool isLoading = false;

  // If created a note once, this will be true. Editing afterwhile will be
  // updates instead
  bool alreadyCreatedNote = false;

  late Note note;

  @action
  void init() {
    markdownController.addListener(() {
      final lines = markdownController.text.split("\n");
      final firstLine = lines.first;

      if (firstLine.runes.isNotEmpty) {
        title = firstLine.replaceAll("#", "").trimLeft();
      } else {
        title = null;
      }
    });

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        textFieldHasFocus = true;
        return;
      }

      textFieldHasFocus = false;
    });
  }

  Future<void> createNote() async {
    final internetAccess = _offlineService.hasInternetAccess;
    final unixTimestamp = DateTime.now().millisecondsSinceEpoch;
    final model = Note(
        id: Random().nextInt(9999),
        etag: "etag",
        readonly: false,
        modified: unixTimestamp,
        title: title!,
        category: "",
        content: markdownController.text,
        favorite: false);

    if (!internetAccess) {
      if (alreadyCreatedNote) {
        return _updateNote();
      }

      _notesStorage.saveNote(model);

      _offlineService.addQueue(OfflineQueueAction.ADD,
          noteAsJson: jsonEncode(model));

      alreadyCreatedNote = true;
      note = model;

      _toastService.showTextToast("Created $title", type: ToastType.success);

      return;
    }

    _notesStorage.saveNote(model);

    if (alreadyCreatedNote) {
      return _updateNote();
    }

    isLoading = true;

    final newNote = NewNote(
      modified: DateTime.now().millisecondsSinceEpoch,
      title: title!,
      content: markdownController.text,
      category: "",
    );

    final response = await _noteRepositories.createNewNote(newNote);

    if (response != null) {
      isLoading = false;
      alreadyCreatedNote = true;
      note = response;
      _toastService.showTextToast("Created $title", type: ToastType.success);
    }
  }

  Future<void> _updateNote() async {
    final updateNote = Note(
        id: note.id,
        etag: note.etag,
        readonly: note.readonly,
        modified: DateTime.now().millisecondsSinceEpoch,
        title: title!,
        category: note.title,
        content: markdownController.text,
        favorite: note.favorite);
    final internetAccess = _offlineService.hasInternetAccess;

    _notesStorage.saveNote(updateNote);

    if (!internetAccess) {
      return;
    }

    isLoading = true;

    await _noteRepositories.updateNote(note.id, updateNote);
    isLoading = false;
  }

  void dispose() async {
    await _homeViewController.fetchNotes();
    focusNode.dispose();
    markdownController.dispose();
  }

  @action
  togglePreviewMode() {
    previewMode = !previewMode;
  }
}
