import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:nextcloudnotes/models/note.model.dart';
import 'package:nextcloudnotes/repositories/notes.repositories.dart';
part 'new_note.controller.g.dart';

disposeNewNoteController(NewNoteController instance) {
  instance.dispose();
}

@LazySingleton(dispose: disposeNewNoteController)
class NewNoteController = _NewNoteControllerBase with _$NewNoteController;

abstract class _NewNoteControllerBase with Store {
  _NewNoteControllerBase(this._noteRepositories);
  final NoteRepositories _noteRepositories;
  final FocusNode focusNode = FocusNode();
  final TextEditingController markdownController =
      TextEditingController(text: "# New Note");

  @observable
  bool previewMode = false;

  @observable
  bool textFieldHasFocus = false;

  @observable
  String? title;

  @observable
  bool isLoading = false;

  // If created a note once, this will be true. Editing afterwhile will be
  // updates instead
  bool alreadyCreatedNote = false;

  late Note note;

  @action
  void init() {
    markdownController.addListener(() {
      final lines = markdownController.text.split("\n");
      final firstLine = lines.first;

      if (firstLine.runes.isNotEmpty) {
        title = firstLine.replaceAll("#", "").trimLeft();
      } else {
        title = null;
      }
    });

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        textFieldHasFocus = true;
        return;
      }

      textFieldHasFocus = false;
    });
  }

  Future<void> createNote() async {
    if (alreadyCreatedNote) {
      return _updateNote();
    }
    isLoading = true;

    final newNote = NewNote(
      modified: DateTime.now().millisecondsSinceEpoch,
      title: title!,
      content: markdownController.text,
      category: "",
    );

    final response = await _noteRepositories.createNewNote(newNote);

    if (response != null) {
      isLoading = false;
      alreadyCreatedNote = true;
      note = response;
    }
  }

  Future<void> _updateNote() async {
    final updateNote = Note(
        id: note.id,
        etag: note.etag,
        readonly: note.readonly,
        modified: DateTime.now().millisecondsSinceEpoch,
        title: title!,
        category: note.title,
        content: markdownController.text,
        favorite: note.favorite);
    isLoading = true;
    await _noteRepositories.updateNote(note.id, updateNote);
    isLoading = false;
  }

  void dispose() {
    focusNode.dispose();
    markdownController.dispose();
  }

  @action
  togglePreviewMode() {
    previewMode = !previewMode;
  }
}
