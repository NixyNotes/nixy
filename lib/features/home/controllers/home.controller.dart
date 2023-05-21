import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:nextcloudnotes/models/note.model.dart';
import 'package:nextcloudnotes/repositories/notes.repositories.dart';

part 'home.controller.g.dart';

@lazySingleton
class HomeViewController = _HomeViewControllerBase with _$HomeViewController;

abstract class _HomeViewControllerBase with Store {
  _HomeViewControllerBase(this._noteRepositories);
  final NoteRepositories _noteRepositories;

  ObservableFuture<List<Note>>? notes;

  fetchNotes() async {
    final response = _noteRepositories.fetchNotes();

    notes = ObservableFuture(response);
  }
}
