import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import 'package:nextcloudnotes/core/scheme/note.scheme.dart';
import 'package:nextcloudnotes/core/services/init_isar.dart';
import 'package:nextcloudnotes/models/note.model.dart';

/// The NoteStorage class provides methods for saving, retrieving, and deleting notes using Isar
/// database in Dart.
@lazySingleton
class NoteStorage {
  /// This function saves a list of notes to a local database using Isar.
  ///
  /// Args:
  ///   note (List<Note>): The parameter "note" is a List of Note objects that are to be saved to a
  /// database.
  void saveAllNotes(List<Note> note) {
    final localNotes = note.map(LocalNote.merge).toList();

    isarInstance.writeTxn(() async {
      await isarInstance.localNotes.putAll(localNotes);
    });
  }

  /// This function retrieves all notes from a local database and returns them as a list of Note objects.
  ///
  /// Returns:
  ///   The `getAllNotes()` function is returning a `Future` that resolves to a `List` of `Note` objects.
  /// The `Note` objects are retrieved from an Isar database using the `localNotes` collection and then
  /// converted from Isar objects to `Note` objects using the `fromJson()` constructor.
  Future<List<Note>> getAllNotes() async {
    final notes = await isarInstance.localNotes.where().findAll();
    final modifiedList = notes.map((e) => Note.fromJson(e.toMap())).toList();

    return modifiedList;
  }

  /// The function retrieves a single note from a local database and returns it as a modified Note object.
  ///
  /// Args:
  ///   noteId (int): an integer representing the ID of the note that needs to be retrieved from the local
  /// database. The function uses this ID to query the Isar database and retrieve the corresponding note.
  ///
  /// Returns:
  ///   The `getSingleNote` function is returning a `Future` that will eventually resolve to a single
  /// `Note` object with the specified `noteId`.
  Future<Note> getSingleNote(int noteId) async {
    final note =
        await isarInstance.localNotes.where().idEqualTo(noteId).findFirst();

    final modifiedNote = Note.fromJson(note!.toMap());

    return modifiedNote;
  }

  /// This function saves a note object to a local database using Isar.
  ///
  /// Args:
  ///   note (Note): The parameter "note" is an object of type "Note" that contains the data to be saved.
  /// It is passed as an argument to the "saveNote" function.
  void saveNote(Note note) {
    isarInstance.writeTxn(() async {
      final object = LocalNote.merge(note);

      await isarInstance.localNotes.put(object);
    });
  }

  /// The function deletes a note from a local database using Isar.
  ///
  /// Args:
  ///   note (Note): The parameter "note" is an object of the class "Note" that contains information about
  /// a specific note. This object is used to identify the note that needs to be deleted from the
  /// database.
  void deleteNote(Note note) {
    isarInstance.writeTxn(() async {
      await isarInstance.localNotes.deleteById(note.id);
    });
  }

  /// The function deletes all local notes using Isar database.
  void deleteAll() {
    isarInstance.writeTxn(() async {
      await isarInstance.localNotes.clear();
    });
  }

  /// This function retrieves all notes from a local database that belong to a specific category and
  /// returns them as a list of Note objects.
  ///
  /// Args:
  ///   categoryName (String): The parameter `categoryName` is a `String` that represents the name of
  /// the category for which we want to retrieve all the notes. The method `getAllNotesByCategory` uses
  /// Isar database to query all the notes that belong to the specified category and returns a `Future`
  /// that resolves to
  ///
  /// Returns:
  ///   A `Future` that resolves to a list of `Note` objects that belong to the specified category.
  Future<List<Note>> getAllNotesByCategory(String categoryName) async {
    final notes = await isarInstance.localNotes
        .where()
        .categoryEqualTo(categoryName)
        .findAll();
    final modifiedList = notes.map((e) => Note.fromJson(e.toMap())).toList();

    return modifiedList;
  }
}
