import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:nextcloudnotes/core/controllers/queue.controller.dart';
import 'package:nextcloudnotes/main.dart';
import 'package:nextcloudnotes/models/note.model.dart';
import 'package:nextcloudnotes/repositories/notes.repositories.dart';

part 'note-view.controller.g.dart';

@lazySingleton
class NoteViewController = _NoteViewControllerBase with _$NoteViewController;

abstract class _NoteViewControllerBase with Store {
  _NoteViewControllerBase(this._noteRepositories, this._queueController);
  final NoteRepositories _noteRepositories;
  final QueueController _queueController;

  TextEditingController markdownController = TextEditingController();

  Future<Note> fetchNote(int noteId) {
    return _noteRepositories.fetchNote(noteId);
  }

  Future<bool> deleteNote(int noteId) async {
    final deleted = await _noteRepositories.deleteNote(noteId);

    if (deleted) {
      scaffolMessengerKey.currentState
          ?.showSnackBar(const SnackBar(content: Text("ok")));

      return true;
    }

    return false;
  }

  @action
  Future<void> updateNote(int noteId, Note note) async {
    final note0 = note.toJson();
    note0["content"] = markdownController.text;

    _queueController.queue.sink.add(
        QueueAction(type: QueueActionTypes.UPDATE, note: Note.fromJson(note0)));
  }
}
