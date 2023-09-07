import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:nextcloudnotes/core/storage/note.storage.dart';
import 'package:nextcloudnotes/models/note.model.dart';
import 'package:nextcloudnotes/repositories/notes.repositories.dart';

enum ProviderActionType { ADD, UPDATE, DELETE }

/// Provider action
class ProviderAction {
  ProviderAction({
    required this.action,
    required this.note,
    this.noteId,
  });

  final ProviderActionType action;

  final int? noteId;

  final Note note;
}

@lazySingleton
class ProviderService {
  ProviderService(this._noteStorage, this._noteRepositories);
  final StreamController<ProviderAction> _stream = StreamController();
  final StreamController<ProviderAction> returnedResponses =
      StreamController.broadcast();
  final NoteStorage _noteStorage;
  final NoteRepositories _noteRepositories;

  Future<void> init() async {
    _stream.stream.listen(_streamFn);
  }

  void addAction(ProviderAction action) {
    _stream.sink.add(action);
  }

  Future<void> _streamFn(ProviderAction action) async {
    switch (action.action) {
      case ProviderActionType.DELETE:
        return _deleteAction(action);
      case ProviderActionType.ADD:
        return _addAction(action);
      case ProviderActionType.UPDATE:
        return _addAction(action);
    }
  }

  Future<void> _deleteAction(ProviderAction action) async {
    _noteStorage.deleteNote(action.note);

    try {
      await _noteRepositories.deleteNote(action.noteId!);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _addAction(ProviderAction action) async {
    _noteStorage.saveNote(action.note);

    final model = NewNote.fromJson(action.note.toJson());

    try {
      if (action.action == ProviderActionType.UPDATE) {
        final response =
            await _noteRepositories.updateNote(action.noteId!, action.note);

        returnedResponses.sink.add(
          ProviderAction(
            action: ProviderActionType.UPDATE,
            note: response!,
            noteId: action.noteId,
          ),
        );
      } else {
        final response = await _noteRepositories.createNewNote(model);

        returnedResponses.sink.add(
          ProviderAction(
            action: ProviderActionType.ADD,
            note: response!,
            noteId: action.noteId,
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  void dispose() {
    _stream.close();
  }
}
