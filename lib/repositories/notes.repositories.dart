import 'dart:async';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:nextcloudnotes/core/adapters/init_adapters.dart';
import 'package:nextcloudnotes/core/storage/note.storage.dart';
import 'package:nextcloudnotes/models/note.model.dart';

@lazySingleton

/// The NoteRepositories class contains methods for fetching, deleting, updating, and creating notes
/// using an API endpoint.
class NoteRepositories {
  /// The NoteRepositories class contains methods for fetching, deleting, updating, and creating notes
  /// using an API endpoint.
  NoteRepositories(this._adapter, this._noteStorage);

  final Adapter _adapter;
  final NoteStorage _noteStorage;

  Future<List<Note>?> fetchNotes([String? etag]) async {
    // return _adapter.currentAdapter?.fetchNotes();
    return _noteStorage.getAllNotes();
  }

  Future<Note?> fetchNote(
    int noteId, [
    String? etag,
  ]) async {
    return _adapter.currentAdapter?.fetchNote(id: noteId);
  }

  Future<bool?> deleteNote(int noteId) async {
    return _adapter.currentAdapter?.deleteNote(id: noteId);
  }

  Future<Note?> updateNote(int noteId, Note note) async {
    return _adapter.currentAdapter?.updateNote(id: noteId, data: note);
  }

  Future<Note?> createNewNote(NewNote note) async {
    try {
      return _adapter.currentAdapter?.createNewNote(data: note);
    } on DioError {
      rethrow;
    }
  }
}
