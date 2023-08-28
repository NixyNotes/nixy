// ignore_for_file: public_member_api_docs

import 'package:freezed_annotation/freezed_annotation.dart';

part 'note.model.freezed.dart';
part 'note.model.g.dart';

@freezed
class Note with _$Note {
  const factory Note({
    required int id,
    required int modified,
    required String title,
    required String content,
    bool? favorite,
    String? category,
  }) = _Note;

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);
}

@freezed
class NewNote with _$NewNote {
  const factory NewNote({
    required int modified,
    required String title,
    required String content,
    required String category,
  }) = _NewNote;

  factory NewNote.fromJson(Map<String, dynamic> json) =>
      _$NewNoteFromJson(json);
}
