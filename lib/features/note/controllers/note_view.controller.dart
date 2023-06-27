import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:nextcloudnotes/core/controllers/app.controller.dart';
import 'package:nextcloudnotes/core/scheme/offline_queue.scheme.dart';
import 'package:nextcloudnotes/core/services/offline.service.dart';
import 'package:nextcloudnotes/core/services/toast.service.dart';
import 'package:nextcloudnotes/core/shared/patterns.dart';
import 'package:nextcloudnotes/core/storage/note.storage.dart';
import 'package:nextcloudnotes/models/note.model.dart';
import 'package:nextcloudnotes/repositories/notes.repositories.dart';
import 'package:nixy_markdown/nixi_markdown.dart';

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
    this._appController,
    this._toastService,
  );
  final NoteRepositories _noteRepositories;
  final OfflineService _offlineService;
  final NoteStorage _noteStorage;
  final AppController _appController;
  final ToastService _toastService;

  final FocusNode focusNode = FocusNode();
  final UndoHistoryController undoHistoryController = UndoHistoryController();

  late TextEditingController markdownController;

  @observable
  bool isTextFieldFocused = false;

  @observable
  bool editMode = false;

  @observable
  bool autoSave = false;

  late ReactionDisposer autoSaveDisposer;
  late Timer? autoSaveTimer;

  @computed
  String get prettyDate => DateFormat('yyyy-MM-dd HH:mm')
      .format(DateTime.utc(1970).add(Duration(seconds: note.modified)));

  late Note note;

  void init(BuildContext context) {
    markdownController = NixyTextFieldController(
      NixyMarkdownControllerPatterns,
      context,
    );
    autoSaveDisposer = autorun((_) {
      if (isTextFieldFocused) {
        // If text field has focus, auto save every 5 seconds.
        autoSaveTimer =
            Timer.periodic(_appController.autoSaveTimer.value, (timer) async {
          await updateNote();
        });
      } else {
        if (autoSaveTimer != null) {
          autoSaveTimer?.cancel();
        }
      }
    });

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        isTextFieldFocused = true;
      } else {
        isTextFieldFocused = false;
      }
    });
  }

  void dispose() {
    focusNode.dispose();
    markdownController.dispose();
    undoHistoryController.dispose();
    autoSaveDisposer();
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
      _toastService.showTextToast(
        '${note.title} has been moved to trash.',
        type: ToastType.success,
      );

      _noteStorage.deleteNote(note);

      return true;
    }

    return false;
  }

  @action
  Future<void> updateNote() async {
    final checkInternetAccess = _offlineService.hasInternetAccess;
    final note0 = note.toJson();
    final lines = markdownController.text.split('\n');
    final firstLine = lines.first;
    final title = firstLine.replaceAll('#', '').trimLeft();

    note0['content'] = markdownController.text;
    note0['title'] = title;
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

    await _noteRepositories.updateNote(note.id, note);
    _noteStorage.saveNote(note);
  }

  void onTapDone() {
    focusNode.unfocus();
    toggleEditMode();
    updateNote().then((value) => fetchNote(note.id));
  }

  @action
  void toggleEditMode() {
    editMode = !editMode;
  }
}
