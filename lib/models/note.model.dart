import 'package:freezed_annotation/freezed_annotation.dart';

part 'note.model.freezed.dart';
part 'note.model.g.dart';

@freezed
class Note with _$Note {
  const factory Note({
    required int id,
    required String etag,
    required bool readonly,
    required int modified,
    required String title,
    required String category,
    required String content,
    required bool favorite,
  }) = _Note;

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);
}
