import 'package:nextcloudnotes/core/adapters/base.adapter.dart';
import 'package:nextcloudnotes/models/note.model.dart';

class NextcloudAdapter implements BaseAdapter {
  @override
  Future<Note> createNewNote({required NewNote data}) {
    // TODO: implement createNewNote
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteNote({required int id}) {
    print('delete from nextcloud');

    throw UnimplementedError();
  }

  @override
  Future<Note> fetchNote({required int id}) {
    // TODO: implement fetchNote
    throw UnimplementedError();
  }

  @override
  Future<Note> fetchNotes() {
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
