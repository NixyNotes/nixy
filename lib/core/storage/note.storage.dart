import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import 'package:nextcloudnotes/core/scheme/note.scheme.dart';
import 'package:nextcloudnotes/core/services/init_isar.dart';
import 'package:nextcloudnotes/models/note.model.dart';

@lazySingleton
class NoteStorage {
  saveAllNotes(List<Note> note) {
    final localNotes = note.map((e) => LocalNote.merge(e)).toList();

    isarInstance.writeTxn(() async {
      isarInstance.localNotes.putAll(localNotes);
    });
  }

  Future<List<Note>> getAllNotes() async {
    final notes = await isarInstance.localNotes.where().findAll();
    final modifiedList = notes.map((e) => Note.fromJson(e.toMap())).toList();

    return modifiedList;
  }

  Future<Note> getSingleNote(int noteId) async {
    final note =
        await isarInstance.localNotes.where().idEqualTo(noteId).findFirst();

    final modifiedNote = Note.fromJson(note!.toMap());

    return modifiedNote;
  }
}
