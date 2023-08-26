import 'package:nextcloudnotes/models/note.model.dart';

/// Adapter for backends
abstract class BaseAdapter {
  /// Fetch notes
  Future<Note> fetchNotes();

  /// Fetch notes by category name
  Future<Note> fetchNotesByCategory({required String categoryName});

  /// Fetch single note by id
  Future<Note> fetchNote({required int id});

  /// Delete note by id
  Future<bool> deleteNote({required int id});

  /// Update note by id
  Future<Note> updateNote({required int id, required Note data});

  /// Create new note
  Future<Note> createNewNote({required NewNote data});

  /// To convert custom models to general note model
  Note convertToGeneralModel();
}
