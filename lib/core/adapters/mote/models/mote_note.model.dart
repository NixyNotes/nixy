import 'package:freezed_annotation/freezed_annotation.dart';

part 'mote_note.model.freezed.dart';
part 'mote_note.model.g.dart';

@freezed
class MoteNote with _$MoteNote {
  const factory MoteNote({
    required int id,
    required String title,
    required String content,
    required String slug,
    required int userId,
    required dynamic deletedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
    required MoteNoteUser user,
    List<MoteNoteTag>? tags,
  }) = _MoteNote;

  factory MoteNote.fromJson(Map<String, dynamic> json) =>
      _$MoteNoteFromJson(json);
}

@freezed
class MoteNoteTag with _$MoteNoteTag {
  const factory MoteNoteTag({
    required int id,
    required String label,
    required String slug,
    required int userId,
    required int noteId,
  }) = _MoteNoteTag;

  factory MoteNoteTag.fromJson(Map<String, dynamic> json) =>
      _$MoteNoteTagFromJson(json);
}

@freezed
class MoteNoteUser with _$MoteNoteUser {
  const factory MoteNoteUser({
    required int id,
    required String email,
    required String username,
    required String password,
    required dynamic profilePicture,
  }) = _MoteNoteUser;

  factory MoteNoteUser.fromJson(Map<String, dynamic> json) =>
      _$MoteNoteUserFromJson(json);
}
