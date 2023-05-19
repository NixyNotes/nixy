import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:nextcloudnotes/models/note.model.dart';
import 'package:nextcloudnotes/repositories/notes.repositories.dart';
part 'note-view.controller.g.dart';

@lazySingleton
class NoteViewController = _NoteViewControllerBase with _$NoteViewController;

abstract class _NoteViewControllerBase with Store {
  _NoteViewControllerBase(this._noteRepositories);
  final NoteRepositories _noteRepositories;

  Note? note;

  Future<Note> fetchNote(int noteId) {
    return _noteRepositories.fetchNote(noteId);
  }
}
