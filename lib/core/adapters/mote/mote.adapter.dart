import 'package:nextcloudnotes/core/adapters/base.adapter.dart';
import 'package:nextcloudnotes/models/note.model.dart';

class MoteAdapter implements BaseAdapter {
  @override
  Future<Note> createNewNote({required NewNote data}) {
    // TODO: implement createNewNote
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteNote({required int id}) {
    print('deleting from mote');
    // TODO: implement deleteNote
    throw UnimplementedError();
  }

  @override
  Future<Note> fetchNote({required int id}) {
    // TODO: implement fetchNote
    throw UnimplementedError();
  }

  @override
  Future<List<Note>> fetchNotes() {
    // TODO: implement fetchNotes
    throw UnimplementedError();
  }

  @override
  Future<Note> fetchNotesByCategory({required String categoryName}) {
    // TODO: implement fetchNotesByCategory
    throw UnimplementedError();
  }

  @override
  Future<Note> updateNote({required int id, required Note data}) {
    // TODO: implement updateNote
    throw UnimplementedError();
  }

  @override
  Note convertToGeneralModel() {
    // TODO: implement convertToGeneralModel
    throw UnimplementedError();
  }
}
